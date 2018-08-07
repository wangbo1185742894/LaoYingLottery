//
//  CLLoginViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLoginViewController.h"
#import "CLLoginSMSView.h"
#import "CLLoginPwdView.h"
#import "CLAlertController.h"
#import "CLSendVerifyCodeAPI.h"
#import "CLUserLoginRegisterAPI.h"
#import "CLLoginOfPwdAPI.h"

#import "CLRegisterViewController.h"
#import "CLLoginRegisterAdapter.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"

#import "CLShowHUDManager.h"

#import "CLSaveUserPassWordTool.h"
#import "CLRoutable.h"

#import "CQCustomerEntrancerService.h"
#import "CLAppContext.h"
#import "CLUserBaseInfo.h"
#import "CLSetLoginPwdViewController.h"
@interface CLLoginViewController () <CLLoginSMSViewDelegate,CLLoginPwdViewDelegate,CLAlertControllerDelegate,CLRequestCallBackDelegate>

@property (nonatomic, strong) UIScrollView* loginScrollView;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIButton* registerBtn;
@property (nonatomic, strong) UIButton *imageRegisterBtn;

@property (nonatomic, strong) UIButton* loginSwitchItem;
@property (nonatomic, strong) UIBarButtonItem* backItem;

@property (nonatomic, strong) CLLoginSMSView* smsView;
@property (nonatomic, strong) CLLoginPwdView* pwdView;

@property (nonatomic, strong) UILabel *explainLabel;


@property (nonatomic) BOOL isPwdLoginning;

@property (nonatomic, strong) CLAlertController* alertView;

//api
@property (nonatomic, strong) CLSendVerifyCodeAPI* sendVerifyAPI;
@property (nonatomic, strong) CLLoginOfPwdAPI* pwdLoginAPI;
@property (nonatomic, strong) CLUserLoginRegisterAPI* smsOrThirdLoginAPI;

@property (nonatomic, strong) NSString *blockName;//调用匿名回调的名字

@end

@implementation CLLoginViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.blockName = params[@"blockName"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"登录";
    // Do any additional setup after loading the view.
    [self createLoginUI];
    
    self.isPwdLoginning = YES;
    
}

- (void) createLoginUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:self.backItem];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.loginSwitchItem]];
    [self.view addSubview:self.loginScrollView];
     self.containerView = [[UIView alloc] init];
    [self.loginScrollView addSubview:self.containerView];
    [self.containerView addSubview:self.smsView];
    [self.containerView addSubview:self.pwdView];
    [self.containerView addSubview:self.registerBtn];
    [self.containerView addSubview:self.imageRegisterBtn];
    [self.containerView addSubview:self.explainLabel];
    
    [self.loginScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.loginScrollView);
        make.width.mas_equalTo(self.view.bounds.size.width);
        make.height.mas_equalTo(self.view.bounds.size.height);
    }];
    
    [self.smsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(__SCALE(35));
    }];
    
    [self.pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.top.equalTo(self.containerView).offset(__SCALE(35));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdView.mas_bottom).offset(5);
        make.centerX.equalTo(self.containerView);
        make.height.mas_equalTo(__SCALE(35));
    }];
    [self.imageRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.centerY.equalTo(self.registerBtn);
        make.left.equalTo(self.registerBtn.mas_right).offset(2.f);
    }];
    
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(__SCALE(-30.f));
        make.centerX.equalTo(self.containerView);
    }];
    
}

#pragma mark - private

