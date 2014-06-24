#!/bin/bash
# -*- sh -*-

BASENAME=`dirname $0`/..
rsync -avr $BASENAME/depot/images/ kdr2@kdr2.com:depot/img-kdr2-com/
python $BASENAME/script/upload-images-to-cloudinary.py
