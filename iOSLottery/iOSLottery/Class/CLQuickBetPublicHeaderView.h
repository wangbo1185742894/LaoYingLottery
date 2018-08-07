//
//  CLQuickBetPublicHeaderView.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CLQuickBetPublicHeaderViewHeight __SCALE(35.f)
@interface CLQuickBetPublicHeaderView : UIView

+ (instancetype)quickBetPublicHeaderViewWithTitle:(NSString *)title backBlock:(void(^)(void))backBlock;

@end