// switch login stype
- (void)switchLoginStyle:(id)sender {
    
    self.isPwdLoginning = !self.isPwdLoginning;
    
}
// goto register viewController
- (void)gotoRegister:(id)sender {
    
    CLRegisterViewController* registerViewC = [[CLRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerViewC animated:YES];
}

//close 登录成功后关闭页面 实现回调
- (void) closeViewController {

    [self dismissViewControllerAnimated:YES completion:^{
        
        //调用匿名回调
        if (self.blockName && self.blockName.length > 0) {
            
            [CLRoutable openWithURL:self.blockName];
        }
    }];
}
//点击返回 登录失败关闭页面 不实现回调
- (void)backItemOnClick{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.sendVerifyAPI) {
        
        if (request.urlResponse.success) {
            [self show:@"验证码已发送,请注意查收"];
        }else{
            [self show:request.urlResponse.errorMessage];
        }
        
    } else if (request == self.pwdLoginAPI || request == self.smsOrThirdLoginAPI){
        
        if (request.urlResponse.success) {
            [CLLoginRegisterAdapter loginSuccessWithMessage:[request.urlResponse.resp firstObject]];
            if (![CLAppContext context].userMessage.user_info.has_pwd) {
                //如果没有登录密码 则跳转设置登录密码
                WS(_weakSelf)
                CLSetLoginPwdViewController *setPwd = [[CLSetLoginPwdViewController alloc] init];
                setPwd.setPwdFinishBlock = ^(){
                    [_weakSelf closeViewController];
                };
                [self.navigationController pushViewController:setPwd animated:YES];
                
            }else{
                [self closeViewController];
            }
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    }
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    if (request == self.sendVerifyAPI) {
        //忽略
    } else if (request == self.pwdLoginAPI || request == self.smsOrThirdLoginAPI) {
        
        [self show:request.urlResponse.errorMessage];
    }
    [self stopLoading];
}

#pragma mark - CLLoginSMSViewDelegate

- (void)smsSyncRightMobile:(NSString *)mobile{
    
    [self.pwdView syncMobile:mobile];
}

- (void) sendSMSVerifyCode:(NSString*) mobile {
    
    self.sendVerifyAPI.mobile = mobile;
    [self showLoading];
    [self.sendVerifyAPI start];
}

- (void) SMSLoginCommitEventWithMobile:(NSString *)mobile verityCode:(NSString *)code {
    self.smsOrThirdLoginAPI.mobile = mobile;
    self.smsOrThirdLoginAPI.verify_code = code;
    //缓存用户名
    [CLSaveUserPassWordTool saveUserId:mobile PassWord:@""];
    [self showLoading];
    [self.smsOrThirdLoginAPI start];
}

#pragma mark - CLLoginPwdViewDelegate

- (void)pwdSyncRightMobile:(NSString *)mobile{
    
    [self.smsView syncMobile:mobile];
}

- (void) forgetPwdEvent {
    
    WS(_ws);
    [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_ws];
}

- (void) pwdLoginEventWithMobile:(NSString *)mobile password:(NSString *)pwd {
    
    self.pwdLoginAPI.mobile = mobile;
    self.pwdLoginAPI.password = pwd;
    //缓存用户名 和密码
    [CLSaveUserPassWordTool saveUserId:mobile PassWord:pwd];
    [self showLoading];
    [self.pwdLoginAPI start];
    
}

#pragma mark - CLAlertControllerDelegate

- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index {
    
    if (index == 1) {
//        NSLog(@"打电话...");
    }
}

#pragma mark - setter

- (void)setIsPwdLoginning:(BOOL)isPwdLoginning {
    
    _isPwdLoginning = isPwdLoginning;
    self.smsView.hidden = _isPwdLoginning;
    self.pwdView.hidden = !_isPwdLoginning;
    [self.loginSwitchItem setTitle:_isPwdLoginning?@"验证码登录":@"密码登录" forState:UIControlStateNormal];
}

#pragma mark - getter

- (UIButton *)loginSwitchItem {
    
    if (!_loginSwitchItem) {
        _loginSwitchItem = [[UIButton alloc] initWithFrame:__Rect(0, 0, __SCALE(70.f), __SCALE(40.f))];
        [_loginSwitchItem setTitle:@"验证码登录" forState:UIControlStateNormal];
        _loginSwitchItem.titleLabel.font = FONT_SCALE(13);
        [_loginSwitchItem addTarget:self action:@selector(switchLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginSwitchItem;
}

- (UIBarButtonItem *)backItem {
    
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"allBack.png"] style:UIBarButtonItemStyleDone target:self action:@selector(backItemOnClick)];
    }
    return _backItem;
}

- (UIScrollView *)loginScrollView {
    
    if (!_loginScrollView) {
        _loginScrollView = [[UIScrollView alloc] init];
    }
    return _loginScrollView;
}

- (CLLoginSMSView *)smsView {
    
    if (!_smsView) {
        _smsView = [[CLLoginSMSView alloc] init];
        _smsView.delegate = self;
    }
    return _smsView;
}

- (CLLoginPwdView *)pwdView {
    
    if (!_pwdView) {
        _pwdView = [[CLLoginPwdView alloc] init];
        _pwdView.delegate = self;
    }
    return _pwdView;
}

- (UIButton *)registerBtn {
    
    if (!_registerBtn) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"快速注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = FONT_SCALE(15);
        [_registerBtn addTarget:self action:@selector(gotoRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
- (UIButton *)imageRegisterBtn{
    
    if (!_imageRegisterBtn) {
        _imageRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageRegisterBtn setBackgroundImage:[UIImage imageNamed:@"registerArrow.png"] forState:UIControlStateNormal];
        [_imageRegisterBtn addTarget:self action:@selector(gotoRegister:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageRegisterBtn;
}
- (UILabel *)explainLabel{
    
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] init];
//        _explainLabel.text = @"快三由老鹰彩票提供技术支持";
        _explainLabel.textColor = UIColorFromRGB(0x999999);
        _explainLabel.font = FONT_SCALE(12.f);
        if ([[CLAppContext clientType] isEqualToString:@"1001"]) {
            _explainLabel.hidden = YES;
        }else{
            _explainLabel.hidden = NO;
            _explainLabel.text = [NSString stringWithFormat:@"\"%@\"由\"老鹰彩票\"提供技术支持", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        }
    }
    return _explainLabel;
}
- (CLAlertController *)alertView {
    
    if (!_alertView) {
        _alertView = [CLAlertController alertControllerWithTitle:@"请联系客服" message:nil style:CLAlertControllerStyleActionSheet delegate:self];
        _alertView.buttonItems = @[@"取消",@"联系客服"];
    }
    return _alertView;
}

- (CLSendVerifyCodeAPI *)sendVerifyAPI {
    
    if (!_sendVerifyAPI) {
        _sendVerifyAPI = [[CLSendVerifyCodeAPI alloc] init];
        _sendVerifyAPI.delegate = self;
    }
    return _sendVerifyAPI;
}

- (CLLoginOfPwdAPI *)pwdLoginAPI {
    
    if (!_pwdLoginAPI) {
        _pwdLoginAPI = [[CLLoginOfPwdAPI alloc] init];
        _pwdLoginAPI.delegate = self;
    }
    return _pwdLoginAPI;
}

- (CLUserLoginRegisterAPI *)smsOrThirdLoginAPI {
    
    if (!_smsOrThirdLoginAPI) {
        _smsOrThirdLoginAPI = [[CLUserLoginRegisterAPI alloc] init];
        _smsOrThirdLoginAPI.delegate = self;
    }
    return _smsOrThirdLoginAPI;
}

- (void)dealloc {
    
    if (!_sendVerifyAPI) {
        _sendVerifyAPI.delegate = nil;
        [_sendVerifyAPI cancel];
    }
    if (_pwdLoginAPI) {
        _pwdLoginAPI.delegate = nil;
        [_pwdLoginAPI cancel];
    }
    if (_smsOrThirdLoginAPI) {
        _smsOrThirdLoginAPI.delegate = nil;
        [_smsOrThirdLoginAPI cancel];
    }
    self.pwdView.delegate = nil;
    self.smsView.delegate = nil;
    self.pwdView = nil;
    self.smsView = nil;
    if (_alertView)
        _alertView.delegate = nil;

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
