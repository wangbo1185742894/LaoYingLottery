//
//  BBBetDetailBottomView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBBetDetailBottomView.h"

#import "SLConfigMessage.h"

#import "UITextField+SLLimitInput.h"

#import "UILabel+SLAttributeLabel.h"

#import "UITextField+SLTextField.h"

#import "SLAwardAmountRequset.h"

#import "BBMatchInfoManager.h"
#import "BBBetDetailsInfoManager.h"

#import "BBChuanGuanModel.h"

#import "BBBetDetailChuanGuanView.h"

#import "SLExternalService.h"

@interface BBBetDetailBottomView ()<UITextFieldDelegate,CLRequestCallBackDelegate>

/**
 最终赔率以出票为准
 */
@property (nonatomic, strong) UILabel *topInfoLabel;
@property (nonatomic, strong) UIButton *chuanGuanButton;//所有串关和箭头的所在的底部View
@property (nonatomic, strong) UILabel *chuanGuanLabel;//所选串关的label
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头View
@property (nonatomic, strong) UIView *midLineView;//中间线View
@property (nonatomic, strong) UILabel *betLabel;//投label
@property (nonatomic, strong) UITextField *multipleTextField;//倍数textField
@property (nonatomic, strong) UILabel *mulLabel;//倍label
@property (nonatomic, strong) UIView *bottomLineView;//串关底部横线
@property (nonatomic, strong) BBBetDetailChuanGuanView *chuanGuanSelectView;//串关选择View
@property (nonatomic, strong) UILabel *noteMultipleLabel;//注数 倍数 钱数label
/**
 预计奖金
 */
@property (nonatomic, strong) UILabel *awardLabel;
/**
 请选择投注方式label
 */
@property (nonatomic, strong) UILabel *selectBetTypeLabel;
/**
 付款button
 */
@property (nonatomic, strong) UIButton *payButton;

/**
 预计奖金requset
 */
@property (nonatomic, strong) SLAwardAmountRequset *request;


@end


@implementation BBBetDetailBottomView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = SL_UIColorFromRGB(0xffffff);
        [self addUI];
        [self reloadSelectLabel];
        
        [self createUIWithSelect:self.chuanGuanButton.selected];
        
        self.multipleTextField.text = [NSString stringWithFormat:@"%zi", [BBBetDetailsInfoManager getDefaultMultiple]];
        [self reloadAwardAndNote];
    }
    return self;
}

