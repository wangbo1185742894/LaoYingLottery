//
//  CQBasicViewController+CQProxy.h
//  caiqr
//
//  Created by 洪利 on 2017/3/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQmyproxy.h"
#import "CQCommonAlterConfigModel.h"
#import "NSObject+CQAddGlobalAlert.h"


@interface UIViewController (CQProxy)

//记录注册弹窗的类名
@property (nonatomic, strong) NSString *lClassName;

//使用全套数据发起注册
- (void)addAlterToservice:(id)alertView withSuperView:(id)superView option:(CQAlertViewDisPlayedOption)option;

//仅告知control我有这么一个可能窗需要弹，轮到我弹的时候你告诉我我自己决定弹不弹
- (void)addAlertToserviceAndLoadBySelf:(NSString *)alertClassName option:(CQAlertViewDisPlayedOption)option;


@end
