//
//  CLUserCertifyViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/23.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCertifyViewController.h"
#import "NSString+Legitimacy.h"
#import "CQInputTextFieldView.h"
#import "CLBindUserCertifyAPI.h"
#import "CLUserCenterPageConfigure.h"
#import "CLPersonalMsgHandler.h"
#import "CLAlertController.h"
#import "NSString+NSFormat.h"
#import "CLAllJumpManager.h"
#import "CLAllAlertInfo.h"
#import "CLAlertPromptMessageView.h"

@interface CLUserCertifyViewController () <CLRequestCallBackDelegate, CLAlertControllerDelegate>

@property (nonatomic, strong) UILabel *topTitliLbl;
@property (nonatomic, strong) UILabel* topMegLbl;
@property (nonatomic, strong) CQInputTextFieldView* realNameInput;
@property (nonatomic, strong) UIView *lineView;//中间的线
@property (nonatomic, strong) CQInputTextFieldView* userIdInput;
@property (nonatomic, strong) UIButton* commitBtn;

@property (nonatomic, strong) UIBarButtonItem* rightMoreBarButtonItem;

@property (nonatomic, strong) CLBindUserCertifyAPI* api;

@property (nonatomic) BOOL nameValid;
@property (nonatomic) BOOL userIdValid;

@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;

@property (nonatomic, strong) NSString *blockName;

@property (nonatomic, copy) void(^success)(id);
@end

@implementation CLUserCertifyViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.blockName = params[@"blockName"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleText = @"实名信息";
    [self createUI];
    
    NSString *realName = [CLPersonalMsgHandler personalRealName];
    NSString *idCard = [CLPersonalMsgHandler personalIdCardNo];
    if ([realName isKindOfClass:NSString.class] && (realName.length > 0)) {
        self.realNameInput.inputEnable = NO;
        self.realNameInput.inputTextType = inputTextTypeNormal;
        self.realNameInput.defautlText = realName;
        self.lineView.hidden = NO;
    }
    
    if ([idCard isKindOfClass:NSString.class] && (idCard.length > 0)) {
        self.userIdInput.inputEnable = NO;
        self.userIdInput.inputTextType = inputTextTypeNormal;
        self.userIdInput.defautlText = [idCard stringByReplacingEachCharactersInRange:NSMakeRange(1, idCard.length - 2) withString:@"*"];
    }
    
    self.commitBtn.hidden = [CLPersonalMsgHandler identityAuthentication];
    
    
    WS(_weakSelf)
    self.realNameInput.checkImputTextValid = ^BOOL(NSString* text){
        return (text.length > 0);
    };
    
    self.userIdInput.checkImputTextValid = ^BOOL(NSString* text){
        return [text checkIDCardNumberValid];
    };
    
    self.realNameInput.textContentChange = ^(void){
        _weakSelf.nameValid = (_weakSelf.realNameInput.text.length > 0);
    };
    
    self.userIdInput.textContentChange = ^(void){
        _weakSelf.userIdValid = [_weakSelf.userIdInput.text checkIDCardNumberValid];
    };
    //做身份证号数据长度限制
    self.userIdInput.shouldChangeCharacters = ^(UITextField* textField,NSRange range,NSString* replacementString){
        if (textField.text.length > 17 && ![replacementString isEqualToString:@""]) {
            return NO;
        }
        
        return YES;
    };
    self.realNameInput.keyboardReturnAction = self.userIdInput.keyboardReturnAction = ^{ [_weakSelf hideKeyBoard]; };
    
    [self addObserver:self forKeyPath:@"nameValid" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"userIdValid" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self updateCommitButtonState];
    
}

- (void) hideKeyBoard {
    
    [self.realNameInput resignFirstResponder];
    [self.userIdInput resignFirstResponder];
}

- (void)idAuthenCommitEvent:(id)sender {
    
    self.api.realName = self.realNameInput.text;
    self.api.idCard = self.userIdInput.text;
    [self showLoading];
    [self.api start];
    
}

- (void) updateCommitButtonState {
    
    BOOL commentStatus = (self.nameValid && self.userIdValid);
    self.commitBtn.enabled = commentStatus;
    [self.commitBtn setBackgroundColor:commentStatus ? THEME_COLOR : UNABLE_COLOR ];
    self.commitBtn.layer.borderColor = THEME_COLOR.CGColor;
}

