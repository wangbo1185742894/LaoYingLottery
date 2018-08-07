//
//  NSObject+CQAddGlobalAlert.h
//  caiqr
//
//  Created by 洪利 on 2017/3/31.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQmyproxy.h"
#import "CQCommonAlterPresenter.h"
#import "CQCommonAlterConfigModel.h"
@interface NSObject (CQAddGlobalAlert)

- (void)addAlertToserviceAndLoadBySelf:(NSString *)alertClassName option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle;
- (void)addAlterToservice:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option queeStyle:(CQAlertQueueStyle)queeStyle;

@end
