
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


let random_cell (probability:float) = 
   if Base.Float.O.(<) (Random.float 1.0)  probability then Alive else Dead


  
let west_neighbor i j grid cells: cell list = 
    match getCell (i - 1) j grid with 
       | Some cell -> cell::cells
       | None -> cells


let east_neighbor i j grid cells: cell list = 
    match getCell (i + 1) j grid with 
       | Some cell -> cell::cells
       | None -> cells


let north_neighbor i j grid cells: cell list = 
    match getCell i (j + 1) grid with 
       | Some cell -> cell::cells
       | None -> cells


let south_neighbor i j grid cells: cell list = 
    match getCell i (j - 1) grid with 
       | Some cell -> cell::cells
       | None -> cells

let neighbors i j grid =
   [ ] |> west_neighbor i j grid
       |> east_neighbor i j grid
       |> north_neighbor i j grid
       |> south_neighbor i j grid 
       ;; 

let isAlive cell = 
  match cell with 
    | Alive -> true
    | Dead -> false

let neighbor_status' cells =
  List.filter cells ~f:isAlive  |> List.length 

let neighbor_index i j grid = 
  neighbors i j grid |> neighbor_status'

let new_cell i j grid: cell = 
  match neighbor_index i j grid with 
        | 0 | 1 -> Dead             (* under-population *)
        | 2 -> getCell' i j grid    (* remains stable *)
        | 3 -> Alive                (* reproduction *)
        | _ -> Dead                 (* overcrowding *) 


let updateAt i j grid: grid = 
  putCell i j (new_cell i j grid) grid

let updateAt' (grid:grid) (k:int): grid =
 let (i, j) = address k in 
  updateAt i j grid

let indices grid: int list = List.init (List.length grid) ~f:(fun i -> i)

let update grid = 
  List.fold  (indices grid) ~init:grid ~f:updateAt'
  

let putCell' cell grid k = 
  let (i, j) = address k in
  putCell i j cell grid

let randomCellAt' probability grid k = 
  putCell' (random_cell probability) grid k 

let populate_grid probability grid  = 
  List.fold (indices grid) ~init:grid ~f:(fun grid k -> randomCellAt' probability grid k)