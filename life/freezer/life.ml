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
let bgColor  = rgb 0 0 200
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* WINDOW DIMENSIONS *)
let ww = 800
let wh = 800


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

(* LIFE *)

type cell = Dead | Alive
type grid = cell list list


(* PROGRAM *)


let rec event_loop wx wy = 
    (* there's no resize event so polling in required *)
    let _ = wait_next_event [Poll]
    and wx' = size_x () and wy' = size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
            end;
        Unix.sleep 1;
        event_loop wx' wy'

let () =
        open_window; 
        try event_loop 0 0 ;
        with Graphic_failure _ -> print_endline "Exiting..."
