CompleteNone = (G, F, g, f, V, lb) -> (
  prevmaxVDict := {{V#0#0}}; prevG := 0; prevg := 0;
  for d to #G-1 do (
    prevmaxVDict = for c from G#d to F#d list (
      maxV := null;
      reverse for j in reverse(g#d..min(f#d, c - prevG)) list (
        bprime := c - j - prevG;
        i := j - g#d;
        iprime := max(lb#d#i - prevg, 0);
        if prevmaxVDict#?bprime and prevmaxVDict#bprime#?iprime then (
          newV := prevmaxVDict#bprime#iprime + V#d#i;
          if maxV === null then maxV = newV else (
            diffV := newV - maxV;
            if min(diffV) >= 0 then maxV = newV else if max(diffV) > 0 then maxV = max\transpose{maxV, newV};
          );
        );
        if maxV === null then continue;
        maxV
      )
    );
    prevG = G#d; prevg = g#d;
  );
  prevmaxVDict#0#0
);
