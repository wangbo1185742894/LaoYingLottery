//
//  CLSFCBetDetailsController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCBetDetailsController.h"
#import "UIResponder+CLRouter.h"
#import "CLConfigMessage.h"
#import "CLSFCManager.h"
#import "CLCheckProgessManager.h"
#import "CLLotteryAllInfo.h"

#import "SLBetDetailsTopView.h"

#import "SLBetDetailsFooterView.h"

#import "CLSFCBetDetailBottomView.h"

#import "SLEndBetAlertView.h"

#import "CLLotteryCreateOrderRequset.h"

#import "CLSFCDetailsCell.h"
#import "CLSFCBetModel.h"

#import "CLWebViewActivityViewController.h"

#import "UIBarButtonItem+SLBarButtonItem.h"

#import "CLLoadingAnimationView.h"

#import "CKNewPayViewController.h"

#import "UINavigationController+CLDestroyCurrentController.h"


@interface CLSFCBetDetailsController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

/**
 顶部View(编辑/清空赛事)
 */
@property (nonatomic, strong) SLBetDetailsTopView *topView;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) CALayer *whiteLayer;
@property (nonatomic, strong) UIView *whiteView;

/**
 tableView的区尾
 */
@property (nonatomic, strong) SLBetDetailsFooterView *footerView;

@property (nonatomic, strong)NSMutableArray *dateArray;

/**
 底部投注项View
 */
@property (nonatomic, strong) CLSFCBetDetailBottomView *detailBottomView;

@property (nonatomic, strong) UIView *maskView;

/**
 创建订单请求
 */
@property (nonatomic, strong) CLLotteryCreateOrderRequset *createOreder;


@property (nonatomic, strong) UIAlertController *alertVC;

@property (nonnull, strong) SLEndBetAlertView *endBetAlertView;

@property (nonatomic, strong) NSString *lotteryGameEn;

@end

@implementation CLSFCBetDetailsController

- (void)dealloc
{
    
    NSLog(@"我死了");
}

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.lotteryGameEn = params[@"gameEn"];
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [self.createOreder cancel];
    
    self.createOreder.delegate = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.createOreder.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
        
    [self configData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configNavigation];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.detailBottomView];
    
    self.listTableView.tableFooterView = self.footerView;
    [self.listTableView.layer addSublayer:self.whiteLayer];
    
    self.view.backgroundColor = UIColorFromRGB(0xfaf8f6);
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.view);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(CL__SCALE(15.f));
        make.right.equalTo(self.view.mas_right).offset(CL__SCALE(-15.f));
        make.height.mas_equalTo(CL__SCALE(5.f));
    }];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.whiteView.mas_bottom);
        make.left.equalTo(self.whiteView.mas_left);
        make.right.equalTo(self.whiteView.mas_right);
        make.bottom.equalTo(self.detailBottomView.mas_top);
    }];
    
    [self.detailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.whiteLayer.frame = CGRectMake(0, - CL_SCREEN_HEIGHT, self.listTableView.frame.size.width, CL_SCREEN_HEIGHT);
}

- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{

    if ([eventName isEqualToString:@"CLSFCBETDETAILSOPTIONSRELOADUI"]) {
        
        [self.detailBottomView reloadBetDetailBottonViewUI];
    }
}


#pragma mark ----- 配置数据 -----
- (void)configData{
    
    [self.dateArray removeAllObjects];
    [self.dateArray addObjectsFromArray:[[CLSFCManager shareManager] getListData]];
    
    [self.detailBottomView reloadBetDetailBottonViewUI];
    [self.listTableView reloadData];
    
}

#pragma mark ------------ event Response ------------
- (void)hiddenKeyBoard{
    
    [self.detailBottomView hiddenKeyBoard];
}


#pragma mark ------------ keyBoard Notification ------------
- (void)keyboardShow:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:NO];
}

- (void)keyboardHidden:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:YES];
}



#pragma mark - 键盘出现或消失的动画
- (void)keyboardAnimationWithNoti:(NSNotification *)noti isHidden:(BOOL)isHidden{
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//动画时间
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];//动画曲线
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger height = isHidden ? 0 : - keyboardRect.size.height;
    [self.detailBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(height);
        make.left.right.equalTo(self.view);
    }];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    [self.view layoutIfNeeded];
    self.maskView.hidden = isHidden;
    // commit animations
    [UIView commitAnimations];
}


- (void)configNavigation
{
    self.navTitleText = @"投注详情";
    
    UIBarButtonItem *backItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(backItemClick)];
    
    UIBarButtonItem *space = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
    self.navigationItem.leftBarButtonItems = @[space,backItem];
    
}

- (void)backItemClick
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --- 立即支付 ----
- (void)confirmPay
{
    if ([[CLSFCManager shareManager] getNoteNumber] < 1) {
        [self show:@"每场比赛请至少选择一个赛果"];
        return;
    }
    

    self.createOreder.gameId = [[CLSFCManager shareManager] getGameId];
    
    self.createOreder.betTimes = [NSString stringWithFormat:@"%ld",[[CLSFCManager shareManager] getBetTimes]];
    
    self.createOreder.periodId = [[CLSFCManager shareManager] getPeriodId];
    
    self.createOreder.lotteryNumber = [[CLSFCManager shareManager] getLotteryNumber];

    NSInteger amount = [[CLSFCManager shareManager] getNoteNumber];
    
    self.createOreder.amount = [NSString stringWithFormat:@"%zi",amount * 2 * [[CLSFCManager shareManager] getBetTimes]];

    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    
    [self.createOreder start];
}

