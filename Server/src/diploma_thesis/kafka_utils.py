import time
from datetime import datetime
from os import walk, rename, makedirs, path
from pathlib import Path

from confluent_kafka import SerializingProducer, DeserializingConsumer, TopicPartition
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer, AvroDeserializer
from confluent_kafka.serialization import StringDeserializer, StringSerializer

from events_utils import delete_events_files
from setup import logger, docker_name, dir_path, maximum_file_live_time_min, \
    maximum_old_file_size_mb, kafka_address_port, schema_registry_address_port, group_name, \
    input_topic, partition_id


class Event(object):
    def __init__(self, data, session_id, user_id):
        self.data = data
        self.session_id = session_id
        self.user_id = user_id


class Vulnerability(object):
    def __init__(self, data, specification, version, user_id):
        self.data = data
        self.specification = specification
        self.version = version
        self.user_id = user_id
        self.instance_name = docker_name


def obj_to_dict(obj, ctx):
    return dict(data=obj.data, specification=obj.specification, instance_name=obj.instance_name,
                version=obj.version, user_id=obj.user_id)


def dict_to_obj(obj, ctx):
    if obj is None:
        return None
    return Event(data=obj['data'], session_id=obj['session_id'], user_id=obj['user_id'])


def delivery_report(err, msg):
    """
    Reports the failure or success of a message delivery.
    Args:
        err (KafkaError): The error that occurred on None on success.
        msg (Message): The message that was produced or failed.
    Note:
        In the delivery report callback the Message.key() and Message.value()
        will be the binary format as encoded by any configured Serializers and
        not the same object that was passed to produce().
        If you wish to pass the original object(s) for key and value to delivery
        report callback we recommend a bound callback or lambda where you pass
        the objects along.
    """
    if err is not None:
        logger.error("Delivery failed for User record {}: {}".format(msg.key(), err))
        return
    logger.debug('User record {} successfully produced to {} [{}] at offset {}'.format(
        msg.key(), msg.topic(), msg.partition(), msg.offset()))


def produce_to_topic(key, data_list: [], topic):
    value_schema = Path(dir_path + "schema/producer/output.avsc").read_text()
    schema_registry_conf = {'url': schema_registry_address_port}
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    value_avro_serializer = AvroSerializer(value_schema, schema_registry_client, obj_to_dict)
    producer_conf = {'bootstrap.servers': kafka_address_port,
                     'key.serializer': StringSerializer('utf_8'),
                     'value.serializer': value_avro_serializer}
    producer = SerializingProducer(producer_conf)
    logger.info("Producing records of events for user: " + str(key) + " is started")
    producer.poll(1)
    for data in data_list:
        try:
            producer.produce(topic=topic, key=key, value=data, on_delivery=delivery_report)
        except ValueError as e:
            logger.error("Invalid input: " + str(e) + ", discarding record...")
    logger.info("Producing records of events for user: " + str(key) + " has been finished")
    producer.flush()


def consume_from_topic(topic):
    logger.info("Try to consume data from topic: " + topic)
    sr_conf = {'url': schema_registry_address_port}
    schema_registry_client = SchemaRegistryClient(sr_conf)
    value_schema = Path(dir_path + "schema/producer/input.avsc").read_text()
    value_avro_deserializer = AvroDeserializer(value_schema, schema_registry_client, dict_to_obj)
    string_deserializer = StringDeserializer('utf_8')
    consumer_conf = {'bootstrap.servers': kafka_address_port,
                     'key.deserializer': string_deserializer,
                     'value.deserializer': value_avro_deserializer,
                     'group.id': group_name,
                     'auto.offset.reset': "earliest"
                     }
    consumer = DeserializingConsumer(consumer_conf)
    if str(partition_id) == 'ALL':
        consumer.subscribe([topic])
    else:
        consumer.assign([TopicPartition(input_topic, partition=int(partition_id))])
    msg_before = True
    nothing_new = True
    keys_data = dict()
    solved_key = list()
    while True:
        try:
            msg = consumer.poll(1)
            if msg is None:
                if not msg_before and not nothing_new:
                    break
                # we want to wait 1 second to read all messages that have been sent
                time.sleep(1)
                msg_before = False
                continue
            if msg.key() not in solved_key:
                keys_data[msg.key()] = []
                solved_key.append(msg.key())

            event = msg.value()
            msg_before = True
            if event is not None:
                nothing_new = False
                keys_data[msg.key()].append(event.data)

        except Exception as e:
            logger.error(e)
            consumer.commit()
            consumer.close()
    consumer.commit()
    logger.info("Data was read for users: " + str(keys_data.keys()))
    return keys_data


def input_file_handler(key, full_path):
    for root, dirs, files in walk(full_path):
        for file in files:
            if file.startswith(key + "_"):
                name_version = file.split(".")
                version = int(name_version[0].split("_")[1])
                version = version + 1
                filename = key + "_" + str(version) + ".txt"
                last_mod_timestamp = datetime.fromtimestamp(Path(full_path + file).stat().st_mtime)
                last_mod_of_file_min = int(
                    (datetime.now() - last_mod_timestamp).total_seconds() / 60)
                if last_mod_of_file_min > maximum_file_live_time_min:
                    logger.info("Deleting old data for user: " + key + " if it's more than " +
                                str(maximum_old_file_size_mb) + "MB")
                    delete_events_files(file, maximum_old_file_size_mb)
                    filename = key + "_" + str(1) + ".txt"
                    version = 1
                try:
                    rename(full_path + file, full_path + filename)
                except Exception as e:
                    logger.error(e)
                return filename, version

    return None, 1


def save_data_to_file(keys_data: dict, topic):
    keys_versions = dict()
    for key, data in keys_data.items():
        key = key.replace('\"', '')
        full_path = dir_path + "Data/" + topic + "/"
        filename, version = input_file_handler(key, full_path)
        keys_versions[key] = version

        if not filename:
            filename = key + "_" + str(1) + ".txt"

        makedirs(path.dirname(full_path + filename), exist_ok=True)
        with open(full_path + filename, "a") as file:
            for value in data:
                file.write(value)
            file.close()

    return keys_versions
