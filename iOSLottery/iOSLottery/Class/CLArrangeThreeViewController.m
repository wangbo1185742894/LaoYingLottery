//
//  CLArrangeThreeViewController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//


//排列三彩种页面


#import "CLArrangeThreeViewController.h"

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

#import "CLATMainBetView.h"
#import "CLATChoosePlayMothedView.h"
#import "CLATBetBottomView.h"

#import "CLLotteryBetRequest.h"

#import "CLATManager.h"
#import "CLATBetCache.h"
#import "CLLotteryDataManager.h"

#import "CLLotteryMainBetModel.h"

#import "CLLotteryNoDataView.h"

#import "CLAwardListViewController.h"

#import "CLATBetDetailsViewController.h"

#import "CLSSQHeaderView.h"

#import "CLShowHUDManager.h"

#import "CLDEBetDetailModel.h"

@interface CLArrangeThreeViewController ()<CLLotteryBetViewDelegate,CLRequestCallBackDelegate,UITableViewDataSource,UITableViewDelegate>

/**
 玩法请求
 */
@property (nonatomic, strong) CLLotteryBetRequest *requset;

/**
 当前玩法
 */
@property (nonatomic, assign) CLATPlayMethodType currentPlayMothedType;

@property (nonatomic, strong) NSDictionary *playMethodDic;


@property (nonatomic, strong) NSDictionary *fc3d_playMethodDic;

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

@property (nonatomic, strong) CLATMainBetView *mainBetView;

@property (nonatomic, strong) CLATChoosePlayMothedView *choosePlayMethodView;

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

@implementation CLArrangeThreeViewController


#pragma mark ----- 统条方法 -----
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
    CLArrangeThreeViewController *dEleven = [[self alloc] init];
    dEleven.selectedIndex = index;
    dEleven.isSelectedBetInfo = isSelect;
    dEleven.LotteryGameEn = gameEn;
    [initial presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:dEleven] animated:YES completion:completion];
}

#pragma mark - 配置默认数据
- (void)configDefaultData{
    
    
    CLDEBetDetailModel *betModel = (CLDEBetDetailModel *)[[CLATBetCache shareCache] getBetModelWithIndex:self.selectedIndex lottery:self.LotteryGameEn];
    

    [[CLATManager shareManager] setCurrentPlayMethod:betModel.playMethodType];
    
    [[CLATManager shareManager] saveOneGroupOptions:[NSArray arrayWithArray:betModel.betNumberArr]];
    
    //是从选中投注信息跳转过来的
    self.currentPlayMothedType = betModel.playMethodType;
}

#pragma mark ------ 视图生命周期 ------

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    if (self.isSelectedBetInfo) {
        //如果是从详情跳转过来的，配置默认数据
        
        [self configDefaultData];
    }else{
    
        [self.mainBetView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    
    [[CLATBetCache shareCache] saveCurrentLottery:self.LotteryGameEn ofPlayMethod:[[CLATManager shareManager] getCurrentPlayMethodType]];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeDe];
    
    [[CLATManager shareManager] setCurrentPlayMethod:[[CLATBetCache shareCache] getPlayMethodOfCurrentLottery:self.LotteryGameEn]];
    
    [[CLATManager shareManager] setLotteryGame:self.LotteryGameEn];
    
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

//设置导航栏标题
- (void)p_configNavigationTitle
{

    NSString *key = [NSString stringWithFormat:@"%ld",[[CLATManager shareManager] getCurrentPlayMethodType]];
    
    if ([self.LotteryGameEn hasSuffix:@"pl3"]) {
        
        self.navigationView.navigationTitle = self.playMethodDic[key];
        
    }else{
    
        self.navigationView.navigationTitle = self.fc3d_playMethodDic[key];
    }
    
}

#pragma mark -------- 网络请求 ---------
- (void)requestFinished:(CLBaseRequest *)request
{

    if (request.urlResponse.success) {
        
        [CLLotteryDataManager storeAllInfoData:request.urlResponse.resp gameEn:self.LotteryGameEn];
        
        [[CLATManager shareManager] setBonusMessageWithData:request.urlResponse.resp[@"awardBonus"]];
        
        [[CLATManager shareManager] setOmissionMessageWithData:[CLLotteryDataManager getOmissionDataGameEn:self.LotteryGameEn]];
        
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
//    [self.choosePlayMothed reloadDataForAddBonus];
//    self.navTitleText = [CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].currentPeriod.gameName;
//    //判断上一期是否是等待开奖 如果是则请求数据
//    CLLotteryBonusNumModel *lastBonusModel = [CLLotteryDataManager getLastPeriodBonusDataGameEn:self.LotteryGameEn];
//    if (lastBonusModel.awardStatus == 0) {
//        //等待开奖  请求接口
//        [self configBonusRequestWithPeriod:lastBonusModel.periodId];
//    }
    //配置主页面数据
    [self.mainBetView reloadData];
//    //近期开奖
//    [self configRecentAwardWithData:[CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].awardInfoVos];
    //配置当前期次数据
    //[self.headerView reloadDataForBetHeaderView];
    
    //ssq_assigBetHeaderCurrentPeriodWithData:mainBetModel.currentSubPeriod endTime:mainBetModel.betEndInfo];
    
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

#pragma mark ------ UI 刷新 ------
- (void)routerWithEventName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqual: @"OPTIONSBUTTONCLICK"]) {
        
        [self reloadUI];
    }else if ([eventName isEqualToString:@"restoreOptionStatus"]){
    
        [self.mainBetView reloadData];
    }
}

- (void)reloadUI
{
    
    [self.footerView reloadDataWithNoteNumber:[[CLATManager shareManager] getNoteNumber] hasSelectedOptions:[[CLATManager shareManager] hasSelectedOptionsOfCurrentPlayMethod]];
}

#pragma mark - 配置近期开奖数据
- (void)p_configRecentAwardWithData:(NSArray *)awardInfoVos{
    
    //近期开奖
    if (awardInfoVos && awardInfoVos.count > 0) {
        
        //设置headerView
        CLATRecentAwardHeaderView *headerView = [[CLATRecentAwardHeaderView alloc] initWithFrame:CL__Rect(0, 0, CGRectGetWidth(self.view.frame), CL__SCALE(23.f))];
        
        if ([self.LotteryGameEn hasSuffix:@"fc3d"]) {
            
             [headerView setShowTestNumber:YES];
        }
        
        self.awardTableView.tableHeaderView = headerView;
        
        [self.awardDataSource removeAllObjects];
        [self.awardDataSource addObjectsFromArray:awardInfoVos];
        [self.awardTableView reloadData];
        
    }
    
    self.emptyView.hidden = self.awardDataSource.count > 0 ? YES : NO;

}


#pragma mark --------  切换玩法  ---------
- (void)setCurrentPlayMothedType:(CLATPlayMethodType)currentPlayMothedType
{

    _currentPlayMothedType = currentPlayMothedType;
    
    [self p_configNavigationTitle];

    self.lotteryBetView.is_showBottomView = NO;
    self.lotteryBetView.is_showPlayMothed = NO;
    
    [self.mainBetView reloadData];
}

#pragma mark --------  摇一摇功能 ---------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:pl3ShakeNotification object:nil];
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
    
    return self.choosePlayMethodView;
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
        _navigationView.backgroundColor = UIColorFromRGB(0xe63222);
        WS(_weakSelf)
        _navigationView.leftViewBlock = ^(){
            
            [_weakSelf dismissViewControllerAnimated:YES completion:nil];
            
            [[CLATManager shareManager] clearOptions];
        };
        _navigationView.titleViewBlock = ^(){
            _weakSelf.lotteryBetView.is_showPlayMothed = !(_weakSelf.lotteryBetView.is_showPlayMothed);
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
        _emptyView = [[CLLotteryNoDataView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), CL__SCALE(253.f))];
        
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




- (CLATMainBetView *)mainBetView
{

    if (_mainBetView == nil) {
        
        _mainBetView = [[CLATMainBetView alloc] initWithFrame:(CGRectZero)];
        
        _mainBetView.frame = CGRectMake(0, 0, self.view.frame.size.width, CL__SCALE(565.f));
        
    }
    return _mainBetView;
}

- (CLATChoosePlayMothedView *)choosePlayMethodView
{
    WS(_weakSelf)
    if (_choosePlayMethodView == nil) {
        
        _choosePlayMethodView = [[CLATChoosePlayMothedView alloc] initWithFrame:(CGRectMake(0, 0, self.view.frame.size.width, CL__SCALE(102.f)))];
        
        _choosePlayMethodView.reloadData = ^{
          
            [_weakSelf setCurrentPlayMothedType:0];
            
        };
        
    }
    return _choosePlayMethodView;
}


- (CLATBetBottomView *)footerView
{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLATBetBottomView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, CL__SCALE(kDevice_Is_iPhoneX ? 70.f : 50.f))];
        _footerView.clearButtonClickBlock = ^(BOOL hasSelectBetButton){
            
            if (hasSelectBetButton == YES) {
                
                //清空
                [[CLATManager shareManager] clearCurrentPlayMethodSelectedOptions];
                
                [_weakSelf.mainBetView reloadData];
                
            }else{
            
                //机选
                [[NSNotificationCenter defaultCenter] postNotificationName:pl3ShakeNotification object:nil];
            }
            [_weakSelf reloadUI];
            
        };
        _footerView.confirmButtonClickBlock = ^(){

            if ([[CLATManager shareManager] getToastText].length > 1) {
                
                [CLShowHUDManager showInWindowWithText:[[CLATManager shareManager] getToastText] type:CLShowHUDTypeOnlyText delayTime:1.f];
                
                return ;
            }
            
            if (_weakSelf.isSelectedBetInfo) {
                
                
                [[CLATManager shareManager] saveOneGroupBetOptionsOfReplaceIndex:_weakSelf.selectedIndex];
                
            }else{
            
               [[CLATManager shareManager] saveOneGroupBetOptionsOfReplaceIndex:-1];
            }
            
            
            [[CLATManager shareManager] clearOptions];

            //如果有投注项  跳转投注详情
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLATBetDetailsViewController_push/%@", _weakSelf.LotteryGameEn] dissmissPresent:YES];
            
        };
        
        [_footerView reloadDataWithNoteNumber:[[CLATManager shareManager] getNoteNumber] hasSelectedOptions:[[CLATManager shareManager] hasSelectedOptionsOfCurrentPlayMethod]];
    }
    return _footerView;
}

- (NSDictionary *)playMethodDic
{

    if (_playMethodDic == nil) {
        
        _playMethodDic = @{@"0":@"排列3直选",
                           @"1":@"排列3组三单式",
                           @"2":@"排列3组三复式",
                           @"3":@"排列3组六"};
    }
    return _playMethodDic;
}

- (NSDictionary *)fc3d_playMethodDic
{
    if (_fc3d_playMethodDic == nil) {
        
        _fc3d_playMethodDic = @{@"0":@"3D直选",
                           @"1":@"3D组三单式",
                           @"2":@"3D组三复式",
                           @"3":@"3D组六"};
    }
    return _fc3d_playMethodDic;
    
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
