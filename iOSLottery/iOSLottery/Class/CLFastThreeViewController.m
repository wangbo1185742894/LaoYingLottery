//
//  CLFastThreeViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//



//快三彩种页面



#import "CLFastThreeViewController.h"
#import "Masonry.h"
#import "CLTools.h"
//主页面
#import "CLLotteryBetView.h"
//navigation View
#import "CLNavigationView.h"
//数据请求
#import "CLLotteryBetRequest.h"
#import "CLLotteryBonusInfoRequest.h"
#import "CLLotteryMainBetModel.h"
#import "CLLotteryAllInfo.h"
#import "CLLotteryDataManager.h"
#import "CLLotteryBonusNumModel.h"
#import "CLLotteryPeriodModel.h"
//近期开奖View
#import "CLFastThreeOtherHeaderView.h"
#import "CLFastThreeSumHeaderView.h"
#import "CLFTAwardRecordTableViewCell.h"
#import "CLFTAwardRecordOtherTableViewCell.h"
//玩法筛选
#import "CLFTChoosePlayMothedView.h"
#import "CLFTChoosePlayMothedProtocol.h"
//投注页面
#import "CLFastThreeMainBetView.h"
//头部视图
#import "CLFTBetHeaderView.h"
//尾部视图
#import "CLFTBetFooterView.h"
//投注相关
#import "CLNewLotteryBetInfo.h"
//投注详情页面
#import "CLFTBetDetailViewController.h"
//助手
#import "CLLotteryBetHelperView.h"
#import "UIViewController+CLTransition.h"
#import "CLAllJumpManager.h"
//空数据
#import "CLLotteryNoDataView.h"
//新手引导
#import "CLNewbieGuidanceService.h"
//
#import "CLAppContext.h"

//开奖公告
#import "CLAwardListViewController.h"
@interface CLFastThreeViewController ()<CLLotteryBetViewDelegate, UITableViewDelegate, UITableViewDataSource, CLRequestCallBackDelegate, CLFTChoosePlayMothedProtocol>
@property (nonatomic, strong) UIImageView *backgroundView;//背景图

@property (nonatomic, strong) CLLotteryBetView *lotteryBetView;
//头部玩法筛选按钮
@property (nonatomic, strong) CLNavigationView *navigationView;
//近期开奖
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *awardTableView;//近期开奖的tableView
//玩法
@property (nonatomic, strong) CLFTChoosePlayMothedView *choosePlayMothedView;//玩法筛选view
@property (nonatomic, assign) CLFastThreePlayMothedType currentPlayMothedType;//当前玩法
//投注页
@property (nonatomic, strong) CLFastThreeMainBetView *mainBetView;//和值投注页面
//头部视图
@property (nonatomic, strong) CLFTBetHeaderView *headerView;
//尾部视图
@property (nonatomic, strong) CLFTBetFooterView *footerView;
//助手
@property (nonatomic, strong) CLLotteryBetHelperView *helperView;

//请求
@property (nonatomic, strong) CLLotteryBetRequest *fastThreeRequset;
@property (nonatomic, strong) CLLotteryBonusInfoRequest *bonusNumberRequset;//中奖信息请求

@property (nonatomic, assign) NSInteger selectedIndex;//从投注详情页跳转过来时所选中的index
@property (nonatomic, assign) BOOL isSelectedBetInfo;//是否从投注详情页选中投注信息跳转过来的
//空数据
@property (nonatomic, strong) CLLotteryNoDataView *emptyView;//空数据

@end

@implementation CLFastThreeViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.lotteryGameEn = params[@"gameEn"];
        NSString *playMothed = params[@"playMothed"];
        if (playMothed && playMothed.length > 0) {
            [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:[playMothed integerValue] gameEn:self.lotteryGameEn];
        }
    }
    return self;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_mainBetView) {
        [_mainBetView removeFromSuperview];
    }
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
    
    [self.view addSubview:self.backgroundView];
    
    if (!kDevice_Is_iPhoneX) {
        
        [CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeFT];
    }
    
    self.pageStatisticsName = [[CLAppContext context] getGameNameWithGameEn:self.lotteryGameEn];
    
    self.currentPlayMothedType = [[CLLotteryAllInfo shareLotteryAllInfo] getPlayMothedWithGameEn:self.lotteryGameEn];
    self.view.backgroundColor = UIColorFromRGB(0x338866);
    //配置UI
    [self configUI];
    //发起请求
    [self.fastThreeRequset start];
    //注册通知
    [self registerNotification];
    //根据是否有选中数据 配置UI
    [self configUIWithSelectBetInfo:self.isSelectedBetInfo];
    //注册摇一摇功能
    //开启摇一摇功能
    [[UIApplication sharedApplication] applicationSupportsShakeToEdit];
    [self becomeFirstResponder];
}
#pragma mark ------ 摇一摇代理 delegate ------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[self getShakeNotification] object:nil];
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    
}