#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        WS(_weakSelf)
        
        NSDictionary *resp = request.urlResponse.resp;
        
        if ([request.urlResponse.resp[@"isBetAvailable"] integerValue] == 0) {
            
            //有几场比赛过期  弹窗 重新选择 返回选号页面
            self.endBetAlertView = [[SLEndBetAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            
            self.endBetAlertView.type = SLEndBetGuideTypeNoSale;
            
            self.endBetAlertView.title = resp[@"saleInfo"];
            self.endBetAlertView.jumpButtonTitle = resp[@"buttonTips"];
            self.endBetAlertView.desText = resp[@"message"];
            
            
            if ([resp[@"jumpType"] integerValue] == 2) {
                
                self.endBetAlertView.jumpLotteryBlock = ^{
                    
                    [_weakSelf dismissViewControllerAnimated:YES completion:^{
                        //[SLExternalService goToFootBallViewController];
                    }];
                    
                    
                    //[[BBMatchInfoManager shareManager] clearMatch];
                };
                
            }else{
                
                self.endBetAlertView.jumpLotteryBlock = ^{
                    
                    [_weakSelf.navigationController popViewControllerAnimated:YES];
                };
            }
            
            
            [self.view.window addSubview:self.endBetAlertView];
            
            
        }else{
            
            CKNewPayViewController *paymentController = [[CKNewPayViewController alloc] init];
            paymentController.lotteryGameEn = self.lotteryGameEn;
            paymentController.pushType = CKPayPushTypeBet;
            paymentController.period = [[CLSFCManager shareManager] getPeriodId];
            paymentController.periodTime = [[CLSFCManager shareManager] getPeriodTime];
            
            //普通订单
            paymentController.orderType = CKOrderTypeNormal;
            
            paymentController.hidesBottomBarWhenPushed = YES;
            paymentController.payConfigure = resp;
            
            [self.navigationController pushDestroyViewController:paymentController animated:YES];
            
            
            [[CLSFCManager shareManager] clearOptions];
        }
        
    }else{
        
        [self show:request.urlResponse.errorMessage];
    }
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
}

- (void)requestFailed:(CLBaseRequest *)request{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    [self show:request.urlResponse.errorMessage];
}


#pragma mark --- TableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CL__SCALE(60.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLSFCBetModel *model = self.dateArray[indexPath.row];
    
    CLSFCDetailsCell *cell = [CLSFCDetailsCell createCellWithTableView:tableView];
    
    if (indexPath.row == self.dateArray.count - 1) {
        
//        model.hiddenBottomLine = YES;
//    }else{
//        
//        model.hiddenBottomLine = NO;
    }
//    
    [cell setData:model];
    
    return cell;
    
}


#pragma mark ---- Get Method ---

- (SLBetDetailsTopView *)topView
{
    
    if (_topView == nil) {
        WS(_weak)
        _topView = [[SLBetDetailsTopView alloc] initWithFrame:(CGRectZero)];
        [_topView returnEditClick:^{
            
            [_weak backItemClick];
        }];
        
        [_topView returnEmptyClick:^{
            
            [[CLSFCManager shareManager] clearOptions];
            [_weak.detailBottomView reloadBetDetailBottonViewUI];
            [_weak.listTableView reloadData];
        }];
        
        [_topView setIsShowSelectNumber:NO];
    }
    
    return _topView;
}

- (UITableView *)listTableView
{
    
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.estimatedRowHeight = 400;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.showsHorizontalScrollIndicator = NO;
        
        _listTableView.contentInset = UIEdgeInsetsMake(0, 0, CL__SCALE(20.f), 0);
        
        _listTableView.backgroundColor = UIColorFromRGB(0xfaf8f6);
        
    }
    
    return _listTableView;
}

- (SLBetDetailsFooterView *)footerView
{
    
    if (_footerView == nil) {
        WS(_weakSelf)
        _footerView = [[SLBetDetailsFooterView alloc] initWithFrame:(CGRectMake(0, 0, 200, 33))];
        _footerView.entrustBlock = ^{
            
            CLWebViewActivityViewController *webView = [[CLWebViewActivityViewController alloc] init];
            webView.activityUrlString = @"https://m.caiqr.com/help/c2cAgreementYing.html";
            [_weakSelf.navigationController pushViewController:webView animated:YES];
        };
    }
    return _footerView;
}

- (NSMutableArray *)dateArray
{
    
    if (_dateArray == nil) {
        
        _dateArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dateArray;
}

- (CLSFCBetDetailBottomView *)detailBottomView{
    
    if (!_detailBottomView) {
        _detailBottomView = [[CLSFCBetDetailBottomView alloc] init];
        WS(_weakSelf)
        _detailBottomView.payBlock = ^{
            
            //检查是否登录
            [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
                [_weakSelf confirmPay];
            }];            
        };
    }
    return _detailBottomView;
}

- (UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        
        _maskView.backgroundColor = UIColorFromRGBandAlpha(0x000000, 0.7);
        _maskView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}


- (CALayer *)whiteLayer{
    
    if (!_whiteLayer) {
        _whiteLayer = [[CALayer alloc] init];
        _whiteLayer.backgroundColor = UIColorFromRGB(0xffffff).CGColor;
    }
    return _whiteLayer;
}
- (UIView *)whiteView{
    
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _whiteView;
}

- (CLLotteryCreateOrderRequset *)createOreder
{
    
    if (!_createOreder) {
        _createOreder = [[CLLotteryCreateOrderRequset alloc] init];
        _createOreder.delegate = self;
    }
    return _createOreder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
