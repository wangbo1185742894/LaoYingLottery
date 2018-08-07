//
//  CKFOPService.h
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CKFOPModel;
@class CKFOPAPI;
@interface CKFOPService : NSObject
@property (nonatomic, weak) UIViewController *weakSelfViewController;
@property (nonatomic, strong, readwrite) CKFOPModel *mainDataModel;
@property (nonatomic, assign) BOOL isNeedShowAlter;
//需要输入密码即开启
+ (void)isAlreadyFreeOfPayServiceIfNeedPassword:(BOOL)isNeedPassword weakViewController:(UIViewController *)weakViewController block:(void (^)(id))complete;





















/**
 小额免密快捷开通
 
 @param never_notify 是否不再提醒
 @param quato 金额
 @param isKaitong 是否选择开通
 */
- (void)resetFreeOfPayWithisNeverNotify:(NSString *)never_notify
                                  quato:(NSString *)quato
                              iskaitong:(NSString *)isKaitong
                               complete:(void (^)(id obj))complete;

+ (instancetype)allocWithWeakViewController:(UIViewController *)weakViewController;
//外部调用
- (void)isAlreadyFreeOfPayService:(void (^)(id obj))complete;

@end
