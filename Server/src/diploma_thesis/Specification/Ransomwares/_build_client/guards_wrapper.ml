module G0 : ASTD_plugin_interfaces.Guard_interface = 
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
  let ip = env_acc#get_string "ip" in 
  let c1 = env_acc#get_int "c1" in 
  let c2 = env_acc#get_int "c2" in 
  let c3 = env_acc#get_int "c3" in 
  let c4 = env_acc#get_int "c4" in 
    if (Functions.contains event "Process Create")
    && (addr_src = ip) 
    && ((Functions.contains cmdline "Temp\\\\.\\([0-9a-f]+\\).\\(exe\\|EXE\\)")
    ||(Functions.contains cmdline "\\(Desktop.\\\\[a-zA-Z]+\\|\\(admin\\|ProgramData\\).\\\\[a-zA-Z]+.\\\\[a-zA-Z]+\\).\\(exe\\|bat\\|vbs\\)$")
    || (Functions.contains cmdline "\\\\Temp/file.vbs")) then print_endline ("Alert suspicious process="^cmdline^" on host "^ip^", port "^port_dst);
    
    
    (Functions.contains event "Process Create")
    && (addr_src = ip) 
    && ((Functions.contains cmdline "Temp\\\\.\\([0-9a-f]+\\).\\(exe\\|EXE\\)")
    ||(Functions.contains cmdline "\\(Desktop.\\\\[a-zA-Z]+\\|\\(admin\\|ProgramData\\).\\\\[a-zA-Z]+.\\\\[a-zA-Z]+\\).\\(exe\\|bat\\|vbs\\)$")
    || (Functions.contains cmdline "\\\\Temp/file.vbs"))
end 
let () = ASTD_plugin_builder.register_guard 0 (module G0) 

module G2 : ASTD_plugin_interfaces.Guard_interface = 
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
  let ip = env_acc#get_string "ip" in 
  let c1 = env_acc#get_int "c1" in 
  let c2 = env_acc#get_int "c2" in 
  let c3 = env_acc#get_int "c3" in 
  let c4 = env_acc#get_int "c4" in 
    if (Functions.contains event "Registry Value Set")
    && (addr_src = ip) 
    && (Functions.contains targetobject "HK\\(U\\|LV\\|LM\\|CR\\)\\\\")
    && ((Functions.contains targetobject "\\\\Run.\\\\[a-zA-Z]+.\\(exe\\|vbs\\|bat\\)")
    ||(Functions.contains targetobject "\\\\[A-Za-z]+.\\\\Start")
    ||(Functions.contains cmdline "/d 0 /t REG_DWORD /f")) then print_endline ("Alert Registry modif cmdline="^cmdline^",targetobject="^targetobject^" on host "^ip^", port "^port_dst);
    
    
    (Functions.contains event "Registry Value Set")
    && (addr_src = ip) 
    && (Functions.contains targetobject "HK\\(U\\|LV\\|LM\\|CR\\)\\\\")
    && ((Functions.contains targetobject "\\\\Run.\\\\[a-zA-Z]+.\\(exe\\|vbs\\|bat\\)")
    ||(Functions.contains targetobject "\\\\[A-Za-z]+.\\\\Start")
    ||(Functions.contains cmdline "/d 0 /t REG_DWORD /f"))
    
    
end 
let () = ASTD_plugin_builder.register_guard 2 (module G2) 

module G4 : ASTD_plugin_interfaces.Guard_interface = 
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
  let ip = env_acc#get_string "ip" in 
  let c1 = env_acc#get_int "c1" in 
  let c2 = env_acc#get_int "c2" in 
  let c3 = env_acc#get_int "c3" in 
  let c4 = env_acc#get_int "c4" in 
    if (Functions.contains event "Network Connection")
    && (proto = "tcp") 
    && (addr_src = ip) 
    && (Functions.set_contains [80;443;444;445;4444] port_dst)
    && not (Functions.isnull addr_dst) then print_endline ("Alert '"^image^"' suspicious connection to "^addr_dst^" on port "^port_dst);
    
    (Functions.contains event "Network Connection")
    && (proto = "tcp") 
    && (addr_src = ip) 
    && (Functions.set_contains [80;443;444;445;4444] port_dst)
    && not (Functions.isnull addr_dst)
end 
let () = ASTD_plugin_builder.register_guard 4 (module G4) 

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
  let ip = env_acc#get_string "ip" in 
  let c1 = env_acc#get_int "c1" in 
  let c2 = env_acc#get_int "c2" in 
  let c3 = env_acc#get_int "c3" in 
  let c4 = env_acc#get_int "c4" in 
    if (Functions.contains event "File Create")
    && (addr_src = ip) 
    && ((Functions.contains targetfilename "\\\\[0-9a-zA-Z]+.\\(bat\\|vbs\\)$")
    || (Functions.contains targetfilename "\\\\ProgramData.\\\\[a-zA-Z]+.\\\\[a-zA-Z]+.\\(exe\\|EXE\\)")) then print_endline ("Alert suspicious file targetfilename= "^targetfilename^" on host "^ip^", port "^port_dst);
    
    (Functions.contains event "File Create")
    && (addr_src = ip) 
    && ((Functions.contains targetfilename "\\\\[0-9a-zA-Z]+.\\(bat\\|vbs\\)$")
    || (Functions.contains targetfilename "\\\\ProgramData.\\\\[a-zA-Z]+.\\\\[a-zA-Z]+.\\(exe\\|EXE\\)"))
    
end 
let () = ASTD_plugin_builder.register_guard 6 (module G6) 

