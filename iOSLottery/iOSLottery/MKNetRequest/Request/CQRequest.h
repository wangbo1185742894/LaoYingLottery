//
//  CQCacheRequest.h
//  caiqr
//
//  Created by 彩球 on 16/9/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseRequest.h"

@class CQRequest;

typedef void(^requestCacheCompletion)( CQRequest* __nonnull request);

@interface CQRequest : CLBaseRequest

/** 是否缓存数据 */
@property (nonatomic) BOOL storeCache;

@property (nonatomic) NSInteger cacheTimeInSeconds;
/** 缓存内容 */
@property (nonatomic, strong, nullable) id cacheObject;

/// 返回当前缓存的对象
- (id __nullable)cacheJson;

///// 是否当前的数据从缓存获得
//- (BOOL)isDataFromCache;
//
///// 返回是否当前缓存需要更新
//- (BOOL)isCacheVersionExpired;
//
///// 强制更新缓存
//- (void)startWithoutCache;

/// 手动将其他请求的JsonResponse写入该请求的缓存
//- (void)saveJsonResponseToCacheFile:(id __nullable)jsonResponse;

//- (long long)cacheVersion;
//- (nullable id)cacheSensitiveData;

@property (nonatomic, copy) requestCacheCompletion __nullable requestCacheCompletion;

+ (BOOL) clearAllCaches;

@end
