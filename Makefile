EMACS?=emacs

all: pub

export: dot
	echo "export org files"
	$(EMACS) --batch --script script/compile.el

pub: export
	echo "publish site"
	script/pub

# graphviz dot
DOT_SRCS = $(shell sh -c "ls dot")
DOT_SRCS_WD = $(DOT_SRCS:%=dot/%)
DOT_IMGS = $(DOT_SRCS_WD:%.dot=%.dot.png)

%.dot.png: %.dot
	dot -Tpng $< -o static/$@

dot: $(DOT_IMGS)
	@echo "dot files compiled"