- (void)addUI{
    
    [self addSubview:self.topInfoLabel];
    [self addSubview:self.chuanGuanButton];
    [self addSubview:self.chuanGuanLabel];
    [self addSubview:self.arrowImageView];
    [self addSubview:self.midLineView];
    [self addSubview:self.betLabel];
    [self addSubview:self.multipleTextField];
    [self addSubview:self.mulLabel];
    [self addSubview:self.bottomLineView];
    [self addSubview:self.chuanGuanSelectView];
    [self addSubview:self.noteMultipleLabel];
    [self addSubview:self.awardLabel];
    [self addSubview:self.selectBetTypeLabel];
    [self addSubview:self.payButton];
    
    [self.topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(- 1.f);
        make.right.equalTo(self).offset(1.f);
        make.top.equalTo(self);
        make.height.mas_equalTo(SL__SCALE(20.f));
    }];
    
    [self.chuanGuanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self.midLineView.mas_left);
        make.top.bottom.equalTo(self.midLineView);
    }];
    
    [self.chuanGuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self).multipliedBy(0.5);
        make.centerY.equalTo(self.midLineView);
        make.right.lessThanOrEqualTo(self.arrowImageView.mas_left);
        
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.chuanGuanLabel);
        make.width.height.mas_equalTo(SL__SCALE(20.f));
        make.right.equalTo(self.midLineView.mas_left).offset(SL__SCALE(-10.f));
    }];
    [self.midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topInfoLabel.mas_bottom);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(SL__SCALE(45.f));
        make.width.mas_equalTo(0.5f);
    }];
    [self.betLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.multipleTextField.mas_left).offset(SL__SCALE(-10.f));
        make.centerY.equalTo(self.midLineView);
    }];
    [self.multipleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_right).multipliedBy(0.75f);
        make.top.equalTo(self.midLineView).offset(SL__SCALE(5.f));
        make.bottom.equalTo(self.midLineView).offset(SL__SCALE(- 5.f));
        make.width.mas_equalTo(SL__SCALE(88.f));
    }];
    [self.mulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.multipleTextField.mas_right).offset(SL__SCALE(5.f));
        make.centerY.equalTo(self.multipleTextField);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.midLineView.mas_bottom);
        make.height.mas_equalTo(0.5f);
        make.left.right.equalTo(self);
    }];
    [self.chuanGuanSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0);
        make.top.equalTo(self.bottomLineView.mas_bottom);
    }];
    [self.noteMultipleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(SL__SCALE(20.f));
        make.top.equalTo(self.chuanGuanSelectView.mas_bottom).offset(SL__SCALE(5.f));
    }];
    [self.awardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.noteMultipleLabel);
        make.top.equalTo(self.noteMultipleLabel.mas_bottom).offset(SL__SCALE(5.f));
        make.bottom.equalTo(self).offset(SL__SCALE(SL_kDevice_Is_iPhoneX ? -25.f : -5.f));
    }];
    
    [self.selectBetTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.noteMultipleLabel);
        make.bottom.equalTo(self.awardLabel);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.top.equalTo(self.noteMultipleLabel.mas_top).offset(SL__SCALE(2.f));
        make.bottom.equalTo(self.awardLabel);
        make.right.equalTo(self).offset(SL__SCALE(- 10.f));
        make.height.mas_equalTo(SL__SCALE(35.f));
        make.width.mas_equalTo(SL__SCALE(70.f));
        
    }];
}


#pragma mark ---- CLRequestCallBackDelegate ----
- (void)requestFinished:(CLBaseRequest *)request
{
    if (request.urlResponse.success) {
        
        NSDictionary *dic = request.urlResponse.resp;
        
        if (dic.count > 0) {
            
            NSString *minBonus = dic[@"minBonus"];
            NSString *maxBonus = dic[@"maxBonus"];
            
            NSString *bonus = [NSString stringWithFormat:@"%@~%@元",minBonus,maxBonus];
            
            if ([minBonus isEqualToString:maxBonus]) {
                
                bonus = [NSString stringWithFormat:@"%@元",minBonus];
                
            }
            
            [self setBonusAmount:bonus];
            return;
            
        }
        
        //无数据的时候，本地计算预计奖金
        [self setBonusAmount:[BBBetDetailsInfoManager getExpectedBonus]];
        return;
    }
    
    [self setBonusAmount:[BBBetDetailsInfoManager getExpectedBonus]];
}

#pragma mark ---- 设置预计奖金金额 ----
- (void)setBonusAmount:(NSString *)string
{
    
    NSString *bonus = [NSString stringWithFormat:@"预计奖金：%@", string];
    
    SLAttributedTextParams *param = [SLAttributedTextParams attributeRange:NSMakeRange(5, string.length) Color:SL_UIColorFromRGB(0xE63222)];
    
    [self.awardLabel sl_attributeWithText:bonus controParams:@[param]];
    
    
}

- (void)requestFailed:(CLBaseRequest *)request
{
    
    [self setBonusAmount:[BBBetDetailsInfoManager getExpectedBonus]];
    
}

- (void)hiddenKeyBoard{
    
    
    [self.multipleTextField resignFirstResponder];
}

- (void)reloadBetDetailBottonViewUI{
    
    
    [self reloadSelectLabel];
    
    [self createUIWithSelect:self.chuanGuanButton.selected];
    
    self.multipleTextField.text = [NSString stringWithFormat:@"%zi", [BBBetDetailsInfoManager getMultiple]];
    [self reloadAwardAndNote];
}

