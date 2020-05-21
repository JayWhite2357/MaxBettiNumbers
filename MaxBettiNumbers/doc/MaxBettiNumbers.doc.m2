doc ///
Key
  MaxBettiNumbers
Headline
  Methods to find Max Betti Numbers given bounds on the Hilbert Function
Description
  Text
///
doc ///
Key
  lexBettiNumbers
Headline
  Computes the Betti Numbers of a lexicographic ideal.
Description
  Text
    In a polynomial ring, there is a unique lexicographic ideal with any given hilbert function.
    This function computes the Betti Numbers for the lexicographic ideal of a hilbert function.
    By the Bigatti-Hulett-Pardue theorem, these are the largest possible Betti Numbers for any ideal with that hilbert function.
  Example
    n = 4;
    R = QQ[x_0..x_n]
    I = ideal(x_0,x_1^3,x_1*x_2^2,x_3^2, x_4*x_2, x_4^2*x_1)
    d = regularity I + 1
    hf = apply(d, i-> hilbertFunction(i, I))
    B = lexBettiNumbers(n, hf)
    betti res I
///
