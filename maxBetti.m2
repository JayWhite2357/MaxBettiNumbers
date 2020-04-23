restart
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

  pipeIO = openInOut("!python3 ~/deckstack/deckstack.py " | toString(n + 2) | " -a");
  for pile in piles do (pipeIO << toString(pile) << endl);
  pipeIO << closeOut;
  result := lines get pipeIO;
  addV := sum lexBetti (g, n);
  addS := sum g;
  i := 0;
  while result#?i list (
    (rSize, rCount) := value result_i;
    rValue := addV + toList drop(value result_(i+1),1);
    rFuncs := for j from 1 to rCount list g + toList value result_(i+1+j);
    i = i + rCount + 2;
    (rSize + addS, rValue, rFuncs)
  )
)


getRawMaxBettis = {F=>{}, G=>{},f=>{},g=>{},NumberOut => symbol All} >> o -> n -> getMaxBettis(o.F,o.G,o.f,o.g,n);

n=10
R=QQ[x_0..x_n, MonomialOrder=>Lex]
S=QQ[x_0..x_(n+1), MonomialOrder=>Lex]
getRawMaxBettis(F=>{,,,,,201,318}, G=>{,,,,,201,318}, f=>{,,,,,80,117}, g=>{,,,,,80,117}, n)
getRawMaxBettis(F=>{,,,,,201}, G=>{,,,,,201}, f=>{,,,,,80}, g=>{,,,,,80}, n)



QQ[i]
p = (1/24)*i^4+(7/12)*i^3+(83/24)*i^2-(25/12)*i+26;

sub(p, i=>40)


loadPackage("MaxBettiNumbers", Reload=>true, FileName=>"~/github/ExtremalBettiNumbers/Good/MaxBettiNumbers.m2");
(B,II) = allMaxBettiNumbers(p,,,S)
t2 = tv#0
tv#1
(B, VerticalList (II/(I->hilbertFunct sub(I,R))))
((last BB)_1, VerticalList last last BB)
t1
t2

B

II