- (void)reloadSelectLabel{
    
    NSString *chuanGuan = @"";
    for (BBChuanGuanModel *model in [BBBetDetailsInfoManager getChuanGuan]) {
        
        if (model.isSelect) {
            chuanGuan = [NSString stringWithFormat:@"%@,%@", chuanGuan, model.chuanGuanTitle];
        }
    }
    if (chuanGuan.length > 0) {
        chuanGuan = [chuanGuan substringFromIndex:1];
        self.chuanGuanLabel.text = chuanGuan;
    }else{
        chuanGuan = @"投注方式(必选)";
        SLAttributedTextParams *parms = [SLAttributedTextParams attributeRange:NSMakeRange(4, 4) Color:SL_UIColorFromRGB(0xE63222)];
        [self.chuanGuanLabel sl_attributeWithText:chuanGuan controParams:@[parms]];
    }
}

#pragma mark ---- 刷新底部UI -----
- (void)reloadAwardAndNote{
    
    if ([BBBetDetailsInfoManager getNote] > 0) {
        //如果注数大于0
        self.selectBetTypeLabel.hidden = YES;
        self.noteMultipleLabel.hidden = NO;
        self.awardLabel.hidden = NO;
        
        NSString *noteAward = [NSString stringWithFormat:@"%zi注 %zi倍 共%zi元", [BBBetDetailsInfoManager getNote], [BBBetDetailsInfoManager getMultiple], [BBBetDetailsInfoManager getMultiple] * [BBBetDetailsInfoManager getNote] * 2];
        ;
        NSRange range = [noteAward rangeOfString:@"共"];
        SLAttributedTextParams *param = [SLAttributedTextParams attributeRange:NSMakeRange(range.location, noteAward.length - range.location) Color:SL_UIColorFromRGB(0xE63222)];
        [self.noteMultipleLabel sl_attributeWithText:noteAward controParams:@[param]];
        
        
        [self setBonusAmount:[BBBetDetailsInfoManager getExpectedBonus]];
        
//        self.request.lotteryNumber = [BBBetDetailsInfoManager getAllOddsString];
//        self.request.betTimes = [NSString stringWithFormat:@"%ld",[BBBetDetailsInfoManager getMultiple]];
        
//        //异常情况，不请求
//        if (self.request.lotteryNumber.length > 0) {
//            [self setBonusAmount:@"计算中..."];
//            
//            //        //取消上一次请求
//            //        [self.request cancel];
//            
//            [self.request start];
//        };
        
        
        
    }else{
        
        self.selectBetTypeLabel.hidden = NO;
        self.noteMultipleLabel.hidden = YES;
        self.awardLabel.hidden = YES;
        
    }
    
    if (([BBBetDetailsInfoManager getMultiple] * [BBBetDetailsInfoManager getNote]) > 0) {
        self.payButton.userInteractionEnabled = YES;
        self.payButton.backgroundColor = SL_UIColorFromRGB(0xe63222);
    }else{
        self.payButton.userInteractionEnabled = NO;
        self.payButton.backgroundColor = SL_UIColorFromRGBandAlpha(0xe63222, 0.5);
    }
    
    
}

- (void)hiddenChuanGuanSelectView{
    
    self.chuanGuanButton.selected = YES;
    [self chuanGuanButtonOnClick:self.chuanGuanButton];
}

#pragma mark ------------ event Response ------------
- (void)payButtonOnClick:(UIButton *)btn{
    
    //点击了支付按钮
    if (([BBBetDetailsInfoManager getMultiple] * [BBBetDetailsInfoManager getNote]) <= 0) return;
    
    !self.payBlock ? : self.payBlock();
}
- (void)chuanGuanButtonOnClick:(UIButton *)btn{
    
    [self hiddenKeyBoard];
    btn.selected = !btn.selected;
    self.arrowImageView.transform = CGAffineTransformMakeScale(1.0, btn.selected ? 1.0 : -1.0);
    [self createUIWithSelect:btn.selected];
    !self.chuanGuanShowBlock ? : self.chuanGuanShowBlock(btn.selected);
    
}

