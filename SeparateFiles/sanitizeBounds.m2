cleanUpperBound = f -> (
  bound := 1;
  for d to #f - 1 list (
    if f#d =!= null then (
      bound = min( f#d, bound )
    );
    bound
  ) do (
    bound = macaulayAboveBound(bound, d)
  )
);
cleanLowerBound = f -> if #f == 0 then f else (
  bound := 0;
  reverse for d in reverse( 0 .. #f - 1) list (
    if f#d =!= null then (
      bound = max( f#d, bound )
    );
    bound
  ) do (
    bound = macaulayBelowBound(bound, d)
  )
);
