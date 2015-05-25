#!/bin/sh 
echo "Generating Paper "   
rm paper.pdf paper.aux paper.bbl 
pdflatex paper.tex
bibtex paper.aux 
pdflatex paper.tex
pdflatex paper.tex
clear
echo "  " 
echo "  " 
echo "  " 
echo " ------------> Paper was generated  <------------ " 
echo "  " 
echo "  " 
echo "  " 
