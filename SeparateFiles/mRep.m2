macaulayRepresentation = ( a, d ) -> (
  v := if d <= 1 then a else 0;
  if d > 1 then (
    while a > binomial( v - 1 + d, d ) do (
      v = v + 1
    )
  );
  reverse for i in reverse( 0 .. d - 1 ) list (
    if a === 0 then 0 else if i === 0 then a else (
      a = a - binomial( v + i, i + 1 );
      while a < 0 do (
        v = v - 1;
        a = a + binomial( v + i, i );
      );
      v
    )
  )
)

macaulayAboveBound = ( a, d ) -> (
  if ( a === infinity or ( d === 0 and a > 0 ) ) then infinity else (
    r := macaulayRepresentation( a, d );
    sum for i to #r-1 list (
      binomial( r#i + i + 1, i + 2)
    )
  )
);

macaulayBelowBound = ( a, d ) -> (
  if ( a <= 0 or d <= 0 ) then 0 else if d === 1 then 1 else (
    r := macaulayRepresentation(a, d);
    sum for i to #r-1 list (
      if r#i === 0 then 0 else (
        binomial( r#i + i - 1, i )
      )
    )
  )
);
