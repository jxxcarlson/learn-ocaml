



module type MATRIX = sig
(** The type of a cell *)
type cell

(** The type of a  matrix of cells *)
type t = cell array array

type displayCell= int -> int -> int -> int -> cell -> unit

val rows : int

val columns : int

val init : cell -> t

val get : t -> int -> int ->  cell

val put : cell  -> int -> int ->  t -> unit

val display:  t -> displayCell -> int -> int -> unit

val density : t -> float

end


module IntMatrix : MATRIX with type cell = int = struct

type cell = int

type t = cell array array

type displayCell= int -> int -> int -> int -> cell -> unit


(* PARAMETERS *)

let rows = 200
let columns = 200



(* FUNCTIONS *)


let init cell = Array.make_matrix rows columns cell 

let get m i j = 
  if i < 0 || i >= rows || j < 0 || j >= columns then 0 else m.(i).(j)

let put cell i j m = 
  (m.(i)).(j) <- cell

let sum m = 
  let s = ref 0
  in
    for i = 0 to (rows - 1) do 
      for j = 0 to (columns - 1) do 
        s := !s + get m i j
      done
    done;
  !s

let density m = 
  (Float.of_int (sum m)) /. (Float.of_int (rows*columns))


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
    
    

end



module FloatMatrix : MATRIX with type cell = float = struct

type cell = float

type t = cell array array

type displayCell= int -> int -> int -> int -> cell -> unit


(* PARAMETERS *)

let rows = 200
let columns = 200



(* FUNCTIONS *)

let init cell = Array.make_matrix rows columns cell 


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
    
    

end

