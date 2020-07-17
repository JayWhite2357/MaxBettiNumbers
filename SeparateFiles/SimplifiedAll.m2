SimplifiedAll = ( G, F, g, f, V, lb ) -> (
  maxVDict' := { { V#0#0 } };
  G' := 0;
  F' := 0;
  maxj' := { 0 };
  raveledHFs := for d to #G - 1 list (
    maxj := new MutableList from G#d .. F#d;
    maxHFDict := new MutableList from G#d .. F#d;
    --- Instead of being a vectors, maxVDict#c is a list of vectors.
    maxVDict' = for c from G#d to F#d list (
      --- maxVHF will be the collection of all V and HF that are maximal.
      ---   The keys of the table are the maximal values of V.
      ---   The values of each key are the j's that give that value of V.
      maxVHF := new MutableHashTable;
      for j from max( g#d, c - F' ) to min( f#d, c - G' )
      when maxj'#( c - j - G' ) >= lb#d#( j - g#d )
      do (
        maxj#( c - G#d ) = j;
        --- Instead of being a vectors, maxVDict'#c' is a list of vectors.
        for maxV' in maxVDict'#( c - j - G' ) do (
          V0 := maxV' + V#d#( j - g#d );
          if maxVHF#?V0 then (
            --- In the case where V0 is already in maxVHF, add j to it's key.
            maxVHF#V0 = append( maxVHF#V0, j );
          ) else if false =!= ( --- If max Vdiff <= 0 below is never true...
            for V1 in keys maxVHF do (
              Vdiff := V0 - V1;
              --- If V0 is greater than V1, remove V1.
              if min Vdiff >= 0 then remove( maxVHF, V1 )
              --- If V0 is less than V1, break and do nothing.
              else if max Vdiff <= 0 then break false
            )
          ) then (
            --- In the case where V0 is not less than any V1, add it to maxVHF.
            maxVHF#V0 = { j };
          )
        )
      );
      --- We want to make maxHFDict simply a list of possible j values.
      maxHFDict#( c - G#d ) = unique flatten values maxVHF;
      --- maxVDict#c is a list the vectors stored in the keys of maxVHF
      keys maxVHF
    );
    G' = G#d;
    F' = F#d;
    maxj' = maxj;
    toList maxHFDict
  );
  ( maxVDict'#0, raveledHFs )
);
