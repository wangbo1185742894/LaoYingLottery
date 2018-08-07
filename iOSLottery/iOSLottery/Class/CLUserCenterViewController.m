//
//  CLUserCenterViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCenterViewController.h"
#import "CLLotteryBetOrderListViewController.h"
#import "CLFollowListViewController.h"
#import "CLUserCenterHeaderView.h"
#import "CLUserCenterItemCell.h"
#import "Masonry.h"

#import "CLUserCenterPageConfigure.h"
#import "CLRedEnvelopeViewController.h"

#import "CLAppContext.h"
#import "CLUserBaseInfo.h"

//#import "CLRechargeController.h"
#import "CQCustomerEntrancerService.h"

#import "CLUserCenterRequest.h"

#import "UIScrollView+CLRefresh.h"

#import "CLAccountInfoModel.h"
//无网 浮层
#import "CLNoNetFloatView.h"
#import "CLNetworkReachabilityManager.h"

#import "CLActivityViewController.h"

#import "CLUserCenterItem.h"

#import "CLUmengShareManager.h"
#import "CQBuyRedPacketsViewController.h"
#import "CKNewRechargeViewController.h"
#import "CLBetLimitRequestTool.h"
@interface CLUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource,CLUserCenterHeaderDelegate, CLRequestCallBackDelegate>

/**
 列表试图
 */
@property (nonatomic, strong) UITableView* centerTableView;

/**
 头部视图
 */
@property (nonatomic, strong) CLUserCenterHeaderView* headerView;

/**
 设置按钮
 */
@property (nonatomic, strong) UIBarButtonItem* settingButtonItem;

/**
 客服
 */
@property (nonatomic, strong) UIBarButtonItem* serviceButtonItem;

/**
 数据数组
 */
@property (nonatomic, strong) NSMutableArray* centerData;

/**
 登录状态
 */
@property (nonatomic) BOOL loginState;

/**
 tableView的item模型
 */
@property (nonatomic, strong) CLUserCenterItem* accountItem;
@property (nonatomic, strong) CLUserCenterItem* redEnveItem;

@property (nonatomic, strong) CLUserCenterRequest *userCenterRequest;//红包账户请求

@property (nonatomic, strong) CLNoNetFloatView *noNetFloatView;//无网浮层
@end

@implementation CLUserCenterViewController

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navTitleText = @"我";
    
    [self.navigationItem setLeftBarButtonItem:self.serviceButtonItem];
    [self.navigationItem setRightBarButtonItem:self.settingButtonItem];
    
    [self.view addSubview:self.centerTableView];
    
    [self.centerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(IOS_VERSION >= 11 ? 49 : 0);
    }];
    
    //添加 网络监听通知
    [self addNoNetNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.userCenterRequest start];
}

- (void)viewDidAppear:(BOOL)animated {
    
    self.loginState = [CLAppContext context].appLoginState;
    [self configureData];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self.centerTableView stopRefreshAnimating];
}

- (void)configureData {
    
    
    if (!DEFAULTS(bool, @"bet_limit_status")) {    
        self.centerTableView.alpha = 0;
    }
    self.headerView.isLoginning = self.loginState;
    //如果登录状态 则出现下拉刷新 未出现则不出现
    if ([CLAppContext context].appLoginState) {
        
        [self.centerTableView showsRefresh:YES];
    }else{
        [self.centerTableView showsRefresh:NO];
    }
    
    if ([CLAppContext context].appLoginState) self.headerView.userNickName = [CLAppContext context].userMessage.user_info.nick_name;
    if ([CLAppContext context].appLoginState) self.headerView.userHeadImg = [CLAppContext context].userMessage.user_info.head_img_url;
    
    if (DEFAULTS(bool, @"bet_limit_status")) {
        [self.headerView updateData];
        self.headerView.isShowBottomView = YES;
        if (self.loginState) {
            self.accountItem.title = [NSString stringWithFormat:@"余额: %.2f元",[CLAppContext context].userMessage.account_info.account_balance / 100.0];
            self.redEnveItem.title = [NSString stringWithFormat:@"红包: %@元",@([CLAppContext context].userMessage.account_info.red_balance / 100)];
        } else {
            self.accountItem.title = @"余额: --";
            self.redEnveItem.title = @"红包: --";
        }
        self.centerTableView.alpha = 1;
        [self.centerTableView reloadData];
    }else{
        [bet_limit_tool setBetlimitCallBack:^(BOOL state) {
            if (state) {
                [self.headerView updateData];
                self.headerView.isShowBottomView = YES;
                if (self.loginState) {
                    self.accountItem.title = [NSString stringWithFormat:@"余额: %.2f元",[CLAppContext context].userMessage.account_info.account_balance / 100.0];
                    self.redEnveItem.title = [NSString stringWithFormat:@"红包: %@元",@([CLAppContext context].userMessage.account_info.red_balance / 100)];
                } else {
                    self.accountItem.title = @"余额: --";
                    self.redEnveItem.title = @"红包: --";
                }
                _centerData = nil;
                [self.centerTableView reloadData];
            }else{
                [self.headerView updateData];
                [self.centerData removeAllObjects];
                self.headerView.isShowBottomView = NO;
                self.navigationItem.leftBarButtonItem = nil;
                [self.centerTableView reloadData];
            }
            self.centerTableView.alpha = 1;
        }];
        [bet_limit_tool startCheckBetLimit];
    }
    
    
    
    
}
#pragma mark ------------ private mothed ------------
- (void)configData:(id)info{
    
    NSString* redAdImg = info[@"red_ad_img"];
    if ([redAdImg isKindOfClass:[NSString class]] && redAdImg.length > 0 ) {
        self.headerView.redEnvopleImgUrl = redAdImg;
    }
    CLAccountInfoModel *accountInfo = [CLAccountInfoModel mj_objectWithKeyValues:info[@"account_info"]];
    if (!accountInfo) return;
    if ( !info || (!info[@"red_balance"]) || (!info[@"red_ad_img"])) {
        return;
    }
    [CLAppContext context].userMessage.account_info.account_balance = accountInfo.balance * 100.f;
    [CLAppContext context].userMessage.account_info.red_balance = [info[@"red_balance"] doubleValue] * 100.f;
    [self configureData];  
}

