let rec fact (n: int) : int = 
  match n with 
    0 -> 1
    n -> n * fact (n - 1)