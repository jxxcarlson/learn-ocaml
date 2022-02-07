
open Matrix
open Base

type data = { probability_of_birth :   float; 
              probability_of_death:    float;
              population_density_low:  float;
              population_density_high: float;
              steps : int;
              title: string  
              }


let data = { probability_of_birth = 0.02;
                    probability_of_death = 0.00;
                    population_density_low = 0.2;
                    population_density_high = 0.3;
                    steps = 100_000;
                    title = "Game of Life"
                  }


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


let nextCell data density' m i j = 
  let r = Random.float 1.0  in
  let open Float.O
  in
  if r < data.probability_of_birth && density' < data.population_density_low then 1.0
   else if r < (data.probability_of_birth +. data.probability_of_death ) && density' > data.population_density_high then 0.0 
   else 
    let e = env m i j 
    in
    match e with 
        | 0.0 | 1.0  -> 0.0
        | 2.0        -> get m i j
        | 3.0        -> 1.0
        | _          -> 0.0
  

 (* let updateAt density m i j m' = 
   let r = Random.float 1.0  in
   let open Float.O
   in
   if r < probability_of_birth && density < population_density_low then put 1.0 i j m' 
   else if r < (probability_of_birth +. probability_of_death ) && density > population_density_high then put 0.0 i j m' 
   else updateAt' m i j m' *)

let init data = 
   let 
     m = Array.make_matrix ~dimx:rows ~dimy:columns 0.0;
     
   in 
   begin  
     populate data.probability_of_birth m;
     m
   end


let update data m = 
 let m' = Array.copy m in
 let density' = density m
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      put (nextCell data density' m' i j) i j m'
    done
  done
 
 let displayCellBlue row column dx dy cell = 
  let x = column*dx in
  let y = row*dy in
  let open Float.O in
  if cell = 1.0 then 
    begin
     Graphics.set_color Graphics.blue;
     Graphics.fill_rect x y dx dy
    end
  else
    begin
     Graphics.set_color Graphics.black;
     Graphics.fill_rect x y dx dy
    end
     ;;

 let run data =  
    let 
      world = init data
    in   
    for i = 0 to data.steps do 
         Matrix.display world displayCellBlue 800 800;
         Graphics.set_color Graphics.white;
         Graphics.moveto 10 10;
         Graphics.draw_string (Int.to_string i);
         Graphics.moveto 60 10;
         Graphics.draw_string  (Float.to_string (density world |> round_to 3));
         update data world; 
        (* Unix.sleep 1 *)
    done