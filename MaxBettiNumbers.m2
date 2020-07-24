-- -*- coding: utf-8 -*-
newPackage( "MaxBettiNumbers",
  Headline =>
  "Methods to find Maximum Betti numbers given bounds on the Hilbert function",
  Version => "0.9",
  Date => "July 24, 2020",
  Authors => { { Name => "Jay White", Email => "jay.white@uky.edu" } },
  DebuggingMode => true,
  HomePage => "https://github.com/JayWhite2357/maxbetti"
);

--------------------------------------------------------------------------------
--- exports
--------------------------------------------------------------------------------

--- exports and options for the main method of the package, maxBettiNumbers
export { "maxBettiNumbers" };
export { "HilbertFunctionLowerBound", "HilbertDifferenceLowerBound" };
export { "HilbertFunctionUpperBound", "HilbertDifferenceUpperBound" };
export { "HilbertPolynomial", "ResultsCount" };
--export { "Algorithm" };

--- exports for the type, MaxBetti, that is returned by maxBettiNumbers
export { "MaxBetti" };
export { "isRealizable", "BettiUpperBound", "MaximumBettiSum" };
export { "HilbertFunctions", "MaximalBettiNumbers" };

--- exports and options for the auxillary methods of the package
export { "lexBetti", "almostLexBetti" };
export { "lexsegmentIdeal", "almostLexIdeal" };
export { "AsTally" };

--------------------------------------------------------------------------------
--- end exports
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- types
--------------------------------------------------------------------------------

MaxBetti = new Type of HashTable

--------------------------------------------------------------------------------
--- end types
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Functions to deal with the Macaulay Representation of a Number
--------------------------------------------------------------------------------

--- This is the macaulay representation of a. From this, it is easy to read off
---   the max index of a monomial as well as the Macaulay upper and lower
---   bounds.
--- The output, rep, is a sequcne of length d
--- a = binomial(rep#0, 1) + binomial(d + rep#d, d + 1)
--- Note: this is a different output from most versions of this method.
---   the reason is that this is more compact and efficient.
--- The idea is that we want to easily increment and decrement a without
---   recomputing the representation each time. 

--- Incrementing rep: (increasing a)
---   Find the last element equal to rep#0.
---   Increase that element by 1 and set all preceding elements to 0
--- Decrementing rep: (decreasing a)
---   Find the first nonzero element
---      Reduce it by 1
---      Set all preceding elements to that element's new value
--- Reading off monomial:
---   The first nonzero element indicates the max index.
---   Add 1 to every other nonzero element.
---   Set all zero elements to equal the first nonzero element.
---   Take n+1-e for each element e. This is the index of the variable.
---   The product of all the variables is the ath last monomial,
---      where the 1st last is the power of the last variable.


macaulayRepresentation = ( a, d ) -> (
  v := if d <= 1 then a else 0;
  if d > 1 then (
    while a > binomial( v - 1 + d, d ) do (
      v = v + 1
    )
  );
  reverse for i in reverse( 0 .. d - 1 ) list (
    if a === 0 then 0 else if i === 0 then a else (
      a = a - binomial( v + i, i + 1 );
      while a < 0 do (
        v = v - 1;
        a = a + binomial( v + i, i );
      );
      v
    )
  )
)

macaulayAboveBound = ( a, d ) -> (
  if ( a === infinity or ( d === 0 and a > 0 ) ) then infinity else (
    r := macaulayRepresentation( a, d );
    sum for i to #r-1 list (
      binomial( r#i + i + 1, i + 2 )
    )
  )
);

macaulayBelowBound = ( a, d ) -> (
  if ( a <= 0 or d <= 0 ) then 0 else if d === 1 then 1 else (
    r := macaulayRepresentation( a, d );
    sum for i to #r-1 list (
      if r#i === 0 then 0 else (
        binomial( r#i + i - 1, i )
      )
    )
  )
);

decrementRep = ( rep, firstNonzeroIndex, firstNonzeroValue ) -> (
  rep = join(
    firstNonzeroIndex + 1 : firstNonzeroValue - 1,
    drop( rep, firstNonzeroIndex + 1 )
  );
  if firstNonzeroValue === 1 then (
    firstNonzeroIndex = firstNonzeroIndex + 1;
    if rep#?firstNonzeroIndex then (
      firstNonzeroValue = rep#firstNonzeroIndex;
    )
  ) else (
    firstNonzeroIndex = 0;
    firstNonzeroValue = firstNonzeroValue - 1;
  );
  ( rep, firstNonzeroIndex, firstNonzeroValue )
);

incrementRep = ( rep, lastrep0Index ) -> (
  rep = join(
    toList( lastrep0Index : 0 ),
    { rep#0 + 1 },
    drop( rep, lastrep0Index + 1 )
  );
  if lastrep0Index === 0 then (
    while rep#?( lastrep0Index + 1 ) and
      rep#( lastrep0Index + 1 ) === rep#0 do 
      lastrep0Index = lastrep0Index + 1;
  ) else lastrep0Index = lastrep0Index - 1;
  ( rep, lastrep0Index )
)

--------------------------------------------------------------------------------
--- End Macaulay Representation Methods
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of functions to Sanitize and Optimize the inputs -----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- functions to sanitize the input bounds
--------------------------------------------------------------------------------

--- This function sanitizes g(d) so that it is a valid hilbert function.
--- This relies on the fact that h(d) is must be at least
--- macaulayAboveBound(g(d-1), d-1)
cleanUpperBound = f -> (
  bound := 1;
  for d to #f - 1 list (
    if f#d =!= null then (
      bound = min( f#d, bound )
    );
    bound
  ) do (
    bound = macaulayAboveBound( bound, d )
  )
);

--- This function sanitizes f(d) so that it is a valid hilbert function.
--- This relies on the fact that h(d) is must be at most
--- macaulayBelowBound(g(d+1), d+1)
cleanLowerBound = f -> if #f == 0 then f else (
  bound := 0;
  reverse for d in reverse( 0 .. #f - 1 ) list (
    if f#d =!= null then (
      bound = max( f#d, bound )
    );
    bound
  ) do (
    bound = macaulayBelowBound( bound, d )
  )
);

--------------------------------------------------------------------------------
--- end sanitize bounds
--------------------------------------------------------------------------------

