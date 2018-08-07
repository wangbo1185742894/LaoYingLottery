//
//  CLModifyNickNameViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLModifyNickNameViewController.h"
#import "NSString+Legitimacy.h"
#import "CLUpdateNickNameAPI.h"
#import "CLPersonalMsgHandler.h"
#import "NSString+Coding.h"

@interface CLModifyNickNameViewController ()<UITextFieldDelegate,CLRequestParamSource,CLRequestCallBackDelegate>

@property (strong, nonatomic) UITextField *nickNameTextField;
@property (strong, nonatomic) UIButton* makeSureBtn;
@property (nonatomic, strong) CLUpdateNickNameAPI* api;

@end

@implementation CLModifyNickNameViewController

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [_nickNameTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"修改昵称";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    UIBarButtonItem* barItem = [[UIBarButtonItem alloc] initWithCustomView:self.makeSureBtn];
    self.navigationItem.rightBarButtonItem = barItem;

    [self.view addSubview:self.nickNameTextField];
    self.nickNameTextField.placeholder = [NSString stringWithFormat:@"当前昵称: %@",[CLPersonalMsgHandler personalNickName]];
    
    [self.nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(__SCALE(40));
        make.top.equalTo(self.view).offset(__SCALE(0 + 94));
        make.left.equalTo(self.view).offset(__SCALE(30));
        make.right.equalTo(self.view).offset(-__SCALE(30));
    }];
    
}

#pragma mark - CLRequestParamSource,CLRequestCallBackDelegate

- (NSDictionary *)paramsForPostApi:(CLBaseRequest *)request {
    
    return @{@"nick_name":[self.nickNameTextField.text urlEncode]};
}

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        WS(_weakSelf)
        [[CLPersonalMsgHandler sharedPersonal] updatePersonalMesssageFrom:[request.urlResponse.resp firstObject]];
        [self show:@"昵称修改成功"];
        DELAY(1.f, ^{
            [_weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    self.makeSureBtn.enabled = YES;
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    self.makeSureBtn.enabled = YES;
    [self stopLoading];
}

#pragma mark - private

- (void)commitMsgClicked
{
    if ([self.nickNameTextField.text rangeOfString:@" "].location != NSNotFound)
    {
        [self show:@"昵称存在空格"];
        return;
    }
    if (self.nickNameTextField.text.length <= 0)
    {
        [self show:@"昵称不能为空"];
        return;
    }
    if (self.nickNameTextField.text.length >= 15)
    {
        [self show:@"昵称长度不能超过15位"];
        return;
    }
    if (!self.nickNameTextField.text.checkDomainOfUserNickName) {
        [self show:@"昵称必须是字母数字汉字组合"];
        return;
    }
    //请求开始
    [self showLoading];
    self.makeSureBtn.enabled = NO;
    [self.api start];
    
}

#pragma mark - Offline

// @override
- (void)userOfflineAction:(id)offlineInfo
{
//    [super userOfflineAction:offlineInfo];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

//token失效 被强制下线
- (void)tokenInformationUnValidWithInfo:(id)info
{
    
//    [[CQSingletonUserInfoStore sharedManager] loginValid];
//    
//    [CQReplaceOffLineView showWithMessage:info];
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - getting Method

- (UITextField *)nickNameTextField {
    
    if (!_nickNameTextField) {
        _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _nickNameTextField.textColor = [UIColor blackColor];
        _nickNameTextField.font = FONT_SCALE(14);
        UIView* leftView = [[UIView alloc] initWithFrame:__Rect(0, 0, 10, 10)];
        leftView.backgroundColor = CLEARCOLOR;
        _nickNameTextField.leftView = leftView;
        leftView = nil;
        _nickNameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nickNameTextField.layer.borderColor = THEME_COLOR.CGColor;
        _nickNameTextField.layer.borderWidth = .7f;
        _nickNameTextField.returnKeyType = UIReturnKeyDone;
        _nickNameTextField.delegate = self;
        
    }
    return _nickNameTextField;
}

- (UIButton *)makeSureBtn
{
    if (!_makeSureBtn) {
        _makeSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeSureBtn.frame = __Rect(0, 0, 50, 30);
        [_makeSureBtn setTitle:@"完成" forState:UIControlStateNormal];
        _makeSureBtn.titleLabel.font = FONT(16);
        [_makeSureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_makeSureBtn addTarget:self action:@selector(commitMsgClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _makeSureBtn;
}

- (CLUpdateNickNameAPI *)api {
    
    if (!_api) {
        _api = [[CLUpdateNickNameAPI alloc] init];
        _api.delegate = self;
        _api.paramSource = self;
    }
    return _api;
}

#pragma mark - textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self commitMsgClicked];
    return YES;
}

- (void)dealloc {
    
    if (_api) {
        _api.delegate = nil;
        [_api cancel];
        
    }
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
