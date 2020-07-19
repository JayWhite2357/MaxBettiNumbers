--- This is the macaulay representation of a. From this, it is easy to read off
---   the max index of a monomial as well as the Macaulay upper and lower
---   bounds.
--- The output, rep, is a sequcne of length d
--- a = binomial(rep#0, 1) + binomial(d + rep#d, d + 1)
--- Note: this is a different output from most versions of this method.
---   the reason is that this is more compact and efficient.
--- The idea is that we want to easily increment and decrement a without
---   recomputing the representation each time. 

--- Incrementing rep: (increasing a)
---   Find the last element equal to rep#0.
---   Increase that element by 1 and set all preceding elements to 0
--- Decrementing rep: (decreasing a)
---   Find the first nonzero element
---      Reduce it by 1
---      Set all preceding elements to that element's new value
--- Reading off monomial:
---   The first nonzero element indicates the max index.
---   Add 1 to every other nonzero element.
---   Set all zero elements to equal the first nonzero element.
---   Take n+1-e for each element e. This is the index of the variable.
---   The product of all the variables is the ath last monomial,
---      where the 1st last is the power of the last variable.


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
      binomial( r#i + i + 1, i + 2 )
    )
  )
);

macaulayBelowBound = ( a, d ) -> (
  if ( a <= 0 or d <= 0 ) then 0 else if d === 1 then 1 else (
    r := macaulayRepresentation( a, d );
    sum for i to #r-1 list (
      if r#i === 0 then 0 else (
        binomial( r#i + i - 1, i )
      )
    )
  )
);

decrementRep = ( rep, firstNonzeroIndex, firstNonzeroValue ) -> (
  rep = join(
    firstNonzeroIndex + 1 : firstNonzeroValue - 1,
    drop( rep, firstNonzeroIndex + 1 )
  );
  if firstNonzeroValue === 1 then (
    firstNonzeroIndex = firstNonzeroIndex + 1;
    if rep#?firstNonzeroIndex then (
      firstNonzeroValue = rep#firstNonzeroIndex;
    )
  ) else (
    firstNonzeroIndex = 0;
    firstNonzeroValue = firstNonzeroValue - 1;
  );
  ( rep, firstNonzeroIndex, firstNonzeroValue )
);

incrementRep = ( rep, lastrep0Index ) -> (
  rep = join(
    toList( lastrep0Index : 0 ),
    { rep#0 + 1 },
    drop( rep, lastrep0Index + 1 )
  );
  if lastrep0Index === 0 then (
    while rep#?( lastrep0Index + 1 ) and
      rep#( lastrep0Index + 1 ) === rep#0 do 
      lastrep0Index = lastrep0Index + 1;
  ) else lastrep0Index = lastrep0Index - 1;
  ( rep, lastrep0Index )
)