--- function for padding lists with null
padList = ( l, f ) -> join( f, toList( l - #f : null ) );

--------------------------------------------------------------------------------
--- functions to sanitize the polynomial input
--------------------------------------------------------------------------------

--- This function gives the minimum degree at which that every saturated ideal
--- with hilbert polynomial p is guarenteed to have hilbert function match
--- hilbert polynomial
minPolyBoundDegree = p -> (
  n := first degree p;
  i := ( ring p )_0;
  lC := 0;
  while n > 0 do (
    lC = leadCoefficient p;
    p = p - binomial( n + i, n + 1 ) + binomial( n + i - n! * lC, n + 1 );
    n = first degree p;
  );
  d := sub( p, ZZ );
  if lC > d then error "Invalid Hilbert Polynomial.";
  d
);

--- This function sets G,F,g,f to be the appropriate values to ensure that all
--- ideals in the family have the specified hilbert polynomial
--- if no polynomial is specified, nothing is done.
cleanPolynomial = ( G, F, g, f, p, d ) -> (
  if p =!= null then (
    i := ( ring p )_0;
    pd := sub( sub( p, i => d ), ZZ );
    pd' := sub( sub( p, i => d - 1 ), ZZ );
    deltapd := pd - pd';
    G = padList( d + 1, G );
    F = padList( d + 1, F );
    g = padList( d + 1, g );
    f = padList( d + 1, f );
    if G_d === null or G#d < pd then G = replace( d, pd, G );
    if F_d === null or F#d > pd then F = replace( d, pd, F );
    if g_d === null or g#d < deltapd then g = replace( d, deltapd, g );
    if f_d === null or f#d > deltapd then f = replace( d, deltapd, f );
  );
  ( G, F, g, f )
);

--------------------------------------------------------------------------------
--- end sanitize polynomial
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- functions to optimize the bounds
--------------------------------------------------------------------------------

--- This function makes an optimizations of g(d) based on the following:
--- The smallest that h(d) could be is G(d)-F(d-1)
--- Usage: g = optimizeLowerBound ( G, F, g );
optimizeLowerBound = ( G, F, g ) -> (
  gprime := G - prepend( 0, drop( F, -1 ) );
  max \ transpose { g, gprime }
);

--- This function makes an optimizations of f(d) based on the following:
--- The largest that h(d) could be is G(d)-G(d-1)
--- Usage: f = optimizeLowerBound ( G, F, f );
optimizeUpperBound = ( G, F, f ) -> (
  fprime := F - prepend( 0, drop( G, -1 ) );
  min \ transpose { f, fprime }
);

--- This function makes two optimizations on G(d) based on the following:
--- The smallest that H(d) could be is G(d) + g(d)
--- The smallest that H(d) could be is G(d+1) - f(d)
optimizeAccumulatedLowerBound = ( G, g, f ) -> (
  cumulativeSum := 0;
  G = for d to #G - 1 list (
    cumulativeSum = max( G#d, cumulativeSum + g#d )
  );
  bound := 0;
  reverse for d in reverse( 0 .. #G - 1 ) list (
    bound = max( G#d, bound )
  ) do (
    bound = bound - f#d
  )
);

--- This function makes two optimizations on F(d) based on the following:
--- The largest that H(d) could be is F(d) + f(d)
--- The largest that H(d) could be is F(d+1) - g(d)
optimizeAccumulatedUpperBound = ( F, g, f ) -> (
  cumulativeSum := 0;
  F = for d to #F - 1 list (
    cumulativeSum = min( F#d, cumulativeSum + f#d )
  );
  bound := infinity;
  reverse for d in reverse( 0 .. #F - 1 ) list (
    bound = min( F#d, bound )
  ) do (
    bound = bound - g#d
  )
);

--------------------------------------------------------------------------------
--- end optimize bounds
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- main function to sanitize (and optimize) the inputs
--------------------------------------------------------------------------------

sanitizeInputs = ( G, F, g, f, p, n ) -> (
  --- Sanitize the polynomial input by converting it to bounds
  D := if p === null then 0 else minPolyBoundDegree( p );
  D = max( D, #G-1, #F-1, #g-1, #f-1 );
  ( G, F, g, f ) = cleanPolynomial( G, F, g, f, p, D );
  --- End Sanitize polynomial
  
  --- Sanitize the input length so that they include at least degree 1
  l := max( #G, #F, #g, #f, 2 );
  ( G, F, g, f ) = ( G, F, g, f ) / padList_l;
  --- End Sanitize input length
  
  --- Sanitize the degree 1 upper difference bound
  if ( f#1 === null or f#1 > n + 1 ) then (
    f = replace( 1, n + 1, f )
  );
  --- End Sanitize degree 1
  
  --- Sanitize the inputs so that they are Hilbert functions
  F = cleanUpperBound F;
  f = cleanUpperBound f;
  G = cleanLowerBound G;
  g = cleanLowerBound g;
  --- End sanitize functions
  
  --- Check validity of inputs
  valid := min( min( F - G ), min( f - g ) ) >= 0;
  --- End check validity
  
  --- Optimize the bounds. This drastically improves the run time.
  --- This is done by repeated application of the 4 optimization Functions.
  --- Once G,F,g,f no longer change, we stop and re-sanitize the values
  --- We repeat this process until G,F,g,f are stable.
  --- Throughout this process we check that it is always a possible scenario.
  prevGFgf := null;
  while valid and prevGFgf =!= ( G, F, g, f ) do (
    while valid and prevGFgf =!= ( G, F, g, f ) do (
      prevGFgf = ( G, F, g, f );
      f = optimizeUpperBound( G, F, f );
      g = optimizeLowerBound( G, F, g );
      F = optimizeAccumulatedUpperBound( F, g, f );
      G = optimizeAccumulatedLowerBound( G, g, f );
      valid = min( min( F - G ), min( f - g ) ) >= 0;
    );
    if valid then (
      F = cleanUpperBound F;
      f = cleanUpperBound f;
      G = cleanLowerBound G;
      g = cleanLowerBound g;
      valid = min( min( F - G ), min( f - g ) ) >= 0;
    )
  );
  --- End Optimize bounds
  
  --- Throw an error if bounds don't make sense
  if not valid then (
    error concatenate (
      "The given inputs are invalid or give impossible constraints:\nG = ",
      toString G, "\nF = ", toString F, "\ng = ", toString g, "\nf = ",
      toString f
    );
  );
  if last G =!= last F then (
    error concatenate (
      "The given inputs don't specify constraints that eventually fix the ",
      "Hilbert function:\nG = ", toString G, "\nF = ", toString F, "\ng = ",
      toString g, "\nf = ", toString f );
  );
  --- End throw error
  
  ( G, F, g, f )
);

--------------------------------------------------------------------------------
--- end main sanitize function
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End Sanitize and Optimize --------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- Functions to build V and lowerBound for use in the algorithms.
--------------------------------------------------------------------------------

--- We precompute the V_q values as well as the Macaulay lower bound.
---   Doing this ahead of time saves a ton of repitition.
--- We are setting V#d#(j - g#d) = V_q[d, j]
--- We are setting lowerBound#d#(j - g#d) = [j]_<d>
--- Although we could compute these directly, the following is a more efficient
---   way of computing them iteratively.
BuildVLowerBound = ( g, f, n ) -> (
  --- Make a list of all possible vectors. This way we don't have to compute
  ---   binomials repeatedly
  Vi := for i to n list (
    --- The next line takes the sum of the for loop and appends it to the end;
    ---   there might be a neater way to do this, but I can't find one.
    ( v -> append( v, sum v ) ) for q to n list (
      binomial( n + 1, q + 1 ) - binomial( i + 1, q + 1 )
    )
  );
  --- This is one of our outputs that we will populate.
  V := for d to #g - 1 list new MutableList from g#d .. f#d;
  --- This is the other output that we will populate.
  lowerBound := for d to #g - 1 list new MutableList from g#d .. f#d;
  for d to #g - 1 do (
    VAccumulated := Vi#n; -- This is simply the zero vector to start.
    --- begin initialize the macaulay representation
    rep := macaulayRepresentation( g#d, d );
    --- initialize the lastrep0Index to be the last index in rep that equals
    ---   rep#0.
    lastrep0Index := 0;
    while rep#?( lastrep0Index + 1 ) and
      rep#( lastrep0Index + 1 ) === rep#0 do 
      lastrep0Index = lastrep0Index + 1;
    --- end initialize lastrep0Index
    nextLowerBound := macaulayBelowBound( g#d, d );
    nextrep0 := 0;
    for k to f#d - g#d do (
      --- the index of the monomial is n - nextrep0.
      VAccumulated = VAccumulated + Vi#( n - nextrep0 );
      V#d#k = VAccumulated;
      lowerBound#d#k = nextLowerBound;
      if #rep === 0 then continue;
      nextrep0 = rep#0;
      if nextrep0 === 0 then nextLowerBound = nextLowerBound + 1;
      ( rep, lastrep0Index ) = incrementRep( rep, lastrep0Index );
    )
  );
  ( V, lowerBound )
)

--------------------------------------------------------------------------------
--- End functions for building V and lowerBound
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Begining of the driver methods of the Algorithms themselves ----------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Simplified Method returning no hilbert Functions
--------------------------------------------------------------------------------

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


SimplifiedNone = ( G, F, g, f, V, lowerBound ) -> (
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
        when maxj'#( c - j - G' ) >= lowerBound#d#( j - g#d ) 
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

--------------------------------------------------------------------------------
--- End Simplified None
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Simplified Method returning all hilbert functions with max betti sum
--------------------------------------------------------------------------------

--- This method is similar in structure to SimplifiedNone
--- The functions that give the maximum sum of the Vq's is returned in a
---   "raveled" format. raveledHFs contains a list of each degree, which is a
---   list of the value of the functions in that degree that give the maximum
---   sum of V. This "raveled" result can be unraveled with the
---   UnravelSimplified methods.
--- Note, the last element of the V vectors is the sum of the Vq's, which is why
---   we use that element for tracking HF.

SimplifiedSome = ( G, F, g, f, V, lowerBound ) -> (
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
        when maxj'#( c - j - G' ) >= lowerBound#d#( j - g#d ) list (
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

--------------------------------------------------------------------------------
--- End Simplified Some
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Simplified Method returning all hilbert Functions
--------------------------------------------------------------------------------

SimplifiedAll = ( G, F, g, f, V, lowerBound ) -> (
  maxVDict' := { { V#0#0 } };
  G' := 0;
  F' := 0;
  maxj' := { 0 };
  raveledHFs := for d to #G - 1 list (
    maxj := new MutableList from G#d .. F#d;
    maxHFDict := new MutableList from G#d .. F#d;
    --- Instead of being a vectors, maxVDict#c is a list of vectors.
    maxVDict' = for c from G#d to F#d list (
      --- maxVHF will be the collection of all V and HF that are maximal.
      ---   The keys of the table are the maximal values of V.
      ---   The values of each key are the j's that give that value of V.
      maxVHF := new MutableHashTable;
      for j from max( g#d, c - F' ) to min( f#d, c - G' )
      when maxj'#( c - j - G' ) >= lowerBound#d#( j - g#d )
      do (
        maxj#( c - G#d ) = j;
        --- Instead of being a vectors, maxVDict'#c' is a list of vectors.
        for maxV' in maxVDict'#( c - j - G' ) do (
          V0 := maxV' + V#d#( j - g#d );
          if maxVHF#?V0 then (
            --- In the case where V0 is already in maxVHF, add j to it's key.
            maxVHF#V0 = append( maxVHF#V0, j );
          ) else if false =!= ( --- If max Vdiff <= 0 below is never true...
            for V1 in keys maxVHF do (
              Vdiff := V0 - V1;
              --- If V0 is greater than V1, remove V1.
              if min Vdiff >= 0 then remove( maxVHF, V1 )
              --- If V0 is less than V1, break and do nothing.
              else if max Vdiff <= 0 then break false
            )
          ) then (
            --- In the case where V0 is not less than any V1, add it to maxVHF.
            maxVHF#V0 = { j };
          )
        )
      );
      --- We want to make maxHFDict simply a list of possible j values.
      maxHFDict#( c - G#d ) = unique flatten values maxVHF;
      --- maxVDict#c is a list the vectors stored in the keys of maxVHF
      keys maxVHF
    );
    G' = G#d;
    F' = F#d;
    maxj' = maxj;
    toList maxHFDict
  );
  ( maxVDict'#0, raveledHFs )
);

--------------------------------------------------------------------------------
--- End Simplified All
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Complete Method returning no hilbert Functions
--------------------------------------------------------------------------------

--- Notationally: putting a ' (prime) on a variable indicates that it is the
---   value of the variable in the previous degree.
--- Also: i is shorthand for j-g and b is shorthand for c-G, as indicated above
---   the method SimplifiedNone

--- The "dictionary" entry is thus
---   Dict#b#i instead of (d,c,j) and
---   Dict'#b'#i' instead of (d-1,c',j')

CompleteNone = ( G, F, g, f, V, lowerBound ) -> (
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
        i' := max( lowerBound#d#i - g', 0 );
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

--------------------------------------------------------------------------------
--- End Complete None
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Complete Method returning all hilbert functions with max betti sum
--------------------------------------------------------------------------------

--- This is a combination of CompleteNone and SimplifiedSome.
--- The primary difference is that the "raveled" result in each degree must be
---   a list where each entry corresponds to a c value, which in turn is a list
---   of the possible j values that give maxV for that c and d. So, it is a
---   list of lists of lists. This "raveled" result can be unraveled with the
---   UnravelComplete methods.

CompleteSome = ( G, F, g, f, V, lowerBound ) -> (
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
        i' := max( lowerBound#d#i - g', 0 );
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

--------------------------------------------------------------------------------
--- End Complete Some
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--- Complete Method returning all hilbert Functions
--------------------------------------------------------------------------------

--- This is by far the most complex version. However, there are no new ideas,
---   it is simply a combination of the techniques in CompleteSome and
---   SimplifiedAll.

CompleteAll = ( G, F, g, f, V, lowerBound ) -> (
  maxVDict' := { { { V#0#0 } } };
  G' := 0;
  g' := 0;
  raveledHFs := for d to #G - 1 list (
    maxHFDict := new MutableList from G#d .. F#d;
    maxVDict' = for c from G#d to F#d list (
      maxVHF := new MutableHashTable;
      maxVHFList := reverse for j in reverse( g#d .. min( f#d, c - G' ) ) list (
        b' := c - j - G';
        i := j - g#d;
        i' := max( lowerBound#d#i - g', 0 );
        if maxVDict'#?b' and maxVDict'#b'#?i' then (
          for maxV' in maxVDict'#b'#i' do (
            V0 := maxV' + V#d#i;
            if maxVHF#?V0 then (
              maxVHF#V0 = append( maxVHF#V0, j );
            ) else if false =!= (
              for V1 in keys maxVHF do (
                Vdiff := V0 - V1;
                if min Vdiff >= 0 then remove( maxVHF, V1 )
                else if max Vdiff <= 0 then break false
              )
            ) then (
              maxVHF#V0 = { j }
            )
          )
        );
        if #maxVHF === 0 then continue;
        ( keys maxVHF, unique flatten values maxVHF )
      );
      maxHFDict#( c - G#d ) = maxVHFList / last;
      maxVHFList / first
    );
    G' = G#d;
    g' = g#d;
    toList maxHFDict
  );
  ( maxVDict'#0#0, raveledHFs )
);

