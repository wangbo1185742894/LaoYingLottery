//
//  CLCacheManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDImageCache.h"
typedef NS_ENUM(NSInteger, CLCacheFileName)
{
    CLCacheFileNameHome = 0,//首页
    CLCacheFileNameAwardAnnouncement,//开奖公告
    CLCacheFileNameLaunchActivity, //活动页
    CLCacheFileNameAwardAnnouncementSort//开奖公告排序记录  //存的是字典  key：gameEn  value:用户点击次数（NSNumber）
};
//双色球 大乐透 弹窗 是否第一次展示 记录
static NSString *ssqOmissionPrompt = @"ssqomissionPrompt";
static NSString *dltOmissionPrompt = @"dltomissionPrompt";
@interface CLCacheManager : NSObject

//保存某一项缓存数据
+ (BOOL)saveToCacheWithContent:(id)content cacheFile:(CLCacheFileName)fileStyle;
//获取某一项缓存数据
+ (id)getCacheFormLocationFileWithName:(CLCacheFileName)fileStyle;


/**
 * 根据文件名缓存数据到本地
 */

+ (BOOL)saveToCacheWithContent:(id)content cacheFileName:(NSString*)fileName;

/**
 * 获取文件名缓存的数据
 */

+ (id)getCacheFormLocationcacheFileWithName:(NSString*)fileName;

/**
 * 根据文件名缓存数据到本地 数据不可被清空
 */

+ (BOOL)saveToNoableClearCacheWithContent:(id)content cacheFileName:(NSString*)fileName;

/**
 * 获取文件名缓存的数据 不可被清空的数据
 */

+ (id)getNoableClearCacheFormLocationcacheFileWithName:(NSString*)fileName;

/**
 *  清空所有缓存数据包括Json和图片
 */
+ (BOOL)clearAllCacheFileWith:(SDWebImageNoParamsBlock)block;

/**
 *  清空Json内容缓存数据
 *  @Param isAll 是否清除所有缓存
 */
+ (void)clearTextCacheTypeIsAll:(BOOL)isAll;


//计算当前app缓存数据大小
+ (NSString*)calculateAllCacheFileCount;


/**
 保存本地缓存文件名
 */
+ (void)saveCacheFileList;

/**
 获取本地缓存文件名

 @return 本地缓存文件名
 */
+ (NSMutableArray*)getCacheFileList;

@end
