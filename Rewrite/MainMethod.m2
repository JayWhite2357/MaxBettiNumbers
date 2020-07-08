maxBettiNumbers = method( TypicalValue => HashTable, Options => true );

maxBettiNumbers ZZ := {
  HilbertPolynomial=>null,
  HilbertFunctionUpperBound=>{},
  HilbertFunctionLowerBound=>{},
  HilbertDifferenceUpperBound=>{},
  HilbertDifferenceLowerBound=>{},
  ResultsCount => "None",
  Algorithm => "Automatic"
} >> o -> numberOfVariables -> (
  ---Parse Inputs and handle options
  n := numberOfVariables - 2;
  G := o.HilbertFunctionLowerBound;
  F := o.HilbertFunctionUpperBound;
  g := o.HilbertDifferenceLowerBound;
  f := o.HilbertDifferenceUpperBound;
  p := o.HilbertPolynomial;
  if instance( p, ZZ ) then p = sub( p, QQ(monoid[getSymbol "i"]) );
  alg := if o.Algorithm === "Complete" then 1 else if o.Algorithm === "Simplified" or F === {} then 0 else -1;
  rescnt := if o.ResultsCount === "One" or o.ResultsCount === 1 then 1 else
    if o.ResultsCount === "AllMaxBettiSum" then 2 else
    if o.ResultsCount === "All" then 3 else 0;
  ---End Parse inputs
  
  ---Sanitize Inputs
  (G, F, g, f) = sanitizeInputs(G, F, g, f, p, n);
  ---End Sanitize Inputs
  
  ---Automatically select algorithm
  if alg === -1 then (
    GFgfsimplified := try sanitizeInputs(G, {}, g, f, p, n) else null;
    alg = if (G, F, g, f) ===  GFgfsimplified then 0 else 1;
  );
  methodToRun := {
    {SimplifiedNone, SimplifiedSome, SimplifiedSome, SimplifiedAll},
    {CompleteNone, CompleteSome, CompleteSome, CompleteAll}
  }#alg#rescnt;
  ---End Auto select

  
  ---Run Algorithm
  (V, lb) := BuildVlb(g, f, n);
  result := methodToRun(G, F, g, f, V, lb);
  ---End Run Algorithm
  
  ---Parse Results
  hilbertFunctions := null; bettiUpperBound := null; maximumBettiSum := null; maximalBettiNumbers := null;
  if rescnt === 0 then (
    bettiUpperBound = drop( result, -1 );
    maximumBettiSum = last result;
  ) else if rescnt === 3 then (
    hilbertFunctions = if (alg === 0 ) then UnravelHFs( result#1, G, g, lb ) else UnravelCompleteHFs( result#1, G, g, lb );
    maximalBettiNumbers = result#0 / ( b -> drop( b, -1 ) );
    bettiUpperBound = max \ transpose maximalBettiNumbers;
    maximumBettiSum = max( last \ result#0 );
  ) else (
    hilbertFunctions = if rescnt === 1 then (
      if (alg === 0 ) then UnravelOne( result#1, G, g, lb ) else UnravelCompleteOne( result#1, G, g, lb )
    ) else (
      if (alg === 0 ) then UnravelHFs( result#1, G, g, lb ) else UnravelCompleteHFs( result#1, G, g, lb )
    );
    bettiUpperBound = drop( result#0, -1 );
    maximumBettiSum = last result#0;
  );
  realizable := maximumBettiSum === sum bettiUpperBound;
  bettig := sum lexBettiNum(g, n);
  bettiUpperBound = bettiUpperBound + bettig;
  maximumBettiSum = maximumBettiSum + sum bettig;
  if maximalBettiNumbers =!= null then maximalBettiNumbers = maximalBettiNumbers / plus_bettig;
  if hilbertFunctions =!= null then hilbertFunctions = hilbertFunctions / accumulate_(plus, 0);
  ---End parse results
  
  ---Format results
  new MaxBetti from hashTable{
    isRealizable => realizable,
    BettiUpperBound => bettiUpperBound,
    MaximumBettiSum => maximumBettiSum,
    if maximalBettiNumbers =!= null then MaximalBettiNumbers => VerticalList maximalBettiNumbers,
    if hilbertFunctions =!= null then HilbertFunctions => VerticalList hilbertFunctions
  }
  ---End format results
);
