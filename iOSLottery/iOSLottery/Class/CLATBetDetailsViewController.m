//
//  CLATBetDetailsViewController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATBetDetailsViewController.h"

//相关控制器
#import "CLArrangeThreeViewController.h"
#import "CLArrangeFiveViewController.h"
#import "CLQLCViewController.h"
#import "CLQXCViewController.h"

#import "UINavigationController+CLDestroyCurrentController.h"

#import "CLConfigMessage.h"
#import "CLTools.h"

//各种管理类
#import "CLATManager.h"
#import "CLAFManager.h"
#import "CLQLCManager.h"
#import "CLQXCManager.h"
#import "CLATBetCache.h"
#import "CLAllJumpManager.h"

#import "CLLotteryAllInfo.h"
#import "CLLotteryMainBetModel.h"

#import "CLJumpLotteryManager.h"
#import "CKNewPayViewController.h"

#import "CLNewLotteryBetInfo.h"

#import "CLDElevenBetHeaderView.h"
#import "CLDEBetDetailFooterView.h"

#import "CLDEDetailTableFooterView.h"

#import "CLAlertController.h"

#import "CLLotteryChaseMultipleView.h"

#import "CLLotteryPeriodRequest.h"

#import "CLCreateOrderRequestHandler.h"

#import "CLLotteryDetailTableFooterView.h"

#import "CLEndBetGuideView.h"

#import "CLAppContext.h"

#import "CLDEBetDetailTableViewCell.h"

#import "CLCheckProgessManager.h"

#import "CLATCreateOrderRequset.h"
#import "CLLotteryChaseOrderRequest.h"

#import "CLLoadingAnimationView.h"
#import "CLBetDetailsTopView.h"

@interface CLATBetDetailsViewController ()<UITableViewDelegate, UITableViewDataSource, CLRequestCallBackDelegate, CLAlertControllerDelegate>

@property (nonatomic, strong) CLATCreateOrderRequset *createOreder;

@property (nonatomic, strong) CLLotteryChaseOrderRequest *createChaseOrder;

/**
 头部视图
 */
@property (nonatomic, strong) CLDElevenBetHeaderView *betDetailHeaderView;

@property (nonatomic, strong) UITableView *mainTableView;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) CLBetDetailsTopView *topView;

/**
 tableView上的头部imageView
 */
@property (nonatomic, strong) UIImageView *tableViewHeaderImageView;

/**
 白色
 */
@property (nonatomic, strong) UIImageView *tableImageEmptyView;

/**
 阴影
 */
@property (nonatomic, strong) UIImageView *tableImageShadowView;

@property (nonatomic, strong) CLDEBetDetailFooterView *detailFooterView;//底部视图
@property (nonatomic, strong) CALayer *whiteLayer;//tableView下拉时的白色
@property (nonatomic, strong) CLDEDetailTableFooterView *tableFooterView;//tableview的底部视图

/**
 期数和倍数
 */
@property (nonatomic, strong) CLLotteryChaseMultipleView *chaseMutipleView;

@property (nonatomic, strong) UIView *baffleView;//蒙版
//@property (nonatomic, strong) CLLotteryPeriodRequest *request;//请求
@property (nonatomic, strong) CLCreateOrderRequestHandler *de_createOrderHandler;//创建订单请求
@property (nonatomic, strong) CLAlertController *alertController;//
@property (nonatomic, strong) NSString *lotteryGameEn;
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) CLAlertController *actionSheet;//保存弹窗
@property (nonatomic, strong) CLLotteryDetailTableFooterView *emptyTableFooterView;
@property (nonatomic, strong) CLAlertController *allClearAlert;//清空按钮弹窗

/**
 投注截期弹窗
 */
@property (nonatomic, strong) CLEndBetGuideView *endBetGuideView;



@end

@implementation CLATBetDetailsViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.lotteryGameEn = params[@"gameEn"];
    }
    return self;
}

#pragma mark ---- 视图生命周期 -----
//- (void)ViewContorlBecomeActive:(NSNotification *)notification{
//    
//    [super ViewContorlBecomeActive:notification];
//    //从后台进入前台
//    [self.request start];
//    [self getData];
//    [self assignFooterViewData];
//}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self addKeyBoardNotification];
//    [self addPeriodCutDownNotification];
    [self assignFooterViewData];
    
    [self getData];
}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    [self getData];
//    
//}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navTitleText = [[CLAppContext context] getGameNameWithGameEn:self.lotteryGameEn];
    
    self.pageStatisticsName = self.lotteryGameEn;//防止没取到gameName,友盟依然可以统计到
    self.view.backgroundColor = UIColorFromRGB(0xf7f7ee);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self p_addSubViews];

    [self p_configConstraint];

    //添加返回按钮
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
    
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.whiteLayer.frame = __Rect(0, - SCREEN_HEIGHT, self.mainTableView.frame.size.width, SCREEN_HEIGHT);
}

