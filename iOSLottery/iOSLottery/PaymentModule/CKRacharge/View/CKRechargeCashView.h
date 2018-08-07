//
//  CKRechargeCashView.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CKRechargeCashViewDelegate <NSObject>

@optional
//监听充值金额改变
- (void)rechargeCashChange:(long long)cash;
//vip客服
- (void)vipService;
//最低充值金额，最低充值信息
- (void)limitMoney:(NSInteger)limitMoney limit_msg:(NSString *)msg;

@end

@interface CKRechargeCashView : UIView

@property (nonatomic, weak) id <CKRechargeCashViewDelegate> delegate;

@property (nonatomic, assign) NSInteger defaultAmount;

/**
 设置数据源
 */
- (void)configureFillList:(NSArray*)fillList bigMoney:(NSArray *)bigMoney template:(NSString *)templateValue;

/**
 设置最小输入金额
 */
- (void)configminRechargeMoney:(NSArray *)minRechargeMoney;


/**
 配置颜色

 @param textColor 输入框文字颜色
 @param normalBackColor 按钮背景色
 @param normalTextColor 按钮文字颜色
 @param selectedBackColor 选中时按钮背景色
 @param selectedTextColor 选中时按钮文字颜色
 */
- (void)configureInputTextColor:(UIColor *)textColor
    buttonNormalBackgroundColor:(UIColor *)normalBackColor
          buttonNormalTextColor:(UIColor *)normalTextColor
  buttonselectedBackgroundColor:(UIColor *)selectedBackColor
        buttonselectedTextColor:(UIColor *)selectedTextColor;

/**
 是否限制输入框直接输入

 @param isLimit 是否限制
 */
- (void)inputCashContentLimit:(BOOL) isLimit;

/**
 获取输入框输入金额
 */
- (long long)getRechargeMoney;

@end

@interface CKRechargeTextField : UITextField

@end
