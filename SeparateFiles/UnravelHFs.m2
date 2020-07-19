--- This method unravels a single hilbert function from the raveled result
---   returned from the Simplified algorithm.

UnravelSimplifiedOne = ( HFs, G, g, lowerBound ) -> (
  targetSum := last G;
  lowerBound' := 0;
  result := { };
  for d in reverse( 0 .. #HFs - 1 ) do (
    --- In this version, we take the minimum hilbert function at this degree.
    ---   This is guarenteed to give a valid result in the Simplified case.
    ---   (In the Complete case, it gives a valid result because only valid
    ---   results are stored in raveledHFs.)
    hd := min( HFs#d#( targetSum - G#d ) );
    targetSum = targetSum - hd;
    result = (
      --- We don't really start saving the hilbert function until the Macaulay
      ---   bound is a strict inequality.
      if ( #result === 1 and lowerBound' === hd ) then { hd }
      else prepend( hd, result )
    );
    lowerBound' = lowerBound#d#( hd - g#d );
  );
  { result }
);

--- This is essentially the same as UnravelSimplifiedOne. The only difference is
---   that we track all possible triples (targetSum, lowerBound', result).
---   The list of these is kept in partialUnraveled, which is looped over for
---   each degree. Additionally, all possible values for the hilbert function
---   are considered, and not simply the minimum.
UnravelSimplifiedHFs = ( HFs, G, g, lowerBound ) -> (
  partialUnraveled := { ( last G, 0, { } ) };
  for d in reverse( 0 .. #HFs - 1 ) do (
    partialUnraveled = flatten for tlr in partialUnraveled list (
      ( targetSum, lowerBound', result ) := tlr;
      if targetSum < G#d then continue;
      for hd in HFs#d#( targetSum - G#d ) list (
        if hd < lowerBound' then continue;
        (
          targetSum - hd,
          lowerBound#d#( hd - g#d ),
          if ( #result === 1 and lowerBound' === hd ) then { hd }
          else prepend( hd, result )
        )
      )
    )
  );
  partialUnraveled / last
);

--- In this Complete case, this gives a valid result because only valid results
---   are stored in raveledHFs, since we have the extra "k" index.
--- The only difference from UnravelSimplifiedOne is the lowerBound' - g#d index
UnravelCompleteOne = ( HFs, G, g, lowerBound ) -> (
  targetSum := last G;
  lowerBound' := 0;
  result := { };
  for d in reverse( 0 .. #HFs - 1 ) do (
    --- The only difference from UnravelSimplifiedOne is the lowerBound' - g#d
    hd := min( HFs#d#( targetSum - G#d )#( lowerBound' - g#d ) );
    ( targetSum, lowerBound', result ) =
    (
      targetSum - hd,
      lowerBound#d#( hd - g#d ),
      if ( #result === 1 and lowerBound' === hd ) then { hd }
      else prepend( hd, result )
    )
  );
  { result }
);

--- The only difference from UnravelSimplifiedHFs is the lowerBound' - g#d index
UnravelCompleteHFs = ( HFs, G, g, lowerBound ) -> (
  partialUnraveled := { ( last G, 0, { } ) };
  for d in reverse( 0 .. #HFs - 1 ) do (
    partialUnraveled = flatten for tlr in partialUnraveled list (
      ( targetSum, lowerBound', result ) := tlr;
      if targetSum < G#d then continue;
      --- The only difference from UnravelSimplifiedHFs is the lowerBound' - g#d
      for hd in HFs#d#( targetSum - G#d )#( max( lowerBound' - g#d, 0 ) ) list (
        if hd < lowerBound' then continue;
        (
          targetSum - hd,
          lowerBound#d#( hd - g#d ),
          if ( #result === 1 and lowerBound' === hd ) then { hd }
          else prepend( hd, result )
        )
      )
    )
  );
  partialUnraveled / last
);
