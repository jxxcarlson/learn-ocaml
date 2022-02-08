
open Base

type cell = float

(** The type of a  matrix of cells *)
type matrix = cell array array

type displayCell = int -> int -> int -> int -> cell -> unit


(* PARAMETERS *)

let rows = 200
let columns = 200



(* FUNCTIONS *)


let get m i j = 
  if i < 0 || i >= rows || j < 0 || j >= columns then 0.0 else m.(i).(j)

let put cell i j m = 
  (m.(i)).(j) <- cell


let sum m = 
  let s = ref 0.0
  in
    for i = 0 to (rows - 1) do 
      for j = 0 to (columns - 1) do 
        s := !s +. get m i j
      done
    done;
  !s

let density m = 
  (sum m) /. (Float.of_int (rows*columns))


let display m displayCell width height =
  let dx = width / columns in
  let dy = height / rows in
  begin
   (* auto_synchronize false; *)
   for i = 0 to (rows - 1) do 
      for j = 0 to (columns - 1) do 
        displayCell i j dx dy (get m i j)
      done
    done;
   (* synchronize(); *)
   end
    
    



