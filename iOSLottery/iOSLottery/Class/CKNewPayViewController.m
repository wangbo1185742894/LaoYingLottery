//
//  CKNewPayViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKNewPayViewController.h"
#import "CLAlertController.h"
#import "CLTools.h"
#import "CLAllJumpManager.h"
#import "CLJumpLotteryManager.h"

#import "CKCustomPaymentHomeView.h"
#import "CKPaymentBaseSource.h"
#import "CKPayClient.h"
#import "CKPayConfig.h"
#import "CLLotteryBespeakService.h"
@interface CKNewPayViewController ()<CLAlertControllerDelegate, CKPayClientDelegate>

//最上方的倒计时
@property (nonatomic, strong) UIView *timeBaseView;//倒计时基本View
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *timeLabel;//timeLabel
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CLAlertController *alertController;
@property (nonatomic, strong) CLAlertController *abandonAlert;
@property (nonatomic, assign) BOOL isAlowShowAlert;//是否允许弹窗
//支付View
@property (nonatomic, strong) CKCustomPaymentHomeView *paymengHomeView;
@property (nonatomic, strong) UIButton *navBackButton;//返回按钮

@property (nonatomic, strong) NSString *preHandleToken;
@end

@implementation CKNewPayViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.alertController hidden];
    [self.abandonAlert hidden];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isAlowShowAlert = YES;
    self.navTitleText = @"订单支付";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.navBackButton]];
    [self configUI];
    
    [self.paymengHomeView startRequest];
}

- (void)configUI{
    
    [self.view addSubview:self.paymengHomeView];
    /** 兼容竞彩足球 继续支付 添加倒计时 */
    if (self.periodTime != NSNotFound && self.periodTime > 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
    }
    if (!self.hasNotPeriodTime) {
        
        [self.view addSubview:self.timeBaseView];
        [self.timeBaseView addSubview:self.periodLabel];
        [self.timeBaseView addSubview:self.timeLabel];
        [self.timeBaseView addSubview:self.lineView];
        [self.timeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.view).offset(__SCALE(5.f));
            make.centerX.equalTo(self.view);
        }];
        [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.timeBaseView);
            make.top.bottom.equalTo(self.timeBaseView);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.periodLabel.mas_right);
            make.right.equalTo(self.timeBaseView);
            make.width.mas_greaterThanOrEqualTo(__SCALE(40.f));
            make.centerY.equalTo(self.periodLabel);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.periodLabel.mas_bottom).offset(__SCALE(5.f));
            make.bottom.equalTo(self.timeBaseView);
            make.height.mas_equalTo(.5f);
        }];
    }
    
    
    
    [self.paymengHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.hasNotPeriodTime ? self.view : self.lineView.mas_bottom);
    }];
}
- (void)navBackButtonOnClick:(UIButton *)btn{
    
    //    NSLog(@"点击了返回按钮");
    [self.abandonAlert show];
    
}
#pragma mark ------------ private Mothed ------------
- (void)configSource:(CKPaymentBaseSource *)source orderId:(NSString *)orderId{
    
    WS(_weakSelf)
    source.didFinishedPayWithResult = ^(BOOL isException, id obj){
        //跳转回调
        // 跳转彩票点抢单
        [CLLotteryBespeakService runBespeakServiceWithOrderId:orderId  completion:^{
            
//            [self.navigationController popViewControllerAnimated:YES];
            [_weakSelf pushOrderOrFollow];
        }];
        
    };
    [CKPayClient sharedManager].delegate = self;
    [CKPayClient startPay];
    
    //self.navBackButton.userInteractionEnabled = NO;
    
    NSLog(@"%@", source);
}
- (void)ck_PayClinetStartPayment{
    
    [self showLoading];
}

