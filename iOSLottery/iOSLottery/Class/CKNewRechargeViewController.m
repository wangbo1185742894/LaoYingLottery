//
//  CKNewRechargeViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKNewRechargeViewController.h"
#import "CKRechargeHomeView.h"
#import "CLConfigMessage.h"
#import "CKPaymentBaseSource.h"
#import "CLLoadingAnimationView.h"
#import "CKPayClient.h"
#import "CLAllJumpManager.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"

@interface CKNewRechargeViewController ()<CKPayClientDelegate>
@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
@property (nonatomic, strong) CKRechargeHomeView *homeView;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;

@end

@implementation CKNewRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"充值";
    [self.view addSubview:self.homeView];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];

    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    [self.homeView startRequest];
}

- (void)configSource:(CKPaymentBaseSource *)source{
    
    source.didFinishedPayWithResult = ^(BOOL isException, id obj){
        [[CLLoadingAnimationView shareLoadingAnimationView] stop];
        [self.navigationController popToRootViewControllerAnimated:YES];
    };

    [CKPayClient sharedManager].delegate = self;
    [CKPayClient startPay];

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

- (void)queryAction
{
     [self.alertPromptMessageView showInView:self.view.window];
}

#pragma mark ------------ getter Mothed ------------
- (CKRechargeHomeView *)homeView{
    
    WS(_weakSelf)
    if (!_homeView) {
        _homeView = [CKRechargeHomeView rechargeViewController:self paymentActionBlock:^(CKPaymentBaseSource *source, NSString *flowId) {
            
            [_weakSelf configSource:source];
        }];
//        _homeView.defaultAmount = 150;
    }
    return _homeView;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setImage:[UIImage imageNamed:@"whiteQuestion.png"] forState:UIControlStateNormal];
        rightFuncBtn.frame = CGRectMake(0, 0, 17, 17);
        [rightFuncBtn addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_Recharge;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
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
