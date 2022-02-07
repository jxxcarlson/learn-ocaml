
open Base
open Life


(* WINDOW DIMENSIONS *)
let ww = 800
let wh = 800

let openWindowString w h = 
 String.concat ~sep:"" [ " "; Int.to_string w;  "x";  Int.to_string h ];;
 
let open_window data = 
    Graphics.open_graph (openWindowString ww wh);
    Graphics.set_window_title data.title 

(* no way of setting background color; resizing shows white *)
let clear_window color = 
    let fg = Graphics.foreground 
    in
        Graphics.set_color color;
        Graphics.fill_rect 0 0 (Graphics.size_x ()) (Graphics.size_y ());
        Graphics.set_color fg;;


(* PROGRAM *)


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = 1 (* wait_next_event [Poll] *)
    and wx' = Graphics.size_x () and wy' = Graphics.size_y ()
    in 
        if wx' <> wx || wy' <> wy then Life.run Life.data;
        Unix.sleep 1;
        event_loop wx' wy'


let () =
        open_window data; 
        try event_loop 400 400 ;
        with Graphics.Graphic_failure _ -> Stdio.print_endline "Exiting..." 
