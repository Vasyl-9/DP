module G0 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let ipsrc = env_acc#get_string "ipsrc" in 
  let portsrc = env_acc#get_string "portsrc" in 
  let tcpflags1 = env_acc#get_string "tcpflags1" in 
  let payload = env_acc#get_string "payload" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let portdst = env_acc#get_string "portdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
  let recon_end = env_acc#get_int "recon_end" in 
    tcpflags1 = "S" && recon_end = 0
end 
let () = ASTD_plugin_builder.register_guard 0 (module G0) 

module G1 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let ipsrc = env_acc#get_string "ipsrc" in 
  let portsrc = env_acc#get_string "portsrc" in 
  let tcpflags2 = env_acc#get_string "tcpflags2" in 
  let payload = env_acc#get_string "payload" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let portdst = env_acc#get_string "portdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
  let recon_end = env_acc#get_int "recon_end" in 
    tcpflags2 = "RA"
end 
let () = ASTD_plugin_builder.register_guard 1 (module G1) 

module G3 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let portsrc = env_acc#get_string "portsrc" in 
  let portdst = env_acc#get_string "portdst" in 
  let tcpflags1 = env_acc#get_string "tcpflags1" in 
  let payload = env_acc#get_string "payload" in 
  let ipsrc = env_acc#get_string "ipsrc" in 
  let ipdst = env_acc#get_string "ipdst" in 
    tcpflags1 = "S"
end 
let () = ASTD_plugin_builder.register_guard 3 (module G3) 

module G4 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let portdst = env_acc#get_string "portdst" in 
  let portsrc = env_acc#get_string "portsrc" in 
  let tcpflags2 = env_acc#get_string "tcpflags2" in 
  let payload = env_acc#get_string "payload" in 
  let ipsrc = env_acc#get_string "ipsrc" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (Functions.contains payload "stdapi") && (tcpflags2 = "SA") then print_endline (ipdst^" exploits Standard API on the victim machine "^ipsrc);
    (Functions.contains payload "stdapi") && (tcpflags2 = "SA")
end 
let () = ASTD_plugin_builder.register_guard 4 (module G4) 

module G18 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let thres = env_acc#get_int "thres" in 
  let recon_end = env_acc#get_int "recon_end" in 
    if recon_end = 1 then print_endline ("Exploit phase started");
    recon_end = 1
end 
let () = ASTD_plugin_builder.register_guard 18 (module G18) 

module G6 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && ((Functions.contains cmdline "\\(net\\|net1\\)  user") 
    || (Functions.contains cmdline "icacls"))  then print_endline ("Alert attempted user privilege gain - cmdline="^cmdline^" from host "^ipdst^" on port "^port_dst);
    (addr_dst = ipdst) && ((Functions.contains cmdline "\\(net\\|net1\\)  user") 
    || (Functions.contains cmdline "icacls")) 
end 
let () = ASTD_plugin_builder.register_guard 6 (module G6) 

module G8 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && ((Functions.contains cmdline "bitsadmin") 
    || (Functions.contains cmdline "\\\\winrm.cmd")
    || (Functions.contains cmdline "winrm/config/client @\\{TrustedHosts=")
    || (Functions.contains cmdline "\\\\winrs.exe")
    || (Functions.contains cmdline "\\\\wmiexec.vbs")
    || (Functions.contains cmdline "PsExec")
    || (Functions.contains cmdline "wmic")
    || (Functions.contains cmdline "\\(/PRIVILEGES\\|call setpriority\\|process where name\\)"))  then print_endline ("Alert remote command execution - cmdline="^cmdline^" from host "^ipdst^" on port "^port_dst);
    
    (addr_dst = ipdst) && ((Functions.contains cmdline "bitsadmin") 
    || (Functions.contains cmdline "\\\\winrm.cmd")
    || (Functions.contains cmdline "winrm/config/client @\\{TrustedHosts=")
    || (Functions.contains cmdline "\\\\winrs.exe")
    || (Functions.contains cmdline "\\\\wmiexec.vbs")
    || (Functions.contains cmdline "PsExec")
    || (Functions.contains cmdline "wmic")
    || (Functions.contains cmdline "\\(/PRIVILEGES\\|call setpriority\\|process where name\\)"))
    
end 
let () = ASTD_plugin_builder.register_guard 8 (module G8) 

module G14 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && (Functions.contains cmdline "reg  \\(delete\\|add\\|load\\|copy\\|save\\|query\\)")  then print_endline ("Alert registry modification - cmdline="^cmdline);
    
    (addr_dst = ipdst) && (Functions.contains cmdline "reg  \\(delete\\|add\\|load\\|copy\\|save\\|query\\)")
end 
let () = ASTD_plugin_builder.register_guard 14 (module G14) 

module G12 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && ((Functions.contains cmdline "schtasks /\\(create\\|run\\|delete\\)") 
    || (Functions.contains image "\\\\taskkill.exe"))  then print_endline ("Alert task command execution - cmdline="^cmdline^",image="^image);
    
    (addr_dst = ipdst) && ((Functions.contains cmdline "schtasks /\\(create\\|run\\|delete\\)") 
    || (Functions.contains image "\\\\system32\\\\taskkill.exe"))
end 
let () = ASTD_plugin_builder.register_guard 12 (module G12) 

module G10 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && ((Functions.contains cmdline "john") 
    || (Functions.contains image "unshadow")
    || (Functions.contains image "\\(mimikatz\\|mimilove\\)"))  then print_endline ("Alert pass the hash/ticket attempts - cmdline="^cmdline^",image="^image);
    
    (addr_dst = ipdst) && ((Functions.contains cmdline "john") 
    || (Functions.contains image "unshadow")
    || (Functions.contains image "\\(mimikatz\\|mimilove\\)"))
end 
let () = ASTD_plugin_builder.register_guard 10 (module G10) 

module G16 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let event = env_acc#get_string "event" in 
  let systime = env_acc#get_string "systime" in 
  let image = env_acc#get_string "image" in 
  let cmdline = env_acc#get_string "cmdline" in 
  let pid = env_acc#get_string "pid" in 
  let targetobject = env_acc#get_string "targetobject" in 
  let targetfilename = env_acc#get_string "targetfilename" in 
  let details = env_acc#get_string "details" in 
  let hashes = env_acc#get_string "hashes" in 
  let proto = env_acc#get_string "proto" in 
  let addr_src = env_acc#get_string "addr_src" in 
  let port_src = env_acc#get_string "port_src" in 
  let addr_dst = env_acc#get_string "addr_dst" in 
  let port_dst = env_acc#get_string "port_dst" in 
  let ipdst = env_acc#get_string "ipdst" in 
    if (addr_dst = ipdst) && ((event="5156") || (Functions.contains cmdline "HTran -\\(slave\\|tran\\|remove\\)"))  then print_endline ("Alert Malicious command relay - cmdline="^cmdline);
    
    (addr_dst = ipdst) && ((event="5156") || (Functions.contains cmdline "HTran -\\(slave\\|tran\\|remove\\)"))
end 
let () = ASTD_plugin_builder.register_guard 16 (module G16) 

