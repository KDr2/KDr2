EMACS?=emacs

all: pub

export: dot
	echo "export org files"
	$(EMACS) --batch --script script/compile.el

pub: export
	echo "publish site"
	script/pub

# graphviz dot
DOT_SRCS = $(shell sh -c "ls drawing/dot/")
DOT_SRCS_WD = $(DOT_SRCS:%=drawing/dot/%)
DOT_IMGS = $(DOT_SRCS:%.dot=%.dot.png)

%.dot.png: drawing/dot/%.dot
	dot -Tpng $< -o static/image/dot/$@

dot: $(DOT_IMGS)
	@echo "dot files compiled"

# pgf
PGF_SRCS = $(shell sh -c "ls drawing/pgf")
PGF_SRCS_WD = $(PGF_SRCS:%=drawing/pgf/%)
PGF_IMGS = $(PGF_SRCS:%.tex=%.png)

%.pgf.png: drawing/pgf/%.pgf.tex
	pdflatex -output-directory tmp/pgf $<
	pdftops -eps tmp/pgf/%.pgf.pdf
	convert -density 300 %.pgf.eps static/image/pgf/$@

pgf: $(PGF_IMGS)
	@echo "pgf files compiled"
