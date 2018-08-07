//
//  CQCacheRequest.m
//  caiqr
//
//  Created by 彩球 on 16/9/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQRequest.h"

static NSString *const CaiqrBaseDataCachesDirPath = @"CaiqrBaseDataCaches/";

#define CQRequestErrorDomain @"com.caiqr.nets.domain"

@implementation CQRequest

- (void)start
{
    BOOL valid = YES;// [self checkRequestConfigValid];
    
    if (!valid) {
        
        NSError* error = [NSError errorWithDomain:CQRequestErrorDomain code:CLRequestErrorValidBody userInfo:@{NSLocalizedDescriptionKey:@"post request body is invalid"}];
        
        [self setValue:error forKey:@"requestOperationError"];
        
        [self requestFailedFilter];
        
        if (self.failureCompletionBlock) {
            self.failureCompletionBlock(self);
        }
        
        if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
            [self.delegate requestFailed:self];
        }

        return;
    }
    
    [super start];
    
    if (self.storeCache && [self checkCacheFileDurationValid]) {
        id cacheJson = [self cacheJson];
        if (cacheJson) {
            self.cacheObject = cacheJson;
            if (self.requestCacheCompletion) {
                self.requestCacheCompletion(self);
            }
        }
    }
}


//请求完成
- (void)requestCompleteFilter
{
//    [super requestCompleteFilter];
//    if (!self.storeCache) return;
//    [self saveJsonResponseToCacheFile:self.responseObject];
    
}

//请求失败
- (void)requestFailedFilter
{
//    [super requestFailedFilter];
}

#pragma mark - Cache Save & Path

/** 沙盒路径 */
+ (NSString *)cacheBasePath {
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:CaiqrBaseDataCachesDirPath];

    [CQRequest checkDirectory:path];
    return path;
}

+ (void)checkDirectory:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/** 生产缓存文件名 */
- (NSString *)cacheFileName {
    return @"";
//    NSString *requestInfo = [NSString stringWithFormat:@"Argument:%@",[self requestArgumentKeys]];
//    NSString *cacheFileName = [requestInfo md5];
//    return cacheFileName;
}


/** 拼装缓存文件唯一标识 */
- (NSString*)requestArgumentKeys
{
    NSMutableString* keys = [NSMutableString stringWithCapacity:0];
//    if (self.reqUrlSuffix && (self.reqUrlSuffix.length > 0)) {
//        [keys appendFormat:@"url-%@;",self.reqUrlSuffix];
//    }
//    
//    if (self.requestArgument &&
//        [[self.requestArgument allKeys] containsObject:@"cmd"] &&
//        [self.requestArgument[@"cmd"] isKindOfClass:NSString.class] &&
//        ([self.requestArgument[@"cmd"] length] > 0)) {
//        [keys appendFormat:@"cmd-%@",self.requestArgument[@"cmd"]];
//    }
//    
    return keys;
}

/** 缓存内容文件路径 */
- (NSString *)cacheFilePath {
    NSString *cacheFileName = [self cacheFileName];
    NSString *path = [CQRequest cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

/** 缓存版本文件路径 */
- (NSString *)cacheVersionFilePath {
    NSString *cacheVersionFileName = [NSString stringWithFormat:@"%@.version", [self cacheFileName]];
    NSString *path = [CQRequest cacheBasePath];
    path = [path stringByAppendingPathComponent:cacheVersionFileName];
    return path;
}

/** 获取缓存文件时长 */
- (int)cacheFileDuration:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // get file attribute
    NSError *attributesRetrievalError = nil;
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:path
                                                             error:&attributesRetrievalError];
    if (!attributes) {
        NSLog(@"Error get attributes for file at %@: %@", path, attributesRetrievalError);
        return -1;
    }
    int seconds = -[[attributes fileModificationDate] timeIntervalSinceNow];
    return seconds;
}

/** 检测缓存时效是否有效 */
- (BOOL)checkCacheFileDurationValid
{
    int seconds = [self cacheFileDuration:[self cacheFilePath]];
    if (seconds < 0 || seconds > self.cacheTimeInSeconds) {
        return NO;
    } else {
        return YES;
    }
}


/** 本地化缓存 */
- (void)saveJsonResponseToCacheFile:(id)jsonResponse {
    if (self.cacheTimeInSeconds > 0) {
        NSDictionary *json = jsonResponse;
        if (json != nil) {
            
            [NSKeyedArchiver archiveRootObject:json toFile:[self cacheFilePath]];
        }
    }
}

/** 获取缓存 */
- (id)cacheJson {
    id _cacheJson = nil;
    NSString *path = [self cacheFilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
        _cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return _cacheJson;
    
}

#pragma mark - clear caches

+ (BOOL) clearAllCaches
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[CQRequest cacheBasePath]]) {
        return [fileManager removeItemAtPath:[CQRequest cacheBasePath] error:nil];
    }
    return NO;
    
}

#pragma mark - getter method

- (NSInteger)cacheTimeInSeconds
{
    if (_cacheTimeInSeconds <= 0) {
        return NSIntegerMax;
    }
    return _cacheTimeInSeconds;
}

@end
