//
//  CQBetODHeaderMoneySubView.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//
/**
 * 投注订单详情的头部视图的 子视图  目前类型  1、普通展示 金额  2、图片展示是否中奖  3、倒计时展示
 */

#import <UIKit/UIKit.h>

//视图样式  普通label  图片  倒计时
typedef NS_ENUM(NSInteger, SLBODHeaderMoneyType) {
    
    SLBODHeaderMoneyTypeDefault = 0,
    SLBODHeaderMoneyTypeImage = 1,
    SLBODHeaderMoneyTypeButton
};
//右侧有无竖线
typedef NS_ENUM(NSInteger, CQBODHeaderMoneyLineType) {
    CQBODHeaderMoneyLineTypeNone = 0,
    CQBODHeaderMoneyLineTypeLine
};

@interface SLBetODHeaderMoneySubView : UIView

@property (nonatomic, assign) CQBODHeaderMoneyLineType headerMoneyLineType;
@property (nonatomic, assign) BOOL isFirstAllocView;
@property (nonatomic, copy) void(^continuePayBlock)(UIButton *);
@property (nonatomic, copy) void(^awardImageViewClick)();//中奖图标点击
@property (nonatomic, copy) void(^notWinImageViewClick)();//中奖图标点击

- (void)startShowAnimation;

- (void)assignHeaderMoneyWithData:(id)data HeaderType:(SLBODHeaderMoneyType)type;

- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage;

- (void)stopTimer;
@end
