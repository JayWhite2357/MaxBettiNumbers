doc ///
  Key
    [maxBettiNumbers, HilbertFunctionLowerBound]
    [maxBettiNumbers, HilbertFunctionUpperBound]
    [maxBettiNumbers, HilbertDifferenceLowerBound]
    [maxBettiNumbers, HilbertDifferenceUpperBound]
  Description
    Text
      The options @TT"HilbertFunctionLowerBound"@,
      @TT"HilbertFunctionUpperBound"@,
      @TT"HilbertFunctionLowerBound"@,
      @TT"HilbertDifferenceLowerBound"@, and
      @TO HilbertPolynomial@ are arguments to 
      @TO maxBettiNumbers@.
      Each of these options, other than @TO HilbertPolynomial@, are a list of
      integers starting at degree 0.
      In the case where a value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint).
      Note: if @TO HilbertPolynomial@ is not specified,
      @TT"HilbertFunctionLowerBound"@ and @TT"HilbertFunctionUpperBound"@
       must be equal for large degrees.

      In the case where no lower
      bound is desired at a specified degree, @TT"0"@, @TT"null"@, or nothing
      can be put instead. For instance, to specify only a lower bound of @TT"4"@
      in degree @TT"3"@ on the Hilbert difference function, the option
      @TT"HilbertDifferenceLowerBound=>{,,,4}"@ can be used.
      
      Similarly, in the case where no upper bound is desired at a specified
      degree, @TT"infinity"@, @TT"null"@, or nothing can be put instead.
      For instance, to specify only a upper bound of @TT"4"@
      in degree @TT"3"@ on the Hilbert function, the option
      @TT"HilbertFunctionUpperBound=>{,,,4}"@ can be used.
      
      There are some instances when these options, along with
      @TO HilbertPolynomial@ conflict. In this case, an error is raised.      
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertPolynomial]
///
doc ///
  Key
    [maxBettiNumbers, HilbertPolynomial]
  Description
    Text
      The functions @TO HilbertFunctionLowerBound@,
      @TO HilbertFunctionUpperBound@,
      @TO HilbertFunctionLowerBound@,
      @TO HilbertDifferenceLowerBound@, and
      @TT"HilbertPolynomial"@ are arguments to 
      @TO maxBettiNumbers@.
      In the case where a value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint).
      Note: if @TT"HilbertPolynomial"@ is not specified,
      @TO HilbertFunctionLowerBound@ and  @TO HilbertFunctionUpperBound@
       must be equal for large degrees.
       
      This option can be either a @TO RingElement@ or an integer. In the case
      where this conflicts with the bounds on
      the Hilbert functions, an error is raised.
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertFunctionLowerBound]
///
