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
