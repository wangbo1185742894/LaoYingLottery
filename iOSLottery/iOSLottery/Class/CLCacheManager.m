//
//  CLCacheManager.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLCacheManager.h"
#import "CLArchiverData.h"
#import "CLAppContext.h"

static NSString* cache_fileNameArray = @"CLAllCacheFileListNameArray";

static NSString* cache_Home = @"CLHomeCacheFileListName";

static NSString* cache_AwardAnnouncement = @"CLAwardAnnouncementCacheFileListName";

static NSString* cache_LaunchActivity = @"CLLaunchActivityCacheFileListName";

static NSString*  cache_AwardAnnouncementSort = @"CLAwardAnnouncementCacheFileListNameSort";

@implementation CLCacheManager

+ (BOOL)saveToCacheWithContent:(id)content cacheFile:(CLCacheFileName)fileStyle
{
    [CLCacheManager checkCacheNameExistWithString:[CLCacheManager getCacheFileNameWithStyle:fileStyle]];
    return [[CLArchiverData sharedManager] saveToFile:content FileName:[CLCacheManager getCacheFileNameWithStyle:fileStyle]];
}

+ (id)getCacheFormLocationFileWithName:(CLCacheFileName)fileStyle
{
    return [[CLArchiverData sharedManager] getFromFileWithFileName:[CLCacheManager getCacheFileNameWithStyle:fileStyle]];
}

+ (BOOL)saveToCacheWithContent:(id)content cacheFileName:(NSString*)fileName
{
    [CLCacheManager checkCacheNameExistWithString:fileName];
    return [[CLArchiverData sharedManager] saveToFile:content FileName:fileName];
}


+ (id)getCacheFormLocationcacheFileWithName:(NSString*)fileName
{
    return [[CLArchiverData sharedManager] getFromFileWithFileName:fileName];
}

+ (BOOL)saveToNoableClearCacheWithContent:(id)content cacheFileName:(NSString *)fileName{
    
    return [[CLArchiverData sharedManager] saveNoableClearToFile:content FileName:fileName];
}

+ (id)getNoableClearCacheFormLocationcacheFileWithName:(NSString *)fileName{
    
    return [[CLArchiverData sharedManager] getNoableClearFromFileWithFileName:fileName];
}
+ (void)saveCacheFileList
{
    [[CLArchiverData sharedManager] saveToFile:[CLAppContext context].cacheFileListArrays FileName:cache_fileNameArray];
}

+ (NSMutableArray *)getCacheFileList
{
    return [NSMutableArray arrayWithArray:[[CLArchiverData sharedManager] getFromFileWithFileName:cache_fileNameArray]];
}

+ (void)checkCacheNameExistWithString:(NSString*)cacheFileName
{
    if (![[CLAppContext context].cacheFileListArrays containsObject:cacheFileName])
    {
        [[CLAppContext context].cacheFileListArrays addObject:cacheFileName];
        [self saveCacheFileList];
    }
}

//清空所有缓存数据
+ (BOOL)clearAllCacheFileWith:(SDWebImageNoParamsBlock)block
{

    [[SDImageCache sharedImageCache] clearDiskOnCompletion:block];
    [CLCacheManager clearTextCacheTypeIsAll:YES];
    return YES;
}

+ (void)clearTextCacheTypeIsAll:(BOOL)isAll
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString* documentPath = [CLArchiverData getCanClearDocumentPath];
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [[CLAppContext context].cacheFileListArrays enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            
            if (isAll) {
                NSString *arrayFilePath = [documentPath stringByAppendingPathComponent:obj];
                [fileManager removeItemAtPath:arrayFilePath error:nil];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
        });
    });
    
}

//计算当前app缓存数据大小
+ (NSString*)calculateAllCacheFileCount
{
    NSString* documentPath = [CLArchiverData getCanClearDocumentPath];
    long long __block __fileCount = 0;
    [[CLAppContext context].cacheFileListArrays enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        NSString *arrayFilePath = [documentPath stringByAppendingPathComponent:obj];
        __fileCount += [CLCacheManager fileSizeAtPath:arrayFilePath];
    }];
    
    __fileCount += [[SDImageCache sharedImageCache] getSize];
    
    CGFloat count = __fileCount/(1024.0f);
    if (count > 1024.f)
    {
        return [NSString stringWithFormat:@"%.2fM",(count / 1024.0f)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2fK",count];
    }
    
}

+ (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//匹配不同缓存文件名字
+ (NSString*)getCacheFileNameWithStyle:(CLCacheFileName)fileStyle
{
    switch (fileStyle) {
        case CLCacheFileNameHome:
            return cache_Home;break;
        case CLCacheFileNameAwardAnnouncement:
            return cache_AwardAnnouncement;break;
        case CLCacheFileNameLaunchActivity:
            return cache_LaunchActivity;break;
        case CLCacheFileNameAwardAnnouncementSort:
            return cache_AwardAnnouncementSort;break;
        default:
            break;
    }
    return @"";
}

@end
