//
//  CQCommonAlterPresenter.h
//  caiqr
//
//  Created by 洪利 on 2017/3/29.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQCommonAlterConfigModel.h"
@interface CQCommonAlterPresenter : NSObject

//配置弹窗
/**
 配置包含父视图和弹窗实例的模型并返回，以便交由control 处理

 @param alertView 弹窗实例
 @param superView 父视图
 @return 适用于control 直接处理的数据模型
 */
+ (CQCommonAlterConfigModel *)addAlertView:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option;
+ (CQCommonAlterConfigModel *)addAlertView:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle;


/**
 //添加手动实现加载逻辑的弹窗

 @param alertViewClassName 弹窗的类名
 @return 返回包装了弹窗的数据模型
 */
+ (CQCommonAlterConfigModel *)addAlertViewWithClassName:(NSString *)alertViewClassName option:(CQAlertViewDisPlayedOption)option;

+ (CQCommonAlterConfigModel *)addAlertViewWithClassName:(NSString *)alertViewClassName option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle;

@end
