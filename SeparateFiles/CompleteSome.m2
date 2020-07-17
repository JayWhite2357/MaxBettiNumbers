--- This is a combination of CompleteNone and SimplifiedSome.
--- The primary difference is that the "raveled" result in each degree must be
---   a list where each entry corresponds to a c value, which in turn is a list
---   of the possible j values that give maxV for that c and d. So, it is a
---   list of lists of lists. This "raveled" result can be unraveled with the
---   UnravelComplete methods.

CompleteSome = ( G, F, g, f, V, lb ) -> (
  maxVDict' := { { V#0#0 } };
  G' := 0;
  g' := 0;
  raveledHFs := for d to #G - 1 list (
    maxHFDict := new MutableList from G#d .. F#d;
    maxVDict' = for c from G#d to F#d list (
      maxV := null;
      maxHF := { };
      --- In this case, we need to collect both the maxV and the maxHF.
      ---   The easiest way is to do it at the same time, and then just split it
      ---   up later.
      maxVHFList := reverse for j in reverse( g#d .. min( f#d, c - G' ) ) list (
        b' := c - j - G';
        i := j - g#d;
        i' := max( lb#d#i - g', 0 );
        --- We need to check that this is actually a valid value of j that has
        ---   any valid functions in the previous degree
        if maxVDict'#?b' and maxVDict'#b'#?i' then (
          V0 := maxVDict'#b'#i' + V#d#i;
          if maxV === null then (
            maxHF = { j };
            maxV = V0;
          ) else (
            if last V0 === last maxV then (
              maxHF = append( maxHF, j );
            ) else if last V0 > last maxV then (
              maxHF = { j };
            );
            Vdiff := V0 - maxV;
            if min Vdiff >= 0 then (
              maxV = V0
            ) else if max Vdiff > 0 then (
              maxV = max \ transpose{ maxV, V0 }
            )
          );
        );
        if maxV === null then continue;
        ( maxV, maxHF )
      );
      --- Here we just split up the list so that maxV and maxHF are separate.
      maxHFDict#( c - G#d ) = maxVHFList / last;
      maxVHFList / first
    );
    G' = G#d;
    g' = g#d;
    toList maxHFDict
  );
  ( maxVDict'#0#0, raveledHFs )
);