--------------------------------------------------------------------------------
--- End Complete All
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of the main algorithm code ---------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- functions for extracting hilbert function from the algorithm's return value
--------------------------------------------------------------------------------

--- This method unravels a single hilbert function from the raveled result
---   returned from the Simplified algorithm.

UnravelSimplifiedOne = ( HFs, G, g, lowerBound ) -> (
  targetSum := last G;
  lowerBound' := 0;
  result := { };
  for d in reverse( 0 .. #HFs - 1 ) do (
    --- In this version, we take the minimum hilbert function at this degree.
    ---   This is guarenteed to give a valid result in the Simplified case.
    ---   (In the Complete case, it gives a valid result because only valid
    ---   results are stored in raveledHFs.)
    hd := min( HFs#d#( targetSum - G#d ) );
    targetSum = targetSum - hd;
    result = (
      --- We don't really start saving the hilbert function until the Macaulay
      ---   bound is a strict inequality.
      if ( #result === 1 and lowerBound' === hd ) then { hd }
      else prepend( hd, result )
    );
    lowerBound' = lowerBound#d#( hd - g#d );
  );
  { result }
);

--- This is essentially the same as UnravelSimplifiedOne. The only difference is
---   that we track all possible triples (targetSum, lowerBound', result).
---   The list of these is kept in partialUnraveled, which is looped over for
---   each degree. Additionally, all possible values for the hilbert function
---   are considered, and not simply the minimum.
UnravelSimplifiedHFs = ( HFs, G, g, lowerBound ) -> (
  partialUnraveled := { ( last G, 0, { } ) };
  for d in reverse( 0 .. #HFs - 1 ) do (
    partialUnraveled = flatten for tlr in partialUnraveled list (
      ( targetSum, lowerBound', result ) := tlr;
      if targetSum < G#d then continue;
      for hd in HFs#d#( targetSum - G#d ) list (
        if hd < lowerBound' then continue;
        (
          targetSum - hd,
          lowerBound#d#( hd - g#d ),
          if ( #result === 1 and lowerBound' === hd ) then { hd }
          else prepend( hd, result )
        )
      )
    )
  );
  partialUnraveled / last
);

--- In this Complete case, this gives a valid result because only valid results
---   are stored in raveledHFs, since we have the extra "k" index.
--- The only difference from UnravelSimplifiedOne is the lowerBound' - g#d index
UnravelCompleteOne = ( HFs, G, g, lowerBound ) -> (
  targetSum := last G;
  lowerBound' := 0;
  result := { };
  for d in reverse( 0 .. #HFs - 1 ) do (
    --- The only difference from UnravelSimplifiedOne is the lowerBound' - g#d
    hd := min( HFs#d#( targetSum - G#d )#( lowerBound' - g#d ) );
    ( targetSum, lowerBound', result ) =
    (
      targetSum - hd,
      lowerBound#d#( hd - g#d ),
      if ( #result === 1 and lowerBound' === hd ) then { hd }
      else prepend( hd, result )
    )
  );
  { result }
);

--- The only difference from UnravelSimplifiedHFs is the lowerBound' - g#d index
UnravelCompleteHFs = ( HFs, G, g, lowerBound ) -> (
  partialUnraveled := { ( last G, 0, { } ) };
  for d in reverse( 0 .. #HFs - 1 ) do (
    partialUnraveled = flatten for tlr in partialUnraveled list (
      ( targetSum, lowerBound', result ) := tlr;
      if targetSum < G#d then continue;
      --- The only difference from UnravelSimplifiedHFs is the lowerBound' - g#d
      for hd in HFs#d#( targetSum - G#d )#( max( lowerBound' - g#d, 0 ) ) list (
        if hd < lowerBound' then continue;
        (
          targetSum - hd,
          lowerBound#d#( hd - g#d ),
          if ( #result === 1 and lowerBound' === hd ) then { hd }
          else prepend( hd, result )
        )
      )
    )
  );
  partialUnraveled / last
);

--------------------------------------------------------------------------------
--- End unravel functions
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- auxillary methods
--------------------------------------------------------------------------------

--- This is an efficient way of computing the betti numbers of a lexsegment
---   Instead of computing the actual ideal, we loop through each degree and
---   use the max index of the monomial
---   once we have enough monomials in that degree, we move up to the next
---   degree
--- The returned values are the sums of the binomial coefficients of the
---   generators in each degree. They are exactly the values in the
---   Eliahou-Kervaire resolution.
lexBettiArray = ( h, n ) -> (
  b := for i to n list for q to n list binomial( i, q );
  zeroList := for i to n list 0;
  if not h#?0 then return { zeroList } else if h#0 === 0 then return { b#0 };
  if h#0 > 1 or min h < 0 then error( "Not a valid Hilbert function." );
  ( rep, firstNonzeroIndex, firstNonzeroValue ) :=
    ( { n + 1 }, 0, n + 1 );
  for d to #h - 1 list if d === 0 then zeroList else (
    upperBound := sum for i to #rep - 1 list binomial( rep#i + i, i + 1 );
    if h#d > upperBound then error( "Not a valid Hilbert function." );
    s := zeroList;
    for l from h#d to upperBound - 1 do (
      s = s + b#( n + 1 - firstNonzeroValue );
      ( rep, firstNonzeroIndex, firstNonzeroValue ) = 
        decrementRep( rep, firstNonzeroIndex, firstNonzeroValue );
    );
    s
  ) do if d =!= 0 then (
    --- move rep up one degree
    rep = prepend( 0, rep );
    firstNonzeroIndex = firstNonzeroIndex + 1
    --- end move rep degree
  )
);


--- Note: n is one less than the number of variables.
--- Additionally, S can have many more variables than we need. We only use the
---   first n+1 variables.
--- This is exactly the same algorithm as lexBettiArray, however, we generate
---   the monomials themselves instead of just the binomial coefficients of the
---   max index.
createLexIdeal = ( S, h, n ) -> (
  if not h#?0 then return ideal 0_S else if h#0 === 0 then return ideal 1_S;
  if h#0 > 1 or min h < 0 then error( "Not a valid Hilbert function." );
  ( rep, firstNonzeroIndex, firstNonzeroValue ) :=
    ( { n + 1 }, 0, n + 1 );
  gs := flatten for d to #h - 1 list if d === 0 then { } else (
    upperBound := sum for i to #rep - 1 list binomial( rep#i + i, i + 1 );
    if h#d > upperBound then error( "Not a valid Hilbert function." );
    for l from h#d to upperBound - 1 list (
      product for i to d - 1 list S_(
        n + 1 - (
          if rep#i === 0 then firstNonzeroValue
          else if i === 0 or rep#( i - 1 ) === 0 then rep#i
          else rep#i + 1
        )
      )
    ) do (
      ( rep, firstNonzeroIndex, firstNonzeroValue ) = 
        decrementRep( rep, firstNonzeroIndex, firstNonzeroValue )
    )
  ) do if d =!= 0 then (
    --- move rep up one degree
    rep = prepend( 0, rep );
    firstNonzeroIndex = firstNonzeroIndex + 1
    --- end move rep degree
  );
  ideal if #gs === 0 then 0_S else gs
);


convertBettiArrayToBettiTally = array -> (
  new BettiTally from flatten append (
    for row in pairs array list (
      d := row#0 - 1;
      for col in pairs row#1 list (
        if col#1 === 0 then continue;
        i := col#0 + 1;
        ( i, { d + i }, d + i ) => col#1
      )
    ),
    ( 0, { 0 }, 0 ) => 1
  )
);


lexBetti = method( Options => { AsTally => true } );
lexBetti ( ZZ, List ) := o -> ( numberOfVariables, h ) -> (
  result := lexBettiArray( h, numberOfVariables - 1 );
  if o.AsTally === true then (
    convertBettiArrayToBettiTally result
  ) else (
    result
  )
);

almostLexBetti = method( Options => { AsTally => true } );
almostLexBetti ( ZZ, List ) := o -> ( numberOfVariables, h ) ->
  lexBetti( numberOfVariables - 1, h - prepend( 0, drop( h, -1 ) ), o );

lexsegmentIdeal = method( TypicalValue => Ideal );
lexsegmentIdeal ( PolynomialRing, List ) := ( S, h ) -> 
  createLexIdeal( S, h, dim S - 1 );

almostLexIdeal = method( TypicalValue => Ideal );
almostLexIdeal ( PolynomialRing, List ) := ( S, h ) -> 
  createLexIdeal( S, h - prepend( 0, drop( h, -1 ) ), dim S - 2 );

--------------------------------------------------------------------------------
--- end auxillary methods
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- main Method that parses options and delegates to the appropriate algorithm
--------------------------------------------------------------------------------

maxBettiNumbers = method( TypicalValue => MaxBetti, Options => {
  HilbertPolynomial => null,
  HilbertFunctionUpperBound => { },
  HilbertFunctionLowerBound => { },
  HilbertDifferenceUpperBound => { },
  HilbertDifferenceLowerBound => { },
  ResultsCount => "None",
  Algorithm => "Automatic"
} );

maxBettiNumbers ZZ := o -> numberOfVariables -> (
  ---Parse Inputs and handle options
  n := numberOfVariables - 2;
  G := o.HilbertFunctionLowerBound;
  F := o.HilbertFunctionUpperBound;
  g := o.HilbertDifferenceLowerBound;
  f := o.HilbertDifferenceUpperBound;
  p := o.HilbertPolynomial;
  if instance( p, ZZ ) then p = sub( p, QQ( monoid[ getSymbol "i" ] ) );
  algorithm :=
    if o.Algorithm === "Complete" then 1
    else if o.Algorithm === "Simplified" or F === { } then 0
    else -1;
  resultsCount := 
    if o.ResultsCount === "One" or o.ResultsCount === 1 then 1 
    else if o.ResultsCount === "AllMaxBettiSum" then 2 
    else if o.ResultsCount === "All" then 3
    else 0;
  ---End Parse inputs
  
  ---Sanitize Inputs
  ( G, F, g, f ) = sanitizeInputs( G, F, g, f, p, n );
  ---End Sanitize Inputs
  
  ---Automatically select algorithm
  if algorithm === -1 then (
    GFgfsimplified := try sanitizeInputs( G, { }, g, f, p, n ) else null;
    algorithm = if ( G, F, g, f ) ===  GFgfsimplified then 0 else 1;
  );
  algorithmToRun := {
    { SimplifiedNone, SimplifiedSome, SimplifiedSome, SimplifiedAll },
    { CompleteNone, CompleteSome, CompleteSome, CompleteAll }
  }#algorithm#resultsCount;
  unravelToRun := {
    { null, UnravelSimplifiedOne, UnravelSimplifiedHFs, UnravelSimplifiedHFs },
    { null, UnravelCompleteOne, UnravelCompleteHFs, UnravelCompleteHFs }
  }#algorithm#resultsCount;
  ---End Auto select

  
  ---Run Algorithm
  ( V, lowerBound ) := BuildVLowerBound( g, f, n );
  result := algorithmToRun( G, F, g, f, V, lowerBound );
  ---End Run Algorithm
  
  ---Parse Results
  hilbertFunctions :=
    if resultsCount === 0 then null 
    else unravelToRun ( result#1, G, g, lowerBound );
  bettiUpperBound := null;
  maximumBettiSum := null;
  maximalBettiNumbers := null;
  if resultsCount === 0 then (
    bettiUpperBound = drop( result, -1 );
    maximumBettiSum = last result;
  ) else if resultsCount === 3 then (
    maximalBettiNumbers = result#0 / ( b -> drop( b, -1 ) );
    bettiUpperBound = max \ transpose maximalBettiNumbers;
    maximumBettiSum = max( last \ result#0 );
  ) else (
    bettiUpperBound = drop( result#0, -1 );
    maximumBettiSum = last result#0;
  );
  realizable := maximumBettiSum === sum bettiUpperBound;
  bettig := sum lexBettiArray( g, n );
  bettiUpperBound = bettiUpperBound + bettig;
  maximumBettiSum = maximumBettiSum + sum bettig;
  if maximalBettiNumbers =!= null then
    maximalBettiNumbers = maximalBettiNumbers / plus_bettig;
  if hilbertFunctions =!= null then
    hilbertFunctions = hilbertFunctions / accumulate_( plus, 0 );
  ---End parse results
  
  ---Format results
  new MaxBetti from hashTable{
    isRealizable => realizable,
    BettiUpperBound => bettiUpperBound,
    MaximumBettiSum => maximumBettiSum,
    if maximalBettiNumbers =!= null then
      MaximalBettiNumbers => VerticalList maximalBettiNumbers,
    if hilbertFunctions =!= null then
      HilbertFunctions => VerticalList hilbertFunctions
  }
  ---End format results
);

--------------------------------------------------------------------------------
--- end main Method
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of documentation -------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

beginDocumentation( )

doc ///
  Key
    maxBettiNumbers
    (maxBettiNumbers, ZZ)
  Headline
    Upper bounds for total Betti numbers in a family of saturated ideals.
  Usage
    maxBettiNumbers (N,
      HilbertPolynomial => p,
      HilbertFunctionLowerBound => G,
      HilbertFunctionUpperBound => F,
      HilbertDifferenceLowerBound => g,
      HilbertDifferenceUpperBound => f)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    HilbertPolynomial=>RingElement
      the Hilbert polynomial, @TT"p"@, of the ideals in the family.
      See @TO [maxBettiNumbers, HilbertPolynomial]@.
    HilbertFunctionLowerBound=>List
      the lower bound for the Hilbert function, @TT"G"@, of the ideals in the
      family. See @TO [maxBettiNumbers, HilbertFunctionLowerBound]@.
    HilbertFunctionUpperBound=>List
      the upper bound for the Hilbert function, @TT"F"@, of the ideals in the
      family. See @TO [maxBettiNumbers, HilbertFunctionUpperBound]@.
    HilbertDifferenceLowerBound=>List
      the lower bound for the difference Hilbert function, @TT"g"@, of the
      ideals in the family.
      See @TO [maxBettiNumbers, HilbertDifferenceLowerBound]@.
    HilbertDifferenceUpperBound=>List
      the upper bound for the difference Hilbert function, @TT"f"@, of the
      ideals in the family.
      See @TO [maxBettiNumbers, HilbertDifferenceUpperBound]@.
    ResultsCount=>String
      how many Hilbert functions the result should include.
      See @TO [maxBettiNumbers, ResultsCount]@.
    Algorithm=>String
      the algorithm to use. See @TO [maxBettiNumbers, Algorithm]@.
  Outputs
    :
      an object with the upper bound and additional information.
  Description
    Text
      Consider a polynomial ring, $S$, in @TT"N"@ variables.
      Consider the family of saturated ideals, $I\subset S$, satisfying the
      following constraints. (Note: $h_{S/I}$ will denote the hilbert function
      of $S/I$, and $\Delta$ will denote the difference operator. (i.e.
      $\Delta h_{S/I}(d)=h_{S/I}(d)-h_{S/I}(d-1)$.)
      
      The functions $G$, $F$, $g$, $f$, and $p$ are arguments to the method.
      In the case where a value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint). Note: if $p$ is not specified
      $F$ and $G$ must be equal for large degrees.
      
      @UL{TEX"$G(d)\\leq h_{S/I}(d)\\leq F(d)$ for all $d$",
      TEX"$g(d)\\leq\\Delta h_{S/I}(d)\\leq f(d)$ for all $d$",
      TEX"$h_{S/I}(d)=p(d)$ for large $d$"}@
      
      @TT"maxBettiNumbers"@ returns the upper bound for the total Betti numbers
      of the ideals along with other information.
      A complete description of the output can be found under @TO MaxBetti@.
      
      Almost lexsegment ideals have the largest total Betti numbers out of all
      saturated ideals with a given Hilbert function. The function
      @TO almostLexIdeal@ is useful to obtain the ideals with maximal Betti
      numbers.
      
      The following is an example in $6$ variables where we fix the Hilbert
      polynomial to be $2d+10$, and look at the Betti tables of the ideals that
      realize the maximum total Betti numbers.
    Example
      QQ[d];
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        ResultsCount => "All")
      almostLexBetti_6 \ toList result.HilbertFunctions
    Text
      Restricting to ideals with at least one linear element gives us a
      different result.
    Example
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        HilbertFunctionUpperBound => {,5}, ResultsCount => "All")
      I = almostLexIdeal(QQ[x_1..x_6], first result.HilbertFunctions)
      betti res I
      hilbertPolynomial(I, Projective=>false)
      (0..6)/(d->hilbertFunction(d,I))
    Text
      In most situations, there is an ideal in the family that realizes this
      upper bound. However, there are situations where this is not true.
      This method indicates this with the key @TO isRealizable@. However, there
      is always an ideal that gives the maximum sum of the total Betti numbers.
      This maximum is given by the key @TO MaximumBettiSum@. The following
      example in $5$ variables shows this phenomenon. In it we fix the Hilbert
      polynomial to be $5d+11$, and we restrict $\Delta h_{S/I}(d)\geq 8$ for
      $d=3,4$.
    Example
      result = maxBettiNumbers(5, HilbertDifferenceLowerBound => {,,,8,8},
        HilbertPolynomial => 5*d+11);
      sum result.BettiUpperBound
      result.MaximumBettiSum  -- This doesn't match the previous sum.
      result.isRealizable     -- As a result, this is false.
    Text
      @HEADER2"Default constraints"@
      
      Because the inputs can be incomplete or absent, @TT"maxBettiNumbers"@
      assumes the following default values for the missing information.
      
      @UL{TEX"Lower bounds have a default value of $0$.",
      TEX"Upper bounds have a default value of infinity.",
      TEX"Truncated hilbert functions are assumed to continue, but the
      associated hilbert polynomial is assumed to match the hilbert function at
      last degree where it is specified.",
      TEX"If no Hilbert polynomial is specified, the Hilbert polynomial is
      assumed to be the Hilbert polynomial of $G$ and $F$."}@
      
      More details can be found under
      @TO [maxBettiNumbers, HilbertFunctionLowerBound]@. In the case where the
      inputs result in constraints that are impossible or invalid, an error is
      thrown.
      
      @HEADER2"Output Results"@
      
      In addition to upper bounds for the total Betti numbers, this function can
      optionally output Hilbert functions with maximal total Betti numbers. This
      is specified with the optional argument @TT"ResultsCount"@. More details
      can be found under @TO [maxBettiNumbers, ResultsCount]@.
      
      @HEADER2"Different Algorithms"@
      
      There are two different algorithms that get used: the Simplified
      algorithm, which is faster, but is not guarenteed to give sharp bounds,
      and the Complete algorithm, which always gives sharp bounds. The optional
      argument @TT"Algorithm"@ allows the selection of the algorithm. A more
      complete description can be found under @TO [maxBettiNumbers,Algorithm]@.
      
      @HEADER2"More Examples"@
      
      We will consider an example where $S$ is the polynomial ring in $5$
      variables.
      This example has only maximal total Betti Numbers, and not maximum total
      Betti numbers.
      Also, the Simplified and Complete algorithms give different results.
      Both of these are somewhat unusual, but give an illuminating example.
      We will choose the following constraints:
      $$h_{S/I}(6)=41\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      h_{S/I}(d)=49\ for\ large\ d$$
      $$8\leq \Delta h_{S/I}(3)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      8\leq \Delta h_{S/I}(4)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      5\leq \Delta h_{S/I}(5)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      5\leq \Delta h_{S/I}(6)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ $$
      Since we will be using these constraints in several examples, we will
      first define a few variables to reduce repetition.
    Example
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
    Text
      We find that $(23, 54, 47, 14)$ is the upper bound for the total Betti
      numbers of all saturated ideals with these constraints.
      Additionally, the maximum for the sum of the Betti numbers is $137$.
      Note that because $23 + 54 + 47 + 14 = 138$, there is no single ideal with
      total Betti numbers of $(23, 54, 47, 14)$.
    Example
      maxBettiNumbers(N,p,g,G,F)
    Text
      If we want the Hilbert function of an ideal with maximal total Betti
      numbers, we can pass @TT"ResultsCount=>\"One\""@ as an option.
      Note, this gives an ideal with the maximum for the sum of the Betti
      numbers.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
    Text
      If we want the Hilbert function of all ideals that have the maximum sum of
      the Betti numbers, we can pass @TT"ResultsCount=>\"AllMaxBettiSum\""@ as
      an option.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
    Text
      Finally, if we want the Hilbert function of all ideals that have maximal
      total Betti numbers, we can pass @TT"ResultsCount=>\"All\""@ as an option.
      In addition to returning the upper bound and Hilbert functions, the
      maximal total Betti numbers of $(23, 54, 45, 13)$ and $(22, 54, 47, 14)$
      are also returned.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
    Text
      Because we are setting an upper bound of $h_{S/I}(6) \leq 41$, the
      Simplified algorithm will not give sharp bounds. As a result, the Complete
      algorithm is automatically chosen instead. However, we can force the use
      of a different one. In this case, if we specify
      @TT"Algorithm=>\"Simplified\""@, we get an upper bound that is,
      necessarily, larger. Additionally, we are given a Hilbert function that
      appears to be valid, but is not the Hilbert function of any saturated
      ideal.
    Example
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
    Text
      We can compare the speed of the two algorithms with an example of fixing
      the Hilbert polynomial to be $3d^2-6d+175$ in a ring with $6$ variables.
      Because there is no upper bound for $h_{S/I}$, both algorithms give valid
      results, and smallest possible upper bounds.
    CannedExample
      i23 : p = HilbertPolynomial => 3*d^2-6*d+175;

      i24 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Simplified", ResultsCount=>"None")

      o24 = 5.908441668

      o24 : RR (of precision 53)
      
      i25 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Simplified", ResultsCount=>"All")

      o25 = 7.467646269

      o25 : RR (of precision 53)
      
      i26 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Complete", ResultsCount=>"None")

      o26 = 21.462211888

      o26 : RR (of precision 53)
      
      i27 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Complete", ResultsCount=>"All")

      o27 = 28.756055662

      o27 : RR (of precision 53)
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
  SeeAlso
    MaxBetti  
///
doc ///
  Key
    ResultsCount
///
doc ///
  Key
    HilbertPolynomial
///
doc ///
  Key
    HilbertFunctionLowerBound
///
doc ///
  Key
    HilbertDifferenceLowerBound
///
doc ///
  Key
    HilbertFunctionUpperBound
///
doc ///
  Key
    HilbertDifferenceUpperBound
///
doc ///
  Key
    AsTally
///
doc ///
  Key
    [maxBettiNumbers, HilbertFunctionLowerBound]
    [maxBettiNumbers, HilbertFunctionUpperBound]
    [maxBettiNumbers, HilbertDifferenceLowerBound]
    [maxBettiNumbers, HilbertDifferenceUpperBound]
  Description
    Text
      The options @TT"HilbertFunctionLowerBound"@,
      @TT"HilbertFunctionUpperBound"@,
      @TT"HilbertFunctionLowerBound"@,
      @TT"HilbertDifferenceLowerBound"@, and
      @TO HilbertPolynomial@ are arguments to 
      @TO maxBettiNumbers@.
      Each of these options, other than @TO HilbertPolynomial@, are a list of
      integers starting at degree 0.
      In the case where a value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint).
      Note: if @TO HilbertPolynomial@ is not specified,
      @TT"HilbertFunctionLowerBound"@ and @TT"HilbertFunctionUpperBound"@
       must be equal for large degrees.

      In the case where no lower
      bound is desired at a specified degree, @TT"0"@, @TT"null"@, or nothing
      can be put instead. For instance, to specify only a lower bound of @TT"4"@
      in degree @TT"3"@ on the Hilbert difference function, the option
      @TT"HilbertDifferenceLowerBound=>{,,,4}"@ can be used.
      
      Similarly, in the case where no upper bound is desired at a specified
      degree, @TT"infinity"@, @TT"null"@, or nothing can be put instead.
      For instance, to specify only a upper bound of @TT"4"@
      in degree @TT"3"@ on the Hilbert function, the option
      @TT"HilbertFunctionUpperBound=>{,,,4}"@ can be used.
      
      There are some instances when these options, along with
      @TO HilbertPolynomial@ conflict. In this case, an error is raised.      
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertPolynomial]
///
doc ///
  Key
    [maxBettiNumbers, HilbertPolynomial]
  Description
    Text
      The functions @TO HilbertFunctionLowerBound@,
      @TO HilbertFunctionUpperBound@,
      @TO HilbertFunctionLowerBound@,
      @TO HilbertDifferenceLowerBound@, and
      @TT"HilbertPolynomial"@ are arguments to 
      @TO maxBettiNumbers@.
      In the case where a value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint).
      Note: if @TT"HilbertPolynomial"@ is not specified,
      @TO HilbertFunctionLowerBound@ and  @TO HilbertFunctionUpperBound@
       must be equal for large degrees.
       
      This option can be either a @TO RingElement@ or an integer. In the case
      where this conflicts with the bounds on
      the Hilbert functions, an error is raised.
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertFunctionLowerBound]
///
doc ///
  Key
    lexBetti
    (lexBetti, ZZ, List)
  Headline
    Graded Betti numbers of a lexsegment ideal.
  Usage
    lexBetti (N, h)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    h:List
      the Hilbert function of the lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function,
      there is a unique lexsegment ideal. Furthermore, this ideal has graded
      Betti numbers that are at least as large as those of any other ideal with
      that hilbert function.
      
      The Hilbert function of a lexsegment ideal is determined by the values in
      the degrees that are at and below the largest degree of any generator. As
      a result, it makes sense to specify the Hilbert function through the
      largest degree of a generator and then truncate the rest of the function.
    
      This function returns the graded Betti numbers of a lexsegment ideal with
      the given, tuncated, Hilbert function.
    Example
      lexBetti (4, {1,2,3,3,3,3})
      lexBetti (4, {1,2,3,3,3,3,0})
      lexBetti (5, {1,5,15,35})
  SeeAlso
    lexsegmentIdeal
    almostLexBetti
///
doc ///
  Key
    almostLexBetti
    (almostLexBetti, ZZ, List)
  Headline
    Graded Betti numbers of an almost lexsegment ideal.
  Usage
    almostLexBetti (N, h)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    h:List
      the Hilbert function of the almost lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function
      of a saturated ideal there is a unique almost lexsegment ideal. An almost
      lexsegment ideal is an ideal that is lexsegment in @TT"N-1"@ variables.
      Furthermore, this almost lexsegment ideal is saturated and has graded
      Betti numbers that are at least as large as those of any other saturated
      ideal with that hilbert function.
    
      The Hilbert function of a lexsegment ideal is determined by the values in
      the degrees that are at and below the largest degree of any generator. As
      a result, it makes sense to specify the Hilbert function through the
      largest degree of a generator and then truncate the rest of the function.
      This also applies to almost lexsegment ideals since they are simply
      lexsegment ideals in a smaller ring.
    
      This function returns the graded Betti numbers of an almost lexsegment
      ideal with the given Hilbert function.
    Example
      lexBetti (4, {1,2,3,3,3,3})
      almostLexBetti (5, {1,3,6,9,12,15})
      lexBetti (4, {1,2,3,3,3,3,0})
      almostLexBetti (5, {1,3,6,9,12,15,15})
      lexBetti (5, {1,5,15,35})
      almostLexBetti (6, {1,6,21,56})
  SeeAlso
    almostLexIdeal
    lexBetti
///
doc ///
  Key
    [lexBetti, AsTally]
    [almostLexBetti, AsTally]
  Description
    Text
      This is an option that can be passed to either @TO lexBetti@ or
      @TO almostLexBetti@. If the value of the option is @TT"true"@ a
      @TO BettiTally@ object will be returned. If it is false, a @TO List@ of
      lists will be returned. This latter option is useful if one wishes to
      obtain the total Betti numbers instead of the graded Betti numbers. This
      can easily be done using by applying @TT"sum"@ to the output with
      @TT"AsTally=>false"@.
    Example
      lexBetti (4, {1,2,3,3,3,3}, AsTally => true)
      lexBetti (4, {1,2,3,3,3,3}, AsTally => false)
      sum oo
  SeeAlso
    lexBetti
    almostLexBetti
///
doc ///
  Key
    lexsegmentIdeal
    (lexsegmentIdeal, PolynomialRing, List)
  Headline
    Create a lexsegment ideal.
  Usage
    lexsegmentIdeal (S, h)
  Inputs
    S:PolynomialRing
      the ambient polynomial ring.
    h:List
      the Hilbert function of the lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function,
      there is a unique lexsegment ideal. Furthermore, this ideal has graded
      Betti numbers that are at least as large as those of any other ideal with
      that hilbert function.
    
      The Hilbert function of a lexsegment ideal is determined by the values in
      the degrees that are at and below the largest degree of any generator. As
      a result, it makes sense to specify the Hilbert function through the
      largest degree of a generator and then truncate the rest of the function.
    
      This function returns the lexsegment ideal with the given Hilbert
      function.
      
      Note: this method is significantly faster than the similar @TT"lexIdeal"@
      from the package @TT"LexIdeals"@.
    Example
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3})
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3,0}) --Artinian
      lexsegmentIdeal (QQ[x_1..x_5], {1,5,15,35})
  SeeAlso
    lexBetti
    almostLexIdeal
