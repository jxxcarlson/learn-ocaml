open Matrix

type data = { k : float;
              g : float;
              radius : float;
              steps : int;
              title: string  
              }

(* a rows x columns matrix of a single cell value *)
val init : data -> matrix

val update : data -> matrix -> unit

val run : data -> unit

val data : data