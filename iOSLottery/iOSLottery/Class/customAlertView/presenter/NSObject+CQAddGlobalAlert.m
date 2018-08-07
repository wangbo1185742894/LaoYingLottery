//
//  NSObject+CQAddGlobalAlert.m
//  caiqr
//
//  Created by 洪利 on 2017/3/31.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "NSObject+CQAddGlobalAlert.h"

@implementation NSObject (CQAddGlobalAlert)

- (void)addAlterToservice:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle{
    //数据有效，添加观察者，监测VC生命周期
    if (alertView && superView) {
        CQCommonAlterConfigModel *model = [CQCommonAlterPresenter addAlertView:alertView withSuperView:superView option:option queeStyle:queeStyle];
            [[CQmyproxy dealerProxy] addGlobalAlertWithArray:@[model]];
    }
}
- (void)addAlertToserviceAndLoadBySelf:(NSString *)alertClassName option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle{
    //数据有效，添加观察者，监测VC生命周期
    if (alertClassName) {
        CQCommonAlterConfigModel *model = [CQCommonAlterPresenter addAlertViewWithClassName:alertClassName option:option queeStyle:queeStyle];
            [[CQmyproxy dealerProxy] addGlobalAlertWithArray:@[model]];
    }
}

@end
