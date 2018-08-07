//
//  CKFOPAlertViewController.m
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKFOPAlertViewController.h"
#import "CKPayConfigFile.h"
#import "CKFOPAlertView.h"
#import "CKFOPModel.h"
#import "CKFOPService.h"

@interface CKFOPAlertViewController ()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, copy) void (^ resetFreeOfPay)(id);//设置完成 或者不设置的回调
@property (nonatomic, strong) UIView *backBlackView;//黑色背景
@property (nonatomic, strong) CKFOPAlertView *alterView;
@property (nonatomic, strong) CKFOPModel *mainDataModel;
@property (nonatomic, weak) CKFOPService *publicService;
@end

@implementation CKFOPAlertViewController


+ (void)creatFreeOfPayViewControllerWithPushViewController:(UIViewController *)pushVC service:(CKFOPService *)service complete:(void (^)(id))resetComplete{
    
    CKFOPAlertViewController *vc = [[CKFOPAlertViewController alloc] init];
    vc.resetFreeOfPay = resetComplete;
    vc.publicService = service;
    vc.view.backgroundColor = CKFOP_UIColorFromRGB(0xffffff);
    [vc.view addSubview:vc.backImageView];
    [vc.view addSubview:vc.backBlackView];
    [vc.view addSubview:vc.alterView];
    vc.backImageView.image = snapshotView(pushVC.navigationController.view);
//    vc.viewControllerName = @"小额免密快捷设置";
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
        _backImageView.backgroundColor = [UIColor clearColor];
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

- (CKFOPAlertView *)alterView{
    if (!_alterView) {
        _alterView = [CKFOPAlertView creatWithData:self.publicService.mainDataModel frame:CGRectMake(0, 0, CKFOP_SCREEN_WIDTH/4.0*3, CKFOP_SCREEN_WIDTH/3.0*2+CKFOP_SCALE(40))];
        _alterView.center = self.view.center;
        
        _alterView.chooseComplete = ^(id obj){
            [self dismissViewControllerAnimated:NO completion:^{
                self.resetFreeOfPay?self.resetFreeOfPay(obj):nil;
            }];
        };
    }
    return _alterView;
}

@end
