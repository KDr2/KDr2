#!/bin/bash
# -*- sh -*-

DICT_TMP_DIR=/tmp/stardict-tmp-dict

if [ "X$DICT_DIR" = "X" ]; then
    DICT_DIR=/usr/share/stardict/dic/
fi

mkdir -p $DICT_TMP_DIR
sudo mkdir -p $DICT_DIR

DICT_LIST_FILE=/tmp/dict-list.txt

cat << EOF > $DICT_LIST_FILE
stardict-21shijishuangxiangcidian-2.4.2.tar.bz2
stardict-21shijishuangyukejicidian-2.4.2.tar.bz2
stardict-bcgm-2.4.2.tar.bz2
stardict-cdict-gb-2.4.2.tar.bz2
stardict-cedict-gb-2.4.2.tar.bz2
stardict-CET4-2.4.2.tar.bz2
stardict-CET6-2.4.2.tar.bz2
stardict-chengyuda-2.4.2.tar.bz2
stardict-chibigenc-2.4.2.tar.bz2
stardict-gaojihanyudacidian-2.4.2.tar.bz2
stardict-gaojihanyudacidian_fix-2.4.2.tar.bz2
stardict-ghycyzzd-2.4.2.tar.bz2
stardict-guojibiaozhunhanzidacidian-2.4.2.tar.bz2
stardict-hanyuchengyucidian-2.4.2.tar.bz2
stardict-hanyuchengyucidian_fix-2.4.2.tar.bz2
stardict-HanYuChengYuCiDian-new_colors-2.4.2.tar.bz2
stardict-hanzim-2.4.2.tar.bz2
stardict-kdic-computer-gb-2.4.2.tar.bz2
stardict-kdic-ec-11w-2.4.2.tar.bz2
stardict-langdao-ce-gb-2.4.2.tar.bz2
stardict-langdao-ec-gb-2.4.2.tar.bz2
stardict-lazyworm-ce-2.4.2.tar.bz2
stardict-lazyworm-ec-2.4.2.tar.bz2
stardict-mdbg-cc-cedict-2.4.2.tar.bz2
stardict-ncce-ce-2.4.2.tar.bz2
stardict-ncce-ec-2.4.2.tar.bz2
stardict-poemstory-2.4.2.tar.bz2
stardict-ProECCE-2.4.2.tar.bz2
stardict-quick_eng-zh_CN-2.4.2.tar.bz2
stardict-stardict1.3-2.4.2.tar.bz2
stardict-sun_dict_e2c-2.4.2.tar.bz2
stardict-swjznote-2.4.2.tar.bz2
stardict-TOEIC-2.4.2.tar.bz2
stardict-xdict-ce-gb-2.4.2.tar.bz2
stardict-xdict-ec-gb-2.4.2.tar.bz2
stardict-xhzd-2.4.2.tar.bz2
stardict-xiandaihanyucidian-2.4.2.tar.bz2
stardict-xiandaihanyucidian_fix-2.4.2.tar.bz2
stardict-xiangya-medical-2.4.2.tar.bz2
stardict-zigenzidian-2.4.2.tar.bz2
EOF

#cat << EOF > $DICT_LIST_FILE
#stardict-21shijishuangxiangcidian-2.4.2.tar.bz2
#EOF

for DICT_FILE in `cat $DICT_LIST_FILE`; do
    cd $DICT_TMP_DIR
    curl http://depot.kdr2.com/resource/stardict/$DICT_FILE -o $DICT_FILE
    cd $DICT_DIR
    sudo tar jxvf $DICT_TMP_DIR/$DICT_FILE
done

rm $DICT_LIST_FILE
rm $DICT_TMP_DIR -fr
