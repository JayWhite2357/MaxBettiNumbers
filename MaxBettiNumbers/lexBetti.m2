--Computes the betti numbers of the lex ideal with the given hilbert function.
lexBettiNumbers (ZZ, List) := {
  AsTally => true
} >> o -> (n, h) -> (
  b := for i to n list for q to n list binomial(i, q);
  z := for i to n list 0;
  idxs := {0};
  result := for i to #h - 1 list (
    v := drop(idxs, h_i) / (j -> b_j);
    if #v == 0 then z else sum v
  ) do if i < #h - 1 then (
    idxs = flatten (take(idxs, h_i) / (i -> toList reverse(i..n)))
  );
  if o.AsTally === true then (
    new BettiTally from flatten append(for row in pairs(result) list (
      d := row_0 - 1;
      for col in pairs(row_1) list (
        if col_1 === 0 then continue;
        i := col_0 + 1;
        (i, {d + i}, d + i) => col_1
      )
    ), (0,{0},0) => 1)
  ) else result
)
