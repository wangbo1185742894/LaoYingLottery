//
//  CLArrangeFiveViewController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//


//排列5 彩种页面


#import "CLArrangeFiveViewController.h"

#import "CLAllJumpManager.h"
#import "CLLotteryAllInfo.h"
#import "UIResponder+CLRouter.h"

#import "CLAppContext.h"

#import "CLConfigMessage.h"

#import "CLNavigationView.h"

#import "CLLotteryBetHelperView.h"

#import "CLDElevenBetHeaderView.h"
#import "CLLotteryBetView.h"

#import "CLATRecentAwardHeaderView.h"
#import "CLATRecentAwardTableViewCell.h"


#import "CLAFMainBetView.h"

#import "CLATChoosePlayMothedView.h"
#import "CLATBetBottomView.h"

#import "CLLotteryBetRequest.h"


#import "CLATBetCache.h"
#import "CLAFManager.h"


#import "CLLotteryDataManager.h"

#import "CLLotteryMainBetModel.h"

#import "CLLotteryNoDataView.h"

#import "CLAwardListViewController.h"

#import "CLATBetDetailsViewController.h"

#import "CLSSQHeaderView.h"

#import "CLShowHUDManager.h"

#import "CLDEBetDetailModel.h"

@interface CLArrangeFiveViewController ()<CLLotteryBetViewDelegate,CLRequestCallBackDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 玩法请求
 */
@property (nonatomic, strong) CLLotteryBetRequest *requset;

/**
 头部玩法筛选按钮
 */
@property (nonatomic, strong) CLNavigationView *navigationView;

/**
 助手
 */
@property (nonatomic, strong) CLLotteryBetHelperView *helperView;

/**
 头部视图
 */
@property (nonatomic, strong) CLSSQHeaderView *headerView;

/**
 主View
 */
@property (nonatomic, strong) CLLotteryBetView *lotteryBetView;

/**
 投注View
 */
@property (nonatomic, strong) CLAFMainBetView *mainBetView;

@property (nonatomic, strong) CLATBetBottomView *footerView;

/**
 近期开奖列表
 */
@property (nonatomic, strong) UITableView *awardTableView;

/**
 近期开奖数据
 */
@property (nonatomic, strong) NSMutableArray *awardDataSource;

/**
 空数据
 */
@property (nonatomic, strong) CLLotteryNoDataView *emptyView;

@property (nonatomic, assign) NSInteger selectedIndex;//从投注详情页跳转过来时所选中的index
@property (nonatomic, assign) BOOL isSelectedBetInfo;//是否从投注详情页选中投注信息跳转过来

@end

@implementation CLArrangeFiveViewController

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"排列5控制器销毁");
}

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.LotteryGameEn = params[@"gameEn"];
        NSString *playMothed = params[@"playMethod"];
        if (playMothed && playMothed.length > 0) {
            [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:[playMothed integerValue] gameEn:self.LotteryGameEn];
        }
    }
    return self;
}

#pragma mark ------ public Mothed ------
+ (void)presentFastThreeViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^)(void))completion {
    CLArrangeFiveViewController *dEleven = [[self alloc] init];
    dEleven.selectedIndex = index;
    dEleven.isSelectedBetInfo = isSelect;
    dEleven.LotteryGameEn = gameEn;
    [initial presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:dEleven] animated:YES completion:completion];
}

#pragma mark - 配置默认数据
- (void)configDefaultData{
    
    CLDEBetDetailModel *betModel = (CLDEBetDetailModel *)[[CLATBetCache shareCache] getBetModelWithIndex:self.selectedIndex lottery:self.LotteryGameEn];
    
    
    [[CLAFManager shareManager] saveOneGroupOptions:[NSArray arrayWithArray:betModel.betNumberArr]];
}

#pragma mark ------ 视图生命周期 ------

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.isSelectedBetInfo) {
        //如果是从详情跳转过来的，配置默认数据
        
        [self configDefaultData];
    }
    
    [self.mainBetView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeDe];
    
    [[CLAFManager shareManager] setLotteryGame:self.LotteryGameEn];
    
    self.pageStatisticsName = [[CLAppContext context] getGameNameWithGameEn:self.LotteryGameEn];
    
    
    [self.view addSubview:self.navigationView];
    [self p_configNavigationTitle];
    
    [self.view addSubview:self.helperView];
    
    [self.view addSubview:self.lotteryBetView];
    
    [self.awardTableView addSubview:self.emptyView];
    
    [self.requset start];
    
    [self.lotteryBetView lotteryBetViewReloadData];
    
    [[UIApplication sharedApplication] applicationSupportsShakeToEdit];
    [self becomeFirstResponder];
}

- (void)p_configNavigationTitle
{
    
    self.navigationView.navigationTitle = @"排列5";
    
}

#pragma mark -------- 网络请求 ---------
- (void)requestFinished:(CLBaseRequest *)request
{
    
    if (request.urlResponse.success) {
        
        [CLLotteryDataManager storeAllInfoData:request.urlResponse.resp gameEn:self.LotteryGameEn];
        
        [[CLAFManager shareManager] setBonusMessageWithData:request.urlResponse.resp[@"awardBonus"]];
        
        [[CLAFManager shareManager] setOmissionMessageWithData:[CLLotteryDataManager getOmissionDataGameEn:self.LotteryGameEn]];
            
        //取缓存使用
        [self p_configUIWithCache];
    }
    
   self.emptyView.hidden = self.awardDataSource.count > 0 ? YES : NO;
}

- (void)requestFailed:(CLBaseRequest *)request
{
    
    self.emptyView.hidden = self.awardDataSource.count > 0 ? YES : NO;
}

- (void)p_configUIWithCache
{
    if (![CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].lastAwardInfo) {
        return;
    }

    //配置主页面数据
    [self.mainBetView reloadData];
    //近期开奖

    CLLotteryMainBetModel *data = [CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn];
    
    
    [self.headerView ssq_assigBetHeaderCurrentPeriodWithData:data.currentSubPeriod  endTime:data.betEndInfo];
    
    [self p_configRecentAwardWithData:[CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].awardInfoVos];
    if (data.ifAuditing == 1) {
        
        //处理屏蔽逻辑
        [self.navigationView setShowMidImage:NO];
        [self.navigationView setShowRightBtn:NO];
        self.navigationView.titleViewBlock = nil;
        self.footerView.hidden = YES;
        self.lotteryBetView.mainViewShowStatus = NO;
    }
    
}


#pragma mark ----- 刷新数据 -------
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName  isEqual: @"OPTIONSBUTTONCLICK"]) {
        
        [self reloadUI];
    }
}

- (void)reloadUI
{

    [self.footerView reloadDataWithNoteNumber:[[CLAFManager shareManager] getNoteNumber] hasSelectedOptions:[[CLAFManager shareManager] hasSelectedOptionsOfCurrentPlayMethod]];
}
#pragma mark - 配置近期开奖数据
- (void)p_configRecentAwardWithData:(NSArray *)awardInfoVos{
    
    //近期开奖
    if (awardInfoVos && awardInfoVos.count > 0) {
        
        //设置headerView
        CLATRecentAwardHeaderView *headerView = [[CLATRecentAwardHeaderView alloc] initWithFrame:CL__Rect(0, 0, CGRectGetWidth(self.view.frame), CL__SCALE(23.f))];
        
        [headerView setShowTestNumber:NO];
        [headerView setShowForm:NO];

        self.awardTableView.tableHeaderView = headerView;
        
        [self.awardDataSource removeAllObjects];
        [self.awardDataSource addObjectsFromArray:awardInfoVos];
        [self.awardTableView reloadData];
        
    }
}


#pragma mark --------  摇一摇功能 ---------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:pl5ShakeNotification object:nil];
}

#pragma mark ------------ tableView Delegate ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CL__SCALE(23.f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.awardDataSource.count > 10 ? 10 : self.awardDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLATRecentAwardTableViewCell *cell = [CLATRecentAwardTableViewCell createRecentAwardTableViewCell:tableView isBackground:(indexPath.row % 2) data:self.awardDataSource[indexPath.row]];
    
    return cell;
}
#pragma mark ------------ lotteryDelegate --------------
- (UIView *)lotteryBetViewCustomBetView{
    
    return self.mainBetView;
}
- (UIView *)lotteryBetViewCustomPlayMothedView{
    
    return [[UIView alloc] init];
}

- (UIView *)lotteryBetViewCustomAwardRecordView{
    return self.awardTableView;
}
- (UIView *)lotteryBetViewCustomHeaderView{
    
    return self.headerView;
}

- (UIView *)lotteryBetViewCustomFooterView{
    
    return self.footerView;
}

#pragma mark - 点击了助手按钮
- (void)clickHelperViewWithButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
            //近期开奖
            self.lotteryBetView.is_showBottomView = YES;
            break;

        case 1:
            //玩法说明
            NSLog(@"%@", url_PlayExplain(self.LotteryGameEn));
            [[CLAllJumpManager shareAllJumpManager] open:url_PlayExplain(self.LotteryGameEn)];
            break;
        default:
            break;
    }
}

#pragma mark -------  点击了近期开奖  -------
- (void)p_tapAwardTableView:(UITapGestureRecognizer *)tap{
    
    CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
    awardListVC.gameEn = self.LotteryGameEn;
    awardListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:awardListVC animated:YES];
}

#pragma mark ---- lazyLoad ----

- (CLNavigationView *)navigationView
{
    if (_navigationView == nil) {
        
        _navigationView = [[CLNavigationView alloc] initWithFrame:CL__Rect(0, 0, self.view.frame.size.width, kDevice_Is_iPhoneX ? 88 : 64)];
        
        [_navigationView setShowMidImage:NO];
        
        _navigationView.backgroundColor = UIColorFromRGB(0xe63222);
        WS(_weakSelf)
        _navigationView.leftViewBlock = ^(){
            [_weakSelf dismissViewControllerAnimated:YES completion:nil];
            [[CLAFManager shareManager] clearOptions];
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

//近期开奖列表
- (UITableView *)awardTableView{
    
    if (_awardTableView == nil) {
        
        _awardTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), CL__SCALE(253.f)) style:UITableViewStylePlain];
        
        _awardTableView.delegate = self;
        _awardTableView.dataSource = self;
        _awardTableView.backgroundColor = UIColorFromRGB(0xf7f7ee);
        _awardTableView.scrollEnabled = NO;
        _awardTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapAwardTableView:)];
        [_awardTableView addGestureRecognizer:tap];
        
    }
    return _awardTableView;
}

//近期开奖数据
- (NSMutableArray *)awardDataSource
{
    
    if (!_awardDataSource) {
        _awardDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _awardDataSource;
}

//空数据
- (CLLotteryNoDataView *)emptyView
{
    
    WS(_weakSelf)
    if (!_emptyView) {
        _emptyView = [[CLLotteryNoDataView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(220))];
        _emptyView.hidden = YES;

        _emptyView.emptyBtnBlock = ^(){
            
            [_weakSelf.requset start];
        };
    }
    return _emptyView;
}

//头部视图
- (CLSSQHeaderView *)headerView
{
    
    WS(_weakSelf)
    if (!_headerView) {
        _headerView = [[CLSSQHeaderView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.bounds), __SCALE(25.f))];
        //_headerView.gameEn = self.LotteryGameEn;
        _headerView.ssq_headViewOnClickBlock = ^(){
            
            _weakSelf.lotteryBetView.is_showBottomView = !_weakSelf.lotteryBetView.is_showBottomView;
        };
    }
    return _headerView;
}

- (CLLotteryBetView *)lotteryBetView{
    
    WS(_weakSelf)
    if (_lotteryBetView == nil) {
        
        CGFloat height = kDevice_Is_iPhoneX ?  88 : 64;
        
        _lotteryBetView = [[CLLotteryBetView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height)];
        
        _lotteryBetView.delegate = self;
        
        _lotteryBetView.bottomViewIsShowBlock = ^(BOOL isShow){
            
            _weakSelf.headerView.rotationAnimation = isShow;
        };
        _lotteryBetView.playMothedViewIsShowBlock = ^(BOOL is_show){
            
            [_weakSelf.navigationView midImageViewIsRotation:is_show];
        };
        _lotteryBetView.backgroundColor = UIColorFromRGB(0xeeeee5);
    }
    return _lotteryBetView;
}


- (CLAFMainBetView *)mainBetView
{
    
    if (_mainBetView == nil) {
        
        _mainBetView = [[CLAFMainBetView alloc] initWithFrame:(CGRectZero)];
        
        _mainBetView.frame = CGRectMake(0, 0, self.view.frame.size.width, CL__SCALE(857.f));
        
    }
    return _mainBetView;
}


- (CLATBetBottomView *)footerView
{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLATBetBottomView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, CL__SCALE(kDevice_Is_iPhoneX ? 70.f : 50.f))];
        _footerView.clearButtonClickBlock = ^(BOOL hasSelectBetButton){
            
            if (hasSelectBetButton == YES) {
                
                //清空
                [[CLAFManager shareManager] clearOptions];
                
                [_weakSelf.mainBetView reloadData];
                
            }else{
                
                //机选
                [[NSNotificationCenter defaultCenter] postNotificationName:pl5ShakeNotification object:nil];
            }
            [_weakSelf reloadUI];
            
        };
        _footerView.confirmButtonClickBlock = ^(){
            //确定
            //存储当前的玩法的对应的投注objc
            //[_weakSelf dElevenConfirmBetTerm];
            
            
            if ([[CLAFManager shareManager] getToastText].length > 1) {
                
                [CLShowHUDManager showInWindowWithText:[[CLAFManager shareManager] getToastText] type:CLShowHUDTypeOnlyText delayTime:1.f];
                
                return ;
            }
            
            if (_weakSelf.isSelectedBetInfo) {
                
                [[CLAFManager shareManager] saveOneGroupBetOptionsOfReplaceIndex:_weakSelf.selectedIndex];
            }else{
                
                [[CLAFManager shareManager] saveOneGroupBetOptionsOfReplaceIndex:-1];
            }

            
            [[CLAFManager shareManager] clearOptions];
            
            //如果有投注项  跳转投注详情
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@", _weakSelf.LotteryGameEn] dissmissPresent:YES];
            
        };
        
        [_footerView reloadDataWithNoteNumber:[[CLAFManager shareManager] getNoteNumber] hasSelectedOptions:[[CLAFManager shareManager] hasSelectedOptionsOfCurrentPlayMethod]];
    }
    return _footerView;
}




- (CLLotteryBetRequest *)requset
{
    
    if (!_requset) {
        _requset = [[CLLotteryBetRequest alloc] init];
        _requset.delegate = self;
        _requset.gameEn = self.LotteryGameEn;
    }
    return _requset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
