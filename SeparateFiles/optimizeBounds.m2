--- This function makes an optimizations of g(d) based on the following:
--- The smallest that h(d) could be is G(d)-F(d-1)
--- Usage: g = optimizeLowerBound ( G, F, g );
optimizeLowerBound = ( G, F, g ) -> (
  gprime := G - prepend( 0, drop( F, -1 ) );
  max \ transpose { g, gprime }
);

--- This function makes an optimizations of f(d) based on the following:
--- The largest that h(d) could be is G(d)-G(d-1)
--- Usage: f = optimizeLowerBound ( G, F, f );
optimizeUpperBound = ( G, F, f ) -> (
  fprime := F - prepend( 0, drop( G, -1 ) );
  min \ transpose { f, fprime }
);

--- This function makes two optimizations on G(d) based on the following:
--- The smallest that H(d) could be is G(d) + g(d)
--- The smallest that H(d) could be is G(d+1) - f(d)
optimizeAccumulatedLowerBound = (G, g, f) -> (
  cumulativeSum := 0;
  G = for d to #G - 1 list (
    cumulativeSum = max( G#d, cumulativeSum + g#d )
  );
  bound := 0;
  reverse for d in reverse( 0 .. #G - 1 ) list (
    bound = max(G#d, bound)
  ) do (
    bound = bound - f#d
  )
);

--- This function makes two optimizations on F(d) based on the following:
--- The largest that H(d) could be is F(d) + f(d)
--- The largest that H(d) could be is F(d+1) - g(d)
optimizeAccumulatedUpperBound = (F, g, f) -> (
  cumulativeSum := 0;
  F = for d to #F - 1 list (
    cumulativeSum = min( F#d, cumulativeSum + f#d )
  );
  bound := infinity;
  reverse for d in reverse( 0 .. #F - 1 ) list (
    bound = min(F#d, bound)
  ) do (
    bound = bound - g#d
  )
);
