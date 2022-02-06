open Matrix

type data = { probability_of_birth :   float; 
              probability_of_death:    float;
              population_density_low:  float;
              population_density_high: float;
              steps : int;
              title: string  
              }

(* a rows x columns matrix of a single cell value *)
val init : data -> matrix

val update : data -> matrix -> unit

val run : data -> unit