#pragma mark ------ request Delegate ------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (self.fastThreeRequset == request) {
        [self fastThreeRequestFinished];
    }
    if (self.bonusNumberRequset == request) {
        [self fastThreeBonusNumberFinished];
    }
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    if (self.dataArray.count < 1) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}
- (void)fastThreeRequestFinished{
    
    if (!self.fastThreeRequset.urlResponse.success) {
        [self show:self.fastThreeRequset.urlResponse.errorMessage];
        return;
    }
    if (!self.fastThreeRequset.urlResponse.resp) return;
    //存缓存
    [CLLotteryDataManager storeAllInfoData:self.fastThreeRequset.urlResponse.resp gameEn:self.lotteryGameEn];
    //取缓存使用
    [self configUIWithCache];
}
- (void)fastThreeBonusNumberFinished{
    
    if (!self.bonusNumberRequset.urlResponse.resp || !self.bonusNumberRequset.urlResponse.success) {
        //如果数据不正确
        [self.bonusNumberRequset start];
        return;
    }
    CLLotteryBonusNumModel *model = [CLLotteryBonusNumModel mj_objectWithKeyValues:self.bonusNumberRequset.urlResponse.resp];
    if (model.awardStatus == 1) {
        //数据返回正确 刷新大列表
        [self.fastThreeRequset start];
    }else{
        //如果是等待开奖
        [self.bonusNumberRequset start];
    }
}
#pragma mark -------------- tableViewDelegate -------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return __SCALE(25.f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count > 10 ? 10 : self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sumCellId = @"sumCellID";
    static NSString *otherCellId = @"otherCellID";
    if (self.currentPlayMothedType == CLFastThreePlayMothedTypeHeZhi) {
        
        CLFTAwardRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sumCellId];
        if (!cell) {
            cell = [[CLFTAwardRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sumCellId];
        }
        [cell assignCellWithData:self.dataArray[indexPath.row]];
        return cell;
    }else{
        CLFTAwardRecordOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
        if (!cell) {
            cell = [[CLFTAwardRecordOtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
        }
        [cell assignCellWithData:self.dataArray[indexPath.row]];
        return cell;
    }
    return nil;
}
#pragma mark ------------ lotteryDelegate --------------
- (UIView *)lotteryBetViewCustomBetView{
    
    return self.mainBetView;
}
- (UIView *)lotteryBetViewCustomPlayMothedView{
    
    return self.choosePlayMothedView;
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
#pragma mark ------ choose Play Mothed Delegate ------
- (void)choosePlayMothedWithType:(CLFastThreePlayMothedType)playMothedType{
    
//    NSLog(@"选中玩法： %zi", playMothedType);
    self.currentPlayMothedType = playMothedType;
    self.lotteryBetView.is_showBottomView = NO;
    
}
#pragma mark ------ public Mothed ------
+ (void)presentFastThreeViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^ __nullable)(void))completion {
    CLFastThreeViewController *fastThree = [[self alloc] init];
    fastThree.selectedIndex = index;
    fastThree.isSelectedBetInfo = isSelect;
    fastThree.lotteryGameEn = gameEn;
    [initial presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:fastThree] animated:YES completion:completion];
}
#pragma mark ------ private Mothed ------
                          /*----      UI相关       ----*/
