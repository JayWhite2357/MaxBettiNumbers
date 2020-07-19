TEST /// --Test a preknown result.
N = 4;
p = 4;
mbn = maxBettiNumbers( N, HilbertPolynomial => p );
assert( mbn.BettiUpperBound === { 6, 8, 3 } );
///

TEST /// --Test that all 8 versions of the algorithm produce the same result.
testMatching = ( N, p ) -> (
  mbn = maxBettiNumbers( N, HilbertPolynomial => p );
  mbn1 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "None" );
  mbn2 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "One" );
  mbn3 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "AllMaxBettiSum" );
  mbn4 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Simplified", ResultsCount => "All" );
  mbn5 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "None" );
  mbn6 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "One" );
  mbn7 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "AllMaxBettiSum" );
  mbn8 = maxBettiNumbers( N, HilbertPolynomial => p,
    Algorithm => "Complete", ResultsCount => "All" );
  assert( mbn.BettiUpperBound === mbn1.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn2.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn3.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn4.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn5.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn6.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn7.BettiUpperBound );
  assert( mbn.BettiUpperBound === mbn8.BettiUpperBound );
  assert( sort mbn2.HilbertFunctions === sort mbn6.HilbertFunctions );
  assert( sort mbn3.HilbertFunctions === sort mbn7.HilbertFunctions );
  assert( sort mbn4.HilbertFunctions === sort mbn8.HilbertFunctions );
);
for i from 0 to 10 do testMatching( 4, i );
for i from 2 to 10 do testMatching( i, 4 );
///

TEST /// --Test against brute force method
loadPackage "StronglyStableIdeals";
QQ[d]; p = 2*d+10; N = 5;
time ssI = stronglyStableIdeals( p, N );
getTotalBetti = ( N, I ) -> (
  t := new Tally from ( applyKeys( betti res I, first, plus ) );
  for i from 1 to N - 1 list t_i
);
time maxbetti = max \ transpose ( ssI / getTotalBetti_N );
time mbn = maxBettiNumbers( N, HilbertPolynomial => p );
assert( mbn.BettiUpperBound === maxbetti );
///

TEST /// --Test against a preknown result.
N = 5;
g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
G = HilbertFunctionLowerBound => {,,,,,,41};
F = HilbertFunctionUpperBound => {,,,,,,41};
p = HilbertPolynomial => 49;
mbn1 = maxBettiNumbers( N,p,g,G,F );
assert( mbn1.BettiUpperBound === {23,54,47,14} );
assert( mbn1.isRealizable === false );
assert( mbn1.MaximumBettiSum === 137 );
mbn2 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "One" );
assert( #( mbn2.HilbertFunctions ) === 1 );
assert( mbn1.BettiUpperBound === mbn2.BettiUpperBound );
assert( mbn1.isRealizable === mbn2.isRealizable );
assert( mbn1.MaximumBettiSum === mbn2.MaximumBettiSum );
polys = mbn2.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
mbn3 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "AllMaxBettiSum" );
assert( #( mbn3.HilbertFunctions ) === 18 );
assert( mbn1.BettiUpperBound === mbn3.BettiUpperBound );
assert( mbn1.isRealizable === mbn3.isRealizable );
assert( mbn1.MaximumBettiSum === mbn3.MaximumBettiSum );
polys = mbn3.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
mbn4 = maxBettiNumbers( N,p,g,G,F, ResultsCount => "All" );
assert( #( mbn4.HilbertFunctions ) === 36 );
assert( #( mbn4.MaximalBettiNumbers ) === 2 );
assert( mbn1.BettiUpperBound === mbn4.BettiUpperBound );
assert( mbn1.isRealizable === mbn4.isRealizable );
assert( mbn1.MaximumBettiSum === mbn4.MaximumBettiSum );
polys = mbn4.HilbertFunctions /
  almostLexIdeal_( QQ[x_1..x_N] ) /
  hilbertPolynomial_( Projective => false );
assert( all( polys, p -> sub( p, ZZ )=== 49 ) );
///
