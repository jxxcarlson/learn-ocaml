open Matrix

type initialData = { probability_of_birth :   float; 
                     probability_of_death:    float;
                     population_density_low:  float;
                     population_density_high: float  }

(* a rows x columns matrix of a single cell value *)
val init : initialData -> matrix

val env: matrix -> int -> int -> float

val updateAt : float -> matrix -> int -> int -> matrix -> unit

val nextCell: initialData -> float ->  matrix -> int -> int -> cell

val update : matrix -> unit

val run : initialData -> int -> unit