//
//  CLCheckProgessManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^checkProcessCallBack)(void);

@interface CLCheckProgessManager : NSObject

+ (instancetype)shareCheckProcessManager;

/**
 校验是否登录

 @param callBack 登录成功后的回调
 */
- (void)checkIsLoginWithCallBack:(checkProcessCallBack)callBack;


/**
 校验是否实名认证

 @param callBack 实名认证后的回调
 */
- (void)checkIsUserCertifyWithCallBack:(checkProcessCallBack)callBack;

/**
 校验是否存在银行卡

 @param selectIndex 选择银行卡位置
 @param callBack    添加银行卡成功的回调
 */
- (void)checkhasBankCardWithSelectIndex:(NSInteger)selectIndex CallBack:(checkProcessCallBack)callBack;


/**
 校验是否存在支付密码

 @param callBack 设置支付密码成功的回调
 */
- (void)checkHasPayPassWordWithCallBack:(checkProcessCallBack)callBack;


/**
 提现的校验流程

 @param selectIndex 校验选择银行卡的位置
 @param callBack    回调
 */
- (void)withdrawCheckProcessWithSelectIndex:(NSInteger)selectIndex callBack:(checkProcessCallBack)callBack;

@end
