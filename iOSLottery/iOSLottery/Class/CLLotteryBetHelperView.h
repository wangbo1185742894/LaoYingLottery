//
//  CLLotteryBetHelperView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLLotteryBetHelperView : UIView

@property (nonatomic, copy) void(^helperButtonBlock)(UIButton *);
@property (nonatomic, strong) NSArray *titleArray;//titleView

@end
