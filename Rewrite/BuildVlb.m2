BuildVlb = (g, f, n) -> (
  zd := for d to #g-1 list toList(d:0);
  Vi := for i to n list (v->append(v,sum v))for q to n list (binomial(n+1,q+1)-binomial(i+1,q+1));
  V := for d to #g-1 list new MutableList from (g#d..f#d);
  lb := for d to #g-1 list new MutableList from (g#d..f#d);
  for d to #g-1 do (
    Vacc := Vi#n;
    rep := macaulayRepresentation(g#d, d);
    nextlb := sum for i from 1 to #rep-1 list binomial(rep#i-1+i, i);
    rep0 := 0;
    i := 0;
    for k to f#d-g#d do (
      Vacc = Vacc + Vi#(n - rep0);
      V#d#k = Vacc;
      lb#d#k = nextlb;
      if not rep#?0 then continue;
      rep0 = rep#0;
      if rep0 === 0 then nextlb = nextlb + 1;
      if i === 0 then while rep#?i and rep#i === rep0 do i = i + 1;
      i = i - 1;
      rep = join(zd#i, {rep0 + 1}, drop(rep, i + 1));
    )
  );
  (V, lb)
)
