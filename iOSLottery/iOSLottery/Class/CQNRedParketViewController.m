//
//  CQNRedParketViewController.m
//  caiqr
//
//  Created by 小铭 on 2017/5/5.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQNRedParketViewController.h"
#import "CKCustomPaymentHomeView.h"
#import "Masonry.h"
#import "CKPaymentBaseSource.h"
#import "CKPayClient.h"
@interface CQNRedParketViewController ()<CKPayClientDelegate>

@property (nonatomic, strong) CKCustomPaymentHomeView *paymentView;

@end

@implementation CQNRedParketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"买红包";
    WS(_weakSelf)
    self.paymentView = [CKCustomPaymentHomeView CustomPaymentViewIsBuyRed:YES preHandleToken:_flowIDString viewController:self paymentActionBlock:^(CKPaymentBaseSource * source,NSString *orderID) {
        source.didFinishedPayWithResult = ^(BOOL isException, id obj){
            [_weakSelf buyRedPacketFinishPopFirstNoTagViewController:isException page:obj];
        };
        [CKPayClient sharedManager].delegate = self;
        [CKPayClient startPay];
    }];
    [self.view addSubview:self.paymentView];
    [self.paymentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.paymentView startRequest];
}

- (void)buyRedPacketFinishPopFirstNoTagViewController:(BOOL)isException page:(NSString *)page
{
    
    if (self.navigationController.viewControllers.count > 2) {
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 3] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - paymentClientProtocol

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
