loadPackage("LexIdeals", Reload=>false)
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
  l := max(#F, #G, #f, #g);
  if l < 2 then return (F, G, f, g, false);
  (F, G, f, g) = (F, G, f, g) / padList_l;
  f = replace(1, if f_1 == null then n else min(f_1, n), f);
  (F, f) = cleanAccumulatedUpperBound((F, f) / cleanUpperBound);
  (G, g) = cleanAccumulatedLowerBound((G, g) / cleanLowerBound);
  (F, G, f, g, min(min(F - G), min(f - g)) >= 0)
)

optimizeBounds = (F, G, f, g) -> (F, G, f, g, true)


cleanBounds ({},{},{1},{1,,,,,100},5)
