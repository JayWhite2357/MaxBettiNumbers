doc ///
  Key
    maxBettiNumbers
    (maxBettiNumbers, ZZ)
  Headline
    Upper bounds for total Betti numbers in a family of saturated ideals.
  Usage
    maxBettiNumbers (N,
      HilbertPolynomial => p,
      HilbertFunctionLowerBound => G,
      HilbertFunctionUpperBound => F,
      HilbertDifferenceLowerBound => g,
      HilbertDifferenceUpperBound => f)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    HilbertPolynomial=>RingElement
      the Hilbert polynomial, @TT"p"@, of the ideals in the family.
      See @TO [maxBettiNumbers, HilbertPolynomial]@.
    HilbertFunctionLowerBound=>List
      the lower bound for the Hilbert function, @TT"G"@, of the ideals in the
      family. See @TO [maxBettiNumbers, HilbertFunctionLowerBound]@.
    HilbertFunctionUpperBound=>List
      the upper bound for the Hilbert function, @TT"F"@, of the ideals in the
      family. See @TO [maxBettiNumbers, HilbertFunctionUpperBound]@.
    HilbertDifferenceLowerBound=>List
      the lower bound for the difference Hilbert function, @TT"g"@, of the
      ideals in the family.
      See @TO [maxBettiNumbers, HilbertDifferenceLowerBound]@.
    HilbertDifferenceUpperBound=>List
      the upper bound for the difference Hilbert function, @TT"f"@, of the
      ideals in the family.
      See @TO [maxBettiNumbers, HilbertDifferenceUpperBound]@.
    ResultsCount=>String
      how many Hilbert functions the result should include.
      See @TO [maxBettiNumbers, ResultsCount]@.
    Algorithm=>String
      the algorithm to use. See @TO [maxBettiNumbers, Algorithm]@.
  Outputs
    :
      an object with the upper bound and additional information.
  Description
    Text
      Consider a polynomial ring, $S$, in @TT"N"@ variables.
      Consider the family of saturated ideals, $I\subset S$, satisfying the
      following constraints. (Note: $h_{S/I}$ will denote the hilbert function
      of $S/I$, and $\Delta$ will denote the difference operator. (i.e.
      $\Delta h_{S/I}(d)=h_{S/I}(d)-h_{S/I}(d-1)$.)
      
      The function $G$, $F$, $g$, $f$, and $p$ are arguments to method. In the
      case where the value is not given, the corresponding constraint is
      removed (i.e. made the trivial constraint). Note: $F$ and $G$
      must be equal for large degrees. This is implied, and does not need to be
      explicit if $p$ is specified.
      
      @UL{TEX"$G(d)\\leq h_{S/I}(d)\\leq F(d)$ for all $d$",
      TEX"$g(d)\\leq\\Delta h_{S/I}(d)\\leq f(d)$ for all $d$",
      TEX"$h_{S/I}(d)=p(d)$ for large $d$"}@
      
      @TT"maxBettiNumbers"@ returns the upper bound for the total Betti numbers
      of the ideals along with other information.
      A complete description of the output can be found under @TO MaxBetti@.
      
      Almost lexsegment ideals have the largest total Betti numbers out of all
      saturated ideals with a given Hilbert function. The function
      @TO almostLexIdeal@ is useful to obtain the ideals with maximal Betti
      numbers.
      
      The following is an example in $6$ variables where we fix the Hilbert
      polynomial to be $2d+10$, and look at the Betti tables of the ideals that
      realize the maximum total Betti numbers.
    Example
      QQ[d];
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        ResultsCount => "All")
      almostLexBetti_6 \ toList result.HilbertFunctions
    Text
      Restricting to ideals with at least one linear element gives us a
      different result.
    Example
      result = maxBettiNumbers(6, HilbertPolynomial => 2*d+10,
        HilbertFunctionUpperBound => {,5}, ResultsCount => "All")
      I = almostLexIdeal(QQ[x_1..x_6], first result.HilbertFunctions)
      betti res I
      hilbertPolynomial(I, Projective=>false)
      (0..6)/(d->hilbertFunction(d,I))
    Text
      In most situations, there is an ideal in the family that realizes this
      upper bound. However, there are situations where this is not true.
      This method indicates this with the key @TO isRealizable@. However, there
      is always an ideal that gives the maximum sum of the total Betti numbers.
      This maximum is given by the key @TO MaximumBettiSum@. The following
      example in $5$ variables shows this phenomenon. In it we fix the Hilbert
      polynomial to be $5d+11$, and we restrict $\Delta h_{S/I}(d)\geq 8$ for
      $d=3,4$.
    Example
      result = maxBettiNumbers(5, HilbertDifferenceLowerBound => {,,,8,8},
        HilbertPolynomial => 5*d+11);
      sum result.BettiUpperBound
      result.MaximumBettiSum  -- This doesn't match the previous sum.
      result.isRealizable     -- As a result, this is false.
    Text
      @HEADER2"Default constraints"@
      
      Because the inputs can be incomplete or absent, @TT"maxBettiNumbers"@
      assumes the following default values for the missing information.
      
      @UL{TEX"Lower bounds have a default value of $0$.",
      TEX"Upper bounds have a default value of infinity.",
      TEX"Truncated hilbert functions are assumed to continue, but the
      associated hilbert polynomial is assumed to match the hilbert function at
      last degree where it is specified.",
      TEX"If no Hilbert polynomial is specified, the Hilbert polynomial is
      assumed to be the Hilbert polynomial of $G$ and $F$."}@
      
      More details can be found under
      @TO [maxBettiNumbers, HilbertFunctionLowerBound]@. In the case where the
      inputs result in constraints that are impossible or invalid, an error is
      thrown.
      
      @HEADER2"Output Results"@
      
      In addition to upper bounds for the total Betti numbers, this function can
      optionally output Hilbert functions with maximal total Betti numbers. This
      is specified with the optional argument @TT"ResultsCount"@. More details
      can be found under @TO [maxBettiNumbers, ResultsCount]@.
      
      @HEADER2"Different Algorithms"@
      
      There are two different algorithms that get used: the Simplified
      algorithm, which is faster, but is not guarenteed to give sharp bounds,
      and the Complete algorithm, which always gives sharp bounds. The optional
      argument @TT"Algorithm"@ allows the selection of the algorithm. A more
      complete description can be found under @TO [maxBettiNumbers,Algorithm]@.
      
      @HEADER2"More Examples"@
      
      We will consider an example where $S$ is the polynomial ring in $5$
      variables.
      This example has only maximal total Betti Numbers, and not maximum total
      Betti numbers.
      Also, the Simplified and Complete algorithms give different results.
      Both of these are somewhat unusual, but give an illuminating example.
      We will choose the following constraints:
      $$h_{S/I}(6)=41\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      h_{S/I}(d)=49\ for\ large\ d$$
      $$8\leq \Delta h_{S/I}(3)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      8\leq \Delta h_{S/I}(4)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      5\leq \Delta h_{S/I}(5)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 
      5\leq \Delta h_{S/I}(6)\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ $$
      Since we will be using these constraints in several examples, we will
      first define a few variables to reduce repetition.
    Example
      N = 5;
      g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
      G = HilbertFunctionLowerBound => {,,,,,,41};
      F = HilbertFunctionUpperBound => {,,,,,,41};
      p = HilbertPolynomial => 49;
    Text
      We find that $(23, 54, 47, 14)$ is the upper bound for the total Betti
      numbers of all saturated ideals with these constraints.
      Additionally, the maximum for the sum of the Betti numbers is $137$.
      Note that because $23 + 54 + 47 + 14 = 138$, there is no single ideal with
      total Betti numbers of $(23, 54, 47, 14)$.
    Example
      maxBettiNumbers(N,p,g,G,F)
    Text
      If we want the Hilbert function of an ideal with maximal total Betti
      numbers, we can pass @TT"ResultsCount=>\"One\""@ as an option.
      Note, this gives an ideal with the maximum for the sum of the Betti
      numbers.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
    Text
      If we want the Hilbert function of all ideals that have the maximum sum of
      the Betti numbers, we can pass @TT"ResultsCount=>\"AllMaxBettiSum\""@ as
      an option.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
    Text
      Finally, if we want the Hilbert function of all ideals that have maximal
      total Betti numbers, we can pass @TT"ResultsCount=>\"All\""@ as an option.
      In addition to returning the upper bound and Hilbert functions, the
      maximal total Betti numbers of $(23, 54, 45, 13)$ and $(22, 54, 47, 14)$
      are also returned.
    Example
      maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
    Text
      Because we are setting an upper bound of $h_{S/I}(6) \leq 41$, the
      Simplified algorithm will not give sharp bounds. As a result, the Complete
      algorithm is automatically chosen instead. However, we can force the use
      of a different one. In this case, if we specify
      @TT"Algorithm=>\"Simplified\""@, we get an upper bound that is,
      necessarily, larger. Additionally, we are given a Hilbert function that
      appears to be valid, but is not the Hilbert function of any saturated
      ideal.
    Example
      maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")
    Text
      We can compare the speed of the two algorithms with an example of fixing
      the Hilbert polynomial to be $3d^2-6d+175$ in a ring with $6$ variables.
      Because there is no upper bound for $h_{S/I}$, both algorithms give valid
      results, and smallest possible upper bounds.
    CannedExample
      i27 : p = HilbertPolynomial => 3*d^2-6*d+175;

      i28 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Simplified", ResultsCount=>"None")

      o28 = 5.207294879

      o28 : RR (of precision 53)

      i29 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Simplified", ResultsCount=>"All")

      o29 = 6.675004686

      o29 : RR (of precision 53)

      i30 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Complete", ResultsCount=>"None")

      o30 = 20.432215378

      o30 : RR (of precision 53)

      i31 : first timing maxBettiNumbers(6, p,
              Algorithm=>"Complete", ResultsCount=>"All")

      o31 = 26.732769924

      o31 : RR (of precision 53)
  Caveat
    If @TT"Algorithm=>\"Simplified\""@ is forced, this may not return valid
    Hilbert functions for some inputs.
  SeeAlso
    MaxBetti  
///
