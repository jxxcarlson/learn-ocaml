
open Graphics
open Array

type cell = float

(** The type of a  matrix of cells *)
type matrix = cell array array

let rows = 200
let columns = 200

let probability_of_birth = 0.08

let probability_of_death = 0.04

let population_density_low = 0.4

let population_density_high = 0.8

let init cell = Array.make_matrix rows columns cell

let get m i j = 
  if i < 0 || i >= rows || j < 0 || j >= columns then 0.0 else m.(i).(j)

let put cell i j m = 
  (m.(i)).(j) <- cell

let env m i j = 
 get m (i-1) j +. get m (i + 1) j +. get m i (j - 1) +. get m i (j + 1)

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


 let updateAt' m i j m' = 
   let e = env m i j in
   match e with 
    | 0.0 | 1.0  -> put 0.0 i j m'
    | 2.0        -> put (get m i j) i j m'
    | 3.0        -> put 1.0 i j m'
    | _          -> put 0.0 i j m'

 let updateAt density m i j m' = 
   let r = Random.float 1.0 
   in
   if r < probability_of_birth && density < population_density_low then put 1.0 i j m' 
   else if r < (probability_of_birth +. probability_of_death ) && density > population_density_high then put 0.0 i j m' 
   else updateAt' m i j m'

let update m = 
 let m' = copy m in
 let d = density m
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      updateAt d m' i j m
    done
  done
 

let random_cell (probability:float) = 
   if Base.Float.O.(<) (Random.float 1.0)  probability then 1.0 else 0.0


let randomCellAt probability m i j = 
  put (random_cell probability) i j m

let populate probability m  = 
 let m' = copy m 
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      randomCellAt probability m' i j
    done
  done


let is_close i' j' i j r = 
    abs(i - i') < r && abs (j - j') < r

let centered_around i' j' r m = 
  let m' = copy m in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      if is_close i' j' i j r then put (get m' i j) i j m
       else put 0.0 i j m
    done
  done

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
    
    
let run world n =     
    for i = 0 to n do 
        update world; 
        display world 800 800;
        set_color white;
        moveto 10 10;
        draw_string (string_of_int i);
        moveto 60 10;
        draw_string  (string_of_float (density world |> round_to 3));
        (* Unix.sleep 1 *)
    done


