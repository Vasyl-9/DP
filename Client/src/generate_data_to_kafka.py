from re import findall
from time import sleep
from uuid import getnode, uuid4

from events_utils import read_sysmon_logs_from_dir, read_events_from_dir
from kafka_utils import produce_to_topic, get_partition_from_manager

if __name__ == "__main__":
    session_id = str(uuid4())
    user_id = ':'.join(findall('..', '%012x' % getnode()))
    partition_manager_url = 'http://localhost:8080/partition/set/'
    partition = int(get_partition_from_manager(partition_manager_url, user_id))
    solved_path = []
    while True:
        sysmon_events_list, solved_path = read_sysmon_logs_from_dir("sysmon_logs", solved_path,
                                                                    session_id, user_id)
        local_events_list, solved_path = read_events_from_dir("astd_events", solved_path,
                                                              session_id, user_id)
        if len(sysmon_events_list) > 0 or len(local_events_list) > 0:
            produce_to_topic(user_id, sysmon_events_list + local_events_list,
                             "local_security_incident", partition)
            print("Data was sent")

        print("Waiting for a new data")
        sleep(10)
