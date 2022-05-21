import logging
import sys
import time
from re import findall
from uuid import getnode, uuid4

from events_utils import read_and_parse_sysmon_logs, read_events_from_dir
from kafka_utils import produce_to_topic, get_partition_from_manager

# -------------------------------------
# Logger setup
logger = logging.getLogger("local")
logger.setLevel(logging.INFO)
log_formatter = logging.Formatter \
    ("%(name)-12s %(asctime)s %(levelname)-8s %(filename)s:%(funcName)s %(message)s")
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setFormatter(log_formatter)
logger.addHandler(console_handler)
# -------------------------------------

if __name__ == "__main__":
    session_id = str(uuid4())
    user_id = ':'.join(findall('..', '%012x' % getnode()))
    url = 'http://localhost:8080/partition/set/'
    partition = int(get_partition_from_manager(url, user_id))
    solved_path = []
    sysmon_events_list, solved_path = read_and_parse_sysmon_logs("sysmon_logs", solved_path,
                                                                 session_id, user_id)
    local_events_list, solved_path = read_events_from_dir("astd_events", solved_path,
                                                          session_id, user_id)
    for i in range(5):
        produce_to_topic(user_id, sysmon_events_list + local_events_list,
                         "local_security_incident", partition)
        logger.info("Iteration: " + str(i) + ".Data was sent: " + str(len(sysmon_events_list) +
                                                                      len(local_events_list)))
        time.sleep(60)
    logger.info("All data was sent.")
