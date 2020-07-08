M2
restart
QQ[i]

  

G=F=g=f={};
Ex = 4;
Constraint = true;
n = null;
p = null;
  
if Ex === 1 then (
  n = 3;
  p = 5 * i + 11;
  if Constraint then (g = {,,,8,8};)
);
if Ex === 2 then (
  n = 8;
  p = (1/5040)*i^7+(1/180)*i^6+(29/360)*i^5+(37/72)*i^4+(1327/720)*i^3+(893/360)*i^2+(323/105)*i+35;
  if Constraint then f =  {,,40,116,,586};
);
if Ex === 3 then (
  n = 4;
  p = 3*i^2-6*i+175;
);
if Ex === 4 then (
  n = 3;
  p = 49_(QQ[i]);
  g = {,,,8,8,5,5}; F = {,,,,,,41}; G = {,,,,,,41};
);
if Ex === 5 then (
  n = 4;
  p = 101_(QQ[i]);
);



loadPackage "LexIdeals"
load "CombinedAlgorithms.m2"
load "SanitizeInputs.m2"
load "UnravelHFs.m2"

(F, G, f, g, valid) = sanitizeInputs(G, F, g, f, p, n);
if sanitizeInputs(G, {}, g, f, p, n) === (F, G, f, g, valid) then print "simple version is enough";
if not valid then print "invalid!";
(V, lb) = BuildVlb(g, f, n);


(B, raveledHFs) = CompleteAll (G, F, g, f, V, lb);
hfs1 = UnravelOne(raveledHFs, G, g, lb)
hfsA = UnravelHFs(raveledHFs, G, g, lb)
load "lexBetti.m2"
g
lexBettiNum(g, n)

B
--load "lexBetti.m2"

--hf = first hfs

--sum lexBettiNum(hf, n)

--lexBettiNumbers(hf,n)
--sum lexBettiNum({1,2,3}, n)
--lexBettiNumbers({1,8}, n)
M2
restart
loadPackage "MaxBettiNumbers";
N = 5;
g = HilbertDifferenceLowerBound => {,,,8,8,5,5};
G = HilbertFunctionLowerBound => {,,,,,,41};
F = HilbertFunctionUpperBound => {,,,,,,41};
p = HilbertPolynomial => 49;
maxBettiNumbers(N,p,g,G,F)
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"One")
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"AllMaxBettiSum")
maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All")
maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")

time maxBettiNumbers(N,p,g,G,F, ResultsCount=>"All");

N = 6;
QQ[i]; p = HilbertPolynomial => 3*i^2-6*i+175;
time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"None");
time maxBettiNumbers(N, p, Algorithm=>"Simplified", ResultsCount=>"All");
time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"None");
time maxBettiNumbers(N, p, Algorithm=>"Complete", ResultsCount=>"All");

loadPackage "MaxBettiNumbers"; loadPackage "StronglyStableIdeals";
benchmark("maxBettiNumbers(5, HilbertPolynomial => 25)")
benchmark("stronglyStableIdeals(25, 5)")


diffHF = l -> l - prepend(0, drop(l,-1))

M

hilbertFunction(10,QQ[x_0..x_3])

take(last M1,10)
take(last M2,10)
take(G1,10)
take(G2,10)
take(F1,10)
take(F2,10)
take(g1,10)
take(g2,10)

(last M2) / first
take(G2, 10)

maxBettiNumbers(N,p,g,f,F,Algorithm=>"Simplified")
maxBettiNumbers(N,p,g,f,F,Algorithm=>"Complete")
M = maxBettiNumbers(N,p,g,f,F,ResultsCount=>1)
M.HilbertFunctions / almostLexBettiNumbers_N
M = maxBettiNumbers(N,p,g,f,F,ResultsCount=>"All")
M.HilbertFunctions / almostLexBettiNumbers_N

restart
loadPackage "MaxBettiNumbers";
