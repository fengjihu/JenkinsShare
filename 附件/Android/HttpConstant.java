package com.starsmart.justibian.config;

import okhttp3.logging.HttpLoggingInterceptor;

/**
 * ClassName:HttpContaint  <br/>
 * Funtion:  <br/>
 * Date:2017/11/22 0022 15:31   <br/>
 * Author: Rubinson <br/>
 * Version: 2.2.3 <br/>
 */

public class HttpConstant {
    /**
     * -----------------------------------开发环境----------------------------------------
     */
    private static final String DEV_BASE_URL = "http://192.168.1.180:8801";
    private static final String DEV_WEB_UEL = "http://192.168.1.180:8081";
    private static final String DEV_BLE_URL = "http://192.168.1.42:8080";
    private final static boolean DEV_DebugLog = true;
    private static final HttpLoggingInterceptor.Level DEV_HttpLog = HttpLoggingInterceptor.Level.BODY;
    private static String DEV_RENT_URL = "http://192.168.1.72:8801/indexApp.html";
    private static int DEV_GEO_TABLE_ID_4_BAIDU_MAP = 192199;


    /**
     * -----------------------------------测试环境----------------------------------------
     */
    private static final String TEST_BASE_URL = "http://192.168.1.44:8086";
    private static final String TEST_BLE_URL = "http://test.api.cnjnb.com";
    private static final String TEST_WEB_UEL = "http://192.168.1.44:8086";
    private final static boolean TEST_DebugLog = true;
    private static final HttpLoggingInterceptor.Level TEST_HttpLog = HttpLoggingInterceptor.Level.BODY;
    private static String TEST_RENT_URL = "http://192.168.1.72:8801/indexApp.html";
    private static int TEST_GEO_TABLE_ID_4_BAIDU_MAP = 192199;

    /**
     * -----------------------------------正式环境----------------------------------------
     */
    private static final String RELEASE_BASE_URL = "http://api.ydt138.com";
    private static final String RELEASE_WEB_UEL = "http://api.ydt138.com";
    private static final String RELEASE_BLE_URL = "http://api.cnjnb.com";
    public static boolean RELEASE_DebugLog = false;
    private static String RELEASE_RENT_URL = "http://xzn.yishizu168.com/indexApp.html";
    private static final HttpLoggingInterceptor.Level RELEASE_HttpLog = HttpLoggingInterceptor.Level.NONE;
    private static int RELEASE_GEO_TABLE_ID_4_BAIDU_MAP = 192711;

    /**------------------------------------开发环境使用的配置---------------------------------------*/
//    /**
//     * API 域名
//     */
//    public static final String BASE_URL = DEV_BASE_URL;
//    /**
//     * 蓝牙
//     */
//    public static final String BASE_BLE_URL = TEST_BLE_URL;
//    /**
//     * Log日志输出
//     */
//    public static boolean printDebugLog = DEV_DebugLog;
//    /**
//     * H5 域名
//     */
//    public static final String WEB_URL = DEV_WEB_UEL;
//    /**
//     * 易时租
//     */
//    public static String RENT_URL = DEV_RENT_URL;
//    /**
//     * http请求日志输出
//     */
//    public static HttpLoggingInterceptor.Level printLogWith = DEV_HttpLog;
//    /**
//     * 体验店。百度地图云检索数据库
//     */
//    public static int GEO_TABLE_ID = DEV_GEO_TABLE_ID_4_BAIDU_MAP;

    /**------------------------------------测试环境使用的配置---------------------------------------*/
//    /**
//     * API 域名
//     */
//    public static final String BASE_URL = TEST_BASE_URL;
//    /**
//     * 蓝牙
//     */
//    public static final String BASE_BLE_URL = TEST_BLE_URL;
//    /**
//     * Log日志输出
//     */
//    public static boolean printDebugLog = TEST_DebugLog;
//    /**
//     * H5 域名
//     */
//    public static final String WEB_URL = TEST_WEB_UEL;
//    /**
//     * 易时租
//     */
//    public static String RENT_URL = TEST_RENT_URL;
//    /**
//     * http请求日志输出
//     */
//    public static HttpLoggingInterceptor.Level printLogWith = TEST_HttpLog;
//    /**
//     * 体验店。百度地图云检索数据库
//     */
//    public static int GEO_TABLE_ID = TEST_GEO_TABLE_ID_4_BAIDU_MAP;

    /**
     * ------------------------------------正式环境使用的配置---------------------------------------
     */
    /**
     * API 域名
     */
    public static final String BASE_URL = RELEASE_BASE_URL;
    /**
     * 蓝牙
     */
    public static final String BASE_BLE_URL = RELEASE_BLE_URL;
    /**
     * H5 域名
     */
    public static final String WEB_URL = RELEASE_WEB_UEL;
    /**
     * Log日志输出

     */
    public static boolean printDebugLog = RELEASE_DebugLog;
    /**
     * 易时租
     */
    public static String RENT_URL = RELEASE_RENT_URL;
    /**
     * http请求日志输出
     */
    public static HttpLoggingInterceptor.Level printLogWith = RELEASE_HttpLog;
    public static int GEO_TABLE_ID = RELEASE_GEO_TABLE_ID_4_BAIDU_MAP;
//
//
//    private String[] BASE_URLS = {DEV_BASE_URL, TEST_BASE_URL, RELEASE_BASE_URL};

    /**
     * -------------------------------------------------------------------------------------
     */
 
    
}
