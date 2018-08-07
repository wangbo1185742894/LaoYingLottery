//
//  CLLoginSMSView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLLoginSMSViewDelegate <NSObject>

//如果手机号输入正确则同步到密码页
- (void) smsSyncRightMobile:(NSString *)mobile;

- (void) sendSMSVerifyCode:(NSString*) mobile;

- (void) SMSLoginCommitEventWithMobile:(NSString*)mobile verityCode:(NSString*)code;

@end

@interface CLLoginSMSView : UIView

@property (nonatomic, strong ) NSString* mobile;
@property (nonatomic, strong ) NSString* verity_code;
@property (nonatomic, weak) id <CLLoginSMSViewDelegate> delegate;
@property (nonatomic, strong, setter=syncMobile:) NSString *defaultMobile;

@end
