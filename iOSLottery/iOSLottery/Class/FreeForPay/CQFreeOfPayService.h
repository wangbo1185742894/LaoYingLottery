//
//  CQFreeOfPayService.h
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLPaymentConfig.h"

@class CQFreeOfpayModel;

@interface CQFreeOfPayService : NSObject
@property (nonatomic, weak) UIViewController *weakSelfViewController;
@property (nonatomic, strong, readwrite) CQFreeOfpayModel *mainDataModel;
//@property (nonatomic, assign) BOOL isNeedShowAlter;
/**
 小额免密快捷开通
 
 @param never_notify 是否不再提醒
 @param quato 金额
 @param isKaitong 是否选择开通
 */
- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong
                               complete:(void (^)())complete;

+ (instancetype)allocWithWeakViewController:(UIViewController *)weakViewController;

//外部调用
- (void)isAlreadyFreeOfPayServiceWithChannalType:(paymentChannelType)type complete:(void (^)())complete;

@end