/* 右导航提示说明 */
- (void)promptEvent:(id)sender {
    
    [self.realNameInput resignFirstResponder];
    [self.userIdInput resignFirstResponder];
    [self.alertPromptMessageView showInView:self.view.window];
}

- (void)createUI {
    
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    
    [self.view addSubview:self.topTitliLbl];
    [self.view addSubview:self.topMegLbl];
    [self.view addSubview:self.realNameInput];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.userIdInput];
    [self.view addSubview:self.commitBtn];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
    
    [self.topTitliLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(__SCALE(10.f));
        make.top.equalTo(self.view).offset(__SCALE(5.f));
        make.height.mas_offset(__SCALE(35));
    }];
    
    [self.topMegLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTitliLbl.mas_right).offset(1.f);
        make.right.equalTo(self.view).offset(__SCALE(-10.f));
        make.top.equalTo(self.topTitliLbl);
        make.height.mas_offset(__SCALE(35));
    }];
    
    [self.realNameInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topMegLbl.mas_bottom).offset(20);
        make.height.equalTo(self.topMegLbl);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.realNameInput.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.userIdInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.lineView.mas_bottom);
        make.height.equalTo(self.realNameInput);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.userIdInput.mas_bottom).offset(30);
        make.height.mas_offset(__SCALE(37.f));
    }];
    
    [self updateCommitButtonState];
    
}

- (void)verifySuccessForMethod:(void (^)(id))callBack{
    
    self.success = callBack;
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        
        [CLPersonalMsgHandler updateIdentityAuthenForRealName:self.realNameInput.text idCard:self.userIdInput.text];
        if (self.blockName && self.blockName.length > 0) {
            //调用成功后的匿名回调
            [[CLAllJumpManager shareAllJumpManager] open:self.blockName];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            if (self.success) {
                self.success(nil);
            }
        }
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self stopLoading];
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - getter
- (UILabel *)topTitliLbl
{
    if (!_topTitliLbl) {
        
        AllocNormalLabel(_topTitliLbl, @"温馨提示：\n", FONT_SCALE(12.f), NSTextAlignmentCenter, THEME_COLOR, CGRectZero);
        _topTitliLbl.numberOfLines = 0;
    }
    return _topTitliLbl;
}

- (UILabel *)topMegLbl
{
    if (!_topMegLbl) {
        
        AllocNormalLabel(_topMegLbl, @"真实姓名和身份证号，是您领奖的重要凭证。请仔细确认，提交后不可修改", FONT_SCALE(12.f), NSTextAlignmentLeft, THEME_COLOR, CGRectZero);
        _topMegLbl.numberOfLines = 0;
    }
    return _topMegLbl;
}

- (CQInputTextFieldView *)realNameInput
{
    if (!_realNameInput) {
        _realNameInput = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"真实姓名:";
        textLbl.textColor = UIColorFromRGB(0x333333);
        textLbl.font = FONT(13);
        _realNameInput.leftView = textLbl;
        _realNameInput.textPlaceholder = @"身份证上的名字";
        _realNameInput.inputTextType = inputTextTypeUnderline;
        
    }
    return _realNameInput;
}

- (CQInputTextFieldView *)userIdInput
{
    if (!_userIdInput) {
        _userIdInput = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"身份证号:";
        textLbl.textColor = UIColorFromRGB(0x333333);
        textLbl.font = FONT(13);
        
        _userIdInput.leftView = textLbl;
        _userIdInput.textPlaceholder = @"身份证上的号码";
        _userIdInput.limitType = CQInputLimitTypeNumberAndEnglish;
        _userIdInput.inputTextType = inputTextTypeUnderline;
    }
    return _userIdInput;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _commitBtn.frame = CGRectZero;
        _commitBtn.enabled = NO;
        [_commitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(idAuthenCommitEvent:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 2.f;
        _commitBtn.layer.borderWidth = .5f;
    }
    return _commitBtn;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setImage:[UIImage imageNamed:@"questionmarkWhite"] forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, 17, 17);
        [rightFuncBtn addTarget:self action:@selector(promptEvent:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLBindUserCertifyAPI *)api {
    
    if (!_api) {
        _api = [[CLBindUserCertifyAPI alloc] init];
        _api.delegate = self;
    }
    return _api;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_UserCertify;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
}
#pragma mark - 

- (void)dealloc {
    
    if (_api) {
        _api.delegate = nil;
        [_api cancel];
        
    }
    
    
    [self removeObserver:self forKeyPath:@"nameValid"];
    [self removeObserver:self forKeyPath:@"userIdValid"];
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
