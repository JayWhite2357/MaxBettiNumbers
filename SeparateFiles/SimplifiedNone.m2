--- This is an implementation of the algorithm described in
--- 
--- Note: the portions of the pseudocode in algorithm 3.1 of above are
---   written in comments beginning with --**
SimplifiedNone = ( G, F, g, f, V, lb ) -> (
  --**We initialize the base case by creating a dictionary maxVDict 
  --**  containing (-1,0)=>0
  maxVDict := { V#0#0 };
  G' := 0;
  F' := 0;
  maxj' := { 0 };
  --**For each value of d from 0 to D do:
  for d to #G - 1 do (
    maxj := new MutableList from G#d .. F#d;
    --**For each value of c from G(d) to F(d) do:
    maxVDict = for c from G#d to F#d list (
      --- Note: efficient and compact implementation of maximization
      max \ transpose(
        --**For each value of j from g(d) to f (d) do:
        --- Note: The situations where j + F' < c or j + G' > c are impossible
        for j from max( g#d, c - F' ) to min( f#d, c - G' )
        --- Note: We can ignore the situations where we violate the lower bound
        when maxj'#( c - j - G' ) >= lb#d#( j - g#d ) 
        list (
          maxj#( c - G#d ) = j;
          --**Compute V0 = maxVDict(d', c') + Vq[d,j].
          --- Note: This next line is the potential maximum for this iteration
          maxVDict#( c - j - G' ) + V#d#( j - g#d )
        )
      )
      --**Add the entry (d,c)=>maxV to the dictionary maxVDict
    );
    G' = G#d;
    F' = F#d;
    maxj' = maxj;
  );
  --**Return the value maxVDict(D, G(D), g(D))
  maxVDict#0
);
