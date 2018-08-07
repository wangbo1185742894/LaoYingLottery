//
//  CLAddBankCardViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAddBankCardViewController.h"
#import "CQInputTextFieldView.h"
#import "NSString+Legitimacy.h"
#import "CLAddBankCardAPI.h"
#import "CLAddBankCardCertifyViewController.h"
#import "CLPersonalMsgHandler.h"

@interface CLAddBankCardViewController () <CLRequestCallBackDelegate>

@property (nonatomic, strong) UILabel* topMsgLbl;
@property (nonatomic, strong) CQInputTextFieldView* nameText;
@property (nonatomic, strong) CQInputTextFieldView* idCardText;
@property (nonatomic, strong) CQInputTextFieldView* bankCardText;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic, strong) CLAddBankCardAPI* addCardAPI;

@property (nonatomic) BOOL finishIdCert; //是否实名认证标识


/**
 card_type : 0 表示
 */
@property (nonatomic, strong) NSString* card_type;

@property (nonatomic, strong) NSString *blockName;

@property (nonatomic, strong) NSString *channelType;

@end

@implementation CLAddBankCardViewController
- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.card_type = params[@"cardType"];
        self.channelType = params[@"channelType"];
        self.blockName = params[@"blockName"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"添加银行卡";
    self.finishIdCert = [CLPersonalMsgHandler identityAuthentication];
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self createUI];
    
    if (self.finishIdCert) {
        self.nameText.defautlText = [CLPersonalMsgHandler personalRealName];
        self.nameText.inputEnable = NO;
    }
    
    [self updateCommitBtnEnable];
    
}

- (void)updateCommitBtnEnable
{
    BOOL ret = (self.nameText.inputValidState &&
                ((self.finishIdCert)?YES:self.idCardText.inputValidState) &&
                self.bankCardText.inputValidState);
    
    self.commitBtn.enabled = ret;
    [self.commitBtn setBackgroundColor:ret? THEME_COLOR:UNABLE_COLOR];
    self.commitBtn.layer.borderColor = THEME_COLOR.CGColor;
}

- (BOOL)creditCardNumberFormateWithTextField:(UITextField*)textField replacementString:(NSString*)string
{
    BOOL needOperation = ([string isPureNumandCharacters] || string.length == 0);
    return needOperation;
}

- (void) createUI {
    [self.view addSubview:self.topMsgLbl];
    [self.view addSubview:self.nameText];
    
    if (!self.finishIdCert) {
        [self.view addSubview:self.idCardText];
    }
    [self.view addSubview:self.bankCardText];
    [self.view addSubview:self.commitBtn];
    
    [self.topMsgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topMsgLbl.mas_bottom).offset(10);
        make.height.mas_offset(__SCALE(40));
    }];
    
    if (!self.finishIdCert) {
        [self.idCardText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.nameText.mas_bottom).offset(10);
            make.height.mas_offset(__SCALE(40));
        }];
    }
    
    [self.bankCardText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        
        if (!self.finishIdCert)  {
            make.top.equalTo(self.idCardText.mas_bottom).offset(10);
        } else {
            make.top.equalTo(self.nameText.mas_bottom).offset(10);
        }
        make.height.mas_offset(__SCALE(40));
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.bankCardText.mas_bottom).offset(50);
        make.height.mas_equalTo(__SCALE(35));
    }];
}

