CompleteAll = (G, F, g, f, V, lb) -> (
  prevmaxVDict := {{{V#0#0}}}; prevG := 0; prevg := 0;
  raveledHFs := for d to #G-1 list (
    maxHFDict := new MutableList from G#d..F#d;
    prevmaxVDict = for c from G#d to F#d list (
      maxVHF := new MutableHashTable;
      maxVHFList := reverse for j in reverse(g#d..min(f#d, c - prevG)) list (
        bprime := c - j - prevG;
        i := j - g#d;
        iprime := max(lb#d#i - prevg, 0);
        if prevmaxVDict#?bprime and prevmaxVDict#bprime#?iprime then for Vprime in prevmaxVDict#bprime#iprime do (
          newV := Vprime + V#d#i;
          if maxVHF#?newV then (
            maxVHF#newV = append(maxVHF#newV, j);
          ) else if false =!= for oldV in keys(maxVHF) do (
            diffV := newV - oldV;
            if min(diffV) >= 0 then remove(maxVHF, oldV)
            else if max(diffV) <= 0 then break false
          ) then maxVHF#newV = {j};
        );
        if #maxVHF === 0 then continue;
        (keys maxVHF, unique flatten values maxVHF)
      );
      maxHFDict#(c-G#d) = maxVHFList / last;
      maxVHFList / first
    );
    prevG = G#d; prevg = g#d;
    toList maxHFDict
  );
  (prevmaxVDict#0#0, raveledHFs)
);
