//
//  CQSettingPaymentPwdViewController.m
//  caiqr
//
//  Created by 彩球 on 16/4/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQSettingPaymentPwdViewController.h"
#import "CQSetPaymentPwdView.h"
#import "CLPayPwdSettingAPI.h"
#import "CLSettingAdapter.h"

#import "AppDelegate.h"
#import "CLAllJumpManager.h"
@interface CQSettingPaymentPwdViewController () <CLRequestCallBackDelegate>

@property (nonatomic, strong) UIImageView* screenImgView;
@property (nonatomic, strong) CALayer* alpLayer;
@property (nonatomic, strong) CQSetPaymentPwdView* setPayPwdView;
@property (nonatomic, strong) UIImage* screenImg;

@property (nonatomic, strong) CLPayPwdSettingAPI* settingPayPwdAPI;
@property (nonatomic, strong) NSString *blockName;//回调名字

@end

@implementation CQSettingPaymentPwdViewController
- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.blockName = params[@"blockName"];
    }
    return self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.setPayPwdView cancelKeyBoardObserver];
    [self.setPayPwdView hideKeyboard];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.setPayPwdView addkeyBoardObserver];
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
    
    self.navTitleText = @"设置支付密码";
    [self.view addSubview:self.screenImgView];
    [self.view.layer addSublayer:self.alpLayer];
    [self.view addSubview:self.setPayPwdView];
    
    self.screenImgView.image = [self getImage];
    [self.setPayPwdView startEdit];
}

- (UIImage *)getImage {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView* view = app.window.rootViewController.view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - private


- (void)setPaymentPassword:(NSString*)password
{
    if (password && (password.length == 6)) {
        self.settingPayPwdAPI.pay_pwd = password;
        [self.settingPayPwdAPI start];
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [CLSettingAdapter updatePayPwdStatus:YES];
        [self show:@"设置成功"];
        DELAY(1.f, ^{
            [self closeViewControllerReturnBlock];
        });
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    //error message
    [self show:request.urlResponse.errorMessage];
}


- (void)exceptionMeeage:(NSString*)msg {
    
    [self show:msg];
}

- (void)closeViewControllerReturnBlock
{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.passwordSetterSuccess) self.passwordSetterSuccess();
        if (self.blockName && self.blockName.length > 0) {
            [[CLAllJumpManager shareAllJumpManager] open:self.blockName];
        }
    }];
}

- (void)closeViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)keyboardObserver:(BOOL)show height:(CGFloat)height
{
    if (show) {
        CGFloat canMoveLength = (SCREEN_HEIGHT - (SCREEN_HEIGHT + __Obj_Bounds_Height(self.setPayPwdView)) / 2.f) - ( height + 5.f);
        
        if (canMoveLength < 0) {
            [UIView animateWithDuration:.3f animations:^{
                self.setPayPwdView.center = CGPointMake(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f + canMoveLength - NavigationBar_HEIGHT);
            }];
        }
    }
    else
    {
        if (self.setPayPwdView.center.y != (SCREEN_HEIGHT / 2.f)) {
            [UIView animateWithDuration:.3f animations:^{
                self.setPayPwdView.center = CGPointMake(SCREEN_WIDTH / 2.f, SCREEN_HEIGHT / 2.f - NavigationBar_HEIGHT);
            }];
        }
    }
}

#pragma mark - getter


- (UIImageView *)screenImgView
{
    if (!_screenImgView) {
        _screenImgView = [[UIImageView alloc] initWithFrame:__Rect(0, - 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
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

- (CQSetPaymentPwdView *)setPayPwdView
{
    if (!_setPayPwdView) {
        _setPayPwdView = [[CQSetPaymentPwdView alloc] initWithFrame:__Rect((SCREEN_WIDTH - __SCALE(280.f)) / 2.f, SCREEN_HEIGHT / 7.f, __SCALE(280.f), 0)];
        WS(_weakSelf)
        _setPayPwdView.closeViewHandler = ^{
            [_weakSelf closeViewController];
        };
        _setPayPwdView.confirmEvent = ^(id password){
            [_weakSelf setPaymentPassword:password];
        };
        _setPayPwdView.keyBoardObserver = ^(BOOL show,CGFloat height){
            [_weakSelf keyboardObserver:show height:height];
        };
        _setPayPwdView.exceptionMessage = ^(NSString* msg) {
            [_weakSelf exceptionMeeage:msg];
        };
        
    }
    return _setPayPwdView;
}

- (CLPayPwdSettingAPI *)settingPayPwdAPI {
    
    if (!_settingPayPwdAPI) {
        _settingPayPwdAPI = [[CLPayPwdSettingAPI alloc] init];
        _settingPayPwdAPI.delegate = self;
    }
    return _settingPayPwdAPI;
}

- (void)dealloc {
    
    if (_settingPayPwdAPI) {
        _settingPayPwdAPI.delegate = nil;
        [_settingPayPwdAPI cancel];
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
