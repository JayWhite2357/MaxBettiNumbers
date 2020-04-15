load "getPiles.m2"
load "optimizeBounds.m2"
load "lexBetti.m2"

getMaxBettis = (F, G, f, g, n) -> (
  v = for i to n list (
    vec := for q to n list binomial(n+1,q+1)-binomial(i+1,q+1);
    prepend(sum vec, vec)
  );
  valid = true;
  (F, G, f, g, valid) = cleanBounds(F, G, f, g, n);
  if not valid then return null;
  (F, G, f, g, valid) = optimizeBounds(F, G, f, g);
  if not valid then return null;
  piles = getPilesAndBounds(F, G, f, g, n, v);
  for pile in piles do ("pileout" << toString(pile) << endl);
  "pileout" << close;
  print("cat pileout | python3 ~/deckstack/deckstack.py " | toString(n + 2) | " > pileres");
  run("cat pileout | python3 ~/deckstack/deckstack.py " | toString(n + 2) | " -a > pileres");
  result := lines get "pileres";
  addV = sum lexBetti (g, n);
  i = 0;
  while result#?i list (
    (rSize, rCount) := value result_i;
    rValue := addV + toList drop(value result_(i+1),1);
    rFuncs := for j from 1 to rCount list g + toList value result_(i+1+j);
    i = i + rCount + 2;
    (rSize + last G, rValue, rFuncs)
  )
)

r = getMaxBettis ({},{},{1},{1,,,,,100},5)
