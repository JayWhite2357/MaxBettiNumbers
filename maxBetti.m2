getMaxBettis = (F, G, f, g, n) -> (
  v = for i to n list (
    vec := for q to n list binomial(n+1,q+1)-binomial(i+1,q+1);
    prepend(sum vec, vec)
  );
  (F, G, f, g) = cleanBounds(F, G, f, g);
  (F, G, f, g) = optimizeBounds(F, G, f, g);
  piles = getPilesAndBounds(F, G, f, g, n, v);
  for pile in piles do ("pileout" << toString(pile) << endl);
  "pileout" << close;
  run "cat pileout | python3 ~/deckstack/deckstack.py " | toString(n + 2) | " > pileres";
  value get "pileres"
)
