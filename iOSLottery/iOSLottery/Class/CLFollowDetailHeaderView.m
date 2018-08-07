//
//  CLFollowDetailHeaderView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailHeaderView.h"
#import "CQDefinition.h"
#import "CLOrderBasicMsgView.h"
#import "CLConfigMessage.h"
#import "CLFollowDetailHeaderViewModel.h"
#import "CLTools.h"
#import "UIImageView+CQWebImage.h"

#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"
@interface CLFollowDetailHeaderView ()

//彩种icon
@property (nonatomic, strong) UIImageView* lottIconImgView;
//彩种名称与期次
@property (nonatomic, strong) UILabel* lottNameLbl;

@property (nonatomic, strong) CLOrderBasicMsgView* followMessageView;

@property (nonatomic, strong) UILabel* timerLbl;

@property (nonatomic, strong) UIButton* payButton;

@property (nonatomic, strong) UILabel* stateLbl;

@property (nonatomic, strong) UIButton *stateButton;//已退款的问号

@property (nonatomic, strong) UIView* topSeparateLine;

@property (nonatomic, strong) UIView* bottomSeparateLine;

@property (nonatomic, strong) CLFollowDetailHeaderViewModel *headerModel;

@property (nonatomic, strong) CLAlertPromptMessageView *alertView;
@end


@implementation CLFollowDetailHeaderView

-  (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureHeaderViewModel:(CLFollowDetailHeaderViewModel*)viewModel {
    
    self.headerModel = viewModel;
    self.currentSaleTime = self.headerModel.saleEndTime;
    [self.lottIconImgView setImageWithURL:[NSURL URLWithString:viewModel.lottIcon]];
    self.lottNameLbl.text = viewModel.lottName;
    self.timerLbl.hidden = self.payButton.hidden = !viewModel.isWaitPay;
    self.stateLbl.hidden = viewModel.isWaitPay;
    if (viewModel.isWaitPay) {
        self.timerLbl.text = [NSString stringWithFormat:@"倒计时 %@", [CLTools timeFormatted:viewModel.saleEndTime]];
        [self.payButton setTitle:@"继续支付" forState:UIControlStateNormal];
    } else {
        //如果没有倒计时则移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.stateLbl.text = viewModel.followStatusCn;
    }
    self.stateButton.hidden = !viewModel.isShowRefund;
    self.followMessageView.basicMsgArray = viewModel.cashMsgArray;
}

- (void)continuePayment:(id)sender {
    
    !self.gotoPayment?:self.gotoPayment();
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //如果是倒计时  则添加 全局timer通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerIsGoing:) name:GlobalTimerRuning object:nil];
        [self initViews];
        [self setConstraints];
        
    }
    return self;
}

#pragma mark ------------ timer ------------
- (void)timerIsGoing:(NSNotification *)notification{
    
    self.headerModel.saleEndTime--;
    self.currentSaleTime = self.headerModel.saleEndTime;
    if (self.headerModel.saleEndTime > 0) {
        
        self.timerLbl.text = [NSString stringWithFormat:@"倒计时:%@", [CLTools timeFormatted:self.headerModel.saleEndTime]];
        [self.payButton setTitle:@"继续支付" forState:UIControlStateNormal];
    }else {
        //如果没有倒计时则移除观察者
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        self.stateLbl.text = @"过期未支付";
        self.timerLbl.hidden = self.payButton.hidden = YES;
        self.stateLbl.hidden = NO;
    }
}

- (void) initViews {
    
    self.lottIconImgView = [[UIImageView alloc] init];
    self.lottIconImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.lottNameLbl = [[UILabel alloc] init];
    self.followMessageView = [[CLOrderBasicMsgView alloc] init];
    self.topSeparateLine = [[UIView alloc] init];
    self.bottomSeparateLine = [[UIView alloc] init];
    
    self.stateLbl = [[UILabel alloc] init];
    self.stateLbl.textAlignment = NSTextAlignmentRight;
    self.stateLbl.textColor = UIColorFromRGB(0x333333);
    self.stateLbl.font = FONT_SCALE(14);
    
    self.stateButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.stateButton setImage:[UIImage imageNamed:@"follow_refund.png"] forState:UIControlStateNormal];
    [self.stateButton addTarget:self action:@selector(refundButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.stateButton.hidden = YES;
    
    self.lottNameLbl.font = FONT_BOLD(16);
    self.topSeparateLine.backgroundColor = self.bottomSeparateLine.backgroundColor = SEPARATE_COLOR;
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.payButton setBackgroundColor:THEME_COLOR];
    self.payButton.titleLabel.font = FONT_SCALE(14);
    self.payButton.layer.cornerRadius = 2.f;
    self.payButton.layer.masksToBounds = YES;
    [self.payButton addTarget:self action:@selector(continuePayment:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timerLbl = [[UILabel alloc] init];
    self.timerLbl.textColor = THEME_COLOR;
    self.timerLbl.font = FONT_SCALE(11);
    self.timerLbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:self.lottIconImgView];
    [self addSubview:self.lottNameLbl];
    [self addSubview:self.followMessageView];
    [self addSubview:self.topSeparateLine];
    [self addSubview:self.bottomSeparateLine];
    [self addSubview:self.stateLbl];
    [self addSubview:self.payButton];
    [self addSubview:self.timerLbl];
    [self addSubview:self.stateButton];
}

- (void) setConstraints {
    
    [self.lottIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.top.equalTo(self.mas_top).offset(__SCALE(10.f));
        make.width.height.mas_equalTo(__SCALE(30.f));
    }];
    
    [self.lottNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lottIconImgView.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.lottIconImgView);
        
    }];
    
    [self.topSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(.5f);
        make.top.equalTo(self.lottIconImgView.mas_bottom).offset(__SCALE(10.f));
    }];
    
    [self.bottomSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(0.5);
    }];
    
    [self.followMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.topSeparateLine.mas_bottom);
        make.bottom.equalTo(self.bottomSeparateLine.mas_top);
    }];
 
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lottIconImgView);
        make.height.equalTo(self.lottNameLbl);
        make.right.equalTo(self.stateButton.mas_left).offset(-3.f);
    }];
    
    [self.stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.lottIconImgView);
        make.height.width.mas_equalTo(__SCALE(12.f));
        make.right.equalTo(self).offset(__SCALE(-10.f));
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- 15.f));
        make.height.mas_equalTo(__SCALE(30.f));
        make.width.mas_equalTo(__SCALE(100.f));
        make.bottom.equalTo(self.lottIconImgView.mas_bottom).offset(__SCALE(2.f));
    }];
    
    [self.timerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.payButton);
        make.top.equalTo(self);
        make.bottom.equalTo(self.payButton.mas_top);
    }];
    
}

- (void)refundButtonOnClick:(UIButton *)btn{
    
    [self.alertView showInWindow];
}

- (CLAlertPromptMessageView *)alertView{
    
    if (!_alertView) {
        _alertView = [[CLAlertPromptMessageView alloc] init];
        _alertView.desTitle = allAlertInfo_RefundInfo;
        _alertView.cancelTitle = @"知道了";
    }
    return _alertView;
}

@end