- (void) commitClicked:(id)sender {
    
    self.addCardAPI.bankCardNO = [self.bankCardText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.addCardAPI.type = self.card_type;
    [self.addCardAPI start];
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {

    if (request.urlResponse.success) {
        NSMutableDictionary* bankInfo = [[request.urlResponse.resp firstObject] mutableCopy];
        NSString* realName = (self.finishIdCert)?[CLPersonalMsgHandler personalRealName]:self.nameText.text;
        NSString* idNo = (self.finishIdCert)?[CLPersonalMsgHandler personalIdCardNo]:self.idCardText.text;
        NSString* cardNo = [self.bankCardText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        [bankInfo setObject:realName forKey:@"real_name"];
        [bankInfo setObject:idNo forKey:@"card_code"];
        [bankInfo setObject:cardNo forKey:@"card_no"];
        
        CLAddBankCardCertifyViewController* vc = [[CLAddBankCardCertifyViewController alloc] init];
        vc.bankCardBinInfo = bankInfo;
        vc.blockName = self.blockName;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    //网络错误 or 无网
    [self show:request.urlResponse.errorMessage];
}


#pragma mark - getter

- (UILabel *)topMsgLbl {
    
    if (!_topMsgLbl) {
        _topMsgLbl = [[UILabel alloc] init];
        _topMsgLbl.font = FONT_SCALE(13);
        _topMsgLbl.textColor = UIColorFromRGB(0xe00000);
        _topMsgLbl.textAlignment = NSTextAlignmentCenter;
        _topMsgLbl.text = @"温馨提示:银行卡信息与实名信息一致才能提现";
    }
    return _topMsgLbl;
}

- (CQInputTextFieldView *)nameText {
    
    if (!_nameText) {
        _nameText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, __SCALE(35))];
        textLbl.text = @"姓名:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _nameText.leftView = textLbl;
        _nameText.textPlaceholder = @"持卡人的真实姓名";
        _nameText.inputTextType = inputTextTypeUnderline;
        WS(_weakSelf)
        _nameText.checkImputTextValid = ^BOOL(NSString* text){
            return (text.length > 0);;
        };
        _nameText.textContentChange = ^{
            [_weakSelf updateCommitBtnEnable];
        };
    }
    return _nameText;
}

- (CQInputTextFieldView *)idCardText {
    
    if (!_idCardText) {
        _idCardText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"身份证号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _idCardText.leftView = textLbl;
        _idCardText.limitLength = 18;
        _idCardText.textPlaceholder = @"持卡人的身份证号";
        _idCardText.inputTextType = inputTextTypeUnderline;
        _idCardText.limitType = CQInputLimitTypeNumberAndEnglish;
        _idCardText.limitLength = 18;
        WS(_weakSelf)
        _idCardText.checkImputTextValid = ^BOOL(NSString* text){
            return [text checkIDCardNumberValid];;
        };
        _idCardText.textContentChange = ^{
            [_weakSelf updateCommitBtnEnable];
        };
    }
    return _idCardText;
}

- (CQInputTextFieldView *)bankCardText {
    
    if (!_bankCardText) {
        _bankCardText = [[CQInputTextFieldView alloc] initWithFrame:CGRectZero];
        UILabel* textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, __SCALE(35))];
        textLbl.text = @"银行卡号:";
        textLbl.textColor = [UIColor blackColor];
        textLbl.font = FONT(13);
        _bankCardText.leftView = textLbl;
        _bankCardText.textPlaceholder = @"";
        _bankCardText.inputTextType = inputTextTypeUnderline;
        _bankCardText.limitType = CQInputLimitTypeNumber;
        _bankCardText.keyBoardType = UIKeyboardTypeNumberPad;
        WS(_weakSelf)
        _bankCardText.checkImputTextValid = ^BOOL(NSString* text){
            NSString* cardN = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
            return [cardN checkBankCardNumberValid];
        };
        _bankCardText.textContentChange = ^{
            
            [_weakSelf updateCommitBtnEnable];
        };
        
        _bankCardText.shouldChangeCharacters = ^BOOL(UITextField* textField,NSRange range,NSString* replacementString){
            if ([replacementString isEqualToString:@""]) {
                return YES;
            }
            if ([_weakSelf creditCardNumberFormateWithTextField:textField replacementString:replacementString]) {
                
                if (_weakSelf.bankCardText.text.length > 0) {
                    NSMutableString * temp = [NSMutableString stringWithString:[_weakSelf.bankCardText.text stringByReplacingOccurrencesOfString:@" " withString:@""]] ;
                    
                    for (int i = 4; ; i += 5) {
                        if ((temp.length - 1) >= (i - 1))
                            [temp insertString:@" " atIndex:i];
                        else
                            break;
                        
                    }
                    _weakSelf.bankCardText.defautlText = temp;  
                }
                return YES;
            }else{
                return NO;
            }
            
//            return [_weakSelf creditCardNumberFormateWithTextField:textField replacementString:replacementString];
        };
        
        
    }
    return _bankCardText;
}

- (UIButton *)commitBtn {
    
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _commitBtn.enabled = NO;
        [_commitBtn setBackgroundColor:UNABLE_COLOR];
        [_commitBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = FONT_SCALE(15.f);
        _commitBtn.layer.cornerRadius = 2.f;
        _commitBtn.layer.borderWidth = .5f;
        [_commitBtn addTarget:self action:@selector(commitClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _commitBtn;
}

- (CLAddBankCardAPI *)addCardAPI {
    
    if (!_addCardAPI) {
        _addCardAPI = [[CLAddBankCardAPI alloc] init];
        _addCardAPI.delegate = self;
    }
    return _addCardAPI;
}

- (void)dealloc {
    
    if (_addCardAPI) {
        _addCardAPI = nil;
        [_addCardAPI cancel];
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
