//
//  CQCommonAlterPresenter.m
//  caiqr
//
//  Created by 洪利 on 2017/3/29.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQCommonAlterPresenter.h"
@implementation CQCommonAlterPresenter


+ (CQCommonAlterConfigModel *)addAlertView:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option{
    CQCommonAlterConfigModel *model = [[CQCommonAlterConfigModel alloc] init];
    model.showStyle = CQAlertViewShowStyleDefault;//control 利用父子视图直接add
    model.superView = superView;
    model.alertView = alertView;
    model.option = option;
    model.queeStyel = CQAlertQueueStyleCommon;
    return model;
}

+ (CQCommonAlterConfigModel *)addAlertView:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle{
    CQCommonAlterConfigModel *model = [[CQCommonAlterConfigModel alloc] init];
    model.showStyle = CQAlertViewShowStyleDefault;//control 利用父子视图直接add
    model.superView = superView;
    model.alertView = alertView;
    model.option = option;
    model.queeStyel = CQAlertQueueStyleGlobal;//全局队列
    return model;
}

+ (CQCommonAlterConfigModel *)addAlertViewWithClassName:(NSString *)alertViewClassName option:(CQAlertViewDisPlayedOption)option{
    CQCommonAlterConfigModel *model = [[CQCommonAlterConfigModel alloc] init];
    model.showStyle = CQAlertViewShowStyleBySelf;//手动实现加载
    model.alertViewClassName = alertViewClassName;
    model.option = option;
    model.queeStyel = CQAlertQueueStyleCommon;
    return model;
}

+ (CQCommonAlterConfigModel *)addAlertViewWithClassName:(NSString *)alertViewClassName option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle{
    CQCommonAlterConfigModel *model = [[CQCommonAlterConfigModel alloc] init];
    model.showStyle = CQAlertViewShowStyleBySelf;//手动实现加载
    model.alertViewClassName = alertViewClassName;
    model.option = option;
    model.queeStyel = CQAlertQueueStyleGlobal;//全局队列
    return model;
}

@end
