open Matrix

type initialData = { probability_of_birth :   float; 
                     probability_of_death:    float;
                     population_density_low:  float;
                     population_density_high: float  }

(* a rows x columns matrix of a single cell value *)
val init : initialData -> matrix

val update : initialData -> matrix -> unit

val run : initialData -> int -> unit