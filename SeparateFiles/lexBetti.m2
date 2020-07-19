--- This is an efficient way of computing the betti numbers of a lexsegment
---   Instead of computing the actual ideal, we loop through each degree and
---   use the max index of the monomial
---   once we have enough monomials in that degree, we move up to the next
---   degree
--- The returned values are the sums of the binomial coefficients of the
---   generators in each degree. They are exactly the values in the
---   Eliahou-Kervaire resolution.
lexBettiArray = ( h, n ) -> (
  b := for i to n list for q to n list binomial( i, q );
  zeroList := for i to n list 0;
  if not h#?0 then return { zeroList } else if h#0 === 0 then return { b#0 };
  if h#0 > 1 or min h < 0 then error( "Not a valid Hilbert function." );
  ( rep, firstNonzeroIndex, firstNonzeroValue ) :=
    ( { n + 1 }, 0, n + 1 );
  for d to #h - 1 list if d === 0 then zeroList else (
    upperBound := sum for i to #rep - 1 list binomial( rep#i + i, i + 1 );
    if h#d > upperBound then error( "Not a valid Hilbert function." );
    s := zeroList;
    for l from h#d to upperBound - 1 do (
      s = s + b#( n + 1 - firstNonzeroValue );
      ( rep, firstNonzeroIndex, firstNonzeroValue ) = 
        decrementRep( rep, firstNonzeroIndex, firstNonzeroValue );
    );
    s
  ) do if d =!= 0 then (
    --- move rep up one degree
    rep = prepend( 0, rep );
    firstNonzeroIndex = firstNonzeroIndex + 1
    --- end move rep degree
  )
);


--- Note: n is one less than the number of variables.
--- Additionally, S can have many more variables than we need. We only use the
---   first n+1 variables.
--- This is exactly the same algorithm as lexBettiArray, however, we generate
---   the monomials themselves instead of just the binomial coefficients of the
---   max index.
createLexIdeal = ( S, h, n ) -> (
  if not h#?0 then return ideal 0_S else if h#0 === 0 then return ideal 1_S;
  if h#0 > 1 or min h < 0 then error( "Not a valid Hilbert function." );
  ( rep, firstNonzeroIndex, firstNonzeroValue ) :=
    ( { n + 1 }, 0, n + 1 );
  gs := flatten for d to #h - 1 list if d === 0 then { } else (
    upperBound := sum for i to #rep - 1 list binomial( rep#i + i, i + 1 );
    if h#d > upperBound then error( "Not a valid Hilbert function." );
    for l from h#d to upperBound - 1 list (
      product for i to d - 1 list S_(
        n + 1 - (
          if rep#i === 0 then firstNonzeroValue
          else if i === 0 or rep#( i - 1 ) === 0 then rep#i
          else rep#i + 1
        )
      )
    ) do (
      ( rep, firstNonzeroIndex, firstNonzeroValue ) = 
        decrementRep( rep, firstNonzeroIndex, firstNonzeroValue )
    )
  ) do if d =!= 0 then (
    --- move rep up one degree
    rep = prepend( 0, rep );
    firstNonzeroIndex = firstNonzeroIndex + 1
    --- end move rep degree
  );
  ideal if #gs === 0 then 0_S else gs
);


convertBettiArrayToBettiTally = array -> (
  new BettiTally from flatten append (
    for row in pairs array list (
      d := row#0 - 1;
      for col in pairs row#1 list (
        if col#1 === 0 then continue;
        i := col#0 + 1;
        ( i, { d + i }, d + i ) => col#1
      )
    ),
    ( 0, { 0 }, 0 ) => 1
  )
);


lexBetti = method( Options => { AsTally => true } );
lexBetti ( ZZ, List ) := o -> ( numberOfVariables, h ) -> (
  result := lexBettiArray( h, numberOfVariables - 1 );
  if o.AsTally === true then (
    convertBettiArrayToBettiTally result
  ) else (
    result
  )
);

almostLexBetti = method( Options => { AsTally => true } );
almostLexBetti ( ZZ, List ) := o -> ( numberOfVariables, h ) ->
  lexBetti( numberOfVariables - 1, h - prepend( 0, drop( h, -1 ) ), o );

lexsegmentIdeal = method( TypicalValue => Ideal );
lexsegmentIdeal ( PolynomialRing, List ) := ( S, h ) -> 
  createLexIdeal( S, h, dim S - 1 );

almostLexIdeal = method( TypicalValue => Ideal );
almostLexIdeal ( PolynomialRing, List ) := ( S, h ) -> 
  createLexIdeal( S, h - prepend( 0, drop( h, -1 ) ), dim S - 2 );
