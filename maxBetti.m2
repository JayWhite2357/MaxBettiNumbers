load "getPiles.m2"
load "optimizeBounds.m2"
load "lexBetti.m2"
load "polyToBounds.m2"

getMaxBettis = (F, G, f, g, n, ivar) -> (
  v := for i to n list (
    vec := for q to n list binomial(n+1,q+1)-binomial(i+1,q+1);
    prepend(sum vec, vec)--This is a checksum to verify that the result is a maximum as opposed to simply maximal.
  );
  valid := true;
  (F, G, f, g, valid) = cleanBounds(F, G, f, g, n);
  if not valid then return null;
  (F, G, f, g, valid) = optimizeBounds(F, G, f, g);
  if not valid then return null;
  piles := getPilesAndBounds(F, G, f, g, n, v);
  pipeIO := openInOut("!python3 ~/deckstack/deckstack.py " | toString(n + 2) | " -a");
  for pile in piles do (pipeIO << toString(pile) << endl);
  pipeIO << closeOut;
  result := lines get pipeIO;
  addV := sum lexBetti (g, n);
  d := #g - 1;
  addS := sum g;
  i := 0;
  while result#?i list (
    (rSize, rCount) := value result_i;
    rVector := toList value result_(i+1);
    rMax := sum(rVector) == 2 * first rVector;
    rValue := addV + drop(rVector,1);
    rFuncs := for j from 1 to rCount list g + toList value result_(i+1+j);
    i = i + rCount + 2;
    pd := rSize + addS;
    p := sum(macaulayRep(pd,d)/(l->binomial(l_0,sub(l_0-l_1,ZZ)))@@plus_{ivar-d,ivar-d});
    (p, rValue, rFuncs, rMax)
  )
)


getRawMaxBettis = {HilbertPolynomial=>null, UpperHilbertPolynomialBound=>null, LowerHilbertPolynomialBound=>null, UpperHilbertFunctionBound=>{}, LowerHilbertFunctionBound=>{}, UpperHilbertDifferenceBound=>{}, LowerHilbertDifferenceBound=>{}, NumberOut => symbol All} >> o -> n -> (
  F := o.UpperHilbertFunctionBound;
  G := o.LowerHilbertFunctionBound;
  f := o.UpperHilbertDifferenceBound;
  g := o.LowerHilbertDifferenceBound;
  p := o.HilbertPolynomial;
  pU := o.UpperHilbertPolynomialBound;
  pL := o.LowerHilbertPolynomialBound;
  d := 0;
  if p =!= null then d = max(d, minPolyBoundDegree(p));
  if pU =!= null then d = max(d, minPolyBoundDegree(pU));
  if pL =!= null then d = max(d, minPolyBoundDegree(pL));
  (F, f) = polyCleanUpper(F, f, p, d);
  (F, f) = polyCleanUpper(F, f, pU, d);
  (G, g) = polyCleanLower(G, g, p, d);
  (G, g) = polyCleanLower(G, g, pL, d);
  getMaxBettis(F,G,f,g,n,(QQ[i])_0)
);

end


restart
load "maxBetti.m2"

QQ[i]
pUpper=3*i^2-6*i+175;
pLower=3*i^2-6*i+150;

result = getRawMaxBettis(4, UpperHilbertPolynomialBound => pUpper, LowerHilbertPolynomialBound => pLower);

p

result/last

first L1

VerticalList ((reverse L2)/(B->drop(B,1)))
VerticalList L1

sum(macaulayRep(2,1)/(l->binomial(l_0,sub(l_0-l_1,ZZ)))@@plus_{i-1,i-1})

elapsedTime RMB = getRawMaxBettis(4);

RMB
polyToBounds(p-10)


binomial(27+i,5+i)
