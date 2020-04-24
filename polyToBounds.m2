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

polyToBounds = (p, d) -> (
  i := (ring p)_0;
  pd := sub(sub(p,i=>d),ZZ);
  pm := sub(sub(p,i=>d-1),ZZ);
  (pd-pm,pd)
);

polyCleanUpper = (F, f, p, d) -> (
  if p =!= null then (
    (qd, pd) := polyToBounds(p, d);
    F = padList(d + 1, F);
    f = padList(d + 1, f);
    if F_d === null or F_d > pd then F = replace(d, pd, F);
    if f_d === null or f_d > qd then f = replace(d, qd, f);
  );
  (F, f)
);
polyCleanLower = (G, g, p, d) -> (
  if p =!= null then (
    (qd, pd) := polyToBounds(p, d);
    G = padList(d + 1, G);
    g = padList(d + 1, g);
    if G_d === null or G_d < pd then G = replace(d, pd, G);
    if g_d === null or g_d < qd then g = replace(d, qd, g);
  );
  (G, g)
);
