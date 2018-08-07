                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        //
//  CLAwardGameListAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardGameListAPI.h"
#import "CLAwardVoModel.h"
#import "CLAppContext.h"
@interface CLAwardGameListAPI () <CLBaseConfigRequest>

@property (nonatomic, strong) NSMutableArray* datas;

@end

@implementation CLAwardGameListAPI

- (NSString *)methodName {
    return @"qq";

};

- (NSString *)requestBaseUrlSuffix {
    
    return [NSString stringWithFormat:@"/index/notice/%@",self.gameEn];
}



- (void)deallingWithData:(NSArray*)array {
    
    if (self.datas && self.datas.count > 0) {
        [_datas removeAllObjects];
    }
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.datas addObject:[CLAwardVoModel mj_objectWithKeyValues:obj]];
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