///
doc ///
  Key
    almostLexIdeal
    (almostLexIdeal, PolynomialRing, List)
  Headline
    Create an almost lexsegment ideal.
  Usage
    almostLexIdeal (S, h)
  Inputs
    S:PolynomialRing
      the ambient polynomial ring.
    h:List
      the Hilbert function of the almost lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function
      of a saturated ideal there is a unique almost lexsegment ideal. An almost
      lexsegment ideal is an ideal that is lexsegment in @TT"N-1"@ variables.
      Furthermore, this almost lexsegment ideal is saturated and has graded
      Betti numbers that are at least as large as those of any other saturated
      ideal with that hilbert function.
    
      The Hilbert function of a lexsegment ideal is determined by the values in
      the degrees that are at and below the largest degree of any generator. As
      a result, it makes sense to specify the Hilbert function through the
      largest degree of a generator and then truncate the rest of the function.
      This also applies to almost lexsegment ideals since they are simply
      lexsegment ideals in a smaller ring.
    
      This function returns the almost lexsegment ideal with the given Hilbert
      function.
    Example
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3})
      almostLexIdeal (QQ[x_1..x_5], {1,3,6,9,12,15})
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3,0})
      almostLexIdeal (QQ[x_1..x_5], {1,3,6,9,12,15,15})
      lexsegmentIdeal (QQ[x_1..x_5], {1,5,15,35})
      almostLexIdeal (QQ[x_1..x_6], {1,6,21,56})
  SeeAlso
    almostLexBetti
    lexsegmentIdeal
