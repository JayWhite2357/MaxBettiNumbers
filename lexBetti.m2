--Computes the betti numbers of the lex ideal with the given hilbert function.
lexBetti = (h, n) -> (
  b := for i to n list for q to n list binomial(i, q);
  z := for i to n list 0;
  idxs := {0};
  for i to #h - 1 list (
    v := drop(idxs, h_i) / (j -> b_j);
    if #v == 0 then z else sum v
  ) do if i < #h - 1 then (
    idxs = flatten (take(idxs, h_i) / (i -> toList reverse(i..n)))
  )
)
