--------------------------------------------------------------------------------
--- functions to sanitize the input bounds
--------------------------------------------------------------------------------

load "sanitizeBounds.m2"

--------------------------------------------------------------------------------
--- end sanitize bounds
--------------------------------------------------------------------------------

--- function for padding lists with null
padList = (l, f) -> join( f, toList( l - #f : null ) );

--------------------------------------------------------------------------------
--- functions to sanitize the polynomial input
--------------------------------------------------------------------------------

load "sanitizePolynomial.m2"

--------------------------------------------------------------------------------
--- end sanitize polynomial
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- functions to optimize the bounds
--------------------------------------------------------------------------------

load "optimizeBounds.m2"

--------------------------------------------------------------------------------
--- end optimize bounds
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- main function to sanitize (and optimize) the inputs
--------------------------------------------------------------------------------

sanitizeInputs = (G, F, g, f, p, n) -> (
  --- Sanitize the polynomial input by converting it to bounds
  D := if p === null then 0 else minPolyBoundDegree(p);
  D = max(D, #G-1, #F-1, #g-1, #f-1);
  (G, F, g, f) = cleanPolynomial(G, F, g, f, p, D);
  --- End Sanitize polynomial
  
  --- Sanitize the input length so that they include at least degree 1
  l := max(#G, #F, #g, #f, 2);
  (G, F, g, f) = (G, F, g, f) / padList_l;
  --- End Sanitize input length
  
  --- Sanitize the degree 1 upper difference bound
  if ( f#1 === null or f#1 > n + 1 ) then (
    f = replace(1, n + 1, f)
  );
  --- End Sanitize degree 1
  
  --- Sanitize the inputs so that they are Hilbert functions
  F = cleanUpperBound F;
  f = cleanUpperBound f;
  G = cleanLowerBound G;
  g = cleanLowerBound g;
  --- End sanitize functions
  
  --- Check validity of inputs
  valid := min(min(F - G), min(f - g)) >= 0;
  --- End check validity
  
  --- Optimize the bounds. This drastically improves the run time.
  --- This is done by repeated application of the 4 optimization Functions.
  --- Once G,F,g,f no longer change, we stop and re-sanitize the values
  --- We repeat this process until G,F,g,f are stable.
  --- Throughout this process we check that it is always a possible scenario.
  prevGFgf := null;
  while valid and prevGFgf =!= (G, F, g, f) do (
    while valid and prevGFgf =!= (G, F, g, f) do (
      prevGFgf = (G, F, g, f);
      f = optimizeUpperBound(G, F, f);
      g = optimizeLowerBound(G, F, g);
      F = optimizeAccumulatedUpperBound(F, g, f);
      G = optimizeAccumulatedLowerBound(G, g, f);
      valid = min(min(F - G), min(f - g)) >= 0;
    );
    if valid then (
      F = cleanUpperBound F;
      f = cleanUpperBound f;
      G = cleanLowerBound G;
      g = cleanLowerBound g;
      valid = min(min(F - G), min(f - g)) >= 0;
    )
  );
  --- End Optimize bounds
  
  --- Throw an error if bounds don't make sense
  if not valid then (
    error concatenate (
      "The given inputs are invalid or give impossible constraints:\nG = ",
      toString G, "\nF = ", toString F, "\ng = ", toString g, "\nf = ",
      toString f);
  );
  if last G =!= last F then (
    error concatenate (
      "The given inputs don't specify constraints that eventually fix the ",
      "Hilbert function:\nG = ", toString G, "\nF = ", toString F, "\ng = ",
      toString g, "\nf = ", toString f);
  );
  --- End throw error
  
  (G, F, g, f)
);

--------------------------------------------------------------------------------
--- end main sanitize function
--------------------------------------------------------------------------------
