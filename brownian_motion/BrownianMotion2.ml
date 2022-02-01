open Graphics

(*  

  Given a seed for the random number generator, this program
  computes, then displyas, a Brownian path.

  USAGE EXAMPLE:

  $ ./BrownianMotion.native 194716 

  where 194716 seeds the random number generator.

*)

(* COLORS *)
let white = rgb 255 255 255
let bgColor  = rgb 0 0 0
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW DIMENSIONS *)
let ww = 800
let wh = 800

(* Parameters for Brownian motion *)

let step_size = 10;;
let color_step_size = 6;;
let number_of_steps = 4000;;
let number_of_steps_in_cloud = 200;;
let points_in_cloud = 3000;;
let circle_radius = 2;;


(* WINDOW TOOLS *)


let openWindowString w h = 
 String.concat "" [ " "; string_of_int w;  "x";  string_of_int h ];;
 
let open_window = 
    open_graph (openWindowString ww wh);
    set_window_title "Brownian Motion"  

(* no way of setting background color; resizing shows white *)
let clear_window color = 
    let fg = foreground 
    in
        set_color color;
        fill_rect 0 0 (size_x ()) (size_y ());
        set_color fg


(* COMPUTING A BROWNIAN PATH *)

type point = { x: int; y: int; r: int; g: int; b: int}

let roll k = if k > 255 then 0 else if k < 0 then 255 else k

let reflect k = if k > 255 then 250 else if k < 0 then 5 else k

let rec brownian_path' (point: point) (path_length: int) (list: point list) : point list = 
  if path_length = 0 then 
    list
  else 
  let x' = point.x + (Random.int (2 * step_size + 1)) - step_size in
  let y' = point.y + (Random.int (2 * step_size + 1)) - step_size in
  let r' = point.r + (Random.int (2 * color_step_size + 1)) - color_step_size |> reflect in
  (* let g' = point.g + (Random.int (2 * color_step_size + 1)) - color_step_size |> roll in *)
  let b' = point.b + (Random.int (2 * color_step_size + 1)) - color_step_size|> reflect in
  let point' = {x = x'; y = y'; r = r'; g = point.g; b = b'} in
  brownian_path' point'(path_length - 1) (point'::list)
  ;;

let brownian_path point path_length = 
   Random.self_init ();
   brownian_path' point path_length [];; 

let rec brownian_cloud' point path_length number_of_points point_cloud = 
  if number_of_points = 0 then
     point_cloud
  else
     let end_point' = List.hd (brownian_path point path_length) in
     let end_point = {x = end_point'.x; y = end_point'.y; r = 80; g = 80; b = 140} in
     brownian_cloud' point path_length (number_of_points - 1) (end_point :: point_cloud)

let brownian_cloud point path_length number_of_points =
   brownian_cloud' point path_length number_of_points [] 


(* TOOLS FOR RENDERING A BROWNIAN PATH *)

let render_circle point =  
    set_color (rgb point.r point.g point.b);
    fill_circle point.x point.y 2 ;;
 
let render_points (points: point list) = 
  List.iter render_circle points;;

(* PROGRAM *)

(* Compute Brownian path *)
let origin = {x = ww/2; y = wh/2; r = 125; g = 0; b = 125};;
let path = brownian_path origin number_of_steps;;
let cloud = brownian_cloud origin number_of_steps_in_cloud points_in_cloud;;


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
                render_points cloud;
                render_points path;
                set_color white; 
                fill_circle (ww/2) (wh/2) circle_radius;
            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
