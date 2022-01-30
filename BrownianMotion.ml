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

let step_size = 15;;
let number_of_steps = 1000;;
let circle_radius = 5;;


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

let rec make_random_points' (x:int) (y:int) (dx:int) (dy:int) (n:int) (list: point list): point list = 
  if n = 0 then 
    {x = x; y = y }::list
  else 
  let x' = x + (Random.int (2 * dx) ) - dx in
  let y' = y + (Random.int (2 * dy) ) - dy in
  make_random_points' x' y' dx dy (n - 1) ({x = x; y = y}::list)
  ;;

let make_random_points x y dx dy n seed = 
   Random.init seed;
   make_random_points' x y dx dy n [];; 


(* TOOLS FOR RENDERING A BROWNIAN PATH *)

let render_circle point =  
    fill_circle point.x point.y 2 ;;
 
let render_points (points: point list) = 
  set_color red;
  List.iter render_circle points;;

(* PROGRAM *)

(* Get random seed *)
let seed' = int_of_string Sys.argv.(1);; 

(* Compute Brownian path *)
let random_points = make_random_points (ww/2) (wh/2) step_size step_size number_of_steps seed';; 

let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
                render_points random_points;
                set_color blue; 
                fill_circle (ww/2) (wh/2) circle_radius;
            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