- (void)createUIWithSelect:(BOOL)select{
    
    if (select) {
        
        [self.chuanGuanSelectView setChoosableChuanGuan];
        
        [self.chuanGuanSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self);
            make.top.equalTo(self.bottomLineView.mas_bottom);
        }];
        self.chuanGuanSelectView.hidden = NO;
        
    }else{
        
        [self.chuanGuanSelectView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self);
            make.height.mas_equalTo(SL__SCALE(0.f));
            make.top.equalTo(self.bottomLineView.mas_bottom);
        }];
        self.chuanGuanSelectView.hidden = YES;
    }
}

#pragma mark ------------ textfield delegate ------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.chuanGuanButton.selected = YES;
    [self chuanGuanButtonOnClick:self.chuanGuanButton];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL ret = [textField sl_limitNumberMax:[[BBMatchInfoManager shareManager] getMaxMultiple] ShouldChangeCharactersInRange:range replacementString:string];
    
    if (ret) {
        [[BBMatchInfoManager shareManager] setMuitple:([[textField.text stringByReplacingCharactersInRange:range withString:string] integerValue])];
    }else{
        [[BBMatchInfoManager shareManager] setMuitple:[textField.text integerValue]];
    }
    [self reloadSelectLabel];
    [self reloadAwardAndNote];
    return ret;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField performSelector:@selector(selectAll:) withObject:textField afterDelay:0.1f];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (!(textField.text && textField.text.length > 0)) {
        
        textField.text = @"1";
        [[BBMatchInfoManager shareManager] setMuitple:1];
        [self reloadSelectLabel];
        [self reloadAwardAndNote];
    }
}


#pragma mark ---- 提示选择投注方式 ----
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPoint = [touch locationInView:self];
    
    BOOL isContain = CGRectContainsPoint(self.payButton.frame, touchPoint);
    
    if (isContain == NO) return;
    
    if (self.payButton.userInteractionEnabled == YES) return;

    [SLExternalService showError:@"请先选择投注方式"];

}



#pragma mark ------------ getter Mothed ------------

