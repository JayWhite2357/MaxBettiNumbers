doc ///
  Key
    MaxBetti
  Description
    Text
      This is the type that is returned by @TO maxBettiNumbers@ it is a
      @TO HashTable@ with the following keys.
      
      @UL{{TO BettiUpperBound,TEX" - upper bound for the total Betti numbers."},
      {TO HilbertFunctions,
      TEX" - a list of  Hilbert functions with maximal Betti numbers. See ",
      TO[maxBettiNumbers,ResultsCount],TEX" for more details."},
      {TO isRealizable,
      TEX" - if there is an ideal with the upper bound as its Betti numbers. "},
      {TO MaximalBettiNumbers,TEX" - the maximal total Betti numbers."},
      {TO MaximumBettiSum,TEX" - maximum sum of the total Betti numbers."}}@
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
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
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
