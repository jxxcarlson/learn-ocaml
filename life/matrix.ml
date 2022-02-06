
open Graphics
open Base

type cell = float

(** The type of a  matrix of cells *)
type matrix = cell array array

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


let rec power x n = 
  if n = 0 then 1.0
    else x *. (power x (n - 1))

let round_to n x = 
  let factor = power 10.0 n in
  let x = Float.round (factor *. x)
  in x/.factor



let displayCell row column dx dy cell = 
  let x = column*dx in
  let y = row*dy in
  let open Float.O in
  if cell = 1.0 then 
    begin
     set_color red;
     fill_rect x y dx dy
    end
  else
    begin
     set_color black;
     fill_rect x y dx dy
    end
     ;;



let display m width height =
  let dx = width / columns in
  let dy = height / rows in
  begin
   auto_synchronize false;
   for i = 0 to (rows - 1) do 
      for j = 0 to (columns - 1) do 
        displayCell i j dx dy (get m i j)
      done
    done;
   synchronize();
   end
    
    



