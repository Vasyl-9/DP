module G0 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let tcpflags1 = env_acc#get_string "tcpflags1" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let portdst = env_acc#get_string "portdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
    tcpflags1 = "S"
end 
let () = ASTD_plugin_builder.register_guard 0 (module G0) 

module G1 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let tcpflags2 = env_acc#get_string "tcpflags2" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let portdst = env_acc#get_string "portdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
    tcpflags2 = "RA"
end 
let () = ASTD_plugin_builder.register_guard 1 (module G1) 

