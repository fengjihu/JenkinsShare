#!/usr/bin/env bash
####################################
#此脚本用于医典通Android代码打包
#创建时间   2018.12.25
#创建人    wangzunbin
#####################################
#****************** CONSTANTS *******************************#
#版本号
APP_VER_CODE=$1
APP_VER_NAME=$2

#应用名称
#APP_NAME=$3

BASE_DIR_P=$3
#运行环境
APP_STG=$4

#****************** PATH SETTINGS ***************************#
#变量
BASE_DIR=$BASE_DIR_P
PROJECT_DIR=$BASE_DIR
MODULE_NAME=app
PACKAGE_NAME=com/starsmart/justibian

echo ${APP_VER_CODE}
echo ${APP_VER_NAME}
echo ${BASE_DIR_P}
echo ${APP_STG}



#替换sdk文件
FILE_LOCAL_PROPERTY=${PROJECT_DIR}/local.properties
FILE_BUILD_GRADLE=${PROJECT_DIR}/${MODULE_NAME}/build.gradle
FILE_STRING_XML=${PROJECT_DIR}/${MODULE_NAME}/src/main/res/values/strings.xml
FILE_APPLICATION=${PROJECT_DIR}/${MODULE_NAME}/src/main/java/${PACKAGE_NAME}/config/HttpConstant.java
FILE_ANDROIDMANIFEST=${PROJECT_DIR}/${MODULE_NAME}/src/main/AndroidManifest.xml

echo #{FILE_BUILD_GRADLE}


#****************** DECLARATIONS ******************************#
#获取时间戳
function getTime(){
	echo `date +%Y``date +%m``date +%d``date +%H``date +%M``date +%S`;
}

#获取时间（格式：yyyy-mm-dd-hh-mm-ss）
function getTimeFormat(){
	echo `date +%Y`-`date +%m`-`date +%d`-`date +%H`-`date +%M`-`date +%S`;
}

#获取短时间，格式：mmddhhmm
function getShortTime(){
	echo `date +%m``date +%d``date +%H``date +%M`
}
#生成apk文件名
#OUTPUT_APK_NAME=$(getTimeFormat)-$APP_STG-$APP_VER_NAME.apk
OUTPUT_APK_NAME=$(getTimeFormat)-$APP_STG-$APP_VER_NAME.apk

#****************** FUNTIONS ***************************#



#更改sdk路径
#function changeSDK()
#{
#  echo "begin to changeSDK" $FILE_LOCAL_PROPERTY
#  sed -i "" "s/^sdk.dir.*/sdk.dir=\/Users\/user\/Documents\/Android\/sdk/g" $FILE_LOCAL_PROPERTY
#}

function changeAppVersion()
{
  echo "begin to change appVer" $APP_VER_NAME $FILE_BUILD_GRADLE
  sed -i "s/versionCode .*/versionCode $APP_VER_CODE/g" $FILE_BUILD_GRADLE
  sed -i "s/versionName \".*\"/versionName \"$APP_VER_NAME\"/g" $FILE_BUILD_GRADLE
}

#function changeAPPName()
#{
#  echo "begin to change appName" $APP_NAME $FILE_STRING_XML
#  sed -i "" "s/\<string name=\"app_name\"\>.*\<\/string\>/\<string name=\"app_name\"\>$APP_NAME\<\/string\>/g" $FILE_STRING_XML
#}

