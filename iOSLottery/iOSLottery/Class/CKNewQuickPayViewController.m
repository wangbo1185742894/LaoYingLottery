//
//  CKNewQuickPayViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKNewQuickPayViewController.h"
#import "CKQuickPayHomeView.h"
#import "CKPaymentBaseSource.h"
#import "Masonry.h"
#import "CLLoadingAnimationView.h"
#import "CKPayClient.h"
#import "CLLotteryBespeakService.h"
#import "CLAllJumpManager.h"
#import "CLConfigMessage.h"
@interface CKNewQuickPayViewController ()<CKPayClientDelegate>

@property (nonatomic, strong) CKQuickPayHomeView *paymentView;
@property (nonatomic, strong) UIImageView *backView;



@end

@implementation CKNewQuickPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.view.backgroundColor = UIColorFromRGB(0x000000);
    [self.view addSubview:self.backView];
    [self.view addSubview:self.paymentView];
    
    [self.paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.paymentView startRequest];
}

- (void)continueToTheNextStepOfPayFinished:(id)queryObj isException:(BOOL)isException orderID:(NSString *)orderID
{
    // 跳转彩票点抢单
    [CLLotteryBespeakService runBespeakServiceWithOrderId:orderID  completion:^{
        
        if (self.orderType == CKQuickOrderTypeNormal) {
            
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLLottBetOrdDetaViewController_push/%@", orderID] dissmissPresent:YES animation:NO];
        }else if (self.orderType == CKQuickOrderTypeFollow){
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLFollowDetailViewController_push/%@", orderID] dissmissPresent:YES animation:NO];
        }else if (self.orderType == CKQuickOrderTypeFootball){
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@", orderID] dissmissPresent:YES animation:NO];
        }
    }];
    
}

#pragma mark - PayclientProtocol
- (void)ck_PayClinetStartPayment
{
    [self showLoading];
}

- (void)ck_payClientEndPaymentWithReqState:(BOOL)state message:(id)msg
{
    if (state) {
        
    }else{
        [self show:msg];
    }
    [self stopLoading];
}

#pragma mark ------------ getter Mothed ------------
- (UIImageView *)backView{
    
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backView.contentMode = UIViewContentModeScaleToFill;
        _backView.alpha = 0.5;
        _backView.image = self.backImage;
    }
    return _backView;
}
- (CKQuickPayHomeView *)paymentView{
    
    if (!_paymentView) {
        WS(_weakSelf)
        _paymentView = [CKQuickPayHomeView QuickPaymentViewPreHandleToken:self.preHandleToken viewController:self paymentActionBlock:^(CKPaymentBaseSource *source,NSString *orderId) {
            /** 支付回调 */
            source.didFinishenPay = ^(id obj) {
                //        [_weakSelf continueToTheNextStepOfPayFinished:obj];
            };
            source.didFinishedPayWithResult = ^(BOOL isException, id obj){
                [self stopLoading];
                [_weakSelf continueToTheNextStepOfPayFinished:obj isException:isException orderID:orderId];
            };
            [CKPayClient sharedManager].delegate = _weakSelf;
            [CKPayClient startPay];
        }];
        
        _paymentView.cancelButtonBlock = ^{
            [_weakSelf dismissViewControllerAnimated:NO completion:nil];
        };
    }
    return _paymentView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
