--- This function sanitizes g(d) so that it is a valid hilbert function.
--- This relies on the fact that h(d) is must be at least
--- macaulayAboveBound(g(d-1), d-1)
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

--- This function sanitizes f(d) so that it is a valid hilbert function.
--- This relies on the fact that h(d) is must be at most
--- macaulayBelowBound(g(d+1), d+1)
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
