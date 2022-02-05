open Point

(* COMPUTE BROWNIAN PATH AND CLOUD *)

(* let roll k = if k > 255 then 0 else if k < 0 then 255 else k *)

let reflect k = if k > 255 then 250 else if k < 0 then 5 else k

let rec brownian_path' (point: point) (step_size: int) (color_step_size: int) (path_length: int) (list: point list) : point list = 
  if path_length = 0 then 
    list
  else 
  let x' = point.x + (Random.int (2 * step_size + 1)) - step_size in
  let y' = point.y + (Random.int (2 * step_size + 1)) - step_size in
  let r' = point.r + (Random.int (2 * color_step_size + 1)) - color_step_size |> reflect in
  (* let g' = point.g + (Random.int (2 * color_step_size + 1)) - color_step_size |> roll in *)
  let b' = point.b + (Random.int (2 * color_step_size + 1)) - color_step_size|> reflect in
  let point' = {x = x'; y = y'; radius = point.radius; r = r'; g = point.g; b = b'} in
  brownian_path' point' step_size color_step_size (path_length - 1) (point'::list)
  ;;

let path point step_size color_step_size path_length = 
   Random.self_init ();
   brownian_path' point step_size color_step_size path_length [];; 

let rec cloud' point step_size color_step_size path_length number_of_points point_cloud = 
  if number_of_points = 0 then
     point_cloud
  else
     let end_point' = List.hd (path point step_size color_step_size path_length) in
     let end_point = {x = end_point'.x; y = end_point'.y; radius = end_point'.radius; r = 80; g = 80; b = 140} in
     cloud' point step_size color_step_size path_length (number_of_points - 1) (end_point :: point_cloud)

let cloud point step_size color_step_size path_length number_of_points =
   cloud' point step_size color_step_size path_length number_of_points [] 