///
doc ///
  Key
    [maxBettiNumbers, Algorithm]
  Description
    Text
      There are two algorithms that can be used to find the upper bounds given
      in @TO maxBettiNumbers@.
      
      The ``Simplified'' algorithm simply finds the maximum of while ignoring
      the ideal structure of an ideal. In other words, it searches all possible
      numeric functions instead of just the Hilbert functions. This has two
      consequences. First, it is significantly faster because it allows for a
      simplification of the algorithm. Second, it does not always give the
      smallest upper bounds. However, there is one instance where it is
      guarenteed to give the smallest upper bounds: when no upper bound for the
      Hilbert function is specified.
      
      The ``Complete'' algorithm does not make this simplification, and as a
      result, is slower but give the smallest upper bounds in every situation.
      
      Ideally, we would like to use the ``Simplified'' algorithm when it gives
      the smallest upper bounds, and use the ``Complete'' algorithm otherwise.
      By default, the algorithm is selected that guarentees the smallest upper
      bounds. However, this can be overridden by passing the @TT"Algorithm"@
      option to @TO maxBettiNumbers@. The possible values are
      
      @UL{{TT"\"Automatic\"", TEX" - this is the default and chooses the ",
      TEX"algorithm to use based on the other inputs. Note: This will always ",
      TEX"give the smallest upper bounds as well as valid Hilbert functions."},
      {TT"\"Simplified\"",TEX" - forces use of the ``Simplified'' algorithm. ",
      TEX"Note: if this option is passed, the values in ``HilbertFunctions'' ",
      TEX"may not be actual Hilbert functions."},
      {TT"\"Complete\"",TEX" - forces use of the ``Complete'' algorithm. ",
      TEX"Note: This will always give the smallest upper bounds as well as ",
      TEX"valid Hilbert functions."}}@
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
  SeeAlso
    maxBettiNumbers
