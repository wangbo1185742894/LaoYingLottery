//
//  CLLoginPwdView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLLoginPwdViewDelegate <NSObject>

//如果手机号输入正确则同步到密码页
- (void) pwdSyncRightMobile:(NSString *)mobile;

- (void) forgetPwdEvent;

- (void) pwdLoginEventWithMobile:(NSString*)mobile password:(NSString*)pwd;


@end

@interface CLLoginPwdView : UIView

@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* password;

@property (nonatomic) BOOL isStoreingPwd;

@property (nonatomic, weak) id<CLLoginPwdViewDelegate> delegate;

@property (nonatomic, strong, setter=syncMobile:) NSString *defaultMobile;

@end
