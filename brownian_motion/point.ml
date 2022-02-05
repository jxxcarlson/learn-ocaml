(* This module defined the type 'point.'  A point has
x and y coordinates, a radius, an rgb color values.


*)

type point = { x: int; y: int; radius: int; r: int; g: int; b: int}

(* TOOLS FOR RENDERING A BROWNIAN PATH *)

let render point =  
    Graphics.set_color (Graphics.rgb point.r point.g point.b);
    Graphics.fill_circle point.x point.y point.radius ;;
 
let render_list (points: point list) = 
  List.iter render points;;