///
doc ///
  Key
    [maxBettiNumbers, ResultsCount]
  Description
    Text
      The method @TO maxBettiNumbers@ finds the upper bounds for the total Betti
      numbers. In certain instances, there are ideals that realize these upper
      bounds and have maximum possible total Betti numbers. In this case, these
      ideals also must have the maximum possible sum of the total Betti numbers.
      However, there are some instances where there are no ideals that realize
      the upper bounds. In this case, there are only ideals that realize maximal
      total Betti numbers. Some of these also must have the maximum possible sum
      of the total Betti numbers, while others do not.
      
      @TT"ResultsCount"@ is an option that can be passed to
      @TO maxBettiNumbers@. It determines how many, and what type of ideals are
      collected. The Hilbert function of these ideals is returned in a
      @TO MaxBetti@ object under key @TO HilbertFunctions@.
      
      There are four possible values, with the default being "None".
            
      
      @UL{{TT"\"None\"",TEX" or ",TT"0",
      TEX" - Does not return any Hilbert functions."},
      {TT"\"One\"",TEX" or ",TT"1",
      TEX" - Returns the Hilbert function of an ideal which has the maximum ",
      TEX"possible sum of the total Betti numbers."},
      {TT"\"AllMaxBettiSum\"",TEX" - Returns the Hilbert functions of all ",
      "ideals that have the maximum possible sum of the total Betti numbers."},
      {TT"\"All\"",TEX" - Returns the Hilbert functions of all ideals that ",
      "have maximal total Betti numbers."}}@
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaxBetti
  Description
    Text
      This is the type that is returned by @TO maxBettiNumbers@ it is a
      @TO HashTable@ with the following keys.
      
      @UL{{TO BettiUpperBound,TEX" - upper bound for the total Betti numbers."},
      {TO HilbertFunctions,
      TEX" - a list of  Hilbert functions with maximal total Betti numbers. ",
      TEX"See ",TO[maxBettiNumbers,ResultsCount],TEX" for more details."},
      {TO isRealizable,TEX" - if there is an ideal with the upper bound as its",
      TEX" total Betti numbers."},
      {TO MaximalBettiNumbers,TEX" - the maximal total Betti numbers."},
      {TO MaximumBettiSum,TEX" - maximum sum of the total Betti numbers."}}@
  SeeAlso
    maxBettiNumbers
