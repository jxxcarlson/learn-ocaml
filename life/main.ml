open Graphics
open Grid

(* COLORS *)
let white = rgb 255 255 255
let bgColor  = rgb 0 0 80
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW DIMENSIONS *)
let ww = 760
let wh = 770

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


(* LIFE  *)

let grid = Grid.init Dead 
       |> putCell 15 15 Alive 
       |> putCell 10 10 Alive 
       |> putCell 0 0 Alive;;

 
(* PROGRAM *)

let world = populate_grid 0.5 grid

let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin     
                clear_window bgColor;
                display (populate_grid 0.5 grid |> update |> update) 800 800;

            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
