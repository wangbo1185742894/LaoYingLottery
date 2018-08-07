//
//  CLRedEnvelopAPI.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnvelopAPI.h"
#import "CLAPI.h"
#import "CQUserRedPacketsNewModel.h"
#import "CLAppContext.h"

@interface CLRedEnvelopAPI () <CLBaseConfigRequest>

@property (nonatomic) NSInteger page;

@property (nonatomic) BOOL isLoadMore;

@property (nonatomic, strong) CQUserRedPacketsNewModel* listData;

@end

@implementation CLRedEnvelopAPI

- (NSString *)methodName {

    return @"redEnvelopeListAPI";
}

- (NSDictionary *)requestBaseParams {
    
    
    return @{@"cmd":CMD_RedEnvelopListAPI,
             @"page":[NSString stringWithFormat:@"%zi",self.page],
             @"token":[[CLAppContext context] token],
             @"type":(self.listType == redEnveLoadTypeAvailable)?@"0":@"1"};
}

- (void) refresh {
    
    self.isLoadMore = NO;
    [self start];
}

- (void) nextPage {
    
    self.isLoadMore = YES;
    [self start];
}

- (void)setIsLoadMore:(BOOL)isLoadMore {
    
    _isLoadMore = isLoadMore;
    if (_isLoadMore) {
        self.page++;
    } else {
        self.page = 1;
    }
    
}


- (void)configureRedEnveListDataFromDict:(NSDictionary*)dict {
    
    if (self.listData) {
        self.listData = nil;
    }
    self.listData = [CQUserRedPacketsNewModel mj_objectWithKeyValues:dict];
    self.canLoadingMore = [self.listData.show_more isEqualToString:@"0"];
}

- (CQUserRedPacketsNewModel *) redEnvelistData {
    
    return self.listData;
}

- (BOOL)canLoadingMore {
    
    return _canLoadingMore;
}









@end
