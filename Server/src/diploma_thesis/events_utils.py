import json
import os
from multiprocessing import Pool

from setup import dir_path, input_topic, output_topic


def scanning_execution(input_file):
    cmd = "eval $(opam config env) ; cd " + dir_path + "Specification/LateralMovement ;" \
          "./iASTD -s lateral_movement.spec -i " + input_file + \
          " > " + dir_path + "Output/outLate.txt &" \
          "cd " + dir_path + "Specification/Ping ; ./iASTD -s ping.spec -i " \
          + input_file + " > " + dir_path + "Output/outPing.txt &" \
          "cd " + dir_path + "Specification/Ransomwares ; ./iASTD -s Ransomwares.spec -i " \
          + input_file + " > " + dir_path + "Output/outRans.txt &" \
          "cd " + dir_path + "Specification/Portscan ; ./iASTD -s portscan.spec" \
          " -i " + input_file + " > " + dir_path + "Output/outPortScan.txt &" \
          "cd " + dir_path + "Specification/RAT ; ./iASTD " \
          "-s rat.spec -i " + input_file + " > " + dir_path + "Output/outRAT.txt & wait"
    os.system(cmd)


def read_events_from_file(file_name):
    file = open(dir_path + "Output/" + file_name + ".txt", "r")
    line_before = ""
    exploit_output = []
    for current_line in file:
        if current_line == "\n":
            continue

        elif line_before == "========================================\n" and \
                current_line == "no more event to execute\n":
            return file_name, list()

        elif line_before == "========================================\n" and not exploit_output \
                and (current_line.find("Alert") != -1 or current_line.find("Exploit") != -1
                     or current_line.find("Info") != -1):
            exploit_output.append(current_line)

        elif exploit_output and current_line == "no more event to execute\n":
            return file_name, exploit_output

        elif exploit_output:
            exploit_output.append(current_line)

        elif current_line == "an event was not parsed correctly\n":
            exploit_output.append("Bad format of input events")
            return file_name, exploit_output

        line_before = current_line


def read_dict_from_file(file_name, topic) -> dict:
    output_dict = {}
    file_path = dir_path + "Data/" + topic + "/" + file_name + ".txt"
    if os.path.isfile(file_path):
        with open(file_path, "r") as file:
            output_dict = json.load(file)
        file.close()
    return output_dict


def write_dict_to_file(file_name, topic, data: dict):
    filename = dir_path + "Data/" + topic + "/" + file_name + ".txt"
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, "w") as file:
        json.dump(data, file)
        file.close()


def delete_events_files(file_name, events_size_mb):
    cmd = "cd " + dir_path + "Data/" + input_topic + " ; find -type f \\( -name \"" + file_name + \
          "*\" \\) -size +" + str(events_size_mb) + "M -delete -exec rm -rf " + dir_path + \
          "Data/" + output_topic + "/" + file_name + ".txt {} +"
    os.system(cmd)


def events_handling(input_file):
    scanning_execution(input_file)
    list_files = ["outLate", "outPing", "outRans", "outPortScan", "outRAT"]
    with Pool(processes=5) as pool:
        data_dict = dict(pool.map(read_events_from_file, list_files))
        pool.close()
        pool.join()

    for key, values in data_dict.items():
        exploit_output_list = list()
        for line in values:
            if line.find("\\\\") != -1:
                line = line.replace('\\\\', '\\')
            exploit_output_list.append(line)
        data_dict[key] = exploit_output_list
    return data_dict


def remove_duplicates_from_old_version(vulnerability_dict: dict, resolved_vulnerability_dict: dict):
    for key, values in resolved_vulnerability_dict.items():
        vulnerability_dict[key] = vulnerability_dict[key][len(values):]
    return vulnerability_dict
