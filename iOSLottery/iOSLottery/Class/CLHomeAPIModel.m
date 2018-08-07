//
//  CLHomeAPIModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeAPIModel.h"
#import "CLHomeGameEnteranceModel.h"
#import "CLHomeBannerModel.h"
@implementation CLHomeAPIModel

+ (NSDictionary*)objectClassInArray {
    
    return @{@"banners":@"CLHomeBannerModel",@"gameEntrances":@"CLHomeGameEnteranceModel", @"attentionEntrances":@"CLHomeGameEnteranceModel",@"hotGamePeriods":@"CLHomeHotBetModel"};
}

- (void)setBanners:(NSArray *)banners
{
    NSMutableArray *bannerArr = [NSMutableArray array];
    [banners enumerateObjectsUsingBlock:^(CLHomeBannerModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        (obj.imgUrl && obj.imgUrl.length) ? [bannerArr addObject:obj] : nil;
    }];
    _banners = bannerArr;
}

- (void)setGameEntrances:(NSArray *)gameEntrances
{
    NSMutableArray *gameEnArr = [NSMutableArray array];
    [gameEntrances enumerateObjectsUsingBlock:^(CLHomeGameEnteranceModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentUrl && obj.contentUrl.length?[gameEnArr addObject:obj]:nil;
    }];
    
    _gameEntrances = gameEnArr;
}

@end
