open Graphics

let white = rgb 255 255 255
let bgColor  = rgb 0 0 0
let blue = rgb 0 0 255
let red = rgb 255 0 0

(* no function for converting color back to rgb in Graphics *)
let color_to_rgb color =
    let r = (color land 0xFF0000) asr 0x10
    and g = (color land 0x00FF00) asr 0x8
    and b = (color land 0x0000FF)
    in r, g, b

let open_window = 
    open_graph " 640x480";
    set_window_title "GraphicsExample"

(* no way of setting background color; resizing shows white *)
let clear_window color = 
    let fg = foreground 
    in
        set_color color;
        fill_rect 0 0 (size_x ()) (size_y ());
        set_color fg

(* create a gradient of colors from black at 0,0 to white at w-1,h-1 *)
let gradient arr w h = 
    for y = 0 to h-1 do 
        for x = 0 to w-1 do 
            let s = 255 * (x+y) / (w+h-2) 
            in arr.(y).(x) <- rgb s s s 
        done 
    done

let draw_gradient x y w h = 
    (* w and h are flipped from perspective of the matrix *)
    let arr = Array.make_matrix h w white
    in 
        gradient arr w h;
        draw_image (make_image arr) 0 0

(* NEW *)



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


let render_circle point = 
   let 
    () = set_color red
   in fill_circle point.x point.y 2 ;;

(* END: New *)


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
                set_color blue;
                fill_circle 320 240 6;
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
