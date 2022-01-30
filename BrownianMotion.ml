open Graphics

let white = rgb 255 255 255
let bgColor  = rgb 0 0 0
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW TOOLS *)

(* no function for converting color back to rgb in Graphics *)
let color_to_rgb color =
    let r = (color land 0xFF0000) asr 0x10
    and g = (color land 0x00FF00) asr 0x8
    and b = (color land 0x0000FF)
    in r, g, b

let open_window = 
    open_graph " 640x480";
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
  let 
   foo = Random.init seed
  in
  make_random_points' x y dx dy n [];; 


(* TOOLS FOR RENDERING A BROWNIAN PATH *)
let render_circle point = 
   let 
    () = set_color red
   in fill_circle point.x point.y 2 ;;
 


(* PROGRAM *)


let seed' = int_of_string Sys.argv.(1);;
let random_points = make_random_points 320 240 10 10 500 seed';; 

let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
                List.iter render_circle random_points;
                set_color blue;
                fill_circle 320 240 4;
            end;
        Unix.sleep 1;
        event_loop wx' wy'



let seed = Random.init seed';;
let () = Printf.printf "seed = %d\n" seed' ;;

(* let seed' = Float.of_string Sys.argv.(1);; *)

let () =
       open_window;
    let r,g,b = color_to_rgb background
    in  
        Printf.printf "Background color: %d %d %d\n" r g b;
        try event_loop 0 0 
        with Graphic_failure _ -> print_endline "Exiting..."
