(* 
   A point has an position in the xy plane, a radius, and a 
   color, given by RGB values r, g, and b. 
*)
type point = { x: int; y: int; radius: int; r: int; g: int; b: int}

(* Render a point using the Graphics library *)
val render: point -> unit

(* Render a list of points using the Graphics library *)
val render_list: point list -> unit


