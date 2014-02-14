#!/bin/sh
# -*- sh -*-
BASEDIR=`dirname $0`/..

#for F in `ls $BASEDIR/drawing/pgf/*.pgf.tex`; do
    F=$BASEDIR/$1
    FILENAME=`basename $F`
    BARENAME=${FILENAME%.tex}
    pdflatex -output-directory tmp/pgf $F
    pdftops -eps tmp/pgf/$BARENAME.pdf
    convert -density 300 tmp/pgf/$BARENAME.eps static/image/pgf/$BARENAME.png
#done
