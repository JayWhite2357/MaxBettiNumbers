SimplifiedNone = (G, F, g, f, V, lb) -> (
  prevmaxVDict := {V#0#0}; prevG := 0; prevF := 0; prevmaxJ := {0};
  for d to #G-1 do (
    currmaxJ := new MutableList from G#d..F#d;
    prevmaxVDict = for c from G#d to F#d list
      max\transpose for j from max(g#d,c-prevF) to min(f#d,c-prevG) when prevmaxJ#(c-j-prevG)>=lb#d#(j-g#d) list (
        currmaxJ#(c-G#d) = j;
        prevmaxVDict#(c-j-prevG) + V#d#(j-g#d)
      );
    prevG = G#d; prevF = F#d; prevmaxJ = currmaxJ;
  );
  prevmaxVDict#0
);
