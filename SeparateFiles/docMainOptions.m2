doc ///
  Key
    [maxBettiNumbers, Algorithm]
  Description
    Text
      There are two algorithms that can be used to find the upper bounds given
      in @TO maxBettiNumbers@.
      
      The ``Simplified'' algorithm simply finds the maximum of while ignoring the
      ideal structure of an ideal. In other words, it searches all possible
      numeric functions instead of just the Hilbert functions. This has two
      consequences. First, it is significantly faster because it allows for a
      simplification of the algorithm. Second, it does not always give the
      smallest upper bounds. However, there is one instance where it is
      guarenteed to give the smallest upper bounds: when no upper bound for the
      Hilbert function is specified.
      
      The ``Complete'' algorithm does not make this simplification, and as a
      result, is slower but give the smallest upper bounds in every situation.
      
      Ideally, we would like to use the ``Simplified'' algorithm when it gives the
      smallest upper bounds, and use the ``Complete'' algorithm otherwise. By
      default, the algorithm is selected that guarentees the smallest upper
      bounds. However, this can be overridden by passing the @TT"Algorithm"@
      option to @TO maxBettiNumbers@. The possible values are
      
      @UL{{TT"\"Automatic\"", TEX" - this is the default and chooses the ",
      TEX"algorithm to use based on the other inputs. Note: This will always ",
      TEX"give the smallest upper bounds as well as valid Hilbert functions."},
      {TT"\"Simplified\"",TEX" - forces use of the ``Simplified'' algorithm. ",
      TEX"Note: if this option is passed, the values in ``HilbertFunctions'' ",
      TEX"may not be actual Hilbert functions."},
      {TT"\"Complete\"",TEX" - forces use of the ``Complete'' algorithm. ",
      TEX"Note: This will always give the smallest upper bounds as well as ",
      TEX"valid Hilbert functions."}}@
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
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
      "have maximal total Betti numbers."}}@
  SeeAlso
    maxBettiNumbers
    MaxBetti
///
