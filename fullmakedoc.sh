DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR
cd SeparateFiles
../M2expand.py MaxBettiNumbers.m2 > ../MaxBettiNumbers.m2
cd $DIR
rm -r ~/.Macaulay2/local/share/doc/Macaulay2/MaxBettiNumbers/
echo "uninstallAllPackages;installPackage\"MaxBettiNumbers\";check MaxBettiNumbers;" > installPack.m2
M2 --script installPack.m2
rm installPack.m2
./installdoc.sh
