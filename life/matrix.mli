
(** The type of a cell *)
type cell = float

(** The type of a  matrix of cells *)
type matrix = cell array array

val rows : int

val columns : int

val get : matrix -> int -> int ->  cell

val put : cell  -> int -> int ->  matrix -> unit

val displayCell : int -> int -> int -> int -> cell -> unit

val display: matrix -> int -> int -> unit

val density : matrix -> float

val round_to : int -> float -> float


