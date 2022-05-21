module M1 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
  let ip_1 = ref(env_acc#get_string "ip") in 
  let c1_2 = ref(env_acc#get_int "c1") in 
  let c2_3 = ref(env_acc#get_int "c2") in 
  let c3_4 = ref(env_acc#get_int "c3") in 
  let c4_5 = ref(env_acc#get_int "c4") in 
    ignore(Functions.action1 ip_1 c1_2 c2_3 c3_4 c4_5);
    env_acc#update_string "ip" !ip_1; 
    env_acc#update_int "c1" !c1_2; 
    env_acc#update_int "c2" !c2_3; 
    env_acc#update_int "c3" !c3_4; 
    env_acc#update_int "c4" !c4_5; 
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 1 (module M1) 

module M3 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
  let ip_1 = ref(env_acc#get_string "ip") in 
  let c1_2 = ref(env_acc#get_int "c1") in 
  let c2_3 = ref(env_acc#get_int "c2") in 
  let c3_4 = ref(env_acc#get_int "c3") in 
  let c4_5 = ref(env_acc#get_int "c4") in 
    ignore(Functions.action2 ip_1 c1_2 c2_3 c3_4 c4_5);
    env_acc#update_string "ip" !ip_1; 
    env_acc#update_int "c1" !c1_2; 
    env_acc#update_int "c2" !c2_3; 
    env_acc#update_int "c3" !c3_4; 
    env_acc#update_int "c4" !c4_5; 
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 3 (module M3) 

module M5 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
  let ip_1 = ref(env_acc#get_string "ip") in 
  let c1_2 = ref(env_acc#get_int "c1") in 
  let c2_3 = ref(env_acc#get_int "c2") in 
  let c3_4 = ref(env_acc#get_int "c3") in 
  let c4_5 = ref(env_acc#get_int "c4") in 
    ignore(Functions.action3 ip_1 c1_2 c2_3 c3_4 c4_5);
    env_acc#update_string "ip" !ip_1; 
    env_acc#update_int "c1" !c1_2; 
    env_acc#update_int "c2" !c2_3; 
    env_acc#update_int "c3" !c3_4; 
    env_acc#update_int "c4" !c4_5; 
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 5 (module M5) 

module M7 : ASTD_plugin_interfaces.Action_interface = 
struct 
let execute_action (env_acc : ASTD_environment.environment_accessor) : ASTD_environment.environment_accessor = 
  let ip_1 = ref(env_acc#get_string "ip") in 
  let c1_2 = ref(env_acc#get_int "c1") in 
  let c2_3 = ref(env_acc#get_int "c2") in 
  let c3_4 = ref(env_acc#get_int "c3") in 
  let c4_5 = ref(env_acc#get_int "c4") in 
    ignore(Functions.action4 ip_1 c1_2 c2_3 c3_4 c4_5);
    env_acc#update_string "ip" !ip_1; 
    env_acc#update_int "c1" !c1_2; 
    env_acc#update_int "c2" !c2_3; 
    env_acc#update_int "c3" !c3_4; 
    env_acc#update_int "c4" !c4_5; 
    env_acc 
end 
let () = ASTD_plugin_builder.register_action 7 (module M7) 

