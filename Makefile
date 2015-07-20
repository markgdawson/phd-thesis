open: /tmp/thesisbuild/Thesis.pdf
	open /tmp/thesisbuild/Thesis.pdf

/tmp/thesisbuild/Thesis.pdf: Chapters/
	mkdir -p /tmp/thesisbuild 2>/dev/null
	pdflatex -output-directory /tmp/thesisbuild Thesis.tex