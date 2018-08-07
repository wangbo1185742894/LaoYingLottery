//
//  CQFreeOfPaymentViewController.m
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CQFreeOfPaymentViewController.h"
#import "CLTools.h"
#import "CQDefinition.h"
#import "CQSetFreePPSWAlterView.h"
#import "CQFreeOfpayModel.h"
#import "CQFreeOfPayService.h"
@interface CQFreeOfPaymentViewController ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, copy) void (^ resetFreeOfPay)();//设置完成 或者不设置的回调
@property (nonatomic, strong) UIView *backBlackView;//黑色背景
@property (nonatomic, strong) CQSetFreePPSWAlterView *alterView;
@property (nonatomic, strong) CQFreeOfpayModel *mainDataModel;
@property (nonatomic, weak) CQFreeOfPayService *publicService;
@end

@implementation CQFreeOfPaymentViewController


+ (void)creatFreeOfPayViewControllerWithPushViewController:(UIViewController *)pushVC service:(CQFreeOfPayService *)service complete:(void (^)())resetComplete{
    
    CQFreeOfPaymentViewController *vc = [[CQFreeOfPaymentViewController alloc] init];
    vc.resetFreeOfPay = resetComplete;
    vc.publicService = service;
    vc.view.backgroundColor = UIColorFromRGB(0xffffff);
    [vc.view addSubview:vc.backImageView];
    [vc.view addSubview:vc.backBlackView];
    [vc.view addSubview:vc.alterView];
    vc.backImageView.image = snapshot(pushVC.navigationController.view);
    vc.pageStatisticsName = @"小额免密快捷设置";
    [pushVC presentViewController:vc animated:NO completion:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get method
- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backImageView.backgroundColor = CLEARCOLOR;
    }
    return _backImageView;
}
- (UIView *)backBlackView{
    if (!_backBlackView) {
        _backBlackView = [[UIView alloc] initWithFrame:self.view.bounds];
        _backBlackView.backgroundColor = [UIColor blackColor];
        _backBlackView.alpha = 0.7;
    }
    return _backBlackView;
}

- (CQSetFreePPSWAlterView *)alterView{
    if (!_alterView) {
        _alterView = [CQSetFreePPSWAlterView creatWithData:self.publicService.mainDataModel frame:CGRectMake(0, 0, SCREEN_WIDTH/4.0*3, SCREEN_WIDTH/3.0*2+__SCALE(40))];
        _alterView.center = self.view.center;
        WS(weakself)
        _alterView.chooseComplete = ^(){
            [weakself dismissViewControllerAnimated:NO completion:^{
                weakself.resetFreeOfPay?weakself.resetFreeOfPay():nil;
            }];
        };
    }
    return _alterView;
}

@end