#pragma mark - 添加无网络通知
- (void)addNoNetNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkHasChange:) name:@"CLNetworkReachabilityDidChangeNotificationName" object:nil];
    [CLNetworkReachabilityManager startMonitoring];
}
#pragma mark - 无网浮层
- (void)networkHasChange:(NSNotification *)userInfo{
    if ([[userInfo.userInfo objectForKey:APP_HASNET] integerValue] == 0) {//联网成功
        NSLog(@"1111%@", self.noNetFloatView);
        [self.view addSubview:self.noNetFloatView];
        self.noNetFloatView.hidden = NO;
    }else{//无网络连接
        [self.noNetFloatView removeFromSuperview];
        self.noNetFloatView.hidden = YES;
    }
}
#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success && request.urlResponse.resp) {
        if ([request.urlResponse.resp isKindOfClass:[NSArray class]] && ((NSArray *)request.urlResponse.resp).count > 0) {
            
            [self configData:request.urlResponse.resp[0]];
        }
    }
    [self.centerTableView stopRefreshAnimating];
}

- (void)requestFailed:(CLBaseRequest *)request{
    self.centerTableView.alpha = 1;
    [self.centerTableView stopRefreshAnimating];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.centerData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.centerData[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) return 0.f;
    
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLUserCenterItem* item = self.centerData[indexPath.section][indexPath.row];
    return item.showNeedLogin?((self.loginState)?44:0):44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    CLUserCenterItemCell *cell = [CLUserCenterItemCell userCenterItemCreateWithTableView:tableView];
    
    CLUserCenterItem* item = self.centerData[indexPath.section][indexPath.row];
    
    cell.item = item;
    
//    if (indexPath.row == ((NSArray *)self.centerData[indexPath.section]).count - 1) {
//        cell.has_bottomLine = NO;
//    }else{
//        cell.has_bottomLine = YES;
//    }
    
    cell.has_bottomLine = (indexPath.row == ((NSArray *)self.centerData[indexPath.section]).count - 1)?NO : YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLUserCenterItem* item = self.centerData[indexPath.section][indexPath.row];
    switch (item.type) {
        case UserCenterCellTypeAccount:{
            [CLUserCenterPageConfigure pushPersonalAccountJournalViewController];
        }break;
        case UserCenterCellTypeRedEnvelop:{
            [CLUserCenterPageConfigure pushRedEnvoloperJournalViewController];
        }
            break;
        case UserCenterCellTypeBet:{
            if (self.loginState) {
                [CLUserCenterPageConfigure pushLotteryBetOrderListController];
            }else{
                [CLUserCenterPageConfigure presentLoginViewController];
            }
            
        }
            break;
        case UserCenterCellTypeFollow:{
            if (self.loginState) {
                [CLUserCenterPageConfigure pushLotteryFollowProgramsListController];
            }else{
                [CLUserCenterPageConfigure presentLoginViewController];
            }
            
        }
            break;
        case UserCenterCellTypeActivity:{

            CLActivityViewController *activityVC = [[CLActivityViewController alloc] init];
            [self.navigationController pushViewController:activityVC animated:YES];
        
        }
            
            break;
        case UserCenterCellTypeHelp:

            [CLUserCenterPageConfigure pushHelpFeedbackViewController];
        {
        }
            break;
        default:
            break;
    }
}



#pragma mark - CLUserCenterHeaderDelegate

