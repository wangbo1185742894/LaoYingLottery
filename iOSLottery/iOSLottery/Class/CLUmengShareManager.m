//
//  CLUmengShareManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/29.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLUmengShareManager.h"
#import "UMSocialCore/UMSocialCore.h"
#import "UMMobClick/MobClick.h"
#import "CLConfigAPIMessage.h"
#import "CLAppContext.h"
#import "UShareUI/UShareUI.h"
#import <UMSocialUIManager.h>
@interface CLUmengShareManager ()

@end

@implementation CLUmengShareManager


static NSMutableArray *_platforms;

+ (void)registerAppKeyAndThirdPartyParameter
{
    [self configurationAppKeyParametersWithDictionary:[self acquireShareInfoDictionary]];
    
    [self configurationPlatformWithDictionary:[self acquireShareInfoDictionary]];

}

//获取配置info字典
+ (NSDictionary *)acquireShareInfoDictionary
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"share" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

//设置appKey
+ (void)configurationAppKeyParametersWithDictionary:(NSDictionary *)dict
{

    if (!dict) return;
    
    NSString *appKey = @"";
    if (API_Environment == 1) {
        
        appKey = [[dict objectForKey:@"appKey"] objectForKey:@"online"];//线上
    }else{
        
        appKey = [[dict objectForKey:@"appKey"] objectForKey:@"CVT"];
        [[UMSocialManager defaultManager] openLog:YES];
    }
    
    UMConfigInstance.appKey = appKey;
    
//    [[UMSocialManager defaultManager] setUmSocialAppkey:appKey];
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    UMConfigInstance.channelId = [dict objectForKey:@"channelId"];;
    
    UMConfigInstance.eSType = E_UM_NORMAL;
    
    [MobClick setLogEnabled:YES];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    NSString* verson = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [MobClick setAppVersion:verson];

}

//配置平台参数
+ (void)configurationPlatformWithDictionary:(NSDictionary *)dict
{
    NSArray *tempArr = dict[@"platform"];
    
    _platforms = [NSMutableArray arrayWithCapacity:tempArr.count];
    
    for (NSDictionary *dict in tempArr) {
        
        NSInteger type = [dict[@"type"] integerValue];
        
        if (type == 1) {
            
            [_platforms addObject:@(type)];
            [_platforms addObject:@(2)];
            
        }else{
        
            [_platforms addObject:@(type)];
        }
        
        [[UMSocialManager defaultManager] setPlaform:[dict[@"type"] integerValue] appKey:dict[@"appKey"] appSecret:dict[@"appSecret"] redirectURL:dict[@"redirectUrl"]];
    }

}


//分享内容设置并弹出分享面板
+ (void)umemgShareMessageWithTitile:(NSString *)titile contentText:(NSString *)context image:(NSString *)image placeholderImage:(NSString *)placeholdermage url:(NSString *)url complete:(void(^)(BOOL isSuccess))complete;
{

    [UMSocialUIManager setPreDefinePlatforms:_platforms];
    
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        // 根据获取的platformType确定所选平台进行下一步操作
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString *sharContentString = context;
        
        //设置内容页的image
        
        UIImage *thumImage;
        
        if (placeholdermage && placeholdermage.length > 0) {
            
            thumImage = [UIImage imageNamed:placeholdermage];
        }else{
            
            thumImage = [UIImage imageNamed:@"aboutUs"];
        }
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titile descr:sharContentString thumImage:image.length > 0 ? image : thumImage];
        
        //设置网页地址
        if (url && url.length > 0) {
            
            shareObject.webpageUrl = url;
        }else{
            
            shareObject.webpageUrl = @"http://www.caiqr.com";
        }
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                
                if (complete) {
                    
                    complete(NO);
                }
                
            }else{
                NSLog(@"response data is %@",data);
                //分享成功
                if (complete) {
                    
                    complete(YES);
                }
            }
            
        }];
    }];
}

+ (void)umengShareMessageWithImage:(UIImage *)shareImage
{
    
    [UMSocialUIManager setPreDefinePlatforms:_platforms];

    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
       
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"icon"];
        [shareObject setShareImage:shareImage];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
    }];

}

//授权登录
+ (void)umengThirdParyLoginForPlatformType:(CLUmengPlatformType)logintyp complete:(void (^)(CLUmengLoginResult *))loginResult
{
    UMSocialPlatformType tpye = (UMSocialPlatformType)logintyp;
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:tpye currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        NSLog(@" uid: %@", resp.uid);
        NSLog(@" openid: %@", resp.openid);
        NSLog(@" accessToken: %@", resp.accessToken);
        NSLog(@" refreshToken: %@", resp.refreshToken);
        NSLog(@" expiration: %@", resp.expiration);
        
        // 用户数据
        NSLog(@" name: %@", resp.name);
        NSLog(@" iconurl: %@", resp.iconurl);
        NSLog(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        NSLog(@" originalResponse: %@", resp.originalResponse);
        
        //CLUmengLoginResult *loginDate = [CLUmengLoginResult clUmengLoginResultWithUid:resp.uid userName:resp.name userGender:resp.gender iconUrl:resp.iconurl];
        
        CLUmengLoginResult *loginDate = [CLUmengLoginResult clUmengLoginResultWithUid:@"10086"userName:@"RPJExtension" userGender:@"男" iconUrl:@"www.caiqr.com"];
        
        loginResult(loginDate);
        
    }];
    
}


+ (BOOL)umengOpenUrlOpenURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation{
    
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:source annotation:annotation];
}

+ (BOOL)umengOpenUrliOS9OpenURL:(NSURL *)url options:(NSDictionary *)options
{
    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
}

@end

@implementation CLUmengLoginResult

+ (CLUmengLoginResult *)clUmengLoginResultWithUid:(NSString *)uid userName:(NSString *)username userGender:(NSString *)usergenger iconUrl:(NSString *_Nullable)iconUrl
{
    return [[self alloc] initWithUid:uid userName:username userGender:usergenger iconUrl:iconUrl];
}

- (instancetype)initWithUid:(NSString *)uid userName:(NSString *)username userGender:(NSString *)usergenger iconUrl:(NSString *_Nullable)iconUrl
{
    self = [super init];
    
    if (self) {
        
        _uid = uid;
        _userName = username;
        _userGender = usergenger;
        _iconUrl = iconUrl;
        
    }
    
    return self;
}

@end



