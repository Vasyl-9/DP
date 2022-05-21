from pathlib import Path

import requests
from confluent_kafka import SerializingProducer
from confluent_kafka.schema_registry import SchemaRegistryClient
from confluent_kafka.schema_registry.avro import AvroSerializer
from confluent_kafka.serialization import StringSerializer


def obj_to_dict(obj, ctx):
    return dict(data=obj.data, session_id=obj.session_id, user_id=obj.user_id)


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
        print("Delivery failed for User record {}: {}".format(msg.key(), err))
        return
    print('User record {} successfully produced to {} [{}] at offset {}'.format(
        msg.key(), msg.topic(), msg.partition(), msg.offset()))


def produce_to_topic(key, data_list: [], topic, partition):
    value_schema = Path("schema/producer/input.avsc").read_text()
    schema_registry_conf = {'url': 'http://localhost:8081'}
    schema_registry_client = SchemaRegistryClient(schema_registry_conf)

    value_avro_serializer = AvroSerializer(value_schema, schema_registry_client, obj_to_dict)
    producer_conf = {'bootstrap.servers': '127.0.0.1:9092',
                     'key.serializer': StringSerializer('utf_8'),
                     'value.serializer': value_avro_serializer,
                     'queue.buffering.max.messages': 152000,
                     'client.id': key
                     }
    producer = SerializingProducer(producer_conf)
    producer.poll(1)
    for data in data_list:
        try:
            producer.produce(topic=topic, partition=partition, key=key, value=data,
                             on_delivery=delivery_report)
        except ValueError:
            print("Invalid input, discarding record...")
    print("\nProducing records of events has been finished")
    producer.flush()


def get_partition_from_manager(url, key):
    response = requests.post(url + key)
    return response.text
