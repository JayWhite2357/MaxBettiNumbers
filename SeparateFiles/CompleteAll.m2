--- This is by far the most complex version. However, there are no new ideas,
---   it is simply a combination of the techniques in CompleteSome and
---   SimplifiedAll.

CompleteAll = ( G, F, g, f, V, lowerBound ) -> (
  maxVDict' := { { { V#0#0 } } };
  G' := 0;
  g' := 0;
  raveledHFs := for d to #G - 1 list (
    maxHFDict := new MutableList from G#d .. F#d;
    maxVDict' = for c from G#d to F#d list (
      maxVHF := new MutableHashTable;
      maxVHFList := reverse for j in reverse( g#d .. min( f#d, c - G' ) ) list (
        b' := c - j - G';
        i := j - g#d;
        i' := max( lowerBound#d#i - g', 0 );
        if maxVDict'#?b' and maxVDict'#b'#?i' then (
          for maxV' in maxVDict'#b'#i' do (
            V0 := maxV' + V#d#i;
            if maxVHF#?V0 then (
              maxVHF#V0 = append( maxVHF#V0, j );
            ) else if false =!= (
              for V1 in keys maxVHF do (
                Vdiff := V0 - V1;
                if min Vdiff >= 0 then remove( maxVHF, V1 )
                else if max Vdiff <= 0 then break false
              )
            ) then (
              maxVHF#V0 = { j }
            )
          )
        );
        if #maxVHF === 0 then continue;
        ( keys maxVHF, unique flatten values maxVHF )
      );
      maxHFDict#( c - G#d ) = maxVHFList / last;
      maxVHFList / first
    );
    G' = G#d;
    g' = g#d;
    toList maxHFDict
  );
  ( maxVDict'#0#0, raveledHFs )
);
