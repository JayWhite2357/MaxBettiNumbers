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
