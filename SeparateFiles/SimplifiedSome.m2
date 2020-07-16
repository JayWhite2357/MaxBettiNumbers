SimplifiedSome = (G, F, g, f, V, lb) -> (
  prevmaxVDict := { V#0#0 };
  prevG := 0;
  prevF := 0;
  prevmaxJ := { 0 };
  raveledHFs := for d to #G - 1 list (
    currmaxJ := new MutableList from G#d .. F#d;
    maxHFDict := new MutableList from G#d .. F#d;
    prevmaxVDict = for c from G#d to F#d list (
      maxSum := 0; maxHF := {};
      maxV := max \ transpose (
        for j from max( g#d, c - prevF ) to min( f#d, c - prevG )
        when prevmaxJ#( c - j - prevG ) >= lb#d#( j - g#d ) list (
          currmaxJ#( c - G#d ) = j;
          newV := prevmaxVDict#( c - j - prevG ) + V#d#( j - g#d );
          if last newV === maxSum then (
            maxHF = append( maxHF, j );
          ) else if last newV > maxSum then (
            maxHF = { j };
            maxSum = last newV;
          );
          newV
        )
      );
      maxHFDict#(c-G#d) = maxHF;
      maxV
    );
    prevG = G#d; prevF = F#d; prevmaxJ = currmaxJ;
    toList maxHFDict
  );
  (prevmaxVDict#0, raveledHFs)
);
