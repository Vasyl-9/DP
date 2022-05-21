import logging
import os

from sys import stdout

# ---------------------------------------------------------------------------------------------
# docker names setup

docker_name = os.environ['NAME']
# ---------------------------------------------------------------------------------------------
# Logger setup

logger = logging.getLogger(docker_name)
logger.setLevel(logging.INFO)
log_formatter = logging.Formatter \
    ("%(name)-12s %(asctime)s %(levelname)-8s %(filename)s:%(funcName)s %(message)s")
console_handler = logging.StreamHandler(stdout)
console_handler.setFormatter(log_formatter)
logger.addHandler(console_handler)
# ---------------------------------------------------------------------------------------------
# Kafka setup

input_topic = "local_security_incident"
output_topic = "scanning_result"
kafka_address_port = "0.0.0.0:9092"
schema_registry_address_port = 'http://127.0.0.1:8081'
group_name = 'group - 2'
partition_id = os.environ['PARTITION_ID']
# ---------------------------------------------------------------------------------------------
# Another setup

maximum_file_live_time_min = 120
maximum_old_file_size_mb = 1
maximum_file_size_mb = 100
dir_path = "/home/vasyl/diploma_thesis/"
