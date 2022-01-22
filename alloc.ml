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

type data_record = { item: string; value: float; allocation: float} ;;
type extended_data_record = { item: string; value: float; allocation: float; actual_allocation: float; trade: float; } ;;

let print_record (d :  data_record) : unit  =
    (* Printf.printf "%10s       %10.0f %6.2f\n" d.item d.value d.allocation ;; *)
        Printf.printf "%*s %6.0f %6.2f\n" (-16) d.item  d.value d.allocation ;;


let print_extended_record (d :  extended_data_record) : unit  =
        Printf.printf "%*s %6.0f %6.2f %6.2f %8.2f\n" (-16) d.item  d.value d.allocation d.actual_allocation d.trade;;


let readlines file = let ic = open_in file in 
let rec aux() = 
  try let s = input_line ic in s :: aux() with  
  End_of_file -> []
in aux()


let splitter s = s 
   |> String.split_on_char ',' 
   |> List.filter (fun s -> s <> "") 




let assemble (str: string) : data_record
  = match splitter str with 
      (first :: second :: third :: []) -> { item = first; value = Float.of_string second; allocation = Float.of_string third; }
       (* default -> { item = "Bad data"; value = 0.0; allocation = 0.0; } *)
    ;;

let data = readlines "assets.txt" |> List.map assemble



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

- : float list = [-20.; 20.]


*)
let trade_for_allocation (assets: float list) (target_allocation: float list) = 
  let 
    total = sum assets
  in let 
    delta total amount proportion = amount -. total *. proportion
  in
  map2 (delta total) assets target_allocation;;


let assets = List.map (fun (r: data_record) -> r.value) data;;
let allocations = allocation assets;;

let target_allocations = List.map (fun (d: data_record)-> d.allocation ) data;;
let trades = trade_for_allocation assets target_allocations;;

let pair a b = (a, b);;

let newData = List.map2 pair allocations trades;;

(* let extendDatum (data: data_record) (newData : (float, float) ) : extended_data_record = *)
let extendDatum (datum: data_record) (newDatum: (float * float)) : extended_data_record =
  let 
    (a, b) = newDatum
  in
  { item = datum.item; value = datum.value; allocation = datum.allocation; actual_allocation = a; trade = b; }  ;;



let extendData (data: data_record list) (newData: (float * float) list): extended_data_record list =
   List.map2 extendDatum data newData;;


List.iter print_extended_record (extendData data newData);; 

(* List.iter print_record data;; *)