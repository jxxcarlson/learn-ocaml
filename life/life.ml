
open Matrix
open Base

type data = { probability_of_birth :   float; 
              probability_of_death:    float;
              population_density_low:  float;
              population_density_high: float;
              early_epoch : int; 
              steps : int;
              title: string  
              }


let data = { probability_of_birth = 0.08;
                    probability_of_death = 0.00;
                    population_density_low = 0.2;
                    population_density_high = 0.3;
                    early_epoch = 10;
                    steps = 100_000;
                    title = "Game of Life"
                  }



let rec power x n = 
  if n = 0 then 1.0
    else x *. (power x (n - 1))

let round_to n x = 
  let factor = power 10.0 n in
  let x = Float.round (factor *. x)
  in x/.factor


let env m i j = 
 IntMatrix.get m (i-1) j + IntMatrix.get m (i + 1) j + IntMatrix.get m i (j - 1) + IntMatrix.get m i (j + 1)

 let random_cell (probability:float) = 
   if Base.Float.O.(<) (Random.float 1.0)  probability then 1 else 0


let randomCellAt probability m i j = 
  IntMatrix.put (random_cell probability) i j m



let populate probability m  = 
 let m' = Array.copy m 
 in
  for i = 0 to (IntMatrix.rows - 1) do 
    for j = 0 to (IntMatrix.columns - 1) do 
      randomCellAt probability m' i j
    done
  done


let nextCell t data density' m i j = 
  let r = Random.float 1.0  in
  if t < data.early_epoch &&  Float.O.(<) r  data.probability_of_birth &&  Float.O.(<) density' data.population_density_low then 1
  else if t < data.early_epoch &&  Float.O.(<) r (data.probability_of_birth +. data.probability_of_death ) &&  Float.O.(<) density' data.population_density_high then 0
  else 
    let e = env m i j 
    in
    match e with 
        | 0 | 1  -> 0
        | 2      -> IntMatrix.get m i j
        | 3      -> 1
        | _      -> 0
  
let init data = 
   let 
     m = Array.make_matrix ~dimx:IntMatrix.rows ~dimy:IntMatrix.columns 0;
     
   in 
   begin  
     populate data.probability_of_birth m;
     m
   end


let update t data m = 
 let m' = Array.copy m in
 let density' = IntMatrix.density m
 in
  for i = 0 to (IntMatrix.rows - 1) do 
    for j = 0 to (IntMatrix.columns - 1) do 
      IntMatrix.put (nextCell t data density' m' i j) i j m'
    done
  done
 
 let displayCellBlue row column dx dy cell = 
  let x = column*dx in
  let y = row*dy in
  if cell = 1 then 
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
         IntMatrix.display world displayCellBlue 800 800;
         Graphics.set_color Graphics.white;
         Graphics.moveto 10 10;
         Graphics.draw_string (Int.to_string i);
         Graphics.moveto 60 10;
         Graphics.draw_string  (Float.to_string (IntMatrix.density world |> round_to 3));
         update i data world; 
        (* Unix.sleep 1 *)
    done