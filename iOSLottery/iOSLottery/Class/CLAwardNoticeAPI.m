//
//  CLAwardNoticeAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardNoticeAPI.h"
#import "CLAwardVoModel.h"
#import "CLAppContext.h"
#import "CLCacheManager.h"
@interface CLAwardNoticeAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSMutableArray* datas;

@end

@implementation CLAwardNoticeAPI

- (NSString *)methodName {
    return @"/index/notice";
}

- (NSString *)requestBaseUrlSuffix {
    
    return @"/index/notice";
}


- (void)deallingWithData:(NSArray*)array {
    
    if (self.datas && self.datas.count > 0) {
        [_datas removeAllObjects];
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CLAwardVoModel *model = [CLAwardVoModel mj_objectWithKeyValues:obj];
        //v1.0 版本只支持  快三 和 D11
        //v1.1 版本添加 双色球 和 大乐透
        //v1.3 版本添加 足球
        //v1.4 版本添加 篮球
        //v1.5 版本添加 排列3 排列5 福彩3D
        //v1.6 版本添加 七星彩 七乐彩 胜负彩 任选9
        // || [model.gameEn hasSuffix:@"fc3d"]
        if ([model.gameEn hasSuffix:@"Kuai3"] || [model.gameEn hasSuffix:@"11"] || [model.gameEn hasSuffix:@"ssq"] || [model.gameEn hasSuffix:@"dlt"] || [model.gameEn hasSuffix:@"jczq_mix_p"] || [model.gameEn hasSuffix:@"jclq_mix_p"] || [model.gameEn hasSuffix:@"pl3"] || [model.gameEn hasSuffix:@"pl5"] || [model.gameEn hasSuffix:@"fc3d"] || [model.gameEn hasSuffix:@"qxc"] || [model.gameEn hasSuffix:@"qlc"] || [model.gameEn hasSuffix:@"sfc"]) {
            [self.datas addObject:model];
        }
    }];
    
    //按照缓存的顺序 对数组排序
    NSDictionary *sortDic = [CLCacheManager getCacheFormLocationFileWithName:CLCacheFileNameAwardAnnouncementSort];
    [self.datas sortUsingComparator:^NSComparisonResult(CLAwardVoModel *  _Nonnull obj1, CLAwardVoModel *  _Nonnull obj2) {
        
        NSInteger sortCountObj1 = 0;
        if ([sortDic.allKeys containsObject:obj1.gameEn]) {
            sortCountObj1 = [sortDic[obj1.gameEn] integerValue];
        }
        NSInteger sortCountObj2 = 0;
        if ([sortDic.allKeys containsObject:obj2.gameEn]) {
            sortCountObj2 = [sortDic[obj2.gameEn] integerValue];
        }
        return (sortCountObj1 < sortCountObj2);
    }];
}

- (NSArray*)pullData {
    
    return self.datas;
}

- (NSMutableArray *)datas {
    
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}
- (NSDictionary *)requestBaseParams{
    
    return @{@"channel":[CLAppContext channelId]};
}
@end
