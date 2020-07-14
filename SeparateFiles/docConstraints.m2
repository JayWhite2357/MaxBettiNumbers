doc ///
  Key
    [maxBettiNumbers, HilbertFunctionLowerBound]
    [maxBettiNumbers, HilbertFunctionUpperBound]
    [maxBettiNumbers, HilbertDifferenceLowerBound]
    [maxBettiNumbers, HilbertDifferenceUpperBound]
  Description
    Text
      Each of these options is a list of integers starting at degree 0.
      The bounds set by @TT"HilbertFunctionLowerBound"@ and
      @TT"HilbertFunctionUpperBound"@ must match at large degrees, or at least
      force a condition where they match.
      
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
      @TO HilbertPolynomial@ conflict. In this case, an error is thrown.
      
      In the case where the @TO HilbertPolynomial@ option is not supplied,
      the family of ideals that
      is searched has no direct restriction on the Hilbert polynomial.
      However, because the upper and lower bounds on the Hilbert function
      are required to match for large degrees, there is always at least an
      implicit constraint.
      
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertPolynomial]
///
doc ///
  Key
    [maxBettiNumbers, HilbertPolynomial]
  Description
    Text
      This option can be either a @TO RingElement@ or an integer.
      In the case where this option is not supplied, the family of ideals that
      is searched has no direct restriction on the Hilbert polynomial.
      However, because the upper and lower bounds on the Hilbert function
      are required to match for large degrees, there is always at least an
      implicit constraint. In the case where this conflicts with the bounds on
      the Hilbert functions, an error is raised.
  SeeAlso
    maxBettiNumbers
    [maxBettiNumbers, HilbertFunctionLowerBound]
///
