open Graphics
open Grid

(* COLORS *)
let white = rgb 255 255 255
let bgColor  = rgb 0 0 200
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW DIMENSIONS *)
let ww = 800
let wh = 800

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


(* RENDERING  *)

let foo = Grid.init Dead 
       |> putCell 15 15 Alive 
       |> putCell 10 10 Alive 
       |> putCell 0 0 Alive;;

let render_circle x y radius r g b =  
    set_color (rgb r g b);
    fill_circle x y radius ;;
 
(* PROGRAM *)


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin     
                clear_window bgColor;
                set_color white; 
                render_circle (ww/2) (wh/2) 10 200 0 0;
                display foo 800 800;
            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
