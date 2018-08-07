//
//  SLBetDetailsAlertVeiw.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SLAlertType) {
    SLAlertTypeDelete,
    SLAlertTypeEmpty,
    SLAlertTypeCancel,
};

typedef void(^SLBetDetailsAlertBlock)(SLAlertType type, NSString *matchIssue);

@interface SLBetDetailsAlertVeiw : UIView

@property (nonatomic, strong) SLBetDetailsAlertBlock sureBlock;

@property (nonatomic, strong) SLBetDetailsAlertBlock cancelBlock;

@property (nonatomic, strong) NSString *matchIssue;


/**
 显示弹窗
 */
- (void)showInWindowWithType:(SLAlertType)type matchIssue:(NSString *)matchIssue;

/**
 确定按钮点击事件
 */
- (void)returnSureClick:(SLBetDetailsAlertBlock)block;
/**
 取消按钮点击事件
 */
- (void)returnCancelClick:(SLBetDetailsAlertBlock)block;


@end
