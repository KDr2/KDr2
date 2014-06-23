#!/bin/env python

import os
import yaml

import cloudinary
import cloudinary.uploader
import cloudinary.api

META_EXT = ".cloudinary"
APP_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
IMG_ROOT = os.path.join(APP_ROOT, "depot/images")

def init_cloudinay():
    config_file = os.path.join(APP_ROOT, "config/cloudinary.private.yml")
    cloudinary_config = yaml.load(file(config_file))
    cloudinary.config(**cloudinary_config['production'])


def local_path(path):
    return os.path.join(IMG_ROOT, path)

def depot_url(path):
    return "http://depot.kdr2.com/img-kdr2-com/%s" % path

def public_id(path):
    return "img-kdr2-com/%s" % (os.path.splitext(path)[0])

def upload2cloudinary(path):
    local_img_path = local_path(path)
    if not os.path.isfile(local_img_path):
        return    
    img_mtime = os.path.getmtime(local_img_path)
    meta_mtime = 0
    meta_path = local_img_path + META_EXT
    if os.path.isfile(meta_path):
        meta_mtime = os.path.getmtime(meta_path)
    if(meta_mtime > img_mtime):
        return
    print " ==> Uploading Image : %s" % local_img_path
    ret = cloudinary.uploader.upload(
        depot_url(path),
        public_id=public_id(path),
        format=os.path.splitext(path)[1][1:]
    )
    with open(meta_path, "w") as m:
        m.write("%s" % ret['version'])


def walk_fun(_, d, files):
    print "Entering Drirectory: %s" % d
    path = d.replace(IMG_ROOT + "/", "")
    for f in files:
        if f.endswith(META_EXT):
            continue
        img = os.path.join(path, f)
        upload2cloudinary(img)
    print "Leaving Drirectory: %s" % d


if __name__ == '__main__':
    init_cloudinay()
    os.path.walk(IMG_ROOT, walk_fun, 0)    
