optimizeLowerBound = ( G, F, g ) -> (
  gprime := G - prepend( 0, drop( F, -1 ) );
  max \ transpose { g, gprime }
);
optimizeUpperBound = ( G, F, f ) -> (
  fprime := F - prepend( 0, drop( G, -1 ) );
  min \ transpose { f, fprime }
);
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
