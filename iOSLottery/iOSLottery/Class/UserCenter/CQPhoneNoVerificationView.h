//
//  CQPhoneNoVerificationView.h
//  caiqr
//
//  Created by 彩球 on 15/9/15.
//  Copyright (c) 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  手机号验证CustonView
 */

@protocol CQPhoneNoVerificationViewDelegate <NSObject>

/* 发起获取验证码请求 */
- (void)getVerificationCodeWithPhoneNumber:(NSString*)number;

/* 提交手机号与验证码 */
- (void)confirmClicked;

/* 异常信息回调 */
- (void)verifyExceptionDescription:(NSString*)desc;

@optional

- (void)keyBoardWillShow;

- (void)keyBoardWillHide;

@end


@interface CQPhoneNoVerificationView : UIView


@property (nonatomic, copy) void(^confirmEventAction)(void);
@property (nonatomic, copy) void(^getVerificationCodeFromPhone)(NSString* phoneNumber);
@property (nonatomic, copy) void(^keyBoardShowOrHide)(BOOL show,CGFloat keyBoardHeight);
@property (nonatomic, copy) void(^becomeFirstRespone)(UITextField *accontTextfield);

@property (nonatomic, weak) id<CQPhoneNoVerificationViewDelegate> delegate;
@property (nonatomic, strong) NSString* confirmBtnTitle;
@property (nonatomic, strong) NSString* phoneNumber;
@property (nonatomic, readonly , strong) NSString* verificationCode;


@property (nonatomic, readwrite) BOOL is_FirstResponde;

/**
 *  隐藏键盘
 */
- (void)hideKeyboard;

/**
 *  停止验证码收取倒计时
 */

- (void)stopVerifyCodeTimer;

@end