- (void)ck_payClientEndPaymentWithReqState:(BOOL)state message:(id)msg{
    
    [self stopLoading];
    if (!state) {
        [self show:msg];
    }
}
- (void)ck_didPayment{
    
    self.isAlowShowAlert = NO;
    self.paymengHomeView.buttonStatus = NO;
}
#pragma mark - 跳转详情页
- (void)pushOrderOrFollow{
    
    if (self.orderType == CKOrderTypeNormal) {
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLLottBetOrdDetaViewController_push/%@", self.payConfigure[@"order_id"]] dismiss:NO];
    }else if (self.orderType == CKOrderTypeFollow){
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFollowDetailViewController_push/%@", self.payConfigure[@"order_id"]] dismiss:NO];
    }else if (self.orderType == CKOrderTypeJC){
        
        if (self.pushType == CKPayPushTypeBet) {
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@",self.payConfigure[@"order_id"]] dissmissPresent:YES];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark ------------ alertControllerDelegate ------------
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (alertController == self.alertController) {
        if (index == 0) {
            if (self.pushType == CKPayPushTypeBet) {
                [CLJumpLotteryManager jumpLotteryDestoryWithGameEn:self.lotteryGameEn];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if (alertController == self.abandonAlert) {
        
        if (index == 1) {
            //继续支付
            [self.paymengHomeView startPayment];
        }else if (index == 0){
            NSString *orderId = self.payConfigure[@"order_id"];
            if (orderId && orderId.length > 0) {
            
                [self pushOrderOrFollow];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
}

- (void)timeCutDown:(NSNotification *)notification{
    
    if (self.periodTime == 0) {
        [self timeOut];
        return;
    }
    self.periodTime--;
    self.timeLabel.text = [CLTools timeFormatted:self.periodTime];
    if (self.period.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"距%@期截止:", self.period];
    }else{
        self.periodLabel.text = [NSString stringWithFormat:@"距本期截止:"];
    }
}
- (void)timeOut{
    
    if (self.isAlowShowAlert) {
        [self.alertController show];
        self.isAlowShowAlert = NO;
    }
}
#pragma mark ------------ setter Mothed ------------
- (void)setPayConfigure:(id)payConfigure{
    
    _payConfigure = payConfigure;
    
    self.preHandleToken = payConfigure[@"pre_handle_token"];
}
#pragma mark ------------ getter Mothed ------------
- (UIView *)timeBaseView{
    
    if (!_timeBaseView) {
        _timeBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _timeBaseView.backgroundColor = CLEARCOLOR;
    }
    return _timeBaseView;
}
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.textColor = UIColorFromRGB(0x333333);
        _periodLabel.font = FONT_SCALE(13.f);
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = THEME_COLOR;
        _timeLabel.font = FONT_SCALE(13.f);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = SEPARATE_COLOR;
    }
    return _lineView;
}
- (CLAlertController *)alertController{
    
    if (!_alertController) {
        _alertController = [CLAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前期次或比赛已截止" ] message:@"" style:CLAlertControllerStyleAlert delegate:self];
        _alertController.buttonItems = @[@"确定"];
    }
    return _alertController;
}
- (CLAlertController *)abandonAlert{
    
    if (!_abandonAlert) {
        _abandonAlert = [CLAlertController alertControllerWithTitle:@"距离奖金到手只有一步之遥" message:@"确定要放弃吗？" style:CLAlertControllerStyleAlert delegate:self];
        _abandonAlert.buttonItems = @[@"放弃", @"继续支付"];
        _abandonAlert.isDefaultButtonStyle = YES;
    }
    return _abandonAlert;
}

- (CKCustomPaymentHomeView *)paymengHomeView{
    
    WS(_weakSelf)
    if (!_paymengHomeView) {
        _paymengHomeView = [CKCustomPaymentHomeView CustomPaymentViewIsBuyRed:NO preHandleToken:self.preHandleToken viewController:self paymentActionBlock:^(CKPaymentBaseSource *source , NSString *orderId) {
            
            [_weakSelf configSource:source orderId:orderId];
        }];
    }
    
    return _paymengHomeView;
}
- (UIButton *)navBackButton{
    
    if (!_navBackButton) {
        _navBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_navBackButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        _navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, - 15, 0, 0);
        
        [_navBackButton addTarget:self action:@selector(navBackButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBackButton;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