#pragma mark - 配置UI
- (void)configUI{
    
    [self.view addSubview:self.helperView];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.lotteryBetView];
    [self.awardTableView addSubview:self.emptyView];

    [self.lotteryBetView lotteryBetViewReloadData];
    //获取缓存数据配置UI
    [self configUIWithCache];
}
#pragma mark - 取缓存数据使用
- (void)configUIWithCache{

    if ([CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn].lastAwardInfo) {
        //判断上一期是否未开奖
        if (([CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn].lastAwardInfo.awardStatus == 0)) {
            [self configBonusInfoRequestWithPeriodId:[CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn].lastAwardInfo.periodId];
        }
    }
    //刷新选择玩法的加奖标记
    [self.choosePlayMothedView reloadDataForAddBonus];
    //刷新主视图数据
    [self.mainBetView reloadDataForFTMainBetView];
    //刷新头部视图的数据
    [self.headerView reloadDataForFTBetHeaderView];
    //近期开奖
    [self configRecentAwardWithData:[CLLotteryDataManager getRecentBonusDataGameEn:self.lotteryGameEn]];
    
    if ([CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn].ifAuditing == 1) {
        
        //处理屏蔽逻辑
        [self.navigationView setShowMidImage:NO];
        [self.navigationView setShowRightBtn:NO];
        self.navigationView.titleViewBlock = nil;
        self.footerView.hidden = YES;
        self.lotteryBetView.mainViewShowStatus = NO;
    }
    
}
#pragma mark - 近期开奖数据
- (void)configRecentAwardWithData:(NSArray *)awardInfoVos{
    
    //近期开奖
    if (awardInfoVos && awardInfoVos.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:awardInfoVos];
        [self.awardTableView reloadData];
    }
    if (self.dataArray.count < 1) {
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
}
#pragma mark - 根据选中过来的投注信息 配置UI
- (void)configUIWithSelectBetInfo:(BOOL)isSelectBetInfo{
    
    if (isSelectBetInfo) {
        //是从 选中投注信息 跳转过来的 (需要配置默认选中项)
        self.currentPlayMothedType = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPlayMothedTypeWithIndex:self.selectedIndex lottery:self.lotteryGameEn];
        [self.mainBetView assginDataWithSelectedData:[[CLNewLotteryBetInfo shareLotteryBetInfo] getBetInfoWithIndex:self.selectedIndex lottery:self.lotteryGameEn] playMothedType:self.currentPlayMothedType];
    }
}
#pragma mark - 配置近期开奖
- (void)configAwardTableView{
    
    //配置 近期开奖 的头部视图
    if (self.currentPlayMothedType == CLFastThreePlayMothedTypeHeZhi) {
        CLFastThreeSumHeaderView *headerView = [[CLFastThreeSumHeaderView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(25))];
        self.awardTableView.tableHeaderView = headerView;
    }else{
        CLFastThreeOtherHeaderView *headerView = [[CLFastThreeOtherHeaderView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(25))];
        self.awardTableView.tableHeaderView = headerView;
        
    }
    [self.awardTableView reloadData];
}
#pragma mark - 配置navigation的title
- (void)configNavigationView{
    self.navigationView.navigationTitle = [self getNavigationTitleView];
}
#pragma mark - 获取navigationView的title
- (NSString *)getNavigationTitleView{
    
    switch (self.currentPlayMothedType) {
        case CLFastThreePlayMothedTypeHeZhi:
            return @"和值";
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            return @"三同号";
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            return @"二同号";
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            return @"三不同号";
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            return @"二不同号";
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            return @"三不同号胆拖";
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            return @"二不同号胆拖";
            break;
        default:
            break;
    }
}
#pragma mark - 底部奖金说明数据
- (void)changeFooterViewContentWithNote:(NSInteger)note minBonus:(NSInteger)minBonus maxBonus:(NSInteger)maxBonus hasSelectBetButton:(BOOL)hasSelectBet{
    [self.footerView assignBetNote:note minBonus:minBonus maxBonus:maxBonus hasSelectBetButton:hasSelectBet playMothed:self.currentPlayMothedType];
}
#pragma mark - 配置中奖信息请求接口
- (void)configBonusInfoRequestWithPeriodId:(NSString *)periodId{
    
    self.bonusNumberRequset.gameEn = self.lotteryGameEn;
    self.bonusNumberRequset.periodId = periodId;
    [self.bonusNumberRequset start];
}
                          /*----      通知相关       ----*/