///
doc ///
  Key
    BettiUpperBound
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO List@.
      The upper bound for the total Betti numbers.
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaximumBettiSum
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO ZZ@.
      The maximum value of the sum of the total Betti numbers.
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    HilbertFunctions
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO VerticalList@.
      A list of truncated Hilbert functions returned by @TO maxBettiNumbers@.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    isRealizable
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO Boolean@.
      Is @TT"true"@ if there is an ideal in the family that has total Betti
      numbers that match @TO BettiUpperBound@ otherwise is @TT"false"@.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaximalBettiNumbers
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO VerticalList@.
      Each item in the list is a set of total Betti numbers that are maximal.
      In other words, no ideal has total Betti numbers that are simultaneously
      greater than or equal, and there is an ideal with these total Betti
      numbers.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaxBettiNumbers
  Headline
    Methods to find maximum Betti numbers given bounds on the Hilbert function.
  Description
    Text
      The method @TO maxBettiNumbers@ is the headliner in this package. It
      returns upper bounds for the total Betti numbers in a family that has
      bounds on the Hilbert function and/or the Hilbert difference function.
    
      The method @TO maxBettiNumbers@ can optionally return special Hilbert
      functions. The methods @TO almostLexBetti@ and @TO almostLexIdeal@ are
      helpful in working with these Hilbert function. The functions
      @TO lexBetti@ and @TO lexsegmentIdeal@ use the same code, and are exported
      from the package in hopes that they are useful. These functions are
      written with a concern for speed and efficiency.
