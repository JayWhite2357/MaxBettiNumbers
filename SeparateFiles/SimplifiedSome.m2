--- This method is similar in structure to SimplifiedNone
--- The functions that give the maximum sum of the Vq's is returned in a
---   "raveled" format. raveledHFs contains a list of each degree, which is a
---   list of the value of the functions in that degree that give the maximum
---   sum of V. This "raveled" result can be unraveled with the
---   UnravelSimplified methods.
--- Note, the last element of the V vectors is the sum of the Vq's, which is why
---   we use that element for tracking HF.

SimplifiedSome = (G, F, g, f, V, lb) -> (
  maxVDict' := { V#0#0 };
  G' := 0;
  F' := 0;
  maxj' := { 0 };
  --- Each degree of this for loop returns all the j values in that degree with
  ---   max V.
  raveledHFs := for d to #G - 1 list (
    maxj := new MutableList from G#d .. F#d;
    maxHFDict := new MutableList from G#d .. F#d;
    maxVDict' = for c from G#d to F#d list (
      --- Note, we need to track the maxSum so that we can collect the j values
      maxSum := 0;
      maxHF := { };
      --- However, we can still utilize max \ transpose to maximize the vectors
      maxV := max \ transpose (
        for j from max( g#d, c - F' ) to min( f#d, c - G' )
        when maxj'#( c - j - G' ) >= lb#d#( j - g#d ) list (
          maxj#( c - G#d ) = j;
          V0 := maxVDict'#( c - j - G' ) + V#d#( j - g#d );
          if last V0 === maxSum then (
            maxHF = append( maxHF, j );
          ) else if last V0 > maxSum then (
            maxHF = { j };
            maxSum = last V0;
          );
          V0
        )
      );
      maxHFDict#( c - G#d ) = maxHF;
      maxV
    );
    G' = G#d;
    F' = F#d;
    maxj' = maxj;
    --- This is the list of all j values that gave us max V
    toList maxHFDict
  );
  ( maxVDict'#0, raveledHFs )
);
