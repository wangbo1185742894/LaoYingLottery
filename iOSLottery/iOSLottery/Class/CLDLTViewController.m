//
//  CLDLTViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//


///大乐透 彩种页面


#import "CLDLTViewController.h"
#import "CLSSQConfigMessage.h"
#import "CLTools.h"
//ui
#import "CLLotteryBetView.h"
#import "CLNavigationView.h"
#import "CLSSQChoosePlayMothedView.h"
#import "CLLotteryBetHelperView.h"
#import "CLSSQHeaderView.h"
#import "CLDLTNormalBetView.h"
#import "CLDLTDanTuoBetView.h"
#import "CLSSQFooterView.h"
#import "CLAwardListViewController.h"
#import "CLSSQAwardCell.h"
#import "CLSSQAwardHeaderView.h"
//request
#import "CLLotteryBetRequest.h"
#import "CLLotteryBonusInfoRequest.h"

#import "CLAllJumpManager.h"

//data
#import "CLLotteryAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLLotteryPeriodModel.h"
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLCacheManager.h"

#import "CLNewbieGuidanceService.h"

@interface CLDLTViewController ()<CLLotteryBetViewDelegate, CLRequestCallBackDelegate, UITableViewDelegate, UITableViewDataSource>

//ui
/**
 投注选项View(红球，蓝球)
 */
@property (nonatomic, strong) CLLotteryBetView *mainLotteryBetView;

/**
 导航栏
 */
@property (nonatomic, strong) CLNavigationView *navigationView;

/**
 助手View
 */
@property (nonatomic, strong) CLLotteryBetHelperView *helperView;

/**
 导航栏中选择玩法View
 */
@property (nonatomic, strong) CLSSQChoosePlayMothedView *choosePlayMothedView;

/**
 顶部期次，截期View
 */
@property (nonatomic, strong) CLSSQHeaderView *headerView;

/**
 普通投注View
 */
@property (nonatomic, strong) CLDLTNormalBetView *normalView;

/**
 胆拖投注View
 */
@property (nonatomic, strong) CLDLTDanTuoBetView *danTuoView;

/**
 底部视图
 */
@property (nonatomic, strong) CLSSQFooterView *footerView;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) CLSSQAwardHeaderView *awardHeaderView;

/**
 是否显示遗漏
 */
@property (nonatomic, assign) BOOL isHiddenOmission;

//request
@property (nonatomic, strong) CLLotteryBetRequest *ssqRequest;
@property (nonatomic, strong) CLLotteryBonusInfoRequest *ssqBonusRequest;

//data
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, assign) CLSSQPlayMothedType playMothedType;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) BOOL isSelectedBetInfo;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation CLDLTViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.gameEn = params[@"gameEn"];
        NSString *playMothed = params[@"playMothed"];
        if (playMothed && playMothed.length > 0) {
            [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:[playMothed integerValue] gameEn:self.gameEn];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
//    self.isHiddenOmission = [[CLLotteryAllInfo shareLotteryAllInfo] getShowOmissionWithGameEn:self.gameEn];
    
    //取缓存
    [self getCacheData];
    
    
    [self.mainLotteryBetView lotteryBetViewReloadData];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSDate *start = [NSDate date];
    
    if (!kDevice_Is_iPhoneX) {
        
        [CLNewbieGuidanceService showNewGuidanceInWindowWithType:CLNewbieGuidanceTypeDLT];
    }
    
    self.playMothedType = [[CLLotteryAllInfo shareLotteryAllInfo] getPlayMothedWithGameEn:self.gameEn];

    
    //UI相关
    [self configUI];
    
    if (self.isSelectedBetInfo) {
        //如果是从详情跳转过来的，配置默认数据
        [self configDefaultData];
    }

    //请求相关
    [self configRequest];
    
    
    
    //这里是要执行的代码
    
//    NSDate *end = [NSDate date];
//    
//    NSLog(@"========================== %f",[end timeIntervalSinceDate:start]);


}
+ (void)presentSSQViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^)(void))completion {
    CLDLTViewController *dlt = [[self alloc] init];
    dlt.selectedIndex = index;
    dlt.isSelectedBetInfo = isSelect;
    dlt.gameEn = gameEn;
    [initial presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:dlt] animated:YES completion:completion];
}
#pragma mark ------------ shake Delegate ------------
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        [self randomAnimation];
    }
}
#pragma mark ------------ requestDelegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        
//        NSLog(@"%@", request.urlResponse.resp);
        //存缓存
        [[CLLotteryAllInfo shareLotteryAllInfo] setMainRequestData:[CLLotteryMainBetModel mj_objectWithKeyValues:request.urlResponse.resp] gameEn:self.gameEn];
        //取缓存使用
        [self getCacheData];
    }
}

