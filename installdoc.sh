cd ~/maxbetti/
rm -r ~/JayWhite2357.github.io/MaxBettiNumbers
cp -r ~/.Macaulay2/local/share/doc/Macaulay2/MaxBettiNumbers/ ~/JayWhite2357.github.io/
cp /usr/share/Macaulay2/Style/doc.css ~/JayWhite2357.github.io/MaxBettiNumbers/html
find ~/JayWhite2357.github.io/MaxBettiNumbers/ -type f -exec sed -i 's/\/usr\/share\/Macaulay2\/Style\/doc.css/doc.css/g' {} \;
find ~/JayWhite2357.github.io/MaxBettiNumbers/ -type f -exec sed -i 's/href="_/href="u_/g' {} \;
cd ~/JayWhite2357.github.io/MaxBettiNumbers/html
for f in _*.html; do mv "$f" "u$f"; done
mkdir ~/JayWhite2357.github.io/Macaulay2
cp ~/maxbetti/MaxBettiNumbers.m2 ~/JayWhite2357.github.io/Macaulay2/MaxBettiNumbers.m2
