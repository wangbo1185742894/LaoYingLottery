//
//  CQLaunchConf.h
//  caiqr
//
//  Created by 彩球 on 16/6/15.
//  Copyright © 2016年 Paul. All rights reserved.
//

#ifndef CQLaunchConf_h
#define CQLaunchConf_h

//网络API Debug   1 线上  0测试
#define APP_NETAPI_RELEASE 0

#define APP_API_VERSION @"1.2"

#define APP_DEBUG_STATUS  1

#if APP_DEBUG_STATUS
#define UMENG_APPKEY @"54ddb405fd98c5cc3e00026b" //测试key
#else
#define UMENG_APPKEY @"55079ffffd98c5e736000615" //正式key
#endif

#define GETUISERVICE [[NSBundle mainBundle] objectForInfoDictionaryKey:@"getuiSupport"]


//tabbar导航 版本号,3.9.85开始 版本升级时需要酌情考虑修改
#define TabbarInfo_version @"1.0"


//更新升级提示 网络请求  版本号的替代
/*当前版本 V3.9.6 -> @"41"*/
#define APP_UPDATE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_update_version"]
/** app支付版本 */
#define CQPayVERSION @"4.0"

#if APP_NETAPI_RELEASE

#define CQTalkingDataAppID [[NSBundle mainBundle] objectForInfoDictionaryKey:@"talkingDataAppID"]

#else

#define CQTalkingDataAppID @"bd199d61aa604dc9a4b371492083200c"

#endif
//七牛正式
#define QINIU_Scope @"football"
#define QINIU_SecretKey @"ZTJxJsfSK1Ddd3uUWuI5EyF3XrsfUVavSYBaNIs3"
#define QINIU_Accesskey @"cPSC_aA8oybkt0Gzi6icpMirU-TMKgQiP_EQTwO7"
#define QINIU_PIC_HTTP_PREFIX  @"http://7vzspj.com2.z0.glb.qiniucdn.com/"
//支持银行卡页面url
#define CQ_SUPPLE_BANKCARD_URL_PREFIX @"https://cashier.caiqr.com/bankCards.html"

//talkingDataAppID

/*
 *  client_type  客户端类型
 *  ios: 1 彩球主客户端
 11 易播客户端
 21 彩球投注版
 */
#define CQ_Client_Type  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"client_type"]

/** Channel_Id 渠道统计
 *  APPSTORE 彩球主客户端
 *  APPSTORE 易播客户端
 *           彩球投注版
 */

#define CQ_Channel_ID [[NSBundle mainBundle] objectForInfoDictionaryKey:@"channel_id"]
#define CQ_Scheme [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CaiqrUrlScheme"]


#define CQ_Client_SuppleShare [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"client_suppleShare"] intValue]
#define CQ_Client_SuppleThirdLogin [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"client_suppleThirdLogin"] intValue]


#endif /* CQLaunchConf_h */
