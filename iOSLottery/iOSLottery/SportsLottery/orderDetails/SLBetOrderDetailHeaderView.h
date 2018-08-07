//
//  CQBetOrderDetailProcessView.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//
//投注订单详情页的头部视图
#import <UIKit/UIKit.h>

@interface SLBetOrderDetailHeaderView : UIView

@property (nonatomic, copy) void(^continuePayBlock)(UIButton *);
@property (nonatomic, copy) void(^awardImageViewClick)();
@property (nonatomic, copy) void(^notWinImageViewClick)();

@property (nonatomic, copy) void(^refundClick)();

/**
 根据数据设置UI
 */
- (void)assignUIWithData:(id)data;
//重置再接再厉图片
- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage;

- (void)stopTimer;
@end


@interface SLBetODHeaderTitleView : UIView

- (void)setTitleName:(NSString *)title detail:(NSString *)detail isBasketBall:(BOOL)isBas;

@end

@interface SLBetODHeaderRefundView : UIView

@property (nonatomic, strong) NSString *orderStatus;

@property (nonatomic, assign) NSInteger height;

@property (nonatomic, copy) void(^refundBlock)();

@end

