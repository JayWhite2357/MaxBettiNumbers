SimplifiedAll = (G, F, g, f, V, lb) -> (
  prevmaxVDict := {{V#0#0}}; prevG := 0; prevF := 0; prevmaxJ := {0};
  raveledHFs := for d to #G-1 list (
    currmaxJ := new MutableList from G#d..F#d;
    maxHFDict := new MutableList from G#d..F#d;
    prevmaxVDict = for c from G#d to F#d list (
      maxVHF := new MutableHashTable;
      for j from max(g#d,c-prevF) to min(f#d,c-prevG) when prevmaxJ#(c-j-prevG)>=lb#d#(j-g#d) do (
        currmaxJ#(c-G#d) = j;
        for Vprime in prevmaxVDict#(c-j-prevG) do (
          newV := Vprime + V#d#(j-g#d);
          if maxVHF#?newV then (
            maxVHF#newV = append(maxVHF#newV, j);
          ) else if false =!= for oldV in keys(maxVHF) do (
            diffV := newV - oldV;
            if min(diffV) >= 0 then remove(maxVHF, oldV)
            else if max(diffV) <= 0 then break false
          ) then maxVHF#newV = {j};
        )
      );
      maxHFDict#(c-G#d) = unique flatten values maxVHF;
      keys maxVHF
    );
    prevG = G#d; prevF = F#d; prevmaxJ = currmaxJ;
    toList maxHFDict
  );
  (prevmaxVDict#0, raveledHFs)
);
