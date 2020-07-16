M2
restart
loadPackage ("MaxBettiNumbers", Reload => true);
loadPackage "LexIdeals";
loadPackage "RandomIdeals";
lexsegmentIdealArtinian = (R, h) -> (
  I := lexsegmentIdeal(R,h);
  I + ideal flatten entries basis(#h, coker gens I)
);

R=QQ[x_1..x_4];
I = randomMonomialIdeal(for i to 20 list random(6)+5, R);
h = hilbertFunct(I, MaxDegree=>25);
-- LexIdeals version
t1 = benchmark "I1 = lexIdeal(R,h)";
-- MaxBettiNumbers version
t2 = benchmark "I2 = lexsegmentIdealArtinian(R,h)";
t5 = benchmark "I2 = lexsegmentIdeal(R,h)";
-- LexIdeals version
t3 = benchmark "I3 = lexIdeal(I)";
-- MaxBettiNumbers version
-- Since I have't implemented this yet, I will do a bit of a hack to compare
-- potential speed. This would be a relatively simple modification, and would be
-- as fast, or faster, than the timing given here.
h = hilbertFunct(I, MaxDegree => max((I3_*)/first@@degree));
t4 = benchmark "I4 = lexsegmentIdeal(R,h)";


netList {
  {"Timing","LexIdeals Version","MaxBettiNumbers Version"},
  {"Generate Artinian lex ideal from hilbert function",t1,t2},
  {"Generate lex ideal from another ideal",t3,t4},
  {"Generate non-Artinian lex ideal from hilbert function",,t5}
}
