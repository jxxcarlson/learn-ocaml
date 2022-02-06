
open Matrix
open Base

type initialData = { probability_of_birth : float }

let probability_of_birth = 0.02 (* 0.08 *)

let probability_of_death = 0.04

let population_density_low = 0.4

let population_density_high = 0.8

let init cell = Array.make_matrix ~dimx:rows ~dimy:columns cell


(* let is_close i' j' i j r = 
    abs(i - i') < r && abs (j - j') < r

let centered_around i' j' r m = 
  let m' = copy m in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      if is_close i' j' i j r then put (get m' i j) i j m
       else put 0.0 i j m
    done
  done *)

let env m i j = 
 get m (i-1) j +. get m (i + 1) j +. get m i (j - 1) +. get m i (j + 1)

 let random_cell (probability:float) = 
   if Base.Float.O.(<) (Random.float 1.0)  probability then 1.0 else 0.0


let randomCellAt probability m i j = 
  put (random_cell probability) i j m

let populate probability m  = 
 let m' = Array.copy m 
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      randomCellAt probability m' i j
    done
  done


 let updateAt' m i j m' = 
   let e = env m i j in
   match e with 
    | 0.0 | 1.0  -> put 0.0 i j m'
    | 2.0        -> put (get m i j) i j m'
    | 3.0        -> put 1.0 i j m'
    | _          -> put 0.0 i j m'

 let updateAt density m i j m' = 
   let r = Random.float 1.0  in
   let open Float.O
   in
   if r < probability_of_birth && density < population_density_low then put 1.0 i j m' 
   else if r < (probability_of_birth +. probability_of_death ) && density > population_density_high then put 0.0 i j m' 
   else updateAt' m i j m'

let update m = 
 let m' = Array.copy m in
 let d = density m
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      updateAt d m' i j m
    done
  done
 

 let run world n =     
    for i = 0 to n do 
        update world; 
        display world 800 800;
        Graphics.set_color Graphics.white;
         Graphics.moveto 10 10;
         Graphics.draw_string (Int.to_string i);
         Graphics.moveto 60 10;
         Graphics.draw_string  (Float.to_string (density world |> round_to 3));
        (* Unix.sleep 1 *)
    done