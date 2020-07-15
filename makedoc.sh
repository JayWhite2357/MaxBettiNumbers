cd $(dirname "$0")
cd SeparateFiles
../M2expand.py MaxBettiNumbers.m2 > ../MaxBettiNumbers.m2
cd $(dirname "$0")
echo "uninstallAllPackages;installPackage\"MaxBettiNumbers\";" > installPack.m2
M2 --script installPack.m2
rm installPack.m2
./installdoc.sh
