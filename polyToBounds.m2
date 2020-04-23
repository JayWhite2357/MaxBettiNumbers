polyRep = (p,n) -> (
  i:=(ring p)_0;
  if leadTerm p != i^n/n! then print "Invalid polynomial! Trying to continue.";
  ptmp:=p;
  for j in reverse(1..n) list (
    if ptmp == 0_(ring p) then break;
    d:=(j+3)/2-(j-1)!*coefficient(i^(j-1),ptmp);
    if ptmp==binomial(i-d+1+j,j) then d=d-1;
    ptmp=ptmp-binomial(i-d+j,j);
    {d,j}
  )
)
polyDual=(p,n)->binomial((ring p)_0+n,n)-p;
polyDualRep=(p,n)->polyRep(polyDual(p,n),n);
