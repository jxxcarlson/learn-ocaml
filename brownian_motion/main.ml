
open Point

(*  

  This program computes, then displyas, both a Brownian cloud and path.

  USAGE EXAMPLE:

  $ dune exec ./brownian_motion.exe

*)

(* Parameters for Brownian motion *)

let step_size = 10;;
let color_step_size = 6;;

let number_of_steps = 4000;;
let number_of_steps_in_cloud = 200;;
let points_in_cloud = 3000;;
let window_width = 800;;
let window_height = 800;;

(* PROGRAM *)

(* Compute Brownian path *)
let origin = {x = window_width/2; y = window_height/2; radius = 2; r = 125; g = 0; b = 125};;
let path = Brownian.path origin step_size color_step_size number_of_steps;;
let cloud = Brownian.cloud origin step_size color_step_size number_of_steps_in_cloud points_in_cloud;;
let data = List.append cloud path;;

Canvas.run (origin :: data) window_width window_height