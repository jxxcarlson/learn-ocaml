
(** The type of a cell *)
type cell = Alive | Dead

(** The type of a  grid of cells *)
type grid

val rows : int

val columns : int

(* a rows x columns grid of a single cell value *)
val init : cell -> grid

val getCell : int -> int -> grid -> cell option

val getCell' :int -> int ->  grid -> cell

val putCell : int -> int -> cell -> grid -> grid

val displayCell : (int * int) -> int -> int -> cell -> unit

val display: grid -> int -> int -> unit

(* val updateAt : int -> int -> grid -> grid *)

(* val update : grid -> grid *)
