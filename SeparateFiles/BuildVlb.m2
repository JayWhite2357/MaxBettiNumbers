BuildVLowerBound = (g, f, n) -> (
  Vi := for i to n list (
    (v -> append( v, sum v )) for q to n list (
      binomial( n + 1, q + 1 ) - binomial( i + 1, q + 1 )
    )
  );
  V := for d to #g - 1 list new MutableList from g#d .. f#d;
  lowerBound := for d to #g - 1 list new MutableList from g#d .. f#d;
  for d to #g - 1 do (
    VAccumulated := Vi#n; -- This is simply the zero vector.
    rep := macaulayRepresentation( g#d, d );
    nextLowerBound := macaulayBelowBound( g#d, d );
    rep0 := 0;
    repIndex := 0;
    for k to f#d-g#d do (
      VAccumulated = VAccumulated + Vi#(n - rep0);
      V#d#k = VAccumulated;
      lowerBound#d#k = nextLowerBound;
      if rep#?0 then (
        rep0 = rep#0;
      ) else (
        continue
      );
      if rep0 === 0 then nextLowerBound = nextLowerBound + 1;
      -- Begin increment rep
      if repIndex === 0 then (
        while rep#?repIndex and rep#repIndex === rep0 do (
          repIndex = repIndex + 1
        )
      );
      repIndex = repIndex - 1;
      rep = join(
        toList( repIndex : 0 ),
        { rep0 + 1 },
        drop( rep, repIndex + 1 )
      );
      -- End increment rep
    )
  );
  (V, lowerBound)
)
