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

type point = { x: int; y: int}

let rec brownian_path' (x:int) (y:int) (dx:int) (dy:int) (path_length:int) (list: point list): point list = 
  if path_length = 0 then 
    {x = x; y = y }::list
  else 
  let x' = x + (Random.int (2 * dx + 1)) - dx in
  let y' = y + (Random.int (2 * dy + 1)) - dy in
  brownian_path' x' y' dx dy (path_length - 1) ({x = x'; y = y'}::list)
  ;;

let brownian_path x y dx dy path_length = 
   Random.self_init ();
   brownian_path' x y dx dy path_length [];; 

let rec brownian_cloud' x y dx dy path_length number_of_points point_cloud = 
  if number_of_points = 0 then
     point_cloud
  else
     let end_point = List.hd (brownian_path x y dx dy path_length)
     in brownian_cloud' x y dx dy path_length (number_of_points - 1) (end_point :: point_cloud)

let brownian_cloud x y dx dy path_length number_of_points =
   brownian_cloud' x y dx dy path_length number_of_points [] 


(* TOOLS FOR RENDERING A BROWNIAN PATH *)

let render_circle point =  
    fill_circle point.x point.y 2 ;;
 
let render_points color (points: point list) = 
  set_color color;
  List.iter render_circle points;;

(* PROGRAM *)

(* Compute Brownian path *)
let random_points = brownian_path (ww/2) (wh/2) step_size step_size number_of_steps;;
let cloud = brownian_cloud (ww/2) (wh/2) step_size step_size number_of_steps_in_cloud points_in_cloud;;


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
                render_points blue cloud;
                render_points red random_points;
                set_color white; 
                fill_circle (ww/2) (wh/2) circle_radius;
            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