///
--- replace the following with "doc ///" to run this long example
///
  Key
    "Paper Example"
  Description
    Example
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
      maxBettiNumbers(N,p,g,G,F)
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
      almostLexBetti(N, last o9.HilbertFunctions)
      almostLexIdeal(QQ[x_1..x_N], last o9.HilbertFunctions)
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
      N = 6;
      QQ[i]; p = HilbertPolynomial => 3*i^2-6*i+175;
      time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"None");
      time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"All");
      time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"None");
      time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"All");
      loadPackage "StronglyStableIdeals"
      benchmark("maxBettiNumbers(5, HilbertPolynomial => 25)")
      benchmark("stronglyStableIdeals(25, 5)")
///
--- replace the following with "doc ///" to run this long example
///
  Key
    "Main Example"
  Description
    Example
      QQ[d];
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        ResultsCount => "All")
      almostLexBetti_6 \ toList result.HilbertFunctions
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        HilbertFunctionUpperBound => {,5}, ResultsCount => "All")
      I = almostLexIdeal(QQ[x_1..x_6], first result.HilbertFunctions)
      betti res I
      hilbertPolynomial(I, Projective=>false)
      (0..6)/(d->hilbertFunction(d,I))
      result = maxBettiNumbers(5, HilbertDifferenceLowerBound => {,,,8,8},
        HilbertPolynomial => 5*d+11);
      sum result.BettiUpperBound
      result.MaximumBettiSum  -- This doesn't match the previous sum.
      result.isRealizable     -- As a result, this is false.
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
      maxBettiNumbers(N,p,g,G,F)
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
      p = HilbertPolynomial => 3*d^2-6*d+175;
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Simplified", ResultsCount=>"None")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Simplified", ResultsCount=>"All")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Complete", ResultsCount=>"None")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Complete", ResultsCount=>"All")
///

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of documentation -------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- Beginning of tests ---------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

TEST /// --Test a preknown result.
N = 4;
p = 4;
mbn = maxBettiNumbers( N, HilbertPolynomial => p );
assert( mbn.BettiUpperBound === { 6, 8, 3 } );
///

TEST /// --Test that all 8 versions of the algorithm produce the same result.
testMatching = ( N, p ) -> (
  mbn = maxBettiNumbers( N, HilbertPolynomial => p );
  mbn1 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "None" );
  mbn2 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "One" );
  mbn3 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "AllMaxBettiSum" );
  mbn4 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "All" );
  mbn5 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "None" );
  mbn6 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "One" );
  mbn7 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "AllMaxBettiSum" );
  mbn8 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "All" );
  assert( mbn.BettiUpperBound === mbn1.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn2.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn3.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn4.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn5.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn6.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn7.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn8.BettiUpperBound );
  assert( sort mbn2.HilbertFunctions === sort mbn6.HilbertFunctions );
  assert( sort mbn3.HilbertFunctions === sort mbn7.HilbertFunctions );
  assert( sort mbn4.HilbertFunctions === sort mbn8.HilbertFunctions );
);
for i from 0 to 10 do testMatching( 4, i );
for i from 2 to 10 do testMatching( i, 4 );
///

TEST /// --Test against brute force method
loadPackage "StronglyStableIdeals";
QQ[d]; p = 2*d+10; N = 5;
time ssI = stronglyStableIdeals( p, N );
getTotalBetti = ( N, I ) -> (
  t := new Tally from ( applyKeys( betti res I, first, plus ) );
  for i from 1 to N - 1 list t_i
);
time maxbetti = max \ transpose ( ssI / getTotalBetti_N );
time mbn = maxBettiNumbers( N, HilbertPolynomial => p );
assert( mbn.BettiUpperBound === maxbetti );
///

TEST /// --Test against a preknown result.
N = 5;
g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
G = HilbertFunctionLowerBound => {,,,,,,41};
F = HilbertFunctionUpperBound => {,,,,,,41};
p = HilbertPolynomial => 49;
mbn1 = maxBettiNumbers( N,p,g,G,F );
assert( mbn1.BettiUpperBound === {23,54,47,14} );
assert( mbn1.isRealizable === false );
assert( mbn1.MaximumBettiSum === 137 );
mbn2 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "One" );
assert( #( mbn2.HilbertFunctions ) === 1 );
assert( mbn1.BettiUpperBound === mbn2.BettiUpperBound );
assert( mbn1.isRealizable === mbn2.isRealizable );
assert( mbn1.MaximumBettiSum === mbn2.MaximumBettiSum );
polys = mbn2.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
mbn3 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "AllMaxBettiSum" );
assert( #( mbn3.HilbertFunctions ) === 18 );
assert( mbn1.BettiUpperBound === mbn3.BettiUpperBound );
assert( mbn1.isRealizable === mbn3.isRealizable );
assert( mbn1.MaximumBettiSum === mbn3.MaximumBettiSum );
polys = mbn3.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
mbn4 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "All" );
assert( #( mbn4.HilbertFunctions ) === 36 );
assert( #( mbn4.MaximalBettiNumbers ) === 2 );
assert( mbn1.BettiUpperBound === mbn4.BettiUpperBound );
assert( mbn1.isRealizable === mbn4.isRealizable );
assert( mbn1.MaximumBettiSum === mbn4.MaximumBettiSum );
polys = mbn4.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
///

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--- End of tests ---------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


end