#pragma mark - 获取数据
- (void)getData{
    
    NSArray *tempArray = [NSArray arrayWithArray:self.dataSourceArray];
   
    [self.dataSourceArray removeAllObjects];
    
    [self.dataSourceArray addObjectsFromArray:[[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:self.lotteryGameEn]];
    
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    
    if (tempArray.count < self.dataSourceArray.count) {
        
        [UIView animateWithDuration:0 animations:^{
            [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            
        }];
    }
    [self.mainTableView reloadData];
}


#pragma mark - 配置底部View的数据
- (void)assignFooterViewData
{    
    self.chaseMutipleView.periodTextField.text = [NSString stringWithFormat:@"%zi",[[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn]];
    
    self.chaseMutipleView.multipleTextField.text = [NSString stringWithFormat:@"%zi", [[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn]];
    
    [self.detailFooterView assignBetNote:[[CLATBetCache shareCache] getNoteNumberWithLotteryName:self.lotteryGameEn] period:[[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn] multiple:[[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn]];
}


#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request
{
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    NSDictionary *dic = request.urlResponse.resp;;
    if (!(dic && dic.count > 0)){
    
        [self show:request.urlResponse.errorMessage];
        return;
    }
    
    
    if ([dic[@"isBetAvailable"] integerValue] == 0) {
        
        self.endBetGuideView = [[CLEndBetGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.endBetGuideView.type = (((NSString *)dic[@"saleInfo"]).length > 0) ? CLEndBetGuideTypeEnd : CLEndBetGuideTypeNoSale;
        self.endBetGuideView.title = dic[@"saleInfo"];
        self.endBetGuideView.jumpButtonTitle = dic[@"buttonTips"];
        self.endBetGuideView.desText = [dic[@"message"] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        WS(_weakSelf)
        self.endBetGuideView.jumpLotteryBlock = ^{
            
            if (dic[@"gameEn"] && ((NSString *)dic[@"gameEn"]).length > 0) {
                //跳转其他页面 清空缓存

                [[CLATBetCache shareCache] deleteBetOptionsCacheWithLotteryName:_weakSelf.lotteryGameEn];
                
                [CLJumpLotteryManager jumpLotteryDestoryWithGameEn:dic[@"gameEn"] isJudgeCache:YES];
            }
        };
        [self.view.window addSubview:self.endBetGuideView];
        
    }else{
    
    
        CKNewPayViewController *paymentController = [[CKNewPayViewController alloc] init];
        paymentController.lotteryGameEn = self.lotteryGameEn;
        paymentController.pushType = CKPayPushTypeBet;
        paymentController.period = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.periodId;
        paymentController.periodTime = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.saleEndTime;
    
        
        if ([[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn] > 1) {
            //追号
            paymentController.orderType = CKOrderTypeFollow;
        }else{
            //普通订单
            paymentController.orderType = CKOrderTypeNormal;
        }
        paymentController.hidesBottomBarWhenPushed = YES;
        paymentController.payConfigure = dic;
        
        [self.navigationController pushDestroyViewController:paymentController animated:YES];
        
        [[CLATBetCache shareCache] deleteBetOptionsCacheWithLotteryName:self.lotteryGameEn];
        //[self show:@"当前网络不稳定，请重试"];
    }
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
    [self show:request.urlResponse.errorMessage];
    
}

#pragma mark ------------ tableview delegate ------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(_weakSelf)
    
    CLDEBetDetailTableViewCell *cell = [CLDEBetDetailTableViewCell createDEBetDetailsTableViewCellWithTableView:tableView];
    

    [cell assignBetDetailCellWithData:self.dataSourceArray[indexPath.row]];
    
    __weak CLDEBetDetailTableViewCell *weakCell = cell;
    cell.deleteCellBlock = ^(){
        
        [_weakSelf deleteCellWithIndex:[tableView indexPathForCell:weakCell]];
    };
    return cell;
}

#pragma mark ----- 删除一行 -----
- (void)deleteCellWithIndex:(NSIndexPath *)index{
    
    [self.dataSourceArray removeObjectAtIndex:index.row];
    
    [self.mainTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    
    //从缓存了删除投注内容
    [[CLATBetCache shareCache] removeOneGroupBetOptionsWithIndex:index.row ofLotteryName:self.lotteryGameEn];
    
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    [self assignFooterViewData];
}


#pragma mark ----- 选中一行 -----
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.lotteryGameEn isEqualToString:@"pl5"]) {
        
        [CLArrangeFiveViewController presentFastThreeViewControllerWithInitialVC:self selectedIndex:(indexPath.row) isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:^{
            
        }];
        
        
    }else if ([self.lotteryGameEn isEqualToString:@"pl3"]||[self.lotteryGameEn isEqualToString:@"fc3d"]){
    
        [CLArrangeThreeViewController presentFastThreeViewControllerWithInitialVC:self selectedIndex:(indexPath.row) isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:^{
        }];
        
    }else if ([self.lotteryGameEn isEqualToString:@"qlc"]){
    
        [CLQLCViewController presentFastThreeViewControllerWithInitialVC:self selectedIndex:indexPath.row isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:nil];
    }else if ([self.lotteryGameEn isEqualToString:@"qxc"]){
    
        [CLQXCViewController presentFastThreeViewControllerWithInitialVC:self selectedIndex:indexPath.row isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:nil];
    }

}

#pragma mark ------------ event Response ------------
#pragma mark - 返回按钮
- (void)navBackButtonOnClick:(UIButton *)btn
{
    //如果有投注项则提示，没有则直接返回
    if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:self.lotteryGameEn].count > 0) {
        
        [self.actionSheet show];
        
    }else{
    
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [[CLAllJumpManager shareAllJumpManager] open:@"CLHomeViewController"];
    }
}

#pragma mark - 自选事件
- (void)optionalButtonOnClick
{
    [CLJumpLotteryManager jumpLotteryWithGameEn:self.lotteryGameEn isJudgeCache:NO];
}
#pragma mark - 机选事件
- (void)randomButtonOnClick
{
    //振动
    [CLTools vibrate];
    
    //机选一注
    if ([self.lotteryGameEn isEqualToString:@"pl5"]) {
        
        [[CLAFManager shareManager] randomAddOneBetOptions];
        
    }else if ([self.lotteryGameEn isEqualToString:@"pl3"] || [self.lotteryGameEn isEqualToString:@"fc3d"]){
    
        [[CLATManager shareManager] randomAddOneBetOptions];
        
    }else if ([self.lotteryGameEn isEqualToString:@"qlc"]){
    
       [[CLQLCManager shareManager] randomAddOneBetOptions];
        
    }else if ([self.lotteryGameEn isEqualToString:@"qxc"]){
    
       [[CLQXCManager shareManager] randomAddOneBetOptions];
    }
    
    
    //获取数据
    //CLDEBetDetailDataManager *dataManager = [[CLDEBetDetailDataManager alloc] init];
    [self.dataSourceArray removeAllObjects];
    
    [self.dataSourceArray addObjectsFromArray:[[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:self.lotteryGameEn]];
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    [self assignFooterViewData];
}
#pragma mark - 清空列表
- (void)clearButtonOnClick
{
    if (self.dataSourceArray.count == 0) return;
    
    [self.allClearAlert show];
}

#pragma mark ------------ alert delegate ------------
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (self.alertController == alertController) {
        if (index == 1) {
            
            [self.de_createOrderHandler createOrderRequestWithType:self.lotteryGameEn];
        }
        
    }else if (self.actionSheet == alertController){
        
        if (index == 1) {
            //清空操作
            [[CLATBetCache shareCache] deleteBetOptionsCacheWithLotteryName:self.lotteryGameEn];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (index == 2){
            //保存当前彩种投注内容
            //只保存号码，不保存期次，  将期次置为@""
//            [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:@"" lottery:self.lotteryGameEn];
            
//            [[CLATBetCache shareCache] saveBetOptionsCacheWithLotteryName:self.lotteryGameEn data:[[CLATManager shareManager] getBetOptions]];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.allClearAlert == alertController){
        
        if (index == 1) {
            [self clearAll];
        }
    }
}

#pragma mark - 清空所有
- (void)clearAll{
    
    [[CLATBetCache shareCache] deleteBetOptionsCacheWithLotteryName:self.lotteryGameEn];
    
    //获取数据
    [self getData];
    [self assignFooterViewData];
}

#pragma mark ----- 去支付 ------
- (void)payButtonOnClick{
    
    WS(_weakSelf)
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        [_weakSelf confirmPay];
    }];
}

- (void)confirmPay{
    
    if ([[CLATBetCache shareCache] getBetOptionsCacheWithLotteryName:self.lotteryGameEn].count < 1) {
        [self show:@"请至少投一注"];
        return;
    }

    if ([[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn] > 1) {
        
      
        //有追期
        self.createChaseOrder.gameId = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.gameId;
        
        self.createChaseOrder.lotteryNumber = [[CLATBetCache shareCache] getLotteryNumberWithLotteryName:self.lotteryGameEn];
        
        NSInteger amount = [[CLATBetCache shareCache] getNoteNumberWithLotteryName:self.lotteryGameEn];
        
        self.createChaseOrder.amount = [NSString stringWithFormat:@"%zi",amount * 2 * [[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn] * [[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn]];
        
    
        self.createChaseOrder.followMode = [NSString stringWithFormat:@"%zi",self.chaseMutipleView.isStopChase ? 1 : 0];
        
        self.createChaseOrder.followType = @"0";
        
        NSString *period = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.periodId;
        
        self.createChaseOrder.periodTimesStr = [NSString stringWithFormat:@"%@_%zi", period, [[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn]];

        self.createChaseOrder.totalPeriod = [NSString stringWithFormat:@"%zi",[[CLATBetCache shareCache] getPeriodWithLotteryName:self.lotteryGameEn]];
        
        [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
        
        [self.createChaseOrder start];

        return;
    }
    
    
    self.createOreder.gameId = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.gameId;
    
    self.createOreder.betTimes = [NSString stringWithFormat:@"%zi", [[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn]];
    
    self.createOreder.periodId = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.periodId;
    
    self.createOreder.lotteryNumber = [[CLATBetCache shareCache] getLotteryNumberWithLotteryName:self.lotteryGameEn];
    
    NSInteger amount = [[CLATBetCache shareCache] getNoteNumberWithLotteryName:self.lotteryGameEn];
    
    self.createOreder.amount = [NSString stringWithFormat:@"%zi",amount * 2 * [[CLATBetCache shareCache] getTimesWithLotteryName:self.lotteryGameEn]];
    
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationInCurrentViewControllerWithType:CLLoadingAnimationTypeNormal];
    
    [self.createOreder start];

}


#pragma mark - 点击了蒙版
- (void)tapBaffleViewOnClick:(UITapGestureRecognizer *)tap{
    
    //失去第一响应
    [self.chaseMutipleView lotteryChaseMultipleViewResignResponse];
}

#pragma mark - 添加键盘通知
- (void)addKeyBoardNotification{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 键盘出现
- (void)keyboardWillShow:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:NO];
}
#pragma mark - 键盘消失
- (void)keyboardWillHide:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:YES];
}

#pragma mark - textfield值发生改变
- (void)textFieldChange{
    
    //存储 期次 和 倍数
    [[CLATBetCache shareCache] setTimes:[self.chaseMutipleView.chaseMultiple integerValue] ofLotteryName:self.lotteryGameEn];
    
    [[CLATBetCache shareCache] setPeriod:[self.chaseMutipleView.chasePeriod integerValue] ofLotteryName:self.lotteryGameEn];
    
    [self.detailFooterView assignBetNote:[[CLATBetCache shareCache] getNoteNumberWithLotteryName:self.lotteryGameEn] period:[self.chaseMutipleView.chasePeriod integerValue] multiple:[self.chaseMutipleView.chaseMultiple integerValue]];
}

#pragma mark - 监听键盘事件后动画
- (void)keyboardAnimationWithNoti:(NSNotification *)noti isHidden:(BOOL)isHidden{
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//动画时间
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];//动画曲线
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger height = isHidden ? 0 : - keyboardRect.size.height;
    [self.detailFooterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(height);
        make.height.mas_equalTo(__SCALE(49));
        make.left.right.equalTo(self.view);
    }];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    [self.view layoutIfNeeded];
    self.baffleView.hidden = isHidden;
    // commit animations
    [UIView commitAnimations];
}


#pragma mark ------------ private Mothed ------------

- (void)p_addSubViews
{
    [self.view addSubview:self.tableViewHeaderImageView];
    [self.view addSubview:self.tableImageEmptyView];
    [self.view addSubview:self.tableImageShadowView];
    
    [self.view addSubview:self.betDetailHeaderView];
    [self.view addSubview:self.topView];
    
    [self.view addSubview:self.mainTableView];
    
    [self.view addSubview:self.baffleView];
    [self.view addSubview:self.chaseMutipleView];
    [self.view addSubview:self.detailFooterView];
    [self.mainTableView.layer addSublayer:self.whiteLayer];
    self.mainTableView.tableFooterView = self.tableFooterView;
}

- (void)p_configConstraint
{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.view);
    }];
    
    [self.tableViewHeaderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view).offset(__SCALE(10.f));
        make.right.equalTo(self.view).offset(__SCALE(- 10.f));
        make.height.mas_equalTo(__SCALE(13.f));
    }];
    
    [self.tableImageShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.tableViewHeaderImageView);
    }];
    [self.tableImageEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableViewHeaderImageView.mas_top).offset(__SCALE(5.f));
        make.left.equalTo(self.tableViewHeaderImageView).offset(__SCALE(8.f));
        make.right.equalTo(self.tableViewHeaderImageView).offset(__SCALE(- 8.f));
        make.height.mas_equalTo(__SCALE(11));
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tableImageEmptyView);
        make.top.equalTo(self.tableImageEmptyView.mas_bottom).offset(-.5f);
        make.bottom.equalTo(self.chaseMutipleView.mas_top);
    }];
    [self.detailFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(kDevice_Is_iPhoneX ? 69.f : 49.f));
    }];
    [self.chaseMutipleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.detailFooterView.mas_top);
    }];
    [self.baffleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark ------- lazyLoad -------
- (CLDElevenBetHeaderView *)betDetailHeaderView{
    
    if (!_betDetailHeaderView) {
        _betDetailHeaderView = [[CLDElevenBetHeaderView alloc] initWithFrame:CGRectZero];
        _betDetailHeaderView.arrowImage = nil;
        _betDetailHeaderView.gameEn = self.lotteryGameEn;
        
        _betDetailHeaderView.hidden = YES;
    }
    return _betDetailHeaderView;
}

- (CLBetDetailsTopView *)topView
{
    WS(_weakSelf)
    if (_topView == nil) {
        
        _topView = [[CLBetDetailsTopView alloc] initWithFrame:(CGRectZero)];
        
        [_topView returnOptionalButtonBlock:^{
            
            [_weakSelf optionalButtonOnClick];
        }];
        
        [_topView returnRandomButtonBlock:^{
            
            [_weakSelf randomButtonOnClick];
        }];
        
        [_topView returnClearButtonBlock:^{
            
            [_weakSelf clearButtonOnClick];
        }];
    }
    return _topView;
}


- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 200;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = CLEARCOLOR;
    }
    return _mainTableView;
}

