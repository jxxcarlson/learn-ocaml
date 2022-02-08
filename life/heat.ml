
open Matrix
open Base

type data = { k : float;
              g : float;
              radius : float;
              steps : int;
              title: string  
              }


let data = {   k = 0.5;
               g = 0.0;
               radius = 50.0;
               steps = 100_000;
               title = "Heat Equation"
            }


let rec power x n = 
  if n = 0 then 1.0
    else x *. (power x (n - 1))

let round_to n x = 
  let factor = power 10.0 n in
  let x = Float.round (factor *. x)
  in x/.factor


let env m i j = 
  (get m (i-1) j +. get m (i + 1) j +. get m i (j - 1) +. get m i (j + 1))/. 4.0

let gradSquared m i j = 
  let dx = (get m (i + 1) j) -. (get m (i - 1) j) in
  let dy = (get m i (j + 1)) -. (get m i (j - 1)) in
  dx*.dx +. dy*.dy

 let random_cell = 
   (Random.float 1.0) /. 10.0


let randomCellAt m i j = 
  put random_cell i j m

let populate data m  = 
 let m' = Array.copy m 
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      let d2 = 2*(i-100)*(i-100) + (j-100)*(j-100) in
      let r2 = Int.of_float (data.radius*.data.radius)
      in 
      if d2 < r2  && d2 > 3*r2/4 then  put 1.0 i j m'
      else 
        randomCellAt m' i j
    done

  done


let nextCell data m i j = 
   let
    open Float.O  
   in
     data.k * (get m i j) + (1.0 - data.k)*(env m i j) + data.g*(gradSquared m  i j)
  

let init data = 
   let 
     m = Array.make_matrix ~dimx:rows ~dimy:columns 0.0;
   in 
   begin  
     populate data m;
     m
   end


let update data m = 
 let m' = Array.copy m
 in
  for i = 0 to (rows - 1) do 
    for j = 0 to (columns - 1) do 
      put (nextCell data m' i j) i j m'
    done
  done
 
 let displayCell row column dx dy cell = 
  let x = column*dx in
  let y = row*dy in
  let t = Int.of_float (cell *. 255.0)
  in  
    if t <= 255 then 
        begin
        Graphics.set_color (Graphics.rgb t 0 0);
        Graphics.fill_rect x y dx dy
        end
    else
       begin
        Graphics.set_color (Graphics.rgb 0 0 255);
        Graphics.fill_rect x y dx dy
    end


 let run data =  
    let 
      world = init data
    in   
    for i = 0 to data.steps do 
         Matrix.display world displayCell 800 800;
         update data world; 
         if i % 1000 = 0 then
           begin
                (* Graphics.auto_synchronize false;  *)
                Graphics.set_color Graphics.white;
                Graphics.moveto 10 20;
                Graphics.draw_string (Int.to_string i);
                Graphics.moveto 60 20;
                Graphics.draw_string  (Float.to_string (density world |> round_to 4));
                (* Graphics.synchronize(); 
                Unix.sleep 1 *)
           end
           
        
    done