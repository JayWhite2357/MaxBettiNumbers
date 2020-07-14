cd ~/maxbetti/
./make.sh
rm -r ~/.Macaulay2/local/share/doc/Macaulay2/MaxBettiNumbers/
M2 --script installPack.m2
rm -r ~/Downloads/MaxBettiNumbers
cp -r ~/.Macaulay2/local/share/doc/Macaulay2/MaxBettiNumbers/ ~/Downloads/
cp /usr/share/Macaulay2/Style/doc.css ~/Downloads/MaxBettiNumbers/html
find ~/Downloads/MaxBettiNumbers/ -type f -exec sed -i 's/\/usr\/share\/Macaulay2\/Style\/doc.css/doc.css/g' {} \;
