//
//  CLModifyMobileViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/24.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLModifyMobileViewController.h"
#import "CQPhoneNoVerificationView.h"
#import "CLSendVerifyCodeAPI.h"
#import "CLBindMobileAPI.h"
#import "CLPersonalMsgHandler.h"
#import "UILabel+CLAttributeLabel.h"

@interface CLModifyMobileViewController () <CLRequestCallBackDelegate,CQPhoneNoVerificationViewDelegate>

@property (nonatomic, strong) UILabel* messageLabel;

@property (nonatomic, strong) CQPhoneNoVerificationView* mobileView;

@property (nonatomic, strong) CLSendVerifyCodeAPI* verifyCodeAPI;
@property (nonatomic, strong) CLBindMobileAPI* bindMobileAPI;

@property (nonatomic) BOOL hasMobile;

@end

@implementation CLModifyMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"修改手机号码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString* mobile = [CLPersonalMsgHandler personalMobile];
    self.hasMobile = ([mobile isKindOfClass:[NSString class]] && mobile.length > 0);

    if (self.hasMobile) {
        [self.view addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.center.equalTo(self.view);
            make.height.mas_equalTo(30);
        }];
    } else {
        [self.view addSubview:self.mobileView];
        [self.mobileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view.mas_top).offset(100);
            make.height.mas_equalTo(__SCALE(170));
        }];
    }
}

#pragma mark - CQPhoneNoVerificationViewDelegate

- (void)getVerificationCodeWithPhoneNumber:(NSString *)number {
    
    self.verifyCodeAPI.mobile = number;
    [self.verifyCodeAPI start];
}


- (void)confirmClicked {
    
    self.bindMobileAPI.mobile = self.mobileView.phoneNumber;
    self.bindMobileAPI.verifyCode = self.mobileView.verificationCode;
    [self.bindMobileAPI start];
}

- (void)verifyExceptionDescription:(NSString *)desc {
    
    //提示错误信息
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.verifyCodeAPI) {
        //verify code
    } else if (request == self.bindMobileAPI){
        
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    
}

#pragma mark -

- (void)callPhone
{
    NSString *phoneNum = @"4006892227";// 电话号码
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
}

#pragma mark - getter

- (UILabel *)messageLabel {
    
    if (!_messageLabel) {        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = FONT_SCALE(14);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = UIColorFromRGB(0x666666);
        NSString* String = @"如需更换手机号,请联系客服 ";
        NSString* phoneNumber = @" 400-689-2227";
        AttributedTextParams* param =[AttributedTextParams attributeRange:NSMakeRange(String.length, phoneNumber.length) Color:LINK_COLOR];
        [_messageLabel attributeWithText:[NSString stringWithFormat:@"%@%@",String,phoneNumber] controParams:@[param]];
        _messageLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer* callPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callPhone)];
        [_messageLabel addGestureRecognizer:callPhoneTap];
    }
    return _messageLabel;

}

- (CQPhoneNoVerificationView *)mobileView
{
    if (!_mobileView) {
        _mobileView = [[CQPhoneNoVerificationView alloc] initWithFrame:CGRectZero];
        _mobileView.delegate = self;
        _mobileView.confirmBtnTitle = @"确认";
    }
    return _mobileView;
}


- (CLSendVerifyCodeAPI *)verifyCodeAPI {
    
    if (!_verifyCodeAPI) {
        _verifyCodeAPI = [[CLSendVerifyCodeAPI alloc] init];
        _verifyCodeAPI.delegate = self;
    }
    return _verifyCodeAPI;
}

- (CLBindMobileAPI *)bindMobileAPI {
    
    if (!_bindMobileAPI) {
        _bindMobileAPI = [[CLBindMobileAPI alloc] init];
        _bindMobileAPI.delegate = self;
    }
    return _bindMobileAPI;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
