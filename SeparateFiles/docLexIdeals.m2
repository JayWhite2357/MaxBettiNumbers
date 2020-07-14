doc ///
  Key
    lexBetti
    (lexBetti, ZZ, List)
  Headline
    Graded Betti numbers of a lexsegment ideal.
  Usage
    lexBetti (N, h)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    h:List
      the Hilbert function of the lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function,
      there is a unique lexsegment ideal. Furthermore, this ideal has graded
      Betti numbers that are at least as large as those of any other ideal with
      that hilbert function.
    
      This function returns the graded Betti numbers of a lexsegment ideal with
      the given Hilbert function. Note, because only the truncated version of a
      Hilbert function can be represented by a list, the Hilbert function is
      assumed to continue as if it matches its polynomial by the end of the
      list. In other words, the lexsegment ideal has no generators with degree
      larger than @TT"#h-1"@.
    Example
      lexBetti (4, {1,2,3,3,3,3})
      lexBetti (4, {1,2,3,3,3,3,0})
      lexBetti (5, {1,5,15,35})
  SeeAlso
    lexsegmentIdeal
    almostLexBetti
///
doc ///
  Key
    almostLexBetti
    (almostLexBetti, ZZ, List)
  Headline
    Graded Betti numbers of an almost lexsegment ideal.
  Usage
    almostLexBetti (N, h)
  Inputs
    N:ZZ
      the number of variables in the ambient polynomial ring.
    h:List
      the Hilbert function of the almost lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function
      of a saturated ideal there is a unique almost lexsegment ideal. An almost
      lexsegment ideal is an ideal that is lexsegment in @TT"N-1"@ variables.
      Furthermore, this almost lexsegment ideal is saturated and has graded
      Betti numbers that are at least as large as those of any other saturated
      ideal with that hilbert function.
    
      This function returns the graded Betti numbers of an almost lexsegment
      ideal with the given Hilbert function. Note, because only the truncated version of a
      Hilbert function can be represented by a list, the Hilbert function is
      assumed to continue as if it matches its polynomial by the end of the
      list. In other words, the almost lexsegment ideal has no generators with
      degree larger than @TT"#h-1"@.
    Example
      lexBetti (4, {1,2,3,3,3,3})
      almostLexBetti (5, {1,3,6,9,12,15})
      lexBetti (4, {1,2,3,3,3,3,0})
      almostLexBetti (5, {1,3,6,9,12,15,15})
      lexBetti (5, {1,5,15,35})
      almostLexBetti (6, {1,6,21,56})
  SeeAlso
    almostLexIdeal
    lexBetti
///
doc ///
  Key
    [lexBetti, AsTally]
    [almostLexBetti, AsTally]
  Description
    Text
      This is an option that can be passed to either @TO lexBetti@ or
      @TO almostLexBetti@. If the value of the option is @TT"true"@ a
      @TO BettiTally@ object will be returned. If it is false, a @TO List@ of
      lists will be returned. This latter option is useful if one wishes to
      obtain the total Betti numbers instead of the graded Betti numbers. This
      can easily be done using by applying @TT"sum"@ to the output with
      @TT"AsTally=>false"@.
    Example
      lexBetti (4, {1,2,3,3,3,3}, AsTally => true)
      lexBetti (4, {1,2,3,3,3,3}, AsTally => false)
      sum oo
  SeeAlso
    lexBetti
    almostLexBetti
///
doc ///
  Key
    lexsegmentIdeal
    (lexsegmentIdeal, PolynomialRing, List)
  Headline
    Create a lexsegment ideal.
  Usage
    lexsegmentIdeal (S, h)
  Inputs
    S:PolynomialRing
      the ambient polynomial ring.
    h:List
      the Hilbert function of the lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function,
      there is a unique lexsegment ideal. Furthermore, this ideal has graded
      Betti numbers that are at least as large as those of any other ideal with
      that hilbert function.
    
      This function returns the lexsegment ideal with the given Hilbert
      function. Note, because only the truncated version of a Hilbert function
      can be represented by a list, the Hilbert function is assumed to continue
      as if it matches its polynomial by the end of the list. In other words,
      the lexsegment ideal has no generators with degree larger than @TT"#h-1"@.
      
      Note: this method is significantly faster than the similar @TT"lexIdeal"@
      from the package @TT"LexIdeals"@.
    Example
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3})
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3,0}) --Artinian
      lexsegmentIdeal (QQ[x_1..x_5], {1,5,15,35})
  SeeAlso
    lexBetti
    almostLexIdeal
///
doc ///
  Key
    almostLexIdeal
    (almostLexIdeal, PolynomialRing, List)
  Headline
    Create an almost lexsegment ideal.
  Usage
    almostLexIdeal (S, h)
  Inputs
    S:PolynomialRing
      the ambient polynomial ring.
    h:List
      the Hilbert function of the almost lexsegment ideal.
  Description
    Text
      Consider a polynomial ring in @TT"N"@ variables. For any hilbert function
      of a saturated ideal there is a unique almost lexsegment ideal. An almost
      lexsegment ideal is an ideal that is lexsegment in @TT"N-1"@ variables.
      Furthermore, this almost lexsegment ideal is saturated and has graded
      Betti numbers that are at least as large as those of any other saturated
      ideal with that hilbert function.
    
      This function returns the almost lexsegment ideal with the given Hilbert
      function. Note, because only the truncated version of a Hilbert function
      can be represented by a list, the Hilbert function is assumed to continue
      as if it matches its polynomial by the end of the list. In other words,
      the almost lexsegment ideal has no generators with degree larger than
      @TT"#h-1"@.
    Example
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3})
      almostLexIdeal (QQ[x_1..x_5], {1,3,6,9,12,15})
      lexsegmentIdeal (QQ[x_1..x_4], {1,2,3,3,3,3,0})
      almostLexIdeal (QQ[x_1..x_5], {1,3,6,9,12,15,15})
      lexsegmentIdeal (QQ[x_1..x_5], {1,5,15,35})
      almostLexIdeal (QQ[x_1..x_6], {1,6,21,56})
  SeeAlso
    almostLexBetti
    lexsegmentIdeal
///
