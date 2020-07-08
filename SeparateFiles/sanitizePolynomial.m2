minPolyBoundDegree = p -> (
  n := first degree p;
  i := (ring p)_0;
  tmpp := p;
  lC := 0;
  while (n > 0) do (
    lC = leadCoefficient(tmpp);
    tmpp = tmpp-binomial(n+i,n+1)+binomial(n+i-n!*lC, n+1);
    n = first degree tmpp;
  );
  d := sub(tmpp,ZZ);
  if lC > d then print "Invalid Hilbert Polynomial! Trying to continue.";
  d
);

cleanPolynomial = (G, F, g, f, p, d) -> (
  if p =!= null then (
    i := (ring p)_0;
    pd := sub( sub( p, i => d ), ZZ);
    pm := sub( sub( p, i => d - 1 ), ZZ);
    deltapd := pd - pm;
    G = padList(d + 1, G);
    F = padList(d + 1, F);
    g = padList(d + 1, g);
    f = padList(d + 1, f);
    if G_d === null or G#d < pd then G = replace(d, pd, G);
    if F_d === null or F#d > pd then F = replace(d, pd, F);
    if g_d === null or g#d < deltapd then g = replace(d, deltapd, g);
    if f_d === null or f#d > deltapd then f = replace(d, deltapd, f);
  );
  (G, F, g, f)
);
