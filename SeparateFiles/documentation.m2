load "docMainMethod.m2"
load "docEmptySymbols.m2"
load "docConstraints.m2"
load "docLexIdeals.m2"
doc ///
  Key
    MaxBettiNumbers
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
  Headline
    Methods to find Maximum Betti numbers given bounds on the Hilbert function.
///
doc ///
  Key
    [maxBettiNumbers, Algorithm]
  SeeAlso
    maxBettiNumbers
///
doc ///
  Key
    [maxBettiNumbers, ResultsCount]
  Description
    Text
      The method @TO maxBettiNumbers@ finds the upper bounds for the total Betti
      numbers. In certain instances, there are ideals that realize these upper
      bounds and have maximum possible total Betti numbers. In this case, these
      ideals also must have the maximum possible sum of the total Betti numbers.
      However, there are some instances where there are no ideals that realize
      the upper bounds. In this case, there are only ideals that realize maximal
      total Betti numbers. Some of these also must have the maximum possible sum
      of the total Betti numbers, while others do not.
      
      @TT"ResultsCount"@ is an option that can be passed to
      @TO maxBettiNumbers@. It determines how many, and what type of ideals are
      collected. The Hilbert function of these ideals is returned in a
      @TO MaxBetti@ object under key @TO HilbertFunctions@.
      
      There are four possible values, with the default being "None".
            
      
      @UL{{TT"\"None\"",TEX" or ",TT"0",
      TEX" - Does not return any Hilbert functions."},
      {TT"\"One\"",TEX" or ",TT"1",
      TEX" - Returns the Hilbert function of an ideal which has the maximum ",
      TEX"possible sum of the total Betti numbers."},
      {TT"\"AllMaxBettiSum\"",TEX" - Returns the Hilbert functions of all ",
      "ideals that have the maximum possible sum of the total Betti numbers."},
      {TT"\"All\"",TEX" - Returns the Hilbert functions of all ideals that ",
      "have maximal Betti numbers."}}@
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaxBetti
  Description
    
  SeeAlso
    maxBettiNumbers
///
doc ///
  Key
    BettiUpperBound
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO List@.
      The upper bound for the total Betti numbers.
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaximumBettiSum
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO ZZ@.
      The maximum value of the sum of the total Betti numbers.
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    HilbertFunctions
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO VerticalList@.
      A list of truncated Hilbert functions returned by @TO maxBettiNumbers@.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    isRealizable
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO Boolean@.
      Is @TT"true"@ if there is an ideal in the family that has total Betti
      numbers that match @TO BettiUpperBound@ otherwise is @TT"false"@.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
doc ///
  Key
    MaximalBettiNumbers
  Description
    Text
      Used as a key in @TO MaxBetti@ with value being a @TO VerticalList@.
      Each item in the list is a set of total Betti numbers that are maximal.
      In other words, no ideal has total Betti numbers that are simultaneously
      greater than or equal, and there is an ideal with these Betti numbers.
      See @TO[maxBettiNumbers, ResultsCount]@ for more details.
  SeeAlso
    [maxBettiNumbers, ResultsCount]
    maxBettiNumbers
    MaxBetti
///
