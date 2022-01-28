EMACS?=emacs

all: pub

##########################
# export org to html
##########################
AUTO_PAGES = content/index.org content/misc/categories.org content/misc/archives.org content/misc/site-log.org
%.org: script/site-metadata.el
	@touch $@

export: tangle $(AUTO_PAGES)
	@echo "export org files"
	$(EMACS) $(DEBUG) --batch --script script/compile.el -f export

force-export:
	@echo "export org files"
	$(EMACS) $(DEBUG) --batch --script script/compile.el -f force-export

pub: export
	@echo "publish site"
	script/pub

force-pub: force-export
	@echo "publish site"
	script/pub

##########################
# tangle code
##########################
output/script/site.js: tangle/site-js.tgl.org
	echo '"tangle/site-js.tgl.org"' >> .tangle-files

tangle: output/script/site.js
	@echo "code tangled"

