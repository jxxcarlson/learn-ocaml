let bgColor  = Graphics.rgb 0 0 0

let openWindowString w h = 
 String.concat "" [ " "; string_of_int w;  "x";  string_of_int h ];;
 
let open_window w h = 
    Graphics.open_graph (openWindowString w h);
    Graphics.set_window_title "Brownian Motion"  

(* no way of setting background color; resizing shows white *)
let clear_window color = 
    let fg = Graphics.foreground 
    in
       Graphics.set_color color;
       Graphics.fill_rect 0 0 (Graphics.size_x ()) (Graphics.size_y ());
       Graphics.set_color fg


let rec event_loop wx wy points = 
    (* there's no resize event so polling in required *)
    let _ = Graphics.wait_next_event [Poll]
    and wx' = Graphics.size_x () and wy' = Graphics.size_y ()
    in 
        if wx' <> wx || wy' <> wy then 
            begin 
                clear_window bgColor;
                Point.render_list points
            end;
        Unix.sleep 1;
        event_loop wx' wy' points

let run points w h =
        open_window w h; 
        try event_loop 0 0 points;
        with Graphics.Graphic_failure _ -> print_endline "Exiting..."

