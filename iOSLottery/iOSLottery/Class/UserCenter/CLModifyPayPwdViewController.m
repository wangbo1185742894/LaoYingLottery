//
//  CLModifyPayPwdViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLModifyPayPwdViewController.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "CLModifyPayPwdAPI.h"
#import "NSString+Coding.h"
@interface CLModifyPayPwdViewController () <CLRequestParamSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) CQInputTextFieldView* oldPwd;

@property (nonatomic, strong) CQInputTextFieldView* reNewPwd;

@property (nonatomic, strong) CQInputTextFieldView* commitPwd;

@property (nonatomic, strong) UIButton* commitBtn;

@property (nonatomic, strong) CLModifyPayPwdAPI* modifyPwdAPI;

@end

@implementation CLModifyPayPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"修改支付密码";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.oldPwd];
    [self.view addSubview:self.reNewPwd];
    [self.view addSubview:self.commitPwd];
    [self.view addSubview:self.commitBtn];
    
    [self.oldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_offset(__SCALE(40));
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
    }];
    
    [self.reNewPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.oldPwd);
        make.top.equalTo(self.oldPwd.mas_bottom);
    }];
    
    [self.commitPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(self.oldPwd);
        make.top.equalTo(self.reNewPwd.mas_bottom);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.commitPwd.mas_bottom).offset(20);
        make.height.mas_equalTo(__SCALE(37));
    }];
    
    [self configureCommitEnableState];
    
}

#pragma mark - private

- (void)configureCommitEnableState {
    
    BOOL ret = (self.oldPwd.inputValidState && self.reNewPwd.inputValidState && self.commitPwd.inputValidState);
    
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret?THEME_COLOR:UNABLE_COLOR];
}

- (void)commitClicked:(id)sender {
    
    if (![self.reNewPwd.text isEqualToString:self.commitPwd.text]) {
        [self show:@"两次输入密码不一致"];
        return;
    }
    
    [self.modifyPwdAPI start];
}

#pragma mark - CLRequestParamSource,CLRequestCallBackDelegate

- (NSDictionary *)paramsForPostApi:(CLBaseRequest *)request {
    
    return @{@"pay_pwd":self.oldPwd.text.md5,
             @"new_pay_pwd":self.reNewPwd.text.md5,
             @"re_new_pay_pwd":self.reNewPwd.text.md5};
}

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self show:@"修改成功"];
        WS(_ws)
        DELAY(1.f, ^{
            [_ws.navigationController popViewControllerAnimated:YES];
        });
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}


#pragma mark - getter

- (CQInputTextFieldView *)oldPwd
{
    if (!_oldPwd) {
        _oldPwd = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"旧密码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _oldPwd.leftView = textLbl;
        _oldPwd.secureTextEntry = YES;
        _oldPwd.canShowSecureTxt = YES;
        _oldPwd.textPlaceholder = @"请输入旧密码";
        _oldPwd.limitLength = 6;
        _oldPwd.inputTextType = inputTextTypeUnderline;
        _oldPwd.limitType = CQInputLimitTypeNumber;
        _oldPwd.keyBoardType = UIKeyboardTypeNumberPad;
        WS(_weakSelf)
        _oldPwd.checkImputTextValid = ^BOOL(NSString* text){
            return (text.length == 6);
        };
        _oldPwd.textContentChange = ^{
            [_weakSelf configureCommitEnableState];
        };
        
        
    }
    return _oldPwd;
}

- (CQInputTextFieldView *)reNewPwd
{
    if (!_reNewPwd) {
        _reNewPwd = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"新密码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _reNewPwd.leftView = textLbl;
        _reNewPwd.secureTextEntry = YES;
        _reNewPwd.canShowSecureTxt = YES;
        _reNewPwd.textPlaceholder = @"请输入6位数字";
        _reNewPwd.limitType = CQInputLimitTypeNumber;
        _reNewPwd.limitLength = 6;
        _reNewPwd.keyBoardType = UIKeyboardTypeNumberPad;
        _reNewPwd.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _reNewPwd.checkImputTextValid = ^BOOL(NSString* text){
            return (text.length == 6);
        };
        _reNewPwd.textContentChange = ^{
            [_weakSelf configureCommitEnableState];
        };
    }
    return _reNewPwd;
}

- (CQInputTextFieldView *)commitPwd
{
    if (!_commitPwd) {
        _commitPwd = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"确认密码";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _commitPwd.leftView = textLbl;
        _commitPwd.secureTextEntry = YES;
        _commitPwd.canShowSecureTxt = YES;
        _commitPwd.textPlaceholder = @"请再次输入新密码";
        _commitPwd.limitType = CQInputLimitTypeNumber;
        _commitPwd.limitLength = 6;
        _commitPwd.keyBoardType = UIKeyboardTypeNumberPad;
        _commitPwd.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _commitPwd.checkImputTextValid = ^BOOL(NSString* text){
            return (text.length == 6);
        };
        _commitPwd.textContentChange = ^{
            [_weakSelf configureCommitEnableState];
        };
    }
    return _commitPwd;
}

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitBtn setBackgroundColor:THEME_COLOR];
        _commitBtn.titleLabel.font = FONT_SCALE(15);
        _commitBtn.layer.cornerRadius = 2.f;
        _commitBtn.layer.borderWidth = .5f;
        _commitBtn.layer.borderColor = THEME_COLOR.CGColor;
        [_commitBtn addTarget:self action:@selector(commitClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (CLModifyPayPwdAPI *)modifyPwdAPI {
    
    if (!_modifyPwdAPI) {
        _modifyPwdAPI = [[CLModifyPayPwdAPI alloc] init];
        _modifyPwdAPI.delegate = self;
        _modifyPwdAPI.paramSource = self;
    }
    return _modifyPwdAPI;
}

- (void)dealloc {
    
    if (_modifyPwdAPI) {
        _modifyPwdAPI.delegate = nil;
        _modifyPwdAPI.paramSource = nil;
        [_modifyPwdAPI cancel];
    }
}

@end
