
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


(* PROGRAM *)

let window_width = 800;;
let window_height = 800;;

(* Compute Brownian path *)
let origin = {x = window_width/2; y = window_height/2; radius = 2; r = 125; g = 0; b = 125};;
let center = {x = window_width/2; y = window_height/2; radius = 10; r = 160; g = 160; b = 210};;
let path = Brownian.path origin step_size color_step_size number_of_steps;;
let cloud = Brownian.cloud origin step_size color_step_size number_of_steps_in_cloud points_in_cloud;;

Canvas.run (origin :: (List.append cloud path)) window_width window_height