let file = "assets.txt"
let message = "Hello!"
  
let () =
  (* Write message to file *)
  (* let oc = open_out file in (* create or truncate file, return channel *)
    Printf.fprintf oc "%s\n" message; (* write something *)   
    close_out oc;                     (* flush and close the channel *)
   *)
  (* Read file and display the first line *)
  (* let ic = open_in file in
    try 
      let line = input_line ic in (* read line, discard \n *)
        print_endline line;       (* write the result to stdout *)
        flush stdout;             (* write on the underlying device now *)
        close_in ic               (* close the input channel *) 
    with e ->                     (* some unexpected exception occurs *)
      close_in_noerr ic;          (* emergency closing *)
      raise e                     (* exit with error: files are closed but *)
          *)


(* 
let ic = open_in file in
try 
    let lines = input_lines ic in (* read line, discard \n *)
    close_in ic               (* close the input channel *) 
with e ->                     (* some unexpected exception occurs *)
    close_in_noerr ic;          (* emergency closing *)
    raise e                     exit with error: files are closed but
         *)

let readlines file = let ic = open_in file in 
let rec aux() = 
  try let s = input_line ic in s :: aux() with  
  End_of_file -> []
in aux()


(* let read_file_to_strings "assets.txt" =
  let file = In_channel.create filename in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings *)        