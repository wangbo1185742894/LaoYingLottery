//
//  CLDElevenViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//



//11选5彩种页面



#import "CLDElevenViewController.h"
#import "CLDElevenConfigMessage.h"
#import "CLTools.h"
#import "CLAppContext.h"
//全局缓存
#import "CLLotteryAllInfo.h"
#import "CLLotteryBonusNumModel.h"
#import "CLLotteryPeriodModel.h"
#import "CLNewLotteryBetInfo.h"
//model
#import "CLLotteryDataManager.h"
#import "CLLotteryMainBetModel.h"
//api
#import "CLLotteryBetRequest.h"
#import "CLLotteryBonusInfoRequest.h"
//导航
#import "CLNavigationView.h"
//主页面
#import "CLLotteryBetView.h"
//选择玩法列表
#import "CLDElevenChoosePlayMothedView.h"
//底部视图
#import "CLDElevenBetFooterView.h"
//头部视图
#import "CLDElevenBetHeaderView.h"
//投注页面
#import "CLDElevenMainBetView.h"
//近期开奖
#import "CLDERecentAwardTableViewCell.h"
#import "CLDERecentAwardHeaderView.h"
//投注详情
#import "CLDEBetDetailViewController.h"
//助手
#import "CLLotteryBetHelperView.h"
#import "CLAllJumpManager.h"
//空数据
#import "CLLotteryNoDataView.h"
//新手引导
#import "CLNewbieGuidanceService.h"
//
#import "CLAwardListViewController.h"
@interface CLDElevenViewController ()<CLLotteryBetViewDelegate, UITableViewDelegate, UITableViewDataSource, CLRequestCallBackDelegate>

/**
 请求
 */
@property (nonatomic, strong) CLLotteryBetRequest *dElevenResquest;

@property (nonatomic, strong) CLLotteryBonusInfoRequest *de_bonusNumRequest;

/**
 当前玩法
 */
@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;

/**
 主View
 */
@property (nonatomic, strong) CLLotteryBetView *mainLotteryBetView;

/**
 自定义的导航栏的NavitionView
 */
@property (nonatomic, strong) CLNavigationView *navigationView;

@property (nonatomic, strong) CLDElevenChoosePlayMothedView *choosePlayMothed;//选择玩法
@property (nonatomic, strong) CLDElevenBetFooterView *footerView;//底部视图

/**
 头部视图
 */
@property (nonatomic, strong) CLDElevenBetHeaderView *headerView;
@property (nonatomic, strong) CLDElevenMainBetView *mainBetView;//主投注页面
@property (nonatomic, strong) UITableView *awardTableView;//近期开奖列表
@property (nonatomic, strong) NSMutableArray *awardDataSource;//近期开奖数据
@property (nonatomic, strong) CLLotteryBetHelperView *helperView;

@property (nonatomic, assign) NSInteger selectedIndex;//从投注详情页跳转过来时所选中的index
@property (nonatomic, assign) BOOL isSelectedBetInfo;//是否从投注详情页选中投注信息跳转过来的

/**
 空数据
 */
@property (nonatomic, strong) CLLotteryNoDataView *emptyView;
@end

@implementation CLDElevenViewController
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_mainBetView) {
        [_mainBetView removeFromSuperview];
    }
    
}
- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.LotteryGameEn = params[@"gameEn"];
        NSString *playMothed = params[@"playMothed"];
        if (playMothed && playMothed.length > 0) {
            [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:[playMothed integerValue] gameEn:self.LotteryGameEn];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!kDevice_Is_iPhoneX) {
        
        [CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeDe];
    }

    self.pageStatisticsName = [[CLAppContext context] getGameNameWithGameEn:self.LotteryGameEn];

    [self.view addSubview:self.mainLotteryBetView];
    [self.awardTableView addSubview:self.emptyView];

    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.helperView];
    self.currentPlayMothedType = [[CLLotteryAllInfo shareLotteryAllInfo] getPlayMothedWithGameEn:self.LotteryGameEn];
    [self configNavigationTitle];
    [self configTableViewHeader];
    [self configUIWithCache];
    [self.dElevenResquest start];
    [self configNotification];
    [self configUIWithSelectBetInfo:self.isSelectedBetInfo];
//    //注册摇一摇功能
//    //开启摇一摇功能
    [[UIApplication sharedApplication] applicationSupportsShakeToEdit];
    [self becomeFirstResponder];
}
#pragma mark ------------ public Mothed ------------
#pragma mark ------ public Mothed ------
+ (void)presentFastThreeViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^)(void))completion {
    CLDElevenViewController *dEleven = [[self alloc] init];
    dEleven.selectedIndex = index;
    dEleven.isSelectedBetInfo = isSelect;
    dEleven.LotteryGameEn = gameEn;
    [initial presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:dEleven] animated:YES completion:completion];
}

#pragma mark ------------ 摇一摇功能 ------------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:dElevenShakeNotification object:nil];
}
#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (self.dElevenResquest == request) {
        [self deRequestFinished];
    }
    if (self.de_bonusNumRequest == request) {
        [self deBonusNumberFinished];
    }
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    if (self.awardDataSource.count < 1) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}
- (void)deRequestFinished{
    
    if (!self.dElevenResquest.urlResponse.resp || !self.dElevenResquest.urlResponse.success) return;
    //存缓存
    [CLLotteryDataManager storeAllInfoData:self.dElevenResquest.urlResponse.resp gameEn:self.LotteryGameEn];
    //取缓存使用
    [self configUIWithCache];
}
- (void)deBonusNumberFinished{
    
    if (!self.de_bonusNumRequest.urlResponse.resp || !self.de_bonusNumRequest.urlResponse.success){
        [self.de_bonusNumRequest start];
        return;
    }
    CLLotteryBonusNumModel *model = [CLLotteryBonusNumModel mj_objectWithKeyValues:self.de_bonusNumRequest.urlResponse.resp];
    if (model.awardStatus == 1) {
        //数据正确 刷新大列表
        [self.dElevenResquest start];
    }else{
        //如果是等待开奖
        [self.de_bonusNumRequest start];
    }
}
#pragma mark ------------ tableView Delegate ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return __SCALE(22.f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.awardDataSource.count > 10 ? 10 : self.awardDataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLDERecentAwardTableViewCell *cell = [CLDERecentAwardTableViewCell createRecentAwardTableViewCell:tableView isBackground:(indexPath.row % 2) data:self.awardDataSource[indexPath.row]];
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypePreOne:
            cell.signCount = 1;
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
        case CLDElevenPlayMothedTypePreTwoDirect:
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            cell.signCount = 2;
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:
        case CLDElevenPlayMothedTypePreThreeGroup:
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            cell.signCount = 3;
            break;
        default:
            cell.signCount = 5;
            break;
    }
    return cell;
}
#pragma mark ------------ lotteryDelegate --------------
- (UIView *)lotteryBetViewCustomBetView{
    
    return self.mainBetView;
}
- (UIView *)lotteryBetViewCustomPlayMothedView{
    
    return self.choosePlayMothed;
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
#pragma mark ------------ event Response ------------
#pragma mark - 点击了近期开奖
- (void)de_tapAwardTableView:(UITapGestureRecognizer *)tap{
    
    CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
    awardListVC.gameEn = self.LotteryGameEn;
    awardListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:awardListVC animated:YES];
}
#pragma mark - 期次倒计时
- (void)timerNotificationResponse:(NSNotification *)noti{
    
    [self.headerView reloadDataForBetHeaderView];
    //判断上一期是否是等待开奖  如果是则请求 开奖接口
    if ([CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].lastAwardInfo.awardStatus == 0) {
        [self configBonusRequestWithPeriod:[CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].lastAwardInfo.periodId];
    }
}
#pragma mark - 期次截止
- (void)periodEndNotificationResponse:(NSNotification *)noti{
    
    [self configBonusRequestWithPeriod:[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.LotteryGameEn].periodId];
    //网络刷新
    [self.dElevenResquest start];
}
#pragma mark - 点击了确认按钮
- (void)dElevenConfirmBetTerm{
    
    NSArray *betTermArray = [self.mainBetView getBetTermInfoWithPlayMothed:self.currentPlayMothedType];
    if (betTermArray.count < 1) {
//        NSLog(@"弹窗 提示 投注选项不正确");
        return;
    }
    if (self.isSelectedBetInfo) {
        [[CLNewLotteryBetInfo shareLotteryBetInfo] replaceLotteryBetTerm:betTermArray lotteryType:self.LotteryGameEn index:self.selectedIndex];
    }else{
        [[CLNewLotteryBetInfo shareLotteryBetInfo] addLotteryBetTerm:betTermArray lotteryType:self.LotteryGameEn];
    }
    //获取当前期次信息
    CLLotteryPeriodModel *periodModel = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.LotteryGameEn];
    //设置彩种id en periodid
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameEn:periodModel.gameEn lottery:self.LotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameId:periodModel.gameId lottery:self.LotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:periodModel.periodId lottery:self.LotteryGameEn];
    
    //如果有投注项  跳转投注详情
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDEBetDetailViewController_push/%@", self.LotteryGameEn] dissmissPresent:YES];
}
#pragma mark - 点击了助手按钮
- (void)clickHelperViewWithButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
            //近期开奖
            self.mainLotteryBetView.is_showBottomView = YES;
            break;
        case 1:
            //购彩技巧
            [[CLAllJumpManager shareAllJumpManager] open:url_DE_BuyLotterySkill];

            break;
        case 2:
            //玩法说明
            NSLog(@"%@", url_PlayExplain(self.LotteryGameEn));
            [[CLAllJumpManager shareAllJumpManager] open:url_PlayExplain(self.LotteryGameEn)];
            break;
        default:
            break;
    }
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 配置中奖信息请求接口
- (void)configBonusRequestWithPeriod:(NSString *)periodId{
    
    self.de_bonusNumRequest.gameEn = self.LotteryGameEn;
    self.de_bonusNumRequest.periodId = periodId;
    [self.de_bonusNumRequest start];
}
#pragma mark - 根据选中过来的投注信息 配置UI
- (void)configUIWithSelectBetInfo:(BOOL)isSelectBetInfo{
    
    if (isSelectBetInfo) {
        //是从选中投注信息跳转过来的
        self.currentPlayMothedType = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPlayMothedTypeWithIndex:self.selectedIndex lottery:self.LotteryGameEn];
        [self.mainBetView assginDataWithSelectedData:[[CLNewLotteryBetInfo shareLotteryBetInfo] getBetInfoWithIndex:self.selectedIndex lottery:self.LotteryGameEn] playMothedType:self.currentPlayMothedType];
    }
}
#pragma mark - 配置通知
- (void)configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerNotificationResponse:) name:GlobalTimerRuning object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(periodEndNotificationResponse:) name:self.LotteryGameEn object:nil];
    //注册摇一摇动画通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeAnimationStart:) name:DE_ShakeAnimationStart object:nil];
}
#pragma mark - 摇一摇动画开始
- (void)shakeAnimationStart:(NSNotification *)noti{
    
    self.mainLotteryBetView.is_showBottomView = NO;
}
#pragma mark - 配置tableView的header
- (void)configTableViewHeader{
    
    CLDERecentAwardHeaderView *headerView = [[CLDERecentAwardHeaderView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(20.f))];
    self.awardTableView.tableHeaderView = headerView;
}
#pragma mark - 配置navition title（即 玩法名称）
- (void)configNavigationTitle{
    
    self.navigationView.navigationTitle = [self getNavigatonTitle];
}
#pragma mark - 获取对应玩法的navigation Title
- (NSString *)getNavigatonTitle{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            return @"任选二";
            break;
        case CLDElevenPlayMothedTypeThree:
            return @"任选三";
            break;
        case CLDElevenPlayMothedTypeFour:
            return @"任选四";
            break;
        case CLDElevenPlayMothedTypeFive:
            return @"任选五";
            break;
        case CLDElevenPlayMothedTypeSix:
            return @"任选六";
            break;
        case CLDElevenPlayMothedTypeSeven:
            return @"任选七";
            break;
        case CLDElevenPlayMothedTypeEight:
            return @"任选八";
            break;
        case CLDElevenPlayMothedTypePreOne:
            return @"前一";
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:
            return @"前二直选";
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return @"前二组选";
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:
            return @"前三直选";
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return @"前三组选";
            break;
        case CLDElevenPlayMothedTypeDTTwo:
            return @"任选二胆拖";
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return @"任选三胆拖";
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return @"任选四胆拖";
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return @"任选五胆拖";
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return @"任选六胆拖";
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return @"任选七胆拖";
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return @"任选八胆拖";
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return @"前二组选胆拖";
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return @"前三组选胆拖";
            break;
        default:
            break;
    }
    return @"";
}
#pragma mark - 取缓存数据使用
- (void)configUIWithCache{
    
    if (![CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].lastAwardInfo) {
        return;
    }
    [self.choosePlayMothed reloadDataForAddBonus];
    self.navTitleText = [CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].currentPeriod.gameName;
    //判断上一期是否是等待开奖 如果是则请求数据
    CLLotteryBonusNumModel *lastBonusModel = [CLLotteryDataManager getLastPeriodBonusDataGameEn:self.LotteryGameEn];
    if (lastBonusModel.awardStatus == 0) {
        //等待开奖  请求接口
        [self configBonusRequestWithPeriod:lastBonusModel.periodId];
    }
    //配置主页面数据
    [self.mainBetView reloadDataForMainBetViewWithPlayMothedType:self.currentPlayMothedType];
    //近期开奖
    [self configRecentAwardWithData:[CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].awardInfoVos];
    //配置当前期次数据
    [self.headerView reloadDataForBetHeaderView];
    
    if ([CLLotteryDataManager getAllInfoDataGameEn:self.LotteryGameEn].ifAuditing == 1) {
        
        //处理屏蔽逻辑
        [self.navigationView setShowMidImage:NO];
        [self.navigationView setShowRightBtn:NO];
        self.navigationView.titleViewBlock = nil;
        self.footerView.hidden = YES;
        self.mainLotteryBetView.mainViewShowStatus = NO;
    }
    
}
#pragma mark - 配置近期开奖数据
- (void)configRecentAwardWithData:(NSArray *)awardInfoVos{
    
    //近期开奖
    if (awardInfoVos && awardInfoVos.count > 0) {
        [self.awardDataSource removeAllObjects];
        [self.awardDataSource addObjectsFromArray:awardInfoVos];
        [self.awardTableView reloadData];
    }
    
    if (self.awardDataSource.count < 1) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}
