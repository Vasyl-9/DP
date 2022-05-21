module M2 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
  let count_1 = ref(env_acc#get_int "count") in 
  let thres_2 = ref(env_acc#get_int "thres") in 
  let recon_end_3 = ref(env_acc#get_int "recon_end") in 
    ignore(Functions.action1 count_1 thres_2 recon_end_3);
    env_acc#update_int "count" !count_1; 
    env_acc#update_int "thres" !thres_2; 
    env_acc#update_int "recon_end" !recon_end_3; 
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 2 (module M2) 

module M5 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.action2 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 5 (module M5) 

module M7 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert1 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 7 (module M7) 

module M9 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert2 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 9 (module M9) 

module M15 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert5 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 15 (module M15) 

module M13 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert4 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 13 (module M13) 

module M11 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert3 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 11 (module M11) 

module M17 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
    ignore(Functions.alert6 ());
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 17 (module M17) 

