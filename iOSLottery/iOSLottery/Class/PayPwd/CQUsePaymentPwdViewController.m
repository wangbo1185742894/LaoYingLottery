//
//  CQUsePaymentPwdViewController.m
//  caiqr
//
//  Created by 彩球 on 16/4/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUsePaymentPwdViewController.h"
#import "CQSetPaymentPwdView.h"
#import "CLAlertController.h"
#import "CLPayPwdCheckAPI.h"
#import "CQCustomerEntrancerService.h"
@interface CQUsePaymentPwdViewController () <CLRequestCallBackDelegate,CLAlertControllerDelegate>

@property (nonatomic, strong) UIImageView* screenImgView;
@property (nonatomic, strong) CALayer* alpLayer;
@property (nonatomic, strong) CQUserPaymentPwdView* usePayPwdView;

@property (nonatomic, strong) UIImage* screenImg;

@property (nonatomic, strong) CLPayPwdCheckAPI* checkAPI;

@end

@implementation CQUsePaymentPwdViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hideNavigationBar = NO;
    [self.usePayPwdView cancelKeyBoardObserver];
    [self.usePayPwdView hideKeyboard];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hideNavigationBar = YES;
    [self.usePayPwdView addkeyBoardObserver];
}

- (instancetype) initWithCommonParam:(id)params
{
    self = [super init];
    if (self) {
        self.screenImg = params;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageStatisticsName = @"验证支付密码";
    [self.view addSubview:self.screenImgView];
    [self.view.layer addSublayer:self.alpLayer];
    [self.view addSubview:self.usePayPwdView];
    [self.usePayPwdView startEdit];
}



#pragma mark - private

- (void)setPaymentPassword:(NSString*)password
{
    if (password && (password.length == 6)) {
        //self.needToShowLoadingAnimate = YES;
        self.usePayPwdView.controlCanInput = NO;
        
        self.checkAPI.pay_pwd = password;
        [self.checkAPI start];
        
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self requestSuccess:[request.urlResponse.resp firstObject]];
    } else {
        [self.usePayPwdView clearPassword];
        self.usePayPwdView.controlCanInput = YES;
    }
    
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self.usePayPwdView clearPassword];
    self.usePayPwdView.controlCanInput = YES;
}

- (void)requestSuccess:(id)info
{
    if (![info isKindOfClass:[NSDictionary class]]) return;
    
    NSInteger status = [info[@"status"] integerValue];
    NSString* message = info[@"message"];
    switch (status) {
        case 1:
        {   //成功
            [self show:@"验证成功"];
            
            DELAY(1.f, ^{
                self.usePayPwdView.controlCanInput = YES;
                [self closeViewControllerReturnBlock];
            });
            
        } break;
        case 2:
        {   //错误在限制次数以内
            [self.usePayPwdView clearPassword];
            [self show:message];
            self.usePayPwdView.controlCanInput = YES;
            [self.usePayPwdView startAnimate];
        } break;
        case 3:
        {   //支付密码被锁定
            self.usePayPwdView.hidden = YES;
            [self.usePayPwdView clearPassword];
            [self.usePayPwdView hideKeyboard];
        } break;
        default:
            [self.usePayPwdView clearPassword];
            [self show:@"未验证成功,请重新验证"];
            self.usePayPwdView.controlCanInput = YES;
            [self.usePayPwdView startAnimate];
            break;
    }
    
    
}


- (void)forgetPayPassword
{
    [self.usePayPwdView hideKeyboard];
    WS(_weakSelf)
    [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_weakSelf];
    
//    [self.alertView show];
}

- (void)closeViewControllerReturnBlock
{
    /** 如果浮层显示 便隐藏 */
    //if (!self.serviceView.serviceHidden) self.serviceView.serviceHidden = YES;
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.passwordCheckSuccess) self.passwordCheckSuccess();
    }];
}

- (void)closeViewController
{
    /** 如果浮层显示 便隐藏 */
    //if (!self.serviceView.serviceHidden) self.serviceView.serviceHidden = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)keyboardObserver:(BOOL)show height:(CGFloat)height
{
    if (show) {
        CGFloat canMoveLength = (SCREEN_HEIGHT - (SCREEN_HEIGHT + __Obj_Bounds_Height(self.usePayPwdView)) / 2.f) - ( height + 5.f);
        
        if (canMoveLength < 0) {
            [UIView animateWithDuration:.3f animations:^{
                self.usePayPwdView.center = CGPointMake(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f + canMoveLength);
            }];
        }
    }
    else
    {
        if (self.usePayPwdView.center.y != (SCREEN_HEIGHT / 2.f)) {
            [UIView animateWithDuration:.3f animations:^{
                self.usePayPwdView.center = CGPointMake(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f);
            }];
        }
    }
}


#pragma mark - CLAlertControllerDelegate

//- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index {
//    
//    if (index == 0)
//    {
//        NSString *phoneNum = @"4006892227";// 电话号码
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
//    }
//}



#pragma mark - getter


- (UIImageView *)screenImgView
{
    if (!_screenImgView) {
        _screenImgView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _screenImgView.image = self.screenImg;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeViewController)];
        [_screenImgView addGestureRecognizer:tap];
        _screenImgView.userInteractionEnabled = YES;
    }
    return _screenImgView;
}

- (CALayer *)alpLayer
{
    if (!_alpLayer) {
        _alpLayer = [CALayer layer];
        _alpLayer.frame = self.view.bounds;
        _alpLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3].CGColor;
    }
    return _alpLayer;
}

- (CQUserPaymentPwdView *)usePayPwdView
{
    if (!_usePayPwdView) {
        _usePayPwdView = [[CQUserPaymentPwdView alloc] initWithFrame:__Rect(0, 0, __SCALE(260.f), 0)];
        _usePayPwdView.center = CGPointMake(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f);
        WS(_weakSelf)
        _usePayPwdView.closeViewHandler = ^{
            [_weakSelf closeViewController];
        };
        _usePayPwdView.confirmEvent = ^(id password){
            [_weakSelf setPaymentPassword:password];
        };
        
        _usePayPwdView.forgetEvent = ^{
            [_weakSelf forgetPayPassword];
        };
        
        _usePayPwdView.keyBoardObserver = ^(BOOL show,CGFloat height){
            [_weakSelf keyboardObserver:show height:height];
        };
        
    }
    return _usePayPwdView;
}

- (CLPayPwdCheckAPI *)checkAPI {
    
    if (!_checkAPI) {
        _checkAPI = [[CLPayPwdCheckAPI alloc] init];
        _checkAPI.delegate = self;
    }
    return _checkAPI;
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
