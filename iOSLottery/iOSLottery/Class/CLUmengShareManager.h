//
//  CLUmengShareManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/29.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>


@class CLUmengLoginResult;

typedef NS_ENUM(NSInteger , CLUmengPlatformType) {
    /**新浪*/
    CLUmengPlatformTypeForSina = 0,
    /**微信*/
    CLUmengPlatformTypeForWecha = 1,
    /**QQ*/
    CLUmengPlatformTypeForQQ = 4,
};

@interface CLUmengShareManager : NSObject

//typedef NS_ENUM(NSInteger,UMSocialPlatformType)
//{
//    UMSocialPlatformType_UnKnown            = -2,
//    //预定义的平台
//    UMSocialPlatformType_Predefine_Begin    = -1,
//    UMSocialPlatformType_Sina               = 0, //新浪
//    UMSocialPlatformType_WechatSession      = 1, //微信聊天
//    UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
//    UMSocialPlatformType_WechatFavorite     = 3,//微信收藏
//    UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
//    UMSocialPlatformType_Qzone              = 5,//qq空间
//    UMSocialPlatformType_TencentWb          = 6,//腾讯微博
//    UMSocialPlatformType_AlipaySession      = 7,//支付宝聊天页面
//    UMSocialPlatformType_YixinSession       = 8,//易信聊天页面
//    UMSocialPlatformType_YixinTimeLine      = 9,//易信朋友圈
//    UMSocialPlatformType_YixinFavorite      = 10,//易信收藏
//    UMSocialPlatformType_LaiWangSession     = 11,//点点虫（原来往）聊天页面
//    UMSocialPlatformType_LaiWangTimeLine    = 12,//点点虫动态
//    UMSocialPlatformType_Sms                = 13,//短信
//    UMSocialPlatformType_Email              = 14,//邮件
//    UMSocialPlatformType_Renren             = 15,//人人
//    UMSocialPlatformType_Facebook           = 16,//Facebook
//    UMSocialPlatformType_Twitter            = 17,//Twitter
//    UMSocialPlatformType_Douban             = 18,//豆瓣
//    UMSocialPlatformType_KakaoTalk          = 19,//KakaoTalk
//    UMSocialPlatformType_Pinterest          = 20,//Pinteres
//    UMSocialPlatformType_Line               = 21,//Line
//    
//    UMSocialPlatformType_Linkedin           = 22,//领英
//    
//    UMSocialPlatformType_Flickr             = 23,//Flickr
//    
//    UMSocialPlatformType_Tumblr             = 24,//Tumblr
//    UMSocialPlatformType_Instagram          = 25,//Instagram
//    UMSocialPlatformType_Whatsapp           = 26,//Whatsapp
//    UMSocialPlatformType_DingDing           = 27,//钉钉
//    
//    UMSocialPlatformType_YouDaoNote         = 28,//有道云笔记
//    UMSocialPlatformType_EverNote           = 29,//印象笔记
//    UMSocialPlatformType_GooglePlus         = 30,//Google+
//    UMSocialPlatformType_Pocket             = 31,//Pocket
//    UMSocialPlatformType_DropBox            = 32,//dropbox
//    UMSocialPlatformType_VKontakte          = 33,//vkontakte
//    UMSocialPlatformType_FaceBookMessenger  = 34,//FaceBookMessenger
//    
//    UMSocialPlatformType_Predefine_end      = 999,
//    
//    //用户自定义的平台
//    UMSocialPlatformType_UserDefine_Begin = 1000,
//    UMSocialPlatformType_UserDefine_End = 2000,
//};

/**
 关于plist文件itme字段说明
 type : 平台类别
 type的值可以查看上面UMSocialPlatformType的值
 appKey :
 appSecret:
 redirectURL : url失败回调地址

 */

/**
 注册appKey以及各平台参数
 */
+ (void)registerAppKeyAndThirdPartyParameter;
/**
 分享标准样式

 @param titile 分享的标题
 @param context 分享内容的详情
 @param image 分享的图片
 @param placeholdermage 分享的占位图
 @param url 分享的url
 @param complete 分享完成回调
 */
+ (void)umemgShareMessageWithTitile:(NSString *)titile
                        contentText:(NSString *)context
                              image:(NSString *)image
                   placeholderImage:(NSString *)placeholdermage
                                url:(NSString *)url
                           complete:(void(^)(BOOL isSuccess))complete;


/**
 分享图片样式
 @param shareImage 分享的图片
 */
+ (void)umengShareMessageWithImage:(UIImage *)shareImage;

/**
 第三方登录授权
 
 @param logintyp 登录的授权平台类型，这里的枚举只有常用的三个，如果需要其他平台可以看UMSocialPlatformType值，传integer类型即可。例如@(2);
 @param loginResult 登录授权成功回调
 */
+ (void)umengThirdParyLoginForPlatformType:(CLUmengPlatformType)logintyp complete:(void(^)(CLUmengLoginResult *loginResult))loginResult;

/****************************************************************************************************/
//iOS8以及以下系统的回调方法
+ (BOOL)umengOpenUrlOpenURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation;

//iOS9以及以上系统的回调方法
+ (BOOL)umengOpenUrliOS9OpenURL:(NSURL *)url options:(NSDictionary *)options;

@end

@interface CLUmengLoginResult : NSObject

/**
 用户ID
 */
@property (nonatomic, strong, readonly) NSString *uid;

/**
 用户名
 */
@property (nonatomic, strong, readonly) NSString *userName;

/**
 用户性别
 */
@property (nonatomic, strong, readonly) NSString *userGender;

/**
 用户头像
 */
@property (nonatomic, strong, readonly) NSString *iconUrl;


+ (CLUmengLoginResult *)clUmengLoginResultWithUid:(NSString *)uid userName:(NSString *)username userGender:(NSString *)usergenger iconUrl:(NSString *)iconUrl;

- (instancetype)initWithUid:(NSString *)uid userName:(NSString *)username userGender:(NSString *)usergenger iconUrl:(NSString *)iconUrl;

@end



