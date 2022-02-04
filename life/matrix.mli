
(** The type of a cell *)
type cell = float

(** The type of a  matrix of cells *)
type matrix = cell array array

val rows : int

val columns : int

(* a rows x columns matrix of a single cell value *)
val init : cell -> matrix

val get : matrix -> int -> int ->  cell

val put : cell  -> int -> int ->  matrix -> unit

val displayCell : int -> int -> int -> int -> cell -> unit

val display: matrix -> int -> int -> unit

val env: matrix -> int -> int -> float

val updateAt : float -> matrix -> int -> int -> matrix -> unit

val update : matrix -> unit

val populate : float ->  matrix -> unit

val centered_around: int -> int -> int -> matrix -> unit

val density : matrix -> float

val round_to : int -> float -> float

val run : matrix -> int -> unit 
