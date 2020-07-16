lexBetti = method( Options => {
  AsTally => true
} );
-- Computes the betti numbers of the lex ideal with the given hilbert function.
lexBetti (ZZ, List) := o -> (numberOfVariables, h) -> (
  n := numberOfVariables - 1;
  result := lexBettiNum(h, n);
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
);

almostLexBetti = method( Options => {
  AsTally => true
} );
almostLexBetti (ZZ, List) := o -> (numberOfVariables, h) ->
  lexBetti(numberOfVariables - 1, h - prepend(0,drop(h,-1)), o);


lexBettiNum = (h, n) -> (
  b := for i to n list for q to n list binomial(i, q);
  z := for i to n list 0;
  if not h#?0 then return {z} else if h#0 === 0 then return {b#0};
  if h#0 > 1 or min(h)<0 then error("Not a valid Hilbert function.");
  rep := {n + 1};
  nonzeroidx := 0;
  maxni := n + 1;
  for d to #h-1 list if d === 0 then z else (
    fd := sum for i to #rep-1 list binomial(rep#i+i,i+1);
    if h#d > fd then error("Not a valid Hilbert function.");
    s := z;
    for l from h#d to fd - 1 do (
      s = s + b#(n+1-maxni);
      rep = join(toList((nonzeroidx + 1):(maxni - 1)), drop(rep, nonzeroidx + 1));
      if maxni === 1 then (
        nonzeroidx = nonzeroidx + 1;
        if rep#?nonzeroidx then maxni = rep#nonzeroidx;
      ) else (
        nonzeroidx = 0;
        maxni = maxni - 1;
      );
    );
    s
  ) do (
    if d =!= 0 then (
      rep = prepend(0, rep);
      nonzeroidx = nonzeroidx + 1
    )
  )
);


-- Note: n is one less than the number of variables.
lexsegmentIdealHelper = (S, h, n) -> (
  if not h#?0 then return ideal 0_S else if h#0 === 0 then return ideal 1_S;
  if h#0 > 1 or min(h)<0 then error("Not a valid Hilbert function.");
  rep := {n + 1};
  nonzeroidx := 0;
  maxni := n + 1;
  gs := flatten for d to #h-1 list if d === 0 then {} else (
    fd := sum for i to #rep-1 list binomial( rep#i + i, i + 1 );
    if h#d > fd then error("Not a valid Hilbert function.");
    for l from h#d to fd - 1 list (
      product for i to d-1 list S_(
        n + 1 - (
          if rep#i === 0 then maxni
          else if i === 0 or rep#(i-1) === 0 then rep#i
          else rep#i + 1
        )
      )
    ) do (
      rep = join(toList((nonzeroidx + 1):(maxni - 1)), drop(rep, nonzeroidx + 1));
      if maxni === 1 then (
        nonzeroidx = nonzeroidx + 1;
        if rep#?nonzeroidx then maxni = rep#nonzeroidx;
      ) else (
        nonzeroidx = 0;
        maxni = maxni - 1;
      );
    )
  ) do (
    if d =!= 0 then (
      rep = prepend(0, rep);
      nonzeroidx = nonzeroidx + 1
    )
  );
  if #gs === 0 then ideal(0_S) else ideal gs
);


lexsegmentIdeal = method( TypicalValue => Ideal );
lexsegmentIdeal (PolynomialRing, List) := (S, h) -> 
  lexsegmentIdealHelper(S, h, dim S - 1);

almostLexIdeal = method( TypicalValue => Ideal );
almostLexIdeal (PolynomialRing, List) := (S, h) -> 
  lexsegmentIdealHelper(S, h - prepend(0,drop(h,-1)), dim S - 2);
