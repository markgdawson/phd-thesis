open: Latex/Thesis.pdf
	open -a  /Applications/Skim.app Latex/Thesis.pdf

Latex/Thesis.pdf: Latex/Chapters/*
	cd Latex && pdflatex Thesis.tex
