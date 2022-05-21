module G0 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let request = env_acc#get_string "request" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
    request = "ICMP echo request"
end 
let () = ASTD_plugin_builder.register_guard 0 (module G0) 

module G1 : ASTD_plugin_interfaces.Guard_interface = 
struct 
let [@ocaml.warning "-26"] execute_guard (env_acc : ASTD_environment.environment_accessor) : bool = 
  let reply = env_acc#get_string "reply" in 
  let ipdst = env_acc#get_string "ipdst" in 
  let count = env_acc#get_int "count" in 
  let thres = env_acc#get_int "thres" in 
    reply = "ICMP echo reply"
end 
let () = ASTD_plugin_builder.register_guard 1 (module G1) 

