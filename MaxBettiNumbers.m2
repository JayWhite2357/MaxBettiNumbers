-- -*- coding: utf-8 -*-
newPackage(
  "MaxBettiNumbers",
      Version => "0.1.1",
      Date => "April 24, 2020",
      Authors => {{Name => "Jay White",
      Email => "jay.white@uky.edu"}},
      Headline => "Methods to find Maximum Betti Numbers given bounds on the Hilbert Function",
      DebuggingMode => true,
      AuxiliaryFiles => true,
      PackageImports => {"LexIdeals"}
      )

export {"maxBettiNumbers",
"HilbertFunctionLowerBound", "HilbertPolynomialLowerBound", "HilbertDifferenceLowerBound",
"HilbertFunctionUpperBound", "HilbertPolynomialUpperBound", "HilbertDifferenceUpperBound",
"HilbertPolynomial",
"ResultsCount", "All", "Single", "None",
"lexBettiNumbers",
"AsTally"
}


maxBettiNumbers = method(TypicalValue => List, Options => true);
lexBettiNumbers = method(TypicalValue => List, Options => true);


load "./MaxBettiNumbers/getPiles.m2"
load "./MaxBettiNumbers/optimizeBounds.m2"
load "./MaxBettiNumbers/lexBetti.m2"
load "./MaxBettiNumbers/polyToBounds.m2"

getMaxBettis = (F, G, f, g, n, ivar, deckstackargs) -> (
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
  deckstackPath := searchPath "./MaxBettiNumbers/deckstack.py";
  deckstackFile := (first deckstackPath) | "./MaxBettiNumbers/deckstack.py";
  deckstackCmd := concatenate("!python",1,deckstackFile,1,toString(n+2),1,deckstackargs);
  pipeIO := openInOut(deckstackCmd);
  for pile in piles do (pipeIO << toString(pile) << endl);
  pipeIO << closeOut;
  result := lines get pipeIO;
  addV := sum lexBettiNumbers (n, g, AsTally => false);
  d := #g - 1;
  addS := sum g;
  appendg := macaulayBound(last g, d);
  i := 0;
  while result#?i list (
    (rSize, rCount) := value result_i;
    rVector := toList value result_(i+1);
    rMax := sum(rVector) == 2 * first rVector;
    rValue := addV + drop(rVector,1);
    rFuncs := for j from 1 to rCount list g + toList value result_(i+1+j);
    i = i + rCount + 2;
    pd := rSize + addS;
    p := sum(macaulayRep(last g, d) / (l ->
      binomial(
        l_0 + ivar - d + 1,
        sub(l_0 - l_1 + 1, ZZ))
      ));
    p = p + pd - sub(p+0*ivar, ivar=>d);
    (p, rValue, rFuncs / accumulate_(plus,0), rMax)
  )
);


maxBettiNumbers ZZ := {
  HilbertPolynomial=>null,
  HilbertPolynomialUpperBound=>null,
  HilbertPolynomialLowerBound=>null,
  HilbertFunctionUpperBound=>{},
  HilbertFunctionLowerBound=>{},
  HilbertDifferenceUpperBound=>{},
  HilbertDifferenceLowerBound=>{},
  ResultsCount => All
} >> o -> n -> (
  F := o.HilbertFunctionUpperBound;
  G := o.HilbertFunctionLowerBound;
  f := o.HilbertDifferenceUpperBound;
  g := o.HilbertDifferenceLowerBound;
  p := o.HilbertPolynomial;
  pU := o.HilbertPolynomialUpperBound;
  pL := o.HilbertPolynomialLowerBound;
  deckstackargs := "-a";
  if o.ResultsCount === Single then deckstackargs = "-s";
  if o.ResultsCount === None then deckstackargs = "-n";
  d := 0;
  iv := (QQ[local i])_0;
  if pU =!= null then (
    d = max(d, minPolyBoundDegree(pU));
    iv = (ring pU)_0;
  );
  if pL =!= null then (
    d = max(d, minPolyBoundDegree(pL));
    iv = (ring pL)_0;
  );
  if p =!= null then (
    d = max(d, minPolyBoundDegree(p));
    iv = (ring p)_0;
  );
  (F, f) = polyCleanUpper(F, f, p, d);
  (F, f) = polyCleanUpper(F, f, pU, d);
  (G, g) = polyCleanLower(G, g, p, d);
  (G, g) = polyCleanLower(G, g, pL, d);
  getMaxBettis(F, G, f, g, n, iv, deckstackargs)
);

beginDocumentation()
load "./MaxBettiNumbers/doc.m2"
end



M2
restart
loadPackage("MaxBettiNumbers", Reload=>true)

QQ[i]
pUpper=3*i^2-6*i+175;
pLower=3*i^2-6*i+165;

printNicely = result -> netList (Alignment=>Center,Boxes=>false,HorizontalSpace=>3, prepend({"HilbertPolynomial", "Total Betti Numbers", "Hilbert Function", "Sharp"}, toList\result))
printCountNicely = result -> netList (Alignment=>Center,Boxes=>false,HorizontalSpace=>3, prepend({"HilbertPolynomial", "Total Betti Numbers", "#Hilbert Functions", "Sharp"}, (r->{r_0,r_1,#r_2,r_3})\result))

printCountNicely maxBettiNumbers(ResultsCount=>All, 4, HilbertPolynomialUpperBound => pUpper, HilbertPolynomialLowerBound => pLower)

VerticalList maxBettiNumbers(6,ResultsCount=>None)
