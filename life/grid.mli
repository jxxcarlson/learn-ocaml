
(** The type of a cell *)
type cell = Alive | Dead

(** The type of a  grid of cells *)
type grid = cell list

val rows : int

val columns : int

(* a rows x columns grid of a single cell value *)
val init : cell -> grid

val getCell : int -> int -> grid -> cell option

val getCell' :int -> int ->  grid -> cell

val putCell : int -> int -> cell -> grid -> grid

val putCell' : cell -> grid -> int -> grid

val displayCell : (int * int) -> int -> int -> cell -> unit

val display: grid -> int -> int -> unit

val neighbors : int -> int -> grid -> grid

val updateAt : float -> int -> int -> grid -> grid

val updateAt' : float -> grid -> int -> grid

val update : grid -> grid

val populate_grid : float ->  grid -> grid

val centered_around: int -> int -> int -> grid -> grid

val density : grid -> float

val round_to : int -> float -> float

val run : grid -> int -> unit 
