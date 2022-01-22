(*
    https://ocaml.org/learn/tutorials/command-line_arguments.html
    $ ocaml args.ml a b c
    [0] args.ml
    [1] a
    [2] b
    [3] c
*)
(* val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a *)

open List;;

(* let read_file_to_strings "assets.txt" =
  let file = In_channel.create filename in
  let strings = In_channel.input_lines file in
  In_channel.close file;
  strings *)

(* Sum of a list of floats. *)
let rec sum (xs : float list): float = 
  match xs with
     [] -> 0.0
     | (x::rest) -> x +. sum rest
;;

let allocation (xs : float list) : float list = 
  let 
    total = sum xs
  in 
  map (fun (x: float) -> x /. total) xs;;



(*
# trade_for_allocation [100.0; 100.0] [0.5; 0.5];;
- : float list = [0.; 0.]

# trade_for_allocation [100.0; 100.0] [0.6; 0.4];;
- : float list = [-20.; 20.]


*)
let trade_for_allocation (assets: float list) (target_allocation: float list) = 
  let 
    total = sum assets
  in let 
    delta total amount proportion = amount -. total *. proportion
  in
  map2 (delta total) assets target_allocation;;


(* let r file = In_channel.read_lines file *)

let data = Array.length Sys.argv ;;
let n_args = Array.length Sys.argv ;;

let raw_assets = Array.sub Sys.argv 1 (n_args / 2);;
let allocations = allocation (map Float.of_string (Array.to_list raw_assets));;

let raw_target_allocations = Array.sub Sys.argv (1 + (n_args/2)) (n_args / 2);;
let assets = map Float.of_string (Array.to_list raw_assets) ;;
let target_allocations = map Float.of_string (Array.to_list raw_target_allocations) ;;

let trades = map Float.to_int (trade_for_allocation assets target_allocations);;

let readlines file = let ic = open_in file in 
let rec aux() = 
  try let s = input_line ic in s :: aux() with  
  End_of_file -> []
in aux()

let n = List.length (readlines "assets.txt");;

Printf.printf  "Read %1d lines\n" n;;



Printf.printf "\n\nCurrent allocation\n------------------\n";;
List.iter (Printf.printf  "%10.3f\n") allocations;;
Printf.printf "\n";;

Printf.printf "Trades\n------------------\n";;
List.iter (Printf.printf  "%10d\n") trades;;
Printf.printf "\n";;

(* for i = 0 to length assets - 1 do
  Printf.printf "[%i] %s\n" i Sys.argv.(i)
done *)