#pragma mark - 注册通知 （倒计时相关的通知）
- (void)registerNotification{
    //注册倒计时通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ft_timerNotificationResponse:) name:GlobalTimerRuning object:nil];
    //注册倒计时结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ft_periodEndNotificationResponse:) name:self.lotteryGameEn object:nil];
    //注册快三摇一摇动画开始通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeAnimationStart:) name:FT_ShakeAnimationStart object:nil];
}
#pragma mark - 快三摇一摇动画开始
- (void)shakeAnimationStart:(NSNotification *)noti{
    
    self.lotteryBetView.is_showBottomView = NO;
}
#pragma mark - 获取摇一摇对应当前玩法的通知名称
- (NSString *)getShakeNotification{
    
    switch (self.currentPlayMothedType) {
        case CLFastThreePlayMothedTypeHeZhi:
            return shake_heZhi;
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            return shake_sameThree;
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            return shake_sameTwo;
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            return shake_diffThree;
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            return shake_diffTwo;
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark ------ event Respone ------
#pragma mark - 近期开奖事件
- (void)tapAwardTableView:(UITapGestureRecognizer *)tap{
    
    CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
    awardListVC.gameEn = self.lotteryGameEn;
    awardListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:awardListVC animated:YES];
}
#pragma mark - 倒计时改变通知
- (void)ft_timerNotificationResponse:(NSNotification *)notification{
    
    CLLotteryMainBetModel *model = [CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn];
    
    //配置头部视图的数据
    [self.headerView reloadDataForFTBetHeaderView];
    //判断上一期是否是等待开奖  如果是则请求 开奖接口
    if (model.lastAwardInfo.awardStatus == 0) {
        [self configBonusInfoRequestWithPeriodId:model.lastAwardInfo.periodId];
    }
}
#pragma mark - 期次截止通知
- (void)ft_periodEndNotificationResponse:(NSNotification *)notifation{
    
    [self configBonusInfoRequestWithPeriodId:[CLLotteryDataManager getAllInfoDataGameEn:self.lotteryGameEn].currentPeriod.periodId];
    [self.fastThreeRequset start];
    
}
#pragma mark - 点击了确定投注按钮
- (void)confirmBetTerm{
    
    NSArray *betTermArray = [self.mainBetView getBetTermInfoWithPlayMothed:self.currentPlayMothedType];
    if (betTermArray.count < 1) {
        
//        NSLog(@"弹窗 提示 投注选项不正确");
        return;
    }
    //获取当前玩法的投注项
    if (self.isSelectedBetInfo) {
        //如果是从点击 投注项 跳转过来的 则替换，不是添加
        [[CLNewLotteryBetInfo shareLotteryBetInfo] replaceLotteryBetTerm:betTermArray lotteryType:self.lotteryGameEn index:self.selectedIndex];
    }else{
        [[CLNewLotteryBetInfo shareLotteryBetInfo] addLotteryBetTerm:betTermArray lotteryType:self.lotteryGameEn];
    }
    //获取当前期次数据
    CLLotteryPeriodModel *periodModel = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn];
    //设置彩种id en periodid
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameEn:periodModel.gameEn lottery:self.lotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameId:periodModel.gameId lottery:self.lotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:periodModel.periodId lottery:self.lotteryGameEn];
    
    //如果有投注项  跳转投注详情
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLFTBetDetailViewController_push/%@", self.lotteryGameEn] dissmissPresent:YES];
}
#pragma mark - 点击了清空选项列表
- (void)clearAllSelectedBetButtonWithIsClearButton:(BOOL)isClearButton{
    
    if (isClearButton) {
        //清空
        [self.mainBetView clearAllSelectedBetButtonWithPlayMothed:self.currentPlayMothedType];
    }else{
        //机选
        [[NSNotificationCenter defaultCenter] postNotificationName:[self getShakeNotification] object:nil];
    }
    
}
#pragma mark - 点击了助手中的按钮
- (void)clickHelperViewWithButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:
            //近期开奖
            self.lotteryBetView.is_showBottomView = YES;
            break;
        case 1:
            //购彩技巧
            [[CLAllJumpManager shareAllJumpManager] open:url_FT_BuyLotterySkill];
            
            break;
        case 2:
            //玩法说明
            [[CLAllJumpManager shareAllJumpManager] open:url_PlayExplain(self.lotteryGameEn)];
            
            break;
        default:
            break;
    }
}
#pragma mark ------ setter Mothed ------
- (void)setCurrentPlayMothedType:(CLFastThreePlayMothedType)currentPlayMothedType{
    _currentPlayMothedType = currentPlayMothedType;
    self.lotteryBetView.is_showPlayMothed = NO;
    [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:currentPlayMothedType gameEn:self.lotteryGameEn];
    //配置选择玩法View
    [self.choosePlayMothedView selectedViewWithPlayMothed:self.currentPlayMothedType];
    //改变玩法后 改变 近期开奖tableView
    [self configAwardTableView];
    //改变标题title
    [self configNavigationView];
    //改变betView
    [self.mainBetView refreshShowWithPlayMothed:currentPlayMothedType];
    //刷新列表
    [self.lotteryBetView lotteryBetViewReloadData];
}
#pragma mark ------ getterMothed ------
- (UIImageView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backgroundView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}
- (CLLotteryBetView *)lotteryBetView{
    
    WS(_weakSelf);
    if (!_lotteryBetView) {
        _lotteryBetView = [[CLLotteryBetView alloc] initWithFrame:__Rect(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
        _lotteryBetView.delegate = self;
        _lotteryBetView.playMothedViewIsShowBlock = ^(BOOL is_show){
            
            [_weakSelf.navigationView midImageViewIsRotation:is_show];
        };
        _lotteryBetView.bottomViewIsShowBlock = ^(BOOL is_show){
          
            [_weakSelf.headerView arrowImageViewIsRotation:is_show];
        };
    }
    return _lotteryBetView;
}
- (CLNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[CLNavigationView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, 64)];
        _navigationView.backgroundColor = UIColorFromRGB(0x000000);
        WS(_weakSelf)
        _navigationView.leftViewBlock = ^(){
            [_weakSelf dismissViewControllerAnimated:YES completion:nil];
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
//近期开奖的tableView
- (UITableView *)awardTableView{
    
    if (!_awardTableView) {
        _awardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, __SCALE(275.f)) style:UITableViewStylePlain];
        _awardTableView.delegate = self;
        _awardTableView.dataSource = self;
        _awardTableView.backgroundColor = CLEARCOLOR;
        _awardTableView.scrollEnabled = NO;
        _awardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAwardTableView:)];
        [_awardTableView addGestureRecognizer:tap];
    }
    return _awardTableView;
}
//玩法筛选view
- (CLFTChoosePlayMothedView *)choosePlayMothedView{
    
    if (!_choosePlayMothedView) {
        _choosePlayMothedView = [[CLFTChoosePlayMothedView alloc] initWithFrame:CGRectZero];
        //动态计算高度
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [view addSubview:self.choosePlayMothedView];
        [self.choosePlayMothedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        CGFloat height = [view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        view = nil;
        _choosePlayMothedView = [[CLFTChoosePlayMothedView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), height)];
        _choosePlayMothedView.weakViewController = self;
        _choosePlayMothedView.gameEn = self.lotteryGameEn;
    }
    return _choosePlayMothedView;
}
- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
//投注页面
- (CLFastThreeMainBetView *)mainBetView{
    WS(_weakSelf)
    if (!_mainBetView) {
        _mainBetView = [[CLFastThreeMainBetView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(500))];
        _mainBetView.gameEn = self.lotteryGameEn;
        _mainBetView.betBonusAndNotesBlock = ^(NSInteger note, NSInteger maxBonus, NSInteger minBonus, BOOL hasSelectBetButton){
            
            //点选了投注按钮(更改投注金额)
            [_weakSelf changeFooterViewContentWithNote:note minBonus:maxBonus maxBonus:minBonus hasSelectBetButton:hasSelectBetButton];
        };
    }
    return _mainBetView;
}
//头部视图
- (CLFTBetHeaderView *)headerView{
    WS(_weakSelf)
    if (!_headerView) {
        _headerView = [[CLFTBetHeaderView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, 60)];
        _headerView.gameEn = self.lotteryGameEn;
        _headerView.tapHeadViewBlock = ^(){
            _weakSelf.lotteryBetView.is_showBottomView = !_weakSelf.lotteryBetView.is_showBottomView;
        };
    }
    return _headerView;
}
//尾部视图
- (CLFTBetFooterView *)footerView{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLFTBetFooterView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(49))];
        _footerView.clearButtonClickBlock = ^(BOOL isClearButton){
            //清空
            [_weakSelf clearAllSelectedBetButtonWithIsClearButton:isClearButton];
        };
        _footerView.confirmButtonClickBlock = ^(){
            //确定
            //存储当前的玩法的对应的投注objc
            [_weakSelf confirmBetTerm];
        };
    }
    return _footerView;
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
//页面请求api
- (CLLotteryBetRequest *)fastThreeRequset{
    
    if (!_fastThreeRequset) {
        _fastThreeRequset = [[CLLotteryBetRequest alloc] init];
        _fastThreeRequset.delegate = self;
        _fastThreeRequset.gameEn = self.lotteryGameEn;
    }
    return _fastThreeRequset;
}
//中奖信息请求
- (CLLotteryBonusInfoRequest *)bonusNumberRequset{
    
    if (!_bonusNumberRequset) {
        _bonusNumberRequset = [[CLLotteryBonusInfoRequest alloc] init];
        _bonusNumberRequset.delegate = self;
    }
    return _bonusNumberRequset;
}

//空数据
- (CLLotteryNoDataView *)emptyView{
    
    if (!_emptyView) {
        WS(_weakSelf)
        _emptyView = [[CLLotteryNoDataView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, __SCALE(275.f))];
        _emptyView.hidden = YES;
        _emptyView.emptyBtnBlock = ^(){
           
            [_weakSelf.fastThreeRequset start];
        };
    }
    return _emptyView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