function changeENV()
{
		echo "begin to change app enviroment" $APP_STG $FILE_APPLICATION
#    sed -i "" "s/private String env = \".*\"/private String env = \"$APP_STG\"/g" $FILE_APPLICATION
#    sed -i "" "s/public static final String BASE_URL = \".*\"/public static final String BASE_URL = \"$APP_STG\"/g" $FILE_APPLICATION
    if [ "$APP_STG" = "DEV" ];then
        sed -i "s@^    public static final String BASE_URL = .*@    public static final String BASE_URL = DEV_BASE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String BASE_BLE_URL = .*@    public static final String BASE_BLE_URL = TEST_BLE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static boolean printDebugLog = .*@    public static boolean printDebugLog = DEV_DebugLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String WEB_URL = .*@    public static final String WEB_URL = DEV_WEB_UEL;@g" $FILE_APPLICATION
        sed -i "s@^    public static String RENT_URL = .*@    public static String RENT_URL = DEV_RENT_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static HttpLoggingInterceptor.Level printLogWith = .*@    public static HttpLoggingInterceptor.Level printLogWith = DEV_HttpLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static int GEO_TABLE_ID = .*@    public static int GEO_TABLE_ID = DEV_GEO_TABLE_ID_4_BAIDU_MAP;@g" $FILE_APPLICATION
    elif [ "$APP_STG" = "TEST" ];then
        sed -i "s@^    public static final String BASE_URL = .*@    public static final String BASE_URL = TEST_BASE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String BASE_BLE_URL = .*@    public static final String BASE_BLE_URL = TEST_BLE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static boolean printDebugLog = .*@    public static boolean printDebugLog = TEST_DebugLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String WEB_URL = .*@    public static final String WEB_URL = TEST_WEB_UEL;@g" $FILE_APPLICATION
        sed -i "s@^    public static String RENT_URL = .*@    public static String RENT_URL = TEST_RENT_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static HttpLoggingInterceptor.Level printLogWith = .*@    public static HttpLoggingInterceptor.Level printLogWith = TEST_HttpLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static int GEO_TABLE_ID = .*@    public static int GEO_TABLE_ID = TEST_GEO_TABLE_ID_4_BAIDU_MAP;@g" $FILE_APPLICATION
    else
        sed -i "s@^    public static final String BASE_URL = .*@    public static final String BASE_URL = RELEASE_BASE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String BASE_BLE_URL = .*@    public static final String BASE_BLE_URL = RELEASE_BLE_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static boolean printDebugLog = .*@    public static boolean printDebugLog = RELEASE_DebugLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static final String WEB_URL = .*@    public static final String WEB_URL = RELEASE_WEB_UEL;@g" $FILE_APPLICATION
        sed -i "s@^    public static String RENT_URL = .*@    public static String RENT_URL = RELEASE_RENT_URL;@g" $FILE_APPLICATION
        sed -i "s@^    public static HttpLoggingInterceptor.Level printLogWith = .*@    public static HttpLoggingInterceptor.Level printLogWith = RELEASE_HttpLog;@g" $FILE_APPLICATION
        sed -i "s@^    public static int GEO_TABLE_ID = .*@    public static int GEO_TABLE_ID = RELEASE_GEO_TABLE_ID_4_BAIDU_MAP;@g" $FILE_APPLICATION
    fi

}


#function changeTdAppId(){
#        echo "begin to change app enviroment" $APP_STG $FILE_ANDROIDMANIFEST
#         if [ "$APP_STG" = "STG" ]; then
#           sed -i "" "s/\<meta-data android:name=\"TD_APP_ID\" android:value=.*\/\>/\<meta-data android:name=\"TD_APP_ID\" android:value=\"01FB61C84788498E2000152A3006182A\"\/\>/g" $FILE_ANDROIDMANIFEST
#         else
#           sed -i "" "s/\<meta-data android:name=\"TD_APP_ID\" android:value=.*\/\>/\<meta-data android:name=\"TD_APP_ID\" android:value=\"E2B02483B2C00FF72000152A3006181A\"\/\>/g" $FILE_ANDROIDMANIFEST
#         fi
# }

#****************** Job Begin ***************************#
echo `pwd`

#开始替换变量
#changeSDK(这个禁止打开)
#changeAPPName
changeAppVersion
changeENV
#changeTdAppId(这个禁止打开)

#****************** Job End ***************************#
