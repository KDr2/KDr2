EMACS?=emacs

all: pub

##########################
# export org to html
##########################
AUTO_PAGES = org-src/misc/categories.org org-src/misc/archives.org org-src/misc/site-log.org
%.org: script/site-metadata.el
	@touch $@

export: tangle $(AUTO_PAGES)
	@echo "export org files"
	$(EMACS) --batch --script script/compile.el -f export

force-export:
	@echo "export org files"
	$(EMACS) --batch --script script/compile.el -f force-export

pub: export
	@echo "publish site"
	script/pub

force-pub: force-export dot pgf
	@echo "publish site"
	script/pub

##########################
# tangle code
##########################
output/script/site.js: tangle/site-js.tgl.org
	echo '"tangle/site-js.tgl.org"' >> .tangle-files

tangle: output/script/site.js
	@echo "code tangled"

###########################
# graphviz dot
###########################
DOT_SRCS = $(shell sh -c "ls drawing/dot/")
DOT_SRCS_WD = $(DOT_SRCS:%=drawing/dot/%)
DOT_IMGS = $(DOT_SRCS:%.dot=%.dot.png)

%.dot.png: drawing/dot/%.dot
	dot -Tpng $< -o static/image/dot/$@

dot: $(DOT_IMGS)
	@echo "dot files compiled"

##########################
# pgf
##########################
PGF_SRCS = $(shell sh -c "ls drawing/pgf/")
PGF_IMGS = $(PGF_SRCS:%.pgf.tex=%.pgf.png)

%.pgf.png: drawing/pgf/%.pgf.tex
	script/pgf_compiler.sh $<

pgf: $(PGF_IMGS)
	@echo "pgf files compiled"
