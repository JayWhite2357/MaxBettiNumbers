cd ~/maxbetti/
rm -r ./docs/
mkdir ./docs/
cp -r ~/.Macaulay2/local/share/doc/Macaulay2/MaxBettiNumbers/html/* ./docs/
cp /usr/share/Macaulay2/Style/doc.css ./docs/
cp MaxBettiNumbers.m2 ./docs/
find ./docs/ -type f -exec sed -i 's/\/usr\/share\/Macaulay2\/Style\/doc.css/doc.css/g' {} \;
find ./docs/ -type f -exec sed -i 's/..\/..\/..\/..\/Macaulay2\//.\//g' {} \;
touch ./docs/.nojekyll
