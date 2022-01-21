(*
    https://ocaml.org/learn/tutorials/command-line_arguments.html
    $ ocaml args.ml a b c
    [0] args.ml
    [1] a
    [2] b
    [3] c
*)
(* val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a *)

(* Sum of a list of floats. *)
let rec sum (xs : float list): float = 
  match xs with
     [] -> 0.0
     | (x::rest) -> x +. sum rest
;;

let allocations (xs : float list) : float list = 
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




for i = 0 to Array.length Sys.argv - 1 do
  Printf.printf "[%i] %s\n" i Sys.argv.(i)
done