- (void)userCenterHeaderActionType:(CLUserCenterHeaderActionType)type {
    
    if (type == CLUserCenterHeaderActionTypeHeadImg) {
        //点击头像
        [CLUserCenterPageConfigure pushChangePersonalHeadImgViewController];
    }
    
    if (type == CLUserCenterHeaderActionTypePersonalMsg) {
        //个人信息
        [CLUserCenterPageConfigure pushPersonalMessageViewController];
    }
    
    if (![CLAppContext context].appLoginState || type == CLUserCenterHeaderActionTypeLoginning) {
        
        [CLUserCenterPageConfigure presentLoginViewController];
        
        return;
    }
    
    if (type == CLUserCenterHeaderActionTypeVC) {
        //充值
        [CLUserCenterPageConfigure pushVoucherCenterViewController];
    }
    
    if (type == CLUserCenterHeaderActionTypeDF) {
        //提现
        [CLUserCenterPageConfigure pushDFViewController];
    }
    
    if (type == CLUserCenterHeaderActionTypeRE) {
        //买红包
        [CLUserCenterPageConfigure pushBuyRedEnvolopeViewController];
    }
    
}

#pragma mark - Event 
//设置
- (void)settingEvent:(id)sender {
    
    [CLUserCenterPageConfigure pushSettingViewController];
}

//客服
- (void)customServiceEvent:(id)sender {
    
    WS(_ws);
    [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_ws];
}

#pragma mark -getter Mothed

- (UITableView *)centerTableView {
    
    if (!_centerTableView) {
        
        _centerTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _centerTableView.tableHeaderView = self.headerView;
        _centerTableView.delegate = self;
        _centerTableView.dataSource = self;
        _centerTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _centerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _centerTableView.alpha = 0;
        WS(_weakSelf)
        [_centerTableView addRefresh:^{
            
            [_weakSelf.userCenterRequest start];
        }];
        
    }
    return _centerTableView;
}

- (CLUserCenterHeaderView *)headerView {
    
    if (!_headerView) {
//        _headerView = [[CLUserCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, __SCALE(120))];
        _headerView = [[CLUserCenterHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, __SCALE(120))];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)centerData {
    
    if (!_centerData) {
        
        _centerData = [NSMutableArray new];
        
        self.accountItem = [CLUserCenterItem userCenterItmeWithTitile:@"余额: -" type:(UserCenterCellTypeAccount) showNeedLogin:YES imageName:@"userCenteraccountRecode"];
        
        self.redEnveItem = [CLUserCenterItem userCenterItmeWithTitile:@"红包: -" type:(UserCenterCellTypeRedEnvelop) showNeedLogin:YES imageName:@"userCenterredPacketRecode"];
        
        CLUserCenterItem *betItem = [CLUserCenterItem userCenterItmeWithTitile:@"投注订单" type:(UserCenterCellTypeBet) showNeedLogin:NO imageName:@"userCenterrecode"];
        
        CLUserCenterItem *followItem = [CLUserCenterItem userCenterItmeWithTitile:@"追号方案" type:(UserCenterCellTypeFollow) showNeedLogin:NO imageName:@"userCenterFollow"];
        
        
        CLUserCenterItem *activityItem = [CLUserCenterItem userCenterItmeWithTitile:@"活动" type:(UserCenterCellTypeActivity) showNeedLogin:NO imageName:@"userCenteractive"];
        
        
        CLUserCenterItem *helpItem = [CLUserCenterItem userCenterItmeWithTitile:@"帮助与反馈" type: (UserCenterCellTypeHelp) showNeedLogin:NO imageName:@"userCenterhelpAndFeedback"];
        
        [_centerData addObject:@[self.accountItem,self.redEnveItem]];
        [_centerData addObject:@[betItem,followItem]];
        [_centerData addObject:@[activityItem,helpItem]];
    }
    return _centerData;
}

- (UIBarButtonItem *)settingButtonItem {
    
    if (!_settingButtonItem) {
        _settingButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userCenterSetIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(settingEvent:)];
    }
    return _settingButtonItem;
}

- (UIBarButtonItem *)serviceButtonItem {
    
    if (!_serviceButtonItem) {
        _serviceButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userCenterService.png"] style:UIBarButtonItemStylePlain target:self action:@selector(customServiceEvent:)];
    }
    return _serviceButtonItem;
}
- (CLUserCenterRequest *)userCenterRequest{
    
    if (!_userCenterRequest) {
        _userCenterRequest = [[CLUserCenterRequest alloc] init];
        _userCenterRequest.delegate = self;
    }
    return _userCenterRequest;
}

- (CLNoNetFloatView *)noNetFloatView{
    
    if (!_noNetFloatView) {
        _noNetFloatView = [[CLNoNetFloatView alloc] initWithFrame:__Rect(0, SCREEN_HEIGHT- 64 - 49-  __SCALE(38), SCREEN_WIDTH, __SCALE(38))];
    }
    return _noNetFloatView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}


@end


