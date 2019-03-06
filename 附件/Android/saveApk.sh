#!/usr/bin/env bash
#####################################
#此脚本用于将医典通Android安装包保存至指定路径
#创建时间   2018-12-28
#创建人    wangzunbin
#####################################

ABSOLUTE_BASE_PATH=`pwd`
BASE_DIR=.
PROJECT_DIR=$ABSOLUTE_BASE_PATH
MODULE_NAME=app

BUILD_APK_DIR=$PROJECT_DIR/$MODULE_NAME/build/outputs/apk/debug
OUTPUT_DIR=$ABSOLUTE_BASE_PATH/output
OUTPUT_APK_DIR=$OUTPUT_DIR/$STG_ENV
OUTPUT_LATEST_APK_DIR=$OUTPUT_DIR/latest


echo "begin to save apk to " $OUTPUT_APK_DIR
#判断是否存在out_put
if [ ! -d "$OUTPUT_DIR" ]; then
  mkdir -pv $OUTPUT_DIR
fi
if [ ! -d "$OUTPUT_APK_DIR" ]; then
  mkdir -pv $OUTPUT_APK_DIR
fi
  #清空latest文件夹
  rm -rf $OUTPUT_LATEST_APK_DIR
  mkdir $OUTPUT_LATEST_APK_DIR

#releas版本在gradle中修改了文件名称，此处仅过滤release版本，以Pa开头
echo $BUILD_APK_DIR
cd $BUILD_APK_DIR
`pwd`
#搜索Pa开头的release版本apk，将其拷贝出来
apk_list=`ls *`
for i in $apk_list
do
  echo "copy" $i "to " $OUTPUT_APK_DIR
  #拷贝至历史版本
  cp $BUILD_APK_DIR/$i $OUTPUT_APK_DIR/
  #拷贝至最终目录
  cp $BUILD_APK_DIR/$i $OUTPUT_LATEST_APK_DIR/
done
