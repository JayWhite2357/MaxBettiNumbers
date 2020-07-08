-- -*- coding: utf-8 -*-
newPackage(
  "MaxBettiNumbers",
      Version => "0.1.1",
      Date => "April 24, 2020",
      Authors => {{Name => "Jay White",
      Email => "jay.white@uky.edu"}},
      Headline => "Methods to find Maximum Betti Numbers given bounds on the Hilbert Function",
      DebuggingMode => true
      );

export {"maxBettiNumbers",
"HilbertFunctionLowerBound", "HilbertDifferenceLowerBound",
"HilbertFunctionUpperBound", "HilbertDifferenceUpperBound",
"HilbertPolynomial",
"ResultsCount",
"isRealizable",
"lexBettiNumbers","almostLexBettiNumbers",
"BettiUpperBound",
"MaximumBettiSum",
"HilbertFunctions",
"MaximalBettiNumbers",
"AsTally"
};

load "mRep.m2"
load "BuildVlb.m2"
load "SimplifiedNone.m2"
load "SimplifiedSome.m2"
load "SimplifiedAll.m2"
load "CompleteNone.m2"
load "CompleteSome.m2"
load "CompleteAll.m2"

load "SanitizeInputs.m2"

load "UnravelHFs.m2"
load "lexBetti.m2"
load "MaxType.m2"
load "MainMethod.m2"

end

cat MBNheader.m2 mRep.m2 BuildVlb.m2 SimplifiedNone.m2 SimplifiedSome.m2 SimplifiedAll.m2 CompleteNone.m2 CompleteSome.m2 CompleteAll.m2 sanitizeBounds.m2 sanitizePolynomial.m2 optimizeBounds.m2 SanitizeInputs.m2 UnravelHFs.m2 lexBetti.m2 MaxType.m2 MainMethod.m2 MBNfooter.m2


M2
restart
loadPackage "MaxBettiNumbers";
N = 5;
g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
G = HilbertFunctionLowerBound => {,,,,,,41};
F = HilbertFunctionUpperBound => {,,,,,,41};
p = HilbertPolynomial => 49;
maxBettiNumbers(N,p,g,G,F)
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
h = last oo.HilbertFunctions
almostLexBettiNumbers(N, h)
almostLexIdeal(QQ[x_1..x_N], h)
maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
