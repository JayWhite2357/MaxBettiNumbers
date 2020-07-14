UnravelSimplifiedHFs = (HFs, G, g, lb) -> (
  partialUnraveled := {(last G,{})};
  isFirst := true;
  while HFs#?0 do (
    partialUnraveled = flatten for p in partialUnraveled list (
      minh := if isFirst then 0 else (last lb)#(p#1#0 - last g);
      for h in (last HFs)#(p#0 - last G) list (
        if h < minh then continue;
        (p#0 - h, if h === minh and #p#1 === 1 then {h} else prepend(h, p#1))
      )
    );
    HFs = drop(HFs, -1);
    G = drop(G, -1);
    if isFirst then (
      isFirst = false;
    ) else (
      g = drop(g, -1);
      lb = drop(lb, -1);
    );
  );
  partialUnraveled / last
);


UnravelCompleteHFs = (HFs, G, g, lb) -> (
  partialUnraveled := {(last G,{})};
  isFirst := true;
  while HFs#?0 do (
    partialUnraveled = flatten for p in partialUnraveled list (
      minh := 0;
      if not isFirst then (
        minh = (last lb)#(p#1#0 - last g);
      );
      for h in (last HFs)#(p#0 - last G)#(max(minh - g#(-2), 0)) list (
        if h < minh then continue;
        (p#0 - h, if h === minh and #p#1 === 1 then {h} else prepend(h, p#1))
      )
    );
    HFs = drop(HFs, -1);
    G = drop(G, -1);
    if isFirst then (
      isFirst = false;
    ) else (
      g = drop(g, -1);
      lb = drop(lb, -1);
    )
  );
  partialUnraveled / last
);


UnravelSimplifiedOne = (HFs, G, g, lb) -> (
  targetSum := last G; result := {};
  for d in reverse( 0..#HFs-1 ) do (
    hd := min( HFs#d#( targetSum - G#d ) );
    targetSum = targetSum - hd;
    if ( #result === 1 and lb#( d + 1 )#( result#0 - g#( d+1 ) ) === hd ) then (
      result = {}
    );
    result = prepend(hd, result);
  );
  {result}
);



UnravelCompleteOne = (HFs, G, g, lb) -> (
  targetSum := last G; result := {}; lastlb := 0;
  for d in reverse( 0..#HFs-1 ) do (
    hd := min( HFs#d#( targetSum - G#d )#lastlb );
    targetSum = targetSum - hd;
    if ( #result === 1 ) then (
      lastlb = lb#( d + 1 )#( result#0 - g#( d+1 ) );
      if ( lastlb === hd ) then (
        result = {}
      )
    );
    result = prepend(hd, result);
  );
  {result}
);
