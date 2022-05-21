import time

from events_utils import events_handling, read_dict_from_file, write_dict_to_file, \
    delete_events_files, remove_duplicates_from_old_version
from kafka_utils import Vulnerability, consume_from_topic, produce_to_topic, save_data_to_file
from setup import logger, input_topic, output_topic, maximum_file_size_mb, dir_path

if __name__ == '__main__':
    while True:
        keys_data = dict()
        while not keys_data:
            keys_data = consume_from_topic(input_topic)

        logger.info("Start of processing incidents")
        start = time.perf_counter()
        keys_versions = save_data_to_file(keys_data, input_topic)
        keys_data = None

        for key in keys_versions.keys():
            version = keys_versions.get(key)
            filename = key + "_" + str(version)
            vulnerability_dict = events_handling(dir_path + "Data/" + input_topic + "/" +
                                                 filename + ".txt")
            resolved_vulnerability_dict = read_dict_from_file(key, output_topic)
            if resolved_vulnerability_dict:
                new_vulnerability_dict = remove_duplicates_from_old_version(
                    vulnerability_dict, resolved_vulnerability_dict)
                write_dict_to_file(key, output_topic, vulnerability_dict)
                logger.info("Deleting data for user: " + key + " if it's more than " +
                            str(maximum_file_size_mb) + "MB")
                delete_events_files(key, maximum_file_size_mb)
                vulnerability_dict = new_vulnerability_dict
                new_vulnerability_dict = None
            else:
                write_dict_to_file(key, output_topic, vulnerability_dict)

            for dict_key in vulnerability_dict:
                if len(vulnerability_dict[dict_key]) < 1:
                    vulnerability_dict[dict_key] = ["No new events"]

            vulnerability_list = []
            for dict_key in vulnerability_dict:
                for data in vulnerability_dict[dict_key]:
                    vulnerability_list.append(Vulnerability(data=data,
                                                            specification=dict_key.lstrip("out"),
                                                            version=version, user_id=key))
            produce_to_topic(key, vulnerability_list, output_topic)

        end = time.perf_counter()
        logger.info(f'Processing incidents finished in {round(end - start, 2)} second(s)')
        logger.info("-------------------------------------------------------------------")