#pragma mark - 修改底部视图的 注数 奖金
- (void)betTermChangeWithBetNote:(NSInteger)betNote minBonus:(NSInteger)minBonus maxBonus:(NSInteger)maxBonus hasSelectBetButton:(BOOL)hasSelectBetButton{
    
    [self.footerView assignBetNote:betNote minBonus:minBonus maxBonus:maxBonus hasSelectBetButton:hasSelectBetButton playMothed:self.currentPlayMothedType];
}
#pragma mark - 点击了清空 或 机选 按钮
- (void)de_clearAllSelectedBetButton:(BOOL)hasSelectBetButton{
    
    if (hasSelectBetButton) {
        //清空
        [self.mainBetView clearAllSelectedBetButtonWithPlayMothed:self.currentPlayMothedType];
    }else{
        //机选
        [[NSNotificationCenter defaultCenter] postNotificationName:dElevenShakeNotification object:nil];
    }
    
}
#pragma mark ------------ setter Mothed ------------
- (void)setCurrentPlayMothedType:(CLDElevenPlayMothedType)currentPlayMothedType{
    
    _currentPlayMothedType = currentPlayMothedType;
    [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:currentPlayMothedType gameEn:self.LotteryGameEn];
    self.mainLotteryBetView.is_showBottomView = NO;
    self.mainLotteryBetView.is_showPlayMothed = NO;
    //修改导航栏的titile
    [self configNavigationTitle];
    //改变投注页面
    [self.mainBetView reloadDataWithPlayMothed:currentPlayMothedType];
    //修改玩法选择
    self.choosePlayMothed.currentPlayMothedType = currentPlayMothedType;
    //配置当前页的遗漏
    [self.mainBetView reloadDataForMainBetViewWithPlayMothedType:currentPlayMothedType];
    //刷新tableView
    [self.awardTableView reloadData];
    
    [self.mainLotteryBetView lotteryBetViewReloadData];
}
#pragma mark ------ getter Mothed ------
//api
- (CLLotteryBetRequest *)dElevenResquest{
    
    if (!_dElevenResquest) {
        _dElevenResquest = [[CLLotteryBetRequest alloc] init];
        _dElevenResquest.delegate = self;
        _dElevenResquest.gameEn = self.LotteryGameEn;
    }
    return _dElevenResquest;
}
- (CLLotteryBonusInfoRequest *)de_bonusNumRequest{
    
    if (!_de_bonusNumRequest) {
        _de_bonusNumRequest = [[CLLotteryBonusInfoRequest alloc] init];
        _de_bonusNumRequest.delegate = self;
    }
    return _de_bonusNumRequest;
}
- (CLLotteryBetView *)mainLotteryBetView{
    
    WS(_weakSelf)
    if (!_mainLotteryBetView) {
        CGFloat height = kDevice_Is_iPhoneX ?  88 : 64;
        
        _mainLotteryBetView = [[CLLotteryBetView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height)];
        _mainLotteryBetView.delegate = self;
        _mainLotteryBetView.bottomViewIsShowBlock = ^(BOOL isShow){
            
            [_weakSelf.headerView arrowImageViewIsRotation:isShow];
        };
        _mainLotteryBetView.playMothedViewIsShowBlock = ^(BOOL is_show){
            
            [_weakSelf.navigationView midImageViewIsRotation:is_show];
        };
        _mainLotteryBetView.backgroundColor = UIColorFromRGB(0xeeeee5);
    }
    return _mainLotteryBetView;
}
- (CLNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[CLNavigationView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, kDevice_Is_iPhoneX ? 88 : 64)];
        _navigationView.backgroundColor = THEME_COLOR;
        WS(_weakSelf)
        _navigationView.leftViewBlock = ^(){
            [_weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _navigationView.titleViewBlock = ^(){
            _weakSelf.mainLotteryBetView.is_showPlayMothed = !(_weakSelf.mainLotteryBetView.is_showPlayMothed);
        };
        _navigationView.rightViewBlock = ^(){
            
            _weakSelf.helperView.hidden = NO;
            [_weakSelf.view bringSubviewToFront:_weakSelf.helperView];
        };
    }
    return _navigationView;
}
- (CLDElevenChoosePlayMothedView *)choosePlayMothed{

    if (!_choosePlayMothed) {
        WS(_weakSelf)
        _choosePlayMothed = [[CLDElevenChoosePlayMothedView alloc] initWithFrame:CGRectZero];
        //动态计算高度
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view addSubview:_choosePlayMothed];
        [_choosePlayMothed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        view = nil;
        _choosePlayMothed = [[CLDElevenChoosePlayMothedView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.bounds), height)];
        _choosePlayMothed.gameEn = self.LotteryGameEn;
        _choosePlayMothed.dElevenChoosePlayMothedBlock = ^(CLDElevenPlayMothedType playMothedType){
            _weakSelf.currentPlayMothedType = playMothedType;
        };
    }
    return _choosePlayMothed;
}
//尾部视图
- (CLDElevenBetFooterView *)footerView{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLDElevenBetFooterView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(kDevice_Is_iPhoneX ? 69 : 49))];
        _footerView.clearButtonClickBlock = ^(BOOL hasSelectBetButton){
            //清空
            [_weakSelf de_clearAllSelectedBetButton:hasSelectBetButton];
        };
        _footerView.confirmButtonClickBlock = ^(){
            //确定
            //存储当前的玩法的对应的投注objc
            [_weakSelf dElevenConfirmBetTerm];
        };
    }
    return _footerView;
}
//头部视图
- (CLDElevenBetHeaderView *)headerView{
    
    WS(_weakSelf)
    if (!_headerView) {
        _headerView = [[CLDElevenBetHeaderView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.bounds), __SCALE(25.f))];
        _headerView.gameEn = self.LotteryGameEn;
        _headerView.de_headViewOnClickBlock = ^(){
            
            _weakSelf.mainLotteryBetView.is_showBottomView = !_weakSelf.mainLotteryBetView.is_showBottomView;
        };
    }
    return _headerView;
}
//投注页面
- (CLDElevenMainBetView *)mainBetView{
    
    if (!_mainBetView) {
        WS(_weakSelf)
        _mainBetView = [[CLDElevenMainBetView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(400))];
        _mainBetView.gameEn = self.LotteryGameEn;
        _mainBetView.selectedChangeBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus, BOOL hasSelectBetButton){
        
            [_weakSelf betTermChangeWithBetNote:betNote minBonus:minBonus maxBonus:maxBonus hasSelectBetButton:hasSelectBetButton];
        };
    }
    return _mainBetView;
}
//近期开奖列表
- (UITableView *)awardTableView{
    
    if (!_awardTableView) {
        _awardTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(240)) style:UITableViewStylePlain];
        _awardTableView.delegate = self;
        _awardTableView.dataSource = self;
        _awardTableView.backgroundColor = UIColorFromRGB(0xf7f7ee);
        _awardTableView.scrollEnabled = NO;
        _awardTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(de_tapAwardTableView:)];
        [_awardTableView addGestureRecognizer:tap];
    }
    return _awardTableView;
}
//近期开奖数据
- (NSMutableArray *)awardDataSource{
    
    if (!_awardDataSource) {
        _awardDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _awardDataSource;
}

//空数据
- (CLLotteryNoDataView *)emptyView{
    
    WS(_weakSelf)
    if (!_emptyView) {
        _emptyView = [[CLLotteryNoDataView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(220))];
        _emptyView.hidden = YES;

        _emptyView.emptyBtnBlock = ^(){
            
            [_weakSelf.dElevenResquest start];
        };
    }
    return _emptyView;
}
//助手
- (CLLotteryBetHelperView *)helperView{
    
    WS(_weakSelf)
    if (!_helperView) {
        _helperView = [[CLLotteryBetHelperView alloc] initWithFrame:self.view.bounds];
        _helperView.titleArray = @[@"近期开奖",@"购彩技巧",@"玩法说明"];
        _helperView.helperButtonBlock = ^(UIButton *btn){
            
            [_weakSelf clickHelperViewWithButton:btn];
        };
        _helperView.hidden = YES;
    }
    return _helperView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
