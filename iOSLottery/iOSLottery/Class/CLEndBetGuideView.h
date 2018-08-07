//
//  CLEndBetGuideView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , CLEndBetGuideType) {
    
    CLEndBetGuideTypeEnd = 0,
    CLEndBetGuideTypeNoSale
};

@interface CLEndBetGuideView : UIView

@property (nonatomic, copy) void(^jumpLotteryBlock)();

@property (nonatomic, assign) CLEndBetGuideType type;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *desText;

@property (nonatomic, strong) NSString *jumpButtonTitle;

@end
