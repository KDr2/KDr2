EMACS?=emacs

all: pub

export:
	echo "export org files"
	$(EMACS) --batch --script script/compile.el

pub: export
	echo "publish site"
	script/pub
