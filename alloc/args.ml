(*
    https://ocaml.org/learn/tutorials/command-line_arguments.html
    $ ocaml args.ml a b c
    [0] args.ml
    [1] a
    [2] b
    [3] c
*)
for i = 0 to Array.length Sys.argv - 1 do
  Printf.printf "[%i] %s\n" i Sys.argv.(i)
done
