macaulayDown = (b,e) -> sum(binomial@@toSequence@@plus_{-1,-1}\macaulayRep(b,e));


padList = (l, f) -> f | toList(l-#f:null)
cleanUpperBound = f -> if #f == 0 then f else (
  b := 1;
  for e to #f - 1 list b = min(b, if f_e === null then infinity else f_e) do if b < infinity then b = if e == 0 and b > 0 then infinity else macaulayBound(b, e)
)
cleanLowerBound = f -> if #f == 0 then f else (
  b := 0;
  reverse for e in reverse(0..#f - 1) list b = max(b, if f_e === null then 0 else f_e) do if e > 0 then b = macaulayDown(b, e)
)

cleanAccumulatedUpperBound = (F, f) -> (
  p := 0;
  (for e to #F - 1 list p = min(F_e, p + f_e), f)
)
cleanAccumulatedLowerBound = (G, g) -> (
  p := 0;
  (for e to #G - 1 list p = max(G_e, p + g_e), g)
)


cleanBounds = (F, G, f, g, n) -> (
  l := max(#F, #G, #f, #g, 2);
  --if l < 2 then return (F, G, f, g, false);
  (F, G, f, g) = (F, G, f, g) / padList_l;
  f = replace(1, if f_1 == null then n+1 else min(f_1, n+1), f);
  (F, f) = cleanAccumulatedUpperBound((F, f) / cleanUpperBound);
  (G, g) = cleanAccumulatedLowerBound((G, g) / cleanLowerBound);
  (F, G, f, g, min(min(F - G), min(f - g)) >= 0)
)



optimizeLowerBound = (F, G, g) -> (
  ng := G - prepend(0, drop(F, -1));
  max\transpose{g, ng}
)
optimizeUpperBound = (F, G, f) -> (
  nf := F - prepend(0, drop(G, -1));
  min\transpose{f, nf}
)



optimizeAccumulatedLowerBound = (G, f) -> (
  p := 0;
  reverse for e in reverse(0..#G-1) list p = max(G_e, p) do p = p - f_e
)
optimizeAccumulatedUpperBound = (F, g) -> (
  p := infinity;
  reverse for e in reverse(0..#F-1) list p = min(F_e, p) do p = p - g_e
)



optimizeBounds = (F, G, f, g) -> (
  (pF, pG, pf, pg) := (null, null, null, null);
  while (pF, pG, pf, pg) =!= (F, G, f, g) do (
    (pF, pG, pf, pg) = (F, G, f, g);
    g = optimizeLowerBound(F, G, g);
    f = optimizeUpperBound(F, G, f);
    (F, f) = cleanAccumulatedUpperBound((F, f) / cleanUpperBound);
    (G, g) = cleanAccumulatedLowerBound((G, g) / cleanLowerBound);
    G = optimizeAccumulatedLowerBound(G, f);
    F = optimizeAccumulatedUpperBound(F, g);
    (F, f) = cleanAccumulatedUpperBound((F, f) / cleanUpperBound);
    (G, g) = cleanAccumulatedLowerBound((G, g) / cleanLowerBound);
  );
  (F, G, f, g, true)
)


cleanBounds ({},{},{1},{1,,,,,100},5)
