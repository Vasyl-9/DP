import xml.etree.ElementTree as et
from pathlib import Path


class ASTDEvent:
    def __init__(self, event_info, system_time, image, cmdline, pid, target_object, target_filename,
                 details, hashes, protocol, adr_src, port_src, adr_dst, port_dst):
        self.event_info = event_info
        self.system_time = system_time
        self.image = image
        self.cmdline = cmdline
        self.pid = pid
        self.target_object = target_object
        self.target_filename = target_filename
        self.details = details
        self.hashes = hashes
        self.protocol = protocol
        self.adr_src = adr_src
        self.port_src = port_src
        self.adr_dst = adr_dst
        self.port_dst = port_dst

    def __str__(self):
        return 'e("' + self.event_info + '","' + self.system_time + '","' + self.image + '","' + \
               self.cmdline + '","' + self.pid + '","' + self.target_object + '","' + \
               self.target_filename + '","' + self.details + '","' + self.hashes + '","' + \
               self.protocol + '","' + self.adr_src + '","' + self.port_src + '","' + \
               self.adr_dst + '","' + self.port_dst + '")\n'


class Event(object):
    def __init__(self, data, session_id, user_id):
        self.data = data
        self.session_id = session_id
        self.user_id = user_id


def system_event_id_to_name(event_id):
    switcher = {
        1: "Process creation",
        2: "A process changed a file creation time",
        3: "Network connection",
        4: "Sysmon service state changed",
        5: "Process terminated",
        6: "Driver loaded",
        7: "Image loaded",
        8: "CreateRemoteThread",
        9: "RawAccessRead",
        10: "ProcessAccess",
        11: "FileCreate",
        12: "RegistryEvent (Object create and delete)",
        13: "RegistryEvent (Value Set)",
        14: "RegistryEvent (Key and Value Rename)",
        15: "FileCreateStreamHash",
        16: "Sysmon config state changed",
        17: "Pipe created",
        18: "Pipe connected",
        19: "WmiEventFilter activity detected",
        20: "WmiEventConsumer activity detected",
        21: "WmiEventConsumerToFilter activity detected",
        22: "DNSEvent",
        23: "FileDelete",
        24: "ClipboardChange",
        25: "ProcessTampering",
        26: "FileDeleteDetected",
        255: "Error",
    }
    return switcher.get(event_id, "Error")


def read_sysmon_logs_from_file(directory, filename, session_id, user_id):
    events_list = []
    schema = '{http://schemas.microsoft.com/win/2004/08/events/event}'
    print("Reading from file: " + filename)

    tree = et.parse(directory + '/' + filename)
    root = tree.getroot()
    for events in root:
        event_info = ""
        system_time = ""
        image = ""
        cmdline = ""
        pid = ""
        target_object = ""
        target_filename = ""
        details = ""
        hashes = ""
        protocol = ""
        adr_src = ""
        port_src = ""
        adr_dst = ""
        port_dst = ""

        for event in events:
            if event.tag == schema + 'System':
                for field in event:
                    if field.tag == schema + 'EventID':
                        event_info = system_event_id_to_name(int(field.text))
                    elif field.tag == schema + 'TimeCreated':
                        system_time = field.attrib['SystemTime'] \
                            .replace("T", " ").replace("Z", "")

            elif event.tag == schema + 'EventData':
                for field in event:
                    if field.tag == schema + 'Data':
                        if field.attrib['Name'] == 'Image':
                            image = field.text.replace("\\", "\\\\") \
                                .replace("\n", "").replace("  ", "")
                        elif field.attrib['Name'] == 'CommandLine':
                            cmdline = field.text.replace("\\", "\\\\") \
                                .replace("\n", "").replace("  ", "").replace("\"", "")
                        elif field.attrib['Name'] == 'ProcessId':
                            pid = field.text.replace("\n", "")
                        elif field.attrib['Name'] == 'TargetObject':
                            target_object = field.text.replace("\n", "")
                        elif field.attrib['Name'] == 'TargetFilename':
                            target_filename = field.text.replace("\n", "")
                        elif field.attrib['Name'] == 'Details':
                            details = field.text.replace("\n", "")
                        elif field.attrib['Name'] == 'Hashes':
                            hashes = field.text.replace("\n", "").replace("  ", "")
                        elif field.attrib['Name'] == 'Protocol':
                            protocol = field.text.replace("\n", "")
                        elif field.attrib['Name'] == 'SourceIp':
                            adr_src = field.text
                        elif field.attrib['Name'] == 'SourcePort':
                            port_src = field.text
                        elif field.attrib['Name'] == 'DestinationIp':
                            adr_dst = field.text
                        elif field.attrib['Name'] == 'DestinationPort':
                            port_dst = field.text
            else:
                print("Bad format of events in file: " + str(filename) + ". Skip this file")
                return list()

        event = ASTDEvent(event_info, system_time, image, cmdline, pid, target_object,
                          target_filename, details, hashes, protocol, adr_src, port_src,
                          adr_dst, port_dst)
        events_list.append(Event(data=event.__str__(), session_id=session_id, user_id=user_id))
    return events_list


def read_sysmon_logs_from_dir(directory, solved_path_list, session_id, user_id):
    base_path = Path(directory + '/')
    list_events = []

    for entry in base_path.iterdir():
        if entry.is_file():
            if entry.name not in solved_path_list:
                solved_path_list.append(entry.name)
                list_events = list_events + read_sysmon_logs_from_file(directory, entry.name,
                                                                       session_id, user_id)
            else:
                print("File " + entry.name + " already solved. Skipping data from this file")
    print("Data from " + directory + " was read: " + str(len(list_events)))
    return list_events, solved_path_list


def read_events_from_file(filename, session_id, user_id):
    events_list = []
    print("Reading from file: " + filename)
    file = open(filename, "r")
    for current_line in file:
        if not current_line.startswith("e(\""):
            print("Bad format of events in file: " + str(filename) + ". Skip this file")
            return list()
        events_list.append(Event(data=current_line, session_id=session_id, user_id=user_id))
    return events_list


def read_events_from_dir(directory, solved_path_list, session_id, user_id):
    events_list = []
    base_path = Path(directory + '/')

    for entry in base_path.iterdir():
        if entry.is_file():
            if entry.name not in solved_path_list:
                solved_path_list.append(entry.name)
                events_list = events_list + read_events_from_file(directory + '/' + entry.name,
                                                                  session_id, user_id)
            else:
                print("File " + entry.name + " already solved. Skipping data from this file")
    print("Data from " + directory + " was read: " + str(len(events_list)))
    return events_list, solved_path_list
