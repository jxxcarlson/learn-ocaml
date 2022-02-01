
open Core
open Graphics

type cell = Alive | Dead

type grid = cell list

let rows = 64

let columns = 64

let init cell = List.init (rows*columns) ~f:(fun _ -> cell)

let index row column = columns*row + column

let getCell (i:int) (j:int) (grid:grid) : cell option = List.nth grid (index i j) 

let getCell' i j grid =  (getCell i j grid) |> (fun x -> Option.value x ~default:Dead);;

let putCell i j replacement_cell grid = 
  List.mapi grid ~f:(fun k cell -> if k = (index i j) then replacement_cell else cell);;


let red = rgb 0 0 255;;
let black = rgb 0 0 0;;


let displayCell (row, column) dx dy cell = 
  let x = column*dx in
  let y = row*dy in
  match cell with
  | Alive -> 
    begin
     set_color red;
     fill_rect x y dx dy
    end
  | Dead -> 
    begin
     set_color black;
     fill_rect x y dx dy
    end
     ;;

let address k = 
  let i = k/columns in
  let j = k - columns * i in
  (i, j);;

let display grid width height =
  let dx = width / columns in
  let dy = height / rows in
  List.iteri grid ~f:(fun i cell -> displayCell (address i) dx dy cell) 
