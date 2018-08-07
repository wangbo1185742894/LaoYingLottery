//
//  CLNewbieGuidanceService.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLNewbieGuidanceType) {
    
    CLNewbieGuidanceTypeHome = 0,
    CLNewbieGuidanceTypeFT, //快三
    CLNewbieGuidanceTypeDe,//D11
    CLNewbieGuidanceTypeOrderList, // 订单列表
    CLNewbieGuidanceTypeFootBall,//足球
    CLNewbieGuidanceTypeBasketBall,//篮球
    CLNewbieGuidanceTypeSSQ,//双色球
    CLNewbieGuidanceTypeDLT//大乐透
};
@interface CLNewbieGuidanceService : NSObject

+ (UIView *)getNewGuidanceViewWithType:(CLNewbieGuidanceType)type;
+ (void)showNewGuidanceInWindowWithType:(CLNewbieGuidanceType)type;
@end