- (void)requestFailed:(CLBaseRequest *)request{
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark ------------ lotteryMainDelegate ------------
- (UIView *)lotteryBetViewCustomPlayMothedView{
    
    return self.choosePlayMothedView;
}
- (UIView *)lotteryBetViewCustomHeaderView{
    
    return self.headerView;
}
- (UIView *)lotteryBetViewCustomBetView{
    
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        if (_danTuoView) {
            self.danTuoView.hidden = YES;
        }
        self.normalView.hidden = NO;
        return self.normalView;
    }else{
        if (_normalView) {
            self.normalView.hidden = YES;
        }
        self.danTuoView.hidden = NO;
        return self.danTuoView;
    }
}
- (UIView *)lotteryBetViewCustomFooterView{
    
    return self.footerView;
}
- (UIView *)lotteryBetViewCustomAwardRecordView{
    
    return self.mainTableView;
}
#pragma mark ------------ tableViewDelegate ------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return __SCALE(22.f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count > 10 ? 10 : self.dataSourceArray.count;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"awardCellID";
    CLSSQAwardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLSSQAwardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell assignData:self.dataSourceArray[indexPath.row]];
    cell.backgroundColor = (indexPath.row % 2) ? UIColorFromRGB(0xeeeee5) : UIColorFromRGB(0xffffff);
    return cell;
}
#pragma mark ------------ private Mothed ------------
- (void)configUI{
    
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.mainLotteryBetView];
    [self.view addSubview:self.helperView];
    
}
- (void)getCacheData{
    
    CLLotteryMainBetModel *mainBetModel = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.gameEn];
 
    [self.dataSourceArray removeAllObjects];
    if (mainBetModel.missingNumbers && [mainBetModel.missingNumbers isKindOfClass:[NSDictionary class]]) {
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self.normalView assignOmissionDataWithRed:mainBetModel.missingNumbers[@"AHEAD"] blue:mainBetModel.missingNumbers[@"BACK"]];
        }else{
            [self.danTuoView assignOmissionDataWithRed:mainBetModel.missingNumbers[@"AHEAD"] blue:mainBetModel.missingNumbers[@"BACK"]];
        }
        
    }else{
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self.normalView assignOmissionDataWithRed:@[] blue:@[]];
        }else{
            [self.danTuoView assignOmissionDataWithRed:@[] blue:@[]];
        }
    }
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        [self.normalView assignActicityLink:mainBetModel.activityMap];
    }else{
        [self.danTuoView assignActicityLink:mainBetModel.activityMap];
    }
    [self.dataSourceArray addObjectsFromArray:mainBetModel.awardInfoVos];
    [self.headerView ssq_assigBetHeaderCurrentPeriodWithData:mainBetModel.currentSubPeriod endTime:mainBetModel.betEndInfo];
    [self.mainTableView reloadData];
    if (mainBetModel.beiTou && mainBetModel.beiTou.length > 0) {
        if (mainBetModel.betEndInfo && mainBetModel.betEndInfo.length > 0) {
            [self.awardHeaderView assignBonus:[NSString stringWithFormat:@"奖池滚存:%@", mainBetModel.poolBonus] multiple:[NSString stringWithFormat:@"投%@倍可掏空奖池", mainBetModel.beiTou]];
            self.mainTableView.tableHeaderView = self.awardHeaderView;
        }
    }
    
    if (mainBetModel.ifAuditing == 1) {
        //处理屏蔽逻辑
        [self.navigationView setShowMidImage:NO];
        [self.navigationView setShowRightBtn:NO];
        self.navigationView.titleViewBlock = nil;
        self.footerView.hidden = YES;
        self.mainLotteryBetView.mainViewShowStatus = NO;
    }
}
#pragma mark - 配置默认数据
- (void)configDefaultData{
    
    //是从选中投注信息跳转过来的
    self.playMothedType = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPlayMothedTypeWithIndex:self.selectedIndex lottery:self.gameEn];
    CLLotteryBaseBetTerm *betTerm = [[CLNewLotteryBetInfo shareLotteryBetInfo] getBetInfoWithIndex:self.selectedIndex lottery:self.gameEn];
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        [self.normalView assignDefaultData:(CLDLTNormalBetTerm *)betTerm];
    }else{
        [self.danTuoView assginDefaultData:(CLDLTDanTuoBetTerm *)betTerm];
    }
}
- (void)configRequest{
    
    [self.ssqRequest start];
}
#pragma mark - 随机动画
- (void)randomAnimation{
    
    self.mainLotteryBetView.is_showBottomView = NO;
    [self.normalView ssq_randomSelectBall];
}
#pragma mark ------------ event Response ------------
#pragma mark - 点击了助手
- (void)clickHelperViewWithButton:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            //近期开奖
            self.mainLotteryBetView.is_showBottomView = YES;
            break;
        case 1:{
            self.isHiddenOmission = !self.isHiddenOmission;
            
            [[CLLotteryAllInfo shareLotteryAllInfo] setShowOmission:self.isHiddenOmission gameEn:self.gameEn];
            
            [btn setTitle:self.isHiddenOmission ? @"显示遗漏" : @"隐藏遗漏" forState:UIControlStateNormal];
        }
            break;
        case 2:
            //购彩技巧
            [[CLAllJumpManager shareAllJumpManager] open:url_DE_BuyLotterySkill];
            
            break;
        case 3:
            //玩法说明
            NSLog(@"%@", url_PlayExplain(self.gameEn));
            [[CLAllJumpManager shareAllJumpManager] open:url_PlayExplain(self.gameEn)];
            break;
        default:
            break;
    }
}
#pragma mark - 切换玩法
- (void)switchPlayMothed:(CLSSQPlayMothedType)playMothed{
    
    self.playMothedType = playMothed;
    
}
#pragma mark - 点击了开奖列表
- (void)ssq_tapAwardTableView:(UITableView *)tableview{
    
    CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
    awardListVC.gameEn = self.gameEn;
    awardListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:awardListVC animated:YES];
}
#pragma mark - 清空或机选
- (void)ssq_clearAllSelectedBetButton:(BOOL)hasSelect{
    
    if (hasSelect) {
        //清空
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self.normalView ssq_normalClearAll];
        }else if (self.playMothedType == CLSSQPlayMothedTypeDanTuo){
            [self.danTuoView ssq_danTuoClearAll];
        }
    }else{
        //机选
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self randomAnimation];
        }else if (self.playMothedType == CLSSQPlayMothedTypeDanTuo){
            //            [self.danTuoView ssq_danTuoClearAll];
        }
    }
}
#pragma mark - 确定投注
- (void)ssqConfirmBetTerm{
    
    NSArray *betTermArray = nil;
    
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        if (self.normalView.betTerm.betNote > 0) {
            betTermArray = @[self.normalView.betTerm];
        }else if (self.normalView.betTerm.redArray.count > 0 || self.normalView.betTerm.blueArray.count > 0){
            [self show:@"请至少选择5个红球，2个蓝球"];
        }else{
            [self randomAnimation];
        }
    }else if (self.playMothedType == CLSSQPlayMothedTypeDanTuo){
        
        if (![self getDTAllowBet]) {
            [self show:@"请至少选择一注"];
        }else{
            
            betTermArray = @[self.danTuoView.betTerm];
        }
    }
    if (!(betTermArray && betTermArray.count > 0)) {
        return;
    }
    if (self.isSelectedBetInfo) {
        [[CLNewLotteryBetInfo shareLotteryBetInfo] replaceLotteryBetTerm:betTermArray lotteryType:self.gameEn index:self.selectedIndex];
    }else{
        [[CLNewLotteryBetInfo shareLotteryBetInfo] addLotteryBetTerm:betTermArray lotteryType:self.gameEn];
    }
    //获取当前期次信息
    CLLotteryMainBetModel *model = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.gameEn];
    
    //设置彩种id en periodid
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameEn:self.gameEn lottery:self.gameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameId:model.currentPeriod.gameId lottery:self.gameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:model.currentPeriod.periodId lottery:self.gameEn];
    
    //如果有投注项  跳转投注详情
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLDLTDetailViewController_push/%@", self.gameEn] dissmissPresent:YES];
}
#pragma mark - 胆拖投注是否允许投注
- (BOOL)getDTAllowBet{
    
    return ((self.danTuoView.betTerm.redDanArray.count + self.danTuoView.betTerm.redTuoArray.count >= 6) && (self.danTuoView.betTerm.blueDanArray.count + self.danTuoView.betTerm.blueTuoArray.count >= 2) && self.danTuoView.betTerm.betNote > 0);
}
#pragma mark ------------ setter Mothed ------------
- (void)setPlayMothedType:(CLSSQPlayMothedType)playMothedType{
    
    _playMothedType = playMothedType;
    [[CLLotteryAllInfo shareLotteryAllInfo] setPlayMothed:playMothedType gameEn:self.gameEn];
    self.choosePlayMothedView.playMothedType = playMothedType;
    if (playMothedType == CLSSQPlayMothedTypeNormal) {
        [self.normalView refreshNote];
    }else if (playMothedType == CLSSQPlayMothedTypeDanTuo){
        [self.danTuoView refreshNote];
    }
    CLLotteryMainBetModel *mainBetModel = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.gameEn];
    
    if (mainBetModel.missingNumbers && [mainBetModel.missingNumbers isKindOfClass:[NSDictionary class]]) {
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self.normalView assignOmissionDataWithRed:mainBetModel.missingNumbers[@"AHEAD"] blue:mainBetModel.missingNumbers[@"BACK"]];
        }else{
            [self.danTuoView assignOmissionDataWithRed:mainBetModel.missingNumbers[@"AHEAD"] blue:mainBetModel.missingNumbers[@"BACK"]];
        }
        
    }else{
        if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
            [self.normalView assignOmissionDataWithRed:@[] blue:@[]];
        }else{
            [self.danTuoView assignOmissionDataWithRed:@[] blue:@[]];
        }
    }
    if (self.playMothedType == CLSSQPlayMothedTypeNormal) {
        [self.normalView assignActicityLink:mainBetModel.activityMap];
    }else{
        [self.danTuoView assignActicityLink:mainBetModel.activityMap];
    }
    self.navigationView.navigationTitle = (_playMothedType == CLSSQPlayMothedTypeNormal) ? @"大乐透" : @"大乐透胆拖";
    self.mainLotteryBetView.is_showPlayMothed = NO;
    [self.mainLotteryBetView lotteryBetViewReloadData];
}


