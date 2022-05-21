
let comp (s1 : int ref ) (s2 : int) : bool =
    let x = compare !s1 s2 in
    if x > 0 then true else false

let action1 (count : int ref) (threshold : int ref) (recon_end : int ref) : unit = 
    count := !count+1;
    if !count >= !threshold then (print_endline ("Alert Portscan attack - "^(string_of_int(!count))^" scanned ports"); count := 0; recon_end := 1)

let action2 () : unit = 
   print_endline "Alert Metasploit Privilege Escalation"

let contains s1 s2 =
  (*try ignore(Pcre.exec ~s2 s1); (true)
  with Not_found -> (false)*)
  let re = Str.regexp s2
    in
        try ignore(Str.search_forward re s1 0); true
        with Not_found -> false

let alert1 () : unit = 
   print_endline "Info: User permission changed"

let alert2 () : unit = 
   print_endline "Info: Remote command execution"

let alert3 () : unit = 
   print_endline "Info: Breaking password attempts"

let alert4 () : unit = 
   print_endline "Info: Task command execution"

let alert5 () : unit = 
   print_endline "Info; Register modification"

let alert6 () : unit = 
   print_endline "Info: Malicious communication relay"