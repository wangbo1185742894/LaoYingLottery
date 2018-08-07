//
//  CLSFCViewController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//


#import "CLSFCViewController.h"
#import "CLNavigationView.h"

#import "CLConfigMessage.h"
#import "UIResponder+CLRouter.h"

//自定义View
#import "CLSFCTopView.h"
#import "CLSFCMainBetCell.h"
#import "CLSFCBetBottomView.h"

//请求接口
#import "CLSFCBetListRequset.h"

//单例管理者
#import "CLSFCManager.h"

#import "CLSFCBetDetailsController.h"

#import "CLEmptyPageService.h"

#import "CLLoadingAnimationView.h"

#import "CLAllJumpManager.h"

#import "CLLotteryBetHelperView.h"
#import "CLAwardListViewController.h"

#import "SLWebViewController.h"

@interface CLSFCViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLEmptyPageServiceDelegate>

/**
 头部玩法筛选按钮
 */
@property (nonatomic, strong) CLNavigationView *navigationView;

/**
 助手
 */
@property (nonatomic, strong) CLLotteryBetHelperView *helperView;

/**
 顶部期次，截止时间 View
 */
@property (nonatomic, strong) CLSFCTopView *topVeiw;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) CLSFCBetBottomView *bottomView;

@property (nonatomic, strong) CLSFCBetListRequset *request;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSDictionary *playDic;

/**
 空白页
 */
@property (nonatomic, strong) CLEmptyPageService *emptyPageService;

@end

@implementation CLSFCViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.LotteryGameEn = params[@"gameEn"];
    }
    return self;
}

#pragma mark ------ View LifeCycle ------
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self.mainTableView reloadData];
    [self.bottomView reloadUI];
        
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xF7F7EE);
    
    [self.view addSubview:self.navigationView];
    [self p_setNavigatation];
    
    [self.view addSubview:self.helperView];
   
    [self.view addSubview:self.topVeiw];

    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(CL__SCALE(50.f));
    }];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.topVeiw.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    [self.request start];

}

- (void)p_setNavigatation
{
    self.navigationView.navigationTitle = self.playDic[self.LotteryGameEn];
}

#pragma mark ----- 网络请求回调 -----
- (void)requestFinished:(CLBaseRequest *)request
{
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    if (request.urlResponse.success){
           
        [[CLSFCManager shareManager] disposeData:request.urlResponse.resp];
   
        self.dataArray = [[CLSFCManager shareManager] getListData];
        
        [self.mainTableView reloadData];
        [self.bottomView reloadUI];
        [self.topVeiw reloadUI];
    }
    
    self.bottomView.hidden = !(self.dataArray.count > 0);
    
    self.topVeiw.hidden = !(self.dataArray.count > 0);
    
    [self.emptyPageService showEmptyWithType:(self.dataArray.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.mainTableView];
}

- (void)requestFailed:(CLBaseRequest *)request
{

    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    [self.emptyPageService showEmptyWithType:(self.dataArray.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.mainTableView];
    
    self.topVeiw.hidden = !(self.dataArray.count > 0);
    
    self.bottomView.hidden = !(self.dataArray.count > 0);
    
    [self show:request.urlResponse.errorMessage];
}


#pragma mark --- Empty page delegate ---
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    if (index == 0) {
        //跳首页
        [[CLAllJumpManager shareAllJumpManager] open:@"CLHomeViewController"];

    }
}
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.request start];
}

#pragma mark - 点击了助手按钮
- (void)clickHelperViewWithButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:{
            //近期开奖
            CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
            awardListVC.gameEn = self.LotteryGameEn;
            awardListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:awardListVC animated:YES];
            break;
        }
        case 1:
            //玩法说明
            NSLog(@"%@", url_PlayExplain(self.LotteryGameEn));
            [[CLAllJumpManager shareAllJumpManager] open:url_PlayExplain(self.LotteryGameEn)];
            break;
        default:
            break;
    }
}

#pragma mark ----- TableView Delegate -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CLSFCMainBetCell *cell = [CLSFCMainBetCell createCellWithTableView:tableView];
    
    [cell setData:self.dataArray[indexPath.row]];
    
    cell.showHistoryBlock = ^(CLSFCMainBetCell *reCell) {
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    };
    
    return cell;
}


- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{

    if ([eventName isEqualToString:@"CLSFCOPTIONSRELOADUI"]) {
        
        [self.bottomView reloadUI];
//        [self.mainTableView reloadData];
    }else if ([eventName isEqualToString:@"SFCHistoryViewReloadView"]){
                
        SLWebViewController *web = [[SLWebViewController alloc] init];
        web.activityUrlString = userInfo[@"url"];
        [self.navigationController pushViewController:web animated:YES];
    }
}

#pragma mark ----- lazyLoad -----

- (CLNavigationView *)navigationView
{
    if (_navigationView == nil) {
        
        _navigationView = [[CLNavigationView alloc] initWithFrame:CL__Rect(0, 0, self.view.frame.size.width, kDevice_Is_iPhoneX ? 88 : 64)];
        
        [_navigationView setShowMidImage:NO];
        
        _navigationView.backgroundColor = UIColorFromRGB(0xe63222);
        WS(_weakSelf)
        _navigationView.leftViewBlock = ^(){
            [_weakSelf dismissViewControllerAnimated:YES completion:nil];

            [[CLSFCManager shareManager] clearOptions];
        };
        
        _navigationView.rightViewBlock = ^(){
            
            _weakSelf.helperView.hidden = NO;
            [_weakSelf.view bringSubviewToFront:_weakSelf.helperView];
        };
    }
    return _navigationView;
}

//助手
- (CLLotteryBetHelperView *)helperView
{
    
    WS(_weakSelf)
    if (!_helperView) {
        _helperView = [[CLLotteryBetHelperView alloc] initWithFrame:self.view.bounds];
        _helperView.titleArray = @[@"近期开奖",@"玩法说明"];
        _helperView.helperButtonBlock = ^(UIButton *btn){
            
            [_weakSelf clickHelperViewWithButton:btn];
        };
        _helperView.hidden = YES;
    }
    return _helperView;
}

- (CLSFCTopView *)topVeiw
{
    WS(_weakSelf)

    if (_topVeiw == nil) {
        
        _topVeiw = [[CLSFCTopView alloc] initWithFrame:(CGRectMake(0, 64, self.view.frame.size.width, CL__SCALE(60.f)))];
        
        [_topVeiw returnEndCountDown:^{
           
            [_weakSelf.request start];
        }];
    }
    return _topVeiw;
}

- (UITableView *)mainTableView
{

    if (_mainTableView == nil) {
        
        _mainTableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        
        _mainTableView.separatorStyle = NO;
        
        _mainTableView.estimatedRowHeight = 500;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        
        _mainTableView.estimatedRowHeight = 500;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        
        _mainTableView.backgroundColor = UIColorFromRGB(0xF7F7EE);
    }
    return _mainTableView;
}

- (CLSFCBetBottomView *)bottomView
{

    WS(weakSelf);
    if (_bottomView == nil) {
        
        _bottomView = [[CLSFCBetBottomView alloc] initWithFrame:(CGRectZero)];
        
        [_bottomView returnEmpayClick:^(UIButton *btn) {
           
            [[CLSFCManager shareManager] clearOptions];
            [weakSelf.mainTableView reloadData];
            [weakSelf.bottomView reloadUI];
        }];
        
        [_bottomView returnSureClick:^(UIButton *btn) {
            
            CLSFCBetDetailsController *vc = [[CLSFCBetDetailsController alloc] init];
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    return _bottomView;
}


- (NSArray *)dataArray
{

    if (_dataArray == nil) {
        
        _dataArray = [NSArray new];
    }
    return _dataArray;
}

- (NSDictionary *)playDic
{

    if (_playDic == nil) {
        
        _playDic = @{@"sfc":@"胜负彩",
                     @"rx9":@"任选九场"};
    }
    return _playDic;
}

- (CLSFCBetListRequset *)request
{

    if (_request == nil) {
        
        _request = [[CLSFCBetListRequset alloc] init];
        _request.delegate = self;
        _request.gameEn = self.LotteryGameEn;
    }
    return _request;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.delegate = self;
        _emptyPageService.butTitleArray = @[@"去首页看看"];
        _emptyPageService.contentString = @"当前无可投注的足球比赛";
        _emptyPageService.emptyImageName = @"empty_football";
    }
    return _emptyPageService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
