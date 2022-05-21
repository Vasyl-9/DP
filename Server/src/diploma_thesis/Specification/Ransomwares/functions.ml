
let alert (msg : string) : unit = 
   print_endline msg

let contains s1 s2 =
    let re = Str.regexp s2
    in
        try ignore (Str.search_forward re s1 0); true
        with Not_found -> false

let set_contains arr elem  =
  List.mem (int_of_string elem) arr

let isnull (str: string) : bool = 
  str = ""

let action1(ip : string ref) (c1 : int ref) (c2 : int ref) (c3 : int ref)(c4 : int ref) : unit =
  if !c1 = 0 then c1 := 1;
  (*print_endline ("c1 = "^(string_of_int !c1)^"c2 = "^(string_of_int !c2)^"c3 = "^(string_of_int !c3)^"c4 = "^(string_of_int !c4));*)
  if !c2 = 1 || !c3 = 1 || !c4 = 1 then
     alert("Ransomware attack") 

let action2(ip : string ref) (c1 : int ref) (c2 : int ref) (c3 : int ref)(c4 : int ref) : unit =
  if !c2 = 0 then c2 := 1;
  if !c1 = 1 || !c3 = 1 || !c4 = 1 then
     alert("Ransomware attack")

let action3(ip : string ref) (c1 : int ref) (c2 : int ref) (c3 : int ref)(c4 : int ref) : unit =
  if !c3 = 0 then c3 := 1;
  if !c1 = 1 || !c2 = 1 || !c4 = 1 then
     alert("Ransomware attack") 

let action4(ip : string ref) (c1 : int ref) (c2 : int ref) (c3 : int ref)(c4 : int ref) : unit =
  if !c4 = 0 then c4 := 1;
  if !c1 = 1 || !c2 = 1 || !c3 = 1 then
     alert("Ransomware attack")