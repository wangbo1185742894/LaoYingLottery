//
//  CLLaunchActivityManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLaunchActivityManager.h"
#import "CLCacheManager.h"
#import "CLAppContext.h"
#import "CLFirstStartModel.h"
#import "CaiqrWebImage.h"
#import "CLTools.h"
@implementation CLLaunchActivityManager

+ (void)saveLaunchActivityData{
    
    //数据校验
    if (!([[CLAppContext context] firstStartInfo].advertVos && [[CLAppContext context] firstStartInfo].advertVos.count > 0)) return;
    
    __block NSMutableDictionary *modelDic = [NSMutableDictionary dictionaryWithDictionary:[[CLAppContext context] firstStartInfo].advertVos[0]];
    
    //校验是否已经缓存或图片
//    if ([self getLaunchActivityImageData] && ([self getLaunchActivityImageData].imgUrl == model.imgUrl)) return;
    
    //请求图片 并缓存
    [CaiqrWebImage downloadImageUrl:modelDic[@"imgUrl"] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
        
        if (image) {
            [modelDic setObject:image forKey:@"downloadImage"];
            [modelDic setObject:@([[CLAppContext context] firstStartInfo].advertTime > 0 ? [[CLAppContext context] firstStartInfo].advertTime : 5) forKey:@"cutDownTime"];
            [CLCacheManager saveToCacheWithContent:modelDic cacheFile:CLCacheFileNameLaunchActivity];
        }
    }];
}

+ (CLLaunchActivityModel *)getLaunchActivityImageData{
    
    NSDictionary *dic = [CLCacheManager getCacheFormLocationFileWithName:CLCacheFileNameLaunchActivity];
    if (!(dic && dic.count > 0)) return nil;
    CLLaunchActivityModel * model = [CLLaunchActivityModel mj_objectWithKeyValues:dic];
    model.downloadImage = dic[@"downloadImage"];
    //校验活动是否过期
    //获取当前系统时间
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    
    if ([CLTools compareDate:dateTime withDate:model.endTime] == -1) {
        //未过期
        return model;
    } ;
    return nil;
}
@end