#pragma mark ---- 是否xianshu
- (void)setIsHiddenOmission:(BOOL)isHiddenOmission{
    
    _isHiddenOmission = isHiddenOmission;
    
    if (!([[CLCacheManager getCacheFormLocationcacheFileWithName:dltOmissionPrompt] integerValue] == 1) && isHiddenOmission == NO) {
        //展示说明
        [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeD11];
        [CLCacheManager saveToCacheWithContent:@(1) cacheFileName:dltOmissionPrompt];
    }
    
    [self.normalView hiddenOmission:isHiddenOmission];
    [self.danTuoView hiddenOmission:isHiddenOmission];
    
    //计算frame
    CGSize size = [self.normalView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.normalView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height);
    
    size = [self.danTuoView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];;
    self.danTuoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height);
    
    [self.mainLotteryBetView lotteryBetViewReloadData];
}
#pragma mark ------------ getter Mothed ------------
//请求
- (CLLotteryBetRequest *)ssqRequest{
    
    if (!_ssqRequest) {
        _ssqRequest = [[CLLotteryBetRequest alloc] init];
        _ssqRequest.delegate = self;
        _ssqRequest.gameEn = self.gameEn;
    }
    return _ssqRequest;
}
//主框架
- (CLLotteryBetView *)mainLotteryBetView{
    
    WS(_weakSelf)
    if (!_mainLotteryBetView) {
        
        CGFloat height = kDevice_Is_iPhoneX ?  88 : 64;
        
        _mainLotteryBetView = [[CLLotteryBetView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, SCREEN_HEIGHT - height)];
        _mainLotteryBetView.backgroundColor = UIColorFromRGB(0xeeeee5);
        _mainLotteryBetView.delegate = self;
        _mainLotteryBetView.bottomViewIsShowBlock = ^(BOOL isShow){
            
            _weakSelf.headerView.rotationAnimation = isShow;
        };
        _mainLotteryBetView.playMothedViewIsShowBlock = ^(BOOL is_show){
            
            [_weakSelf.navigationView midImageViewIsRotation:is_show];
        };
    }
    
    return _mainLotteryBetView;
}
//导航栏
- (CLNavigationView *)navigationView{
    if (!_navigationView) {
        _navigationView = [[CLNavigationView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, kDevice_Is_iPhoneX ? 88 : 64)];

        _navigationView.navigationTitle = @"大乐透";
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
//选择玩法
- (CLSSQChoosePlayMothedView *)choosePlayMothedView{
    
    WS(_weakSelf)
    if (!_choosePlayMothedView) {
        _choosePlayMothedView = [[CLSSQChoosePlayMothedView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(60.f))];
        _choosePlayMothedView.backgroundColor = UIColorFromRGB(0xeeeee5);
        _choosePlayMothedView.layer.shadowColor = UIColorFromRGB(0x333333).CGColor;
        _choosePlayMothedView.layer.shadowOpacity = 0.3;
        _choosePlayMothedView.layer.shadowOffset = CGSizeMake(0, 3);
        _choosePlayMothedView.switchPlayMothed = ^(CLSSQPlayMothedType playMothed){
            
            [_weakSelf switchPlayMothed:playMothed];
        };
    }
    return _choosePlayMothedView;
}

//头部视图
- (CLSSQHeaderView *)headerView{
    
    WS(_weakSelf)
    if (!_headerView) {
        _headerView = [[CLSSQHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(30.f))];
        _headerView.ssq_headViewOnClickBlock = ^(){
            
            _weakSelf.mainLotteryBetView.is_showBottomView = !_weakSelf.mainLotteryBetView.is_showBottomView;
        };
    }
    
    return _headerView;
}

//主视图
- (CLDLTNormalBetView *)normalView{
    
    if (!_normalView) {
        WS(_weakSelf)
        _normalView = [[CLDLTNormalBetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(536.5f))];
        
        //        CGSize size = [_normalView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //_normalView.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(536.5f));
        _normalView.backgroundColor = UIColorFromRGB(0xf7f7ee);
        _normalView.ssq_normalCallBackNoteBonusBlock = ^(NSInteger max, NSInteger min, NSInteger note, BOOL hasSelect){
            
            [_weakSelf.footerView assignBetNote:note hasSelectBetButton:hasSelect playMothed:CLSSQPlayMothedTypeNormal];
        };
    }
    return _normalView;
}
- (CLDLTDanTuoBetView *)danTuoView{
    
    WS(_weakSelf)
    if (!_danTuoView) {
        _danTuoView = [[CLDLTDanTuoBetView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(932.f))];
        
        //        CGSize size = [_danTuoView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //        _danTuoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, size.height);
        
        _danTuoView.backgroundColor = UIColorFromRGB(0xf7f7ee);
        _danTuoView.ssq_normalCallBackNoteBonusBlock = ^(NSInteger max, NSInteger min, NSInteger note, BOOL hasSelect){
            
            [_weakSelf.footerView assignBetNote:[_weakSelf getDTAllowBet] ? note : 0 hasSelectBetButton:hasSelect playMothed:CLSSQPlayMothedTypeDanTuo];
        };
    }
    return _danTuoView;
}
//近期开奖
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.view.frame), __SCALE(240)) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ssq_tapAwardTableView:)];
        [_mainTableView addGestureRecognizer:tap];
    }
    return _mainTableView;
}
- (CLSSQAwardHeaderView *)awardHeaderView{
    
    if (!_awardHeaderView) {
        _awardHeaderView = [[CLSSQAwardHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(20))];
        _awardHeaderView.backgroundColor = UIColorFromRGB(0xf7f7ee);
    }
    return _awardHeaderView;
}
//底部视图
- (CLSSQFooterView *)footerView{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLSSQFooterView alloc] initWithFrame:__Rect(0, 0, self.view.frame.size.width, __SCALE(kDevice_Is_iPhoneX ? 69 : 49))];
        _footerView.clearButtonClickBlock = ^(BOOL hasSelectBetButton){
            //清空
            [_weakSelf ssq_clearAllSelectedBetButton:hasSelectBetButton];
        };
        _footerView.confirmButtonClickBlock = ^(){
            //确定
            //存储当前的玩法的对应的投注objc
            [_weakSelf ssqConfirmBetTerm];
        };
    }
    return _footerView;
}
//助手
- (CLLotteryBetHelperView *)helperView{
    
    WS(_weakSelf)
    if (!_helperView) {
        _helperView = [[CLLotteryBetHelperView alloc] initWithFrame:self.view.bounds];
        _helperView.titleArray = @[@"近期开奖", @"显示遗漏",@"购彩技巧",@"玩法说明"];
        _helperView.helperButtonBlock = ^(UIButton *btn){
            
            [_weakSelf clickHelperViewWithButton:btn];
        };
        _helperView.hidden = YES;
    }
    return _helperView;
}
- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
