EMACS?=emacs

all: pub

##########################
# export org to html
##########################
AUTO_PAGES = content/index.org content/misc/categories.org content/misc/archives.org content/misc/site-log.org
%.org: script/site-metadata.el
	@touch $@

export: $(AUTO_PAGES)
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
