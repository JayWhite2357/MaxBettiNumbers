--- Notationally: putting a ' (prime) on a variable indicates that it is the
---   value of the variable in the previous degree.
--- Also: i is shorthand for j-g and b is shorthand for c-G, as indicated above
---   the method SimplifiedNone

--- The "dictionary" entry is thus
---   Dict#b#i instead of (d,c,j) and
---   Dict'#b'#i' instead of (d-1,c',j')

CompleteNone = ( G, F, g, f, V, lb ) -> (
  maxVDict' := { { V#0#0 } };
  G' := 0;
  g' := 0;
  for d to #G - 1 do (
    --- Each iteration of the following is a list of the maxV values for each j.
    maxVDict' = for c from G#d to F#d list (
      maxV := null;
      --- We have to traverse the list in reverse order.
      reverse for j in reverse( g#d .. min( f#d, c - G' ) ) list (
        b' := c - j - G';
        i := j - g#d;
        i' := max( lb#d#i - g', 0 );
        if maxVDict'#?b' and maxVDict'#b'#?i' then (
          V0 := maxVDict'#b'#i' + V#d#i;
          if maxV === null then (
            maxV = V0
          ) else (
            Vdiff := V0 - maxV;
            if min Vdiff >= 0 then (
              maxV = V0 
            ) else if max Vdiff > 0 then (
              maxV = max \ transpose{ maxV, V0 }
            )
          )
        );
        --- If this value of j is impossible, we simply won't save it.
        ---   This won't mess up indexing because it can only happen in the
        ---   beginnin iterations, and we reverse the list after.
        if maxV === null then continue;
        --- The main difference from SimplifiedNone is that we need to save this
        ---   value for each j so that we can use it in the next degree
        ---   as a result, the loops cannot be written as compactly.
        maxV
      )
      --- We return a list of the maxV values for each j.
    );
    G' = G#d;
    g' = g#d;
  );
  maxVDict'#0#0
);