- (UIImageView *)tableViewHeaderImageView{
    
    if (!_tableViewHeaderImageView) {
        _tableViewHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tableViewHeaderImageView.image = [UIImage imageNamed:@"lotteryCreateTicket.png"];
        _tableViewHeaderImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tableViewHeaderImageView;
}
- (UIImageView *)tableImageEmptyView{
    
    if (!_tableImageEmptyView) {
        _tableImageEmptyView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tableImageEmptyView.contentMode = UIViewContentModeScaleAspectFill;
        _tableImageEmptyView.clipsToBounds = YES;
        _tableImageEmptyView.image = [UIImage imageNamed:@"lotteryCreateTicketEmpty.png"];
    }
    return _tableImageEmptyView;
}
- (UIImageView *)tableImageShadowView{
    
    if (!_tableImageShadowView) {
        _tableImageShadowView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tableImageShadowView.contentMode = UIViewContentModeScaleAspectFit;
        _tableImageShadowView.image = [UIImage imageNamed:@"lotteryCreateTickShadow.png"];
    }
    return _tableImageShadowView;
}
- (UIView *)baffleView{
    
    if (!_baffleView) {
        _baffleView = [[UIView alloc] initWithFrame:CGRectZero];
        _baffleView.backgroundColor = UIColorFromRGBandAlpha(0x333333, 0.75);
        _baffleView.hidden = YES;
        UITapGestureRecognizer *tapBaffleView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBaffleViewOnClick:)];
        [_baffleView addGestureRecognizer:tapBaffleView];
    }
    return _baffleView;
}
- (CLDEBetDetailFooterView *)detailFooterView{
    
    WS(_weakSelf)
    if (!_detailFooterView) {
        _detailFooterView = [[CLDEBetDetailFooterView alloc] initWithFrame:CGRectZero];
        _detailFooterView.payButtonClickBlock = ^(){
            
            [_weakSelf payButtonOnClick];
        };
        _detailFooterView.clearButtonClickBlock = ^(){
            
            [_weakSelf clearButtonOnClick];
        };
        _detailFooterView.chaseButtonClickBlock = ^(){
            
            [_weakSelf randomButtonOnClick];
        };
    }
    return _detailFooterView;
}
- (CLLotteryChaseMultipleView *)chaseMutipleView{
    
    if (!_chaseMutipleView) {
        _chaseMutipleView = [[CLLotteryChaseMultipleView alloc] initWithFrame:CGRectZero];
        _chaseMutipleView.backgroundColor = UIColorFromRGB(0xffffff);
        _chaseMutipleView.buyLabel.textColor = UIColorFromRGB(0x333333);
        _chaseMutipleView.periodLabel.textColor = UIColorFromRGB(0x333333);
        _chaseMutipleView.betLabel.textColor = UIColorFromRGB(0x333333);
        _chaseMutipleView.multipleLabel.textColor = UIColorFromRGB(0x333333);
        _chaseMutipleView.multipleTextField.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
        _chaseMutipleView.multipleTextField.layer.borderWidth = .5f;
        _chaseMutipleView.multipleTextField.backgroundColor = UIColorFromRGB(0xffffff);
        _chaseMutipleView.periodTextField.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
        _chaseMutipleView.periodTextField.layer.borderWidth = .5f;
        _chaseMutipleView.periodTextField.backgroundColor = UIColorFromRGB(0xffffff);
        
        _chaseMutipleView.chaseLeftLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        _chaseMutipleView.chaseRightLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        _chaseMutipleView.bottomLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        _chaseMutipleView.awardTopLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [_chaseMutipleView.awardButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        [_chaseMutipleView.chaseTenButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_chaseMutipleView.chaseTenButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_chaseMutipleView.chaseTwentyButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_chaseMutipleView.chaseTwentyButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        
        [_chaseMutipleView.chaseMoreButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_chaseMutipleView.chaseMoreButton setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [_chaseMutipleView.chaseMoreButton setTitle:@"追1期(一天)" forState:(UIControlStateNormal)];
        
        _chaseMutipleView.gameEn = self.lotteryGameEn;
    }
    return _chaseMutipleView;
}
- (CALayer *)whiteLayer{
    
    if (!_whiteLayer) {
        _whiteLayer = [[CALayer alloc] init];
        _whiteLayer.backgroundColor = UIColorFromRGB(0xffffff).CGColor;
    }
    return _whiteLayer;
}
- (CLDEDetailTableFooterView *)tableFooterView{
    
    if (!_tableFooterView) {
        _tableFooterView = [[CLDEDetailTableFooterView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH - __SCALE(20.f), __SCALE(40.f))];
    }
    return _tableFooterView;
}
- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}


- (UIButton *)backButton{
    
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_backButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(navBackButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (CLAlertController *)actionSheet{
    
    if (!_actionSheet) {
        _actionSheet = [CLAlertController alertControllerWithTitle:nil message:nil style:CLAlertControllerStyleActionSheet delegate:self];
        _actionSheet.buttonItems = @[@"取消", @"清除", @"保存"];
        _actionSheet.destructiveButtonIndex = 1;
    }
    return _actionSheet;
}
- (CLLotteryDetailTableFooterView *)emptyTableFooterView{
    
    if (!_emptyTableFooterView) {
        _emptyTableFooterView = [[CLLotteryDetailTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(60.f))];
    }
    return _emptyTableFooterView;
}
- (CLAlertController *)allClearAlert{
    
    if (!_allClearAlert) {
        _allClearAlert = [CLAlertController alertControllerWithTitle:@"清空" message:@"您确定要清空当前的投注内容么？" style:CLAlertControllerStyleAlert delegate:self];
        _allClearAlert.buttonItems = @[@"取消", @"确定"];
    }
    return _allClearAlert;
}

- (CLATCreateOrderRequset *)createOreder
{
    
    if (_createOreder == nil) {
        
        _createOreder = [[CLATCreateOrderRequset alloc] init];
        
        _createOreder.delegate = self;
    }
    return _createOreder;
}

- (CLLotteryChaseOrderRequest *)createChaseOrder
{

    if (_createChaseOrder == nil) {
        
        _createChaseOrder = [[CLLotteryChaseOrderRequest alloc] init];
        
        _createChaseOrder.delegate = self;
    }
    return _createChaseOrder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
