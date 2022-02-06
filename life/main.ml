open Graphics
open Base
open Life

(* COLORS *)
let white = rgb 255 255 255
let bgColor  = rgb 0 0 80
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW DIMENSIONS *)
let ww = 800
let wh = 800

let openWindowString w h = 
 String.concat ~sep:"" [ " "; Int.to_string w;  "x";  Int.to_string h ];;
 
let open_window = 
    open_graph (openWindowString ww wh);
    set_window_title "Game of Life"  

(* no way of setting background color; resizing shows white *)
let clear_window color = 
    let fg = foreground 
    in
        set_color color;
        fill_rect 0 0 (size_x ()) (size_y ());
        set_color fg;;


(* PROGRAM *)

let initialData = { probability_of_birth = 0.02;
                    probability_of_death = 0.00;
                    population_density_low = 0.2;
                    population_density_high = 0.3;
                  }


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = 1 (* wait_next_event [Poll] *)
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then run initialData 100000;
        Unix.sleep 1;
        event_loop wx' wy'


let () =
        open_window; 
        try event_loop 400 400 ;
        with Graphic_failure _ -> Stdio.print_endline "Exiting..." 
