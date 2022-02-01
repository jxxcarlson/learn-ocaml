
open Core

type cell =     Alive | Dead

type grid = cell list

let rows = 16

let columns = 16

let init cell = List.init (rows*columns) ~f:(fun _ -> cell)

let index row column = columns*row + column

let getCell (i:int) (j:int) (grid:grid) : cell option = List.nth grid (index i j) 

let getCell' i j grid =  (getCell i j grid) |> (fun x -> Option.value x ~default:Dead);;

let putCell i j replacement_cell grid = 
  List.mapi grid ~f:(fun k cell -> if k = (index i j) then replacement_cell else cell);;

