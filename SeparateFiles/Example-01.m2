M2
uninstallAllPackages
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
h = last oo.HilbertFunctions
almostLexBetti(N, h)
almostLexIdeal(QQ[x_1..x_N], h)
maxBettiNumbers(N,p,g,G,F, Algorithm=>"Simplified", ResultsCount=>"One")

uninstallAllPackages
installPackage "MaxBettiNumbers"
check "MaxBettiNumbers"



--- Match bad parens (\((?!$)[^ ])|([^ ](?<!^)\))
--- Match (){},with nospaces (\((?!$)[^ ])|([^ ](?<!^)\))|(\{(?!$)[^ ])|([^ ](?<!^)\})|(\[(?!$)[^ ])|([^ ](?<!^)\])|(,(?!$)[^ ])
