load "docMainMethod.m2"
load "docEmptySymbols.m2"
load "docConstraints.m2"
load "docLexIdeals.m2"
load "docMainOptions.m2"
load "docMaxBetti.m2"
doc ///
  Key
    MaxBettiNumbers
  Headline
    Methods to find maximum Betti numbers given bounds on the Hilbert function.
  Description
    Text
      The method @TO maxBettiNumbers@ is the headliner in this package. It
      returns upper bounds for the total Betti numbers in a family that has
      bounds on the Hilbert function and/or the Hilbert difference function.
    
      The method @TO maxBettiNumbers@ can optionally return special Hilbert
      functions. The methods @TO almostLexBetti@ and @TO almostLexIdeal@ are
      helpful in working with these Hilbert function. The functions
      @TO lexBetti@ and @TO lexsegmentIdeal@ use the same code, and are exported
      from the package in hopes that they are useful. These functions are
      written with a concern for speed and efficiency.
///
--- replace the following with "doc ///" to run this long example
///
  Key
    "Paper Example"
  Description
    Example
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
      maxBettiNumbers(N,p,g,G,F)
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
      almostLexBetti(N, last o9.HilbertFunctions)
      almostLexIdeal(QQ[x_1..x_N], last o9.HilbertFunctions)
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
      N = 6;
      QQ[i]; p = HilbertPolynomial => 3*i^2-6*i+175;
      time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"None");
      time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"All");
      time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"None");
      time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"All");
      loadPackage "StronglyStableIdeals"
      benchmark("maxBettiNumbers(5, HilbertPolynomial => 25)")
      benchmark("stronglyStableIdeals(25, 5)")
///
--- replace the following with "doc ///" to run this long example
///
  Key
    "Main Example"
  Description
    Example
      QQ[d];
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        ResultsCount => "All")
      almostLexBetti_6 \ toList result.HilbertFunctions
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        HilbertFunctionUpperBound => {,5}, ResultsCount => "All")
      I = almostLexIdeal(QQ[x_1..x_6], first result.HilbertFunctions)
      betti res I
      hilbertPolynomial(I, Projective=>false)
      (0..6)/(d->hilbertFunction(d,I))
      result = maxBettiNumbers(5, HilbertDifferenceLowerBound => {,,,8,8},
        HilbertPolynomial => 5*d+11);
      sum result.BettiUpperBound
      result.MaximumBettiSum  -- This doesn't match the previous sum.
      result.isRealizable     -- As a result, this is false.
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
      maxBettiNumbers(N,p,g,G,F)
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
      p = HilbertPolynomial => 3*d^2-6*d+175;
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Simplified", ResultsCount=>"None")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Simplified", ResultsCount=>"All")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Complete", ResultsCount=>"None")
      first timing maxBettiNumbers(6, p,
        Algorithm=>"Complete", ResultsCount=>"All")
///
