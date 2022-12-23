# function: remove the row numbers in the README.md file

cd /c/Users/cjt/Documents/GitHub/MyRepo4R
awk '{$1 = ""; print $0}' README.md > READ.md

cat READ.md
