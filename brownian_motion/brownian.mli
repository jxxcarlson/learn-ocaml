

open Point

(* compute Brownian path:

   path origin step_size color_step_size number_of_steps

*)
val path:  point -> int -> int -> int -> point list



(* compute Brownian cloud:

   path origin step_size color_step_size number_of_steps points_in_cloud
   
*)
val cloud:  point -> int -> int -> int -> int -> point list
