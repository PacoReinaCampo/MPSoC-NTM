rm -f *.pdf
rm -f *.tex

pandoc ../BOOK.md -s -o MPSoC-NTM.pdf
pandoc ../BOOK.md -s -o MPSoC-NTM.tex
