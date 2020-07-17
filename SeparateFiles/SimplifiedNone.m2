--- This is an implementation of the algorithm described in the paper
--- Note: the portions of the pseudocode in algorithm 3.1 of above are
---   written in comments beginning with --**
--- Notationally: putting a ' (prime) on a variable indicates that it is the
---   value of the variable in the previous degree.

--- Instead of using a dictionary with (d, c) keys, we opt to only use a list,
---    the dictionaries are lists of the theoretical (d, c) keys.
---    the "dictionary" in each degree is a list of all the keys, where the
---    0th entry is the (d, G#d key). Note, to access a key with a d-1 degree,
---    we simply access the previous version of that dictionary, which is why we
---    have to keep track of that.
--- To make sense of the more compact way of storing these values, we will use
---    the shorthand b to represend c-g and i to represent j-G.


SimplifiedNone = ( G, F, g, f, V, lb ) -> (
  --**We initialize the base case by creating a dictionary maxVDict'
  --**  containing (-1, 0) => 0
  --- V#0#0 is the zero vector
  maxVDict' := { V#0#0 };
  --- These are the correct values in degree -1.
  G' := 0;
  F' := 0;
  maxj' := { 0 };
  --**For each value of d from 0 to D do:
  for d to #G - 1 do (
    --- maxj#c is the max j value that we can get if we respect the Macaulay
    ---   bound. Although it is not necessary, we can quit looping early by
    ---   respecting this bound.
    maxj := new MutableList from G#d .. F#d;
    --**For each value of c from G(d) to F(d) do:
    --- maxVDict' get's assigned only once we have looped through all c, so
    ---   there is no need to create a maxVDict just to reassign maxVDict'
    ---   notationally, it is confusing, but it works well this way.
    maxVDict' = for c from G#d to F#d list (
      --- max \ transpose does elementwise maximization on a bunch of lists
      max \ transpose(
        --**For each value of j from g(d) to f (d) do:
        --- The situations where j + F' < c or j + G' > c are impossible
        for j from max( g#d, c - F' ) to min( f#d, c - G' )
        --- We can ignore the situations where we violate the lower bound.
        ---   This is done by comparing the Macaulay lower bound with the
        ---   maximum j in the previous degree.
        when maxj'#( c - j - G' ) >= lb#d#( j - g#d ) 
        list (
          maxj#( c - G#d ) = j;
          --**Compute V0 = maxVDict(d', c') + Vq[d,j].
          --- This next line is the potential maximum for this iteration
          maxVDict'#( c - j - G' ) + V#d#( j - g#d )
        )
      )
      --**Add the entry (d,c)=>maxV to the dictionary maxVDict
    );
    --- Update all of the values so that they are correct for the next degree
    G' = G#d;
    F' = F#d;
    maxj' = maxj;
  );
  --**Return the value maxVDict(D, G(D), g(D))
  maxVDict'#0
);
