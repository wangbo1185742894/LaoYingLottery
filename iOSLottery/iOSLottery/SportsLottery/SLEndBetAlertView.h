//
//  SLEndBetAlertView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , SLEndBetGuideType) {
    
    SLEndBetGuideTypeEnd = 0,
    SLEndBetGuideTypeNoSale
};

@interface SLEndBetAlertView : UIView

@property (nonatomic, copy) void(^jumpLotteryBlock)();

@property (nonatomic, assign) SLEndBetGuideType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *desText;

@property (nonatomic, strong) NSString *jumpButtonTitle;

@end
