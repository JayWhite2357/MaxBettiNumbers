--- We precompute the V_q values as well as the Macaulay lower bound.
---   Doing this ahead of time saves a ton of repitition.
--- We are setting V#d#(j - g#d) = V_q[d, j]
--- We are setting lowerBound#d#(j - g#d) = [j]_<d>
--- Although we could compute these directly, the following is a more efficient
---   way of computing them iteratively.
BuildVLowerBound = ( g, f, n ) -> (
  --- Make a list of all possible vectors. This way we don't have to compute
  ---   binomials repeatedly
  Vi := for i to n list (
    --- The next line takes the sum of the for loop and appends it to the end;
    ---   there might be a neater way to do this, but I can't find one.
    ( v -> append( v, sum v ) ) for q to n list (
      binomial( n + 1, q + 1 ) - binomial( i + 1, q + 1 )
    )
  );
  --- This is one of our outputs that we will populate.
  V := for d to #g - 1 list new MutableList from g#d .. f#d;
  --- This is the other output that we will populate.
  lowerBound := for d to #g - 1 list new MutableList from g#d .. f#d;
  for d to #g - 1 do (
    VAccumulated := Vi#n; -- This is simply the zero vector to start.
    --- begin initialize the macaulay representation
    rep := macaulayRepresentation( g#d, d );
    --- initialize the lastrep0Index to be the last index in rep that equals
    ---   rep#0.
    lastrep0Index := 0;
    while rep#?( lastrep0Index + 1 ) and
      rep#( lastrep0Index + 1 ) === rep#0 do 
      lastrep0Index = lastrep0Index + 1;
    --- end initialize lastrep0Index
    nextLowerBound := macaulayBelowBound( g#d, d );
    nextrep0 := 0;
    for k to f#d - g#d do (
      --- the index of the monomial is n - nextrep0.
      VAccumulated = VAccumulated + Vi#( n - nextrep0 );
      V#d#k = VAccumulated;
      lowerBound#d#k = nextLowerBound;
      if #rep === 0 then continue;
      nextrep0 = rep#0;
      if nextrep0 === 0 then nextLowerBound = nextLowerBound + 1;
      ( rep, lastrep0Index ) = incrementRep( rep, lastrep0Index );
    )
  );
  ( V, lowerBound )
)
