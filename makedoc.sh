cd ~/maxbetti
cd SeparateFiles
../M2expand.py MaxBettiNumbers.m2 > ../MaxBettiNumbers.m2
cd ..
echo "uninstallAllPackages;installPackage\"MaxBettiNumbers\";" > installPack.m2
M2 --script installPack.m2
rm installPack.m2
./installdoc.sh
