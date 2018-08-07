//
//  CQUserBalanceHeaderView.h
//  caiqr
//
//  Created by 小铭 on 16/3/31.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,userBalanceHeaderViewClickStyle)
{
    /** 用户充值点击事件*/
    userBalanceHeaderViewDepositClick = 0,
    /** 用户提现点击事件 */
    userBalanceHeaderViewWithdrawClick,
    /** 用户兑换红包点击事件 */
    userBalanceHeaderViewConversionClick
};

typedef void(^userBalanceHeaderViewActionBlock)(userBalanceHeaderViewClickStyle clickStyle);

/**
 *  用户流水headerView
 */
@interface CQUserBalanceHeaderView : UIView

@property (nonatomic, copy) userBalanceHeaderViewActionBlock clickActionBlock;  //用户点击block
/**
 *  用户流水headerView创建
 */
+ (instancetype)createUserBalanceHeaderView:(id)userAccount actionBlock:(userBalanceHeaderViewActionBlock)actionBlock;

/**
 配置数据

 @param object 数据
 */
- (void)assignDataWithObject:(id)object;
@end