- (UILabel *)topInfoLabel{
    
    if (!_topInfoLabel) {
        _topInfoLabel = [[UILabel alloc] init];
        _topInfoLabel.text = @"最终赔率以出票为准";
        _topInfoLabel.textColor = SL_UIColorFromRGB(0x8f6e51);
        _topInfoLabel.layer.borderWidth = 0.5f;
        _topInfoLabel.layer.borderColor = SL_UIColorFromRGB(0xece5dd).CGColor;
        _topInfoLabel.font = SL_FONT_SCALE(10.f);
        _topInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _topInfoLabel;
}

- (UIButton *)chuanGuanButton{
    
    if (!_chuanGuanButton) {
        _chuanGuanButton = [[UIButton alloc] init];
        [_chuanGuanButton addTarget:self action:@selector(chuanGuanButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chuanGuanButton;
}

- (UILabel *)chuanGuanLabel{
    
    if (!_chuanGuanLabel) {
        _chuanGuanLabel = [[UILabel alloc] init];
        _chuanGuanLabel.text = @"单关";
        _chuanGuanLabel.font = SL_FONT_SCALE(13.f);
        _chuanGuanLabel.textColor = SL_UIColorFromRGB(0x333333);
    }
    return _chuanGuanLabel;
}

- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.image = [UIImage imageNamed:@"bet_details_packup.png"];
        _arrowImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    }
    return _arrowImageView;
}

- (UIView *)midLineView {
    
    if (!_midLineView) {
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _midLineView;
}

- (UILabel *)betLabel{
    
    if (!_betLabel) {
        _betLabel = [[UILabel alloc] init];
        _betLabel.text = @"投";
        _betLabel.textColor = SL_UIColorFromRGB(0x333333);
        _betLabel.font = SL_FONT_SCALE(14.f);
    }
    return _betLabel;
}

- (UITextField *)multipleTextField{
    
    if (!_multipleTextField) {
        
        _multipleTextField = [[UITextField alloc] init];
        _multipleTextField.text = @"1";
        _multipleTextField.layer.borderColor = SL_UIColorFromRGB(0x8f6e51).CGColor;
        _multipleTextField.layer.borderWidth = 0.5f;
        _multipleTextField.font = SL_FONT_SCALE(14.f);
        _multipleTextField.layer.cornerRadius = 3.f;
        _multipleTextField.clipsToBounds = YES;
        _multipleTextField.textAlignment = NSTextAlignmentCenter;
        _multipleTextField.delegate = self;
        _multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _multipleTextField;
}

- (UILabel *)mulLabel {
    
    if (!_mulLabel) {
        _mulLabel = [[UILabel alloc] init];
        _mulLabel.text = @"倍";
        _mulLabel.textColor = SL_UIColorFromRGB(0x333333);
        _mulLabel.font = SL_FONT_SCALE(14.f);
    }
    return _mulLabel;
}

- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _bottomLineView;
}

- (BBBetDetailChuanGuanView *)chuanGuanSelectView{
    
    if (!_chuanGuanSelectView) {
        WS_SL(_weak)
        _chuanGuanSelectView = [[BBBetDetailChuanGuanView alloc] init];
        _chuanGuanSelectView.backgroundColor = SL_UIColorFromRGB(0xf6f1eb);
        _chuanGuanSelectView.buttonOnClickBlock = ^{
            
            [_weak reloadBetDetailBottonViewUI];
        };
        _chuanGuanSelectView.twoChuanOneBlock = ^{
            
            !_weak.twoChuanOneBlock ? : _weak.twoChuanOneBlock();
        };
    }
    return _chuanGuanSelectView;
}

- (UILabel *)noteMultipleLabel{
    
    if (!_noteMultipleLabel) {
        _noteMultipleLabel = [[UILabel alloc] init];
        _noteMultipleLabel.text = @"20注 10倍 共40元";
        _noteMultipleLabel.font = SL_FONT_SCALE(16.f);
        _noteMultipleLabel.textColor = SL_UIColorFromRGB(0x333333);
    }
    return _noteMultipleLabel;
}

- (UILabel *)awardLabel{
    
    if (!_awardLabel) {
        _awardLabel = [[UILabel alloc] init];
        _awardLabel.text = @"预计奖金：100-200元";
        _awardLabel.textColor = SL_UIColorFromRGB(0x333333);
        _awardLabel.font = SL_FONT_SCALE(12);
    }
    return _awardLabel;
}

- (UILabel *)selectBetTypeLabel{
    
    if (!_selectBetTypeLabel) {
        _selectBetTypeLabel = [[UILabel alloc] init];
        _selectBetTypeLabel.text = @"请选择投注方式";
        _selectBetTypeLabel.textColor = SL_UIColorFromRGB(0x333333);
        _selectBetTypeLabel.font = SL_FONT_SCALE(13);
        _selectBetTypeLabel.hidden = YES;
    }
    return _selectBetTypeLabel;
}

- (UIButton *)payButton{
    
    if (!_payButton ) {
        _payButton = [[UIButton alloc] init];
        [_payButton setTitle:@"付款" forState:UIControlStateNormal];
        _payButton.titleLabel.font = SL_FONT_SCALE(16.f);
        [_payButton setTitleColor:SL_UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _payButton.backgroundColor = SL_UIColorFromRGB(0xe63222);
        _payButton.layer.cornerRadius = 4.f;
        [_payButton addTarget:self action:@selector(payButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
    
}

- (SLAwardAmountRequset *)request
{
    
    if (_request == nil) {
        
        _request = [[SLAwardAmountRequset alloc] init];
        
        _request.delegate = self;
    }
    return _request;
}

@end
