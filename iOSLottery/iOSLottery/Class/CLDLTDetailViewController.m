//
//  CLDLTDetailViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTDetailViewController.h"
#import "CLDLTViewController.h"
#import "UINavigationController+CLDestroyCurrentController.h"
//全局缓存
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryPeriodModel.h"
#import "CLLotteryAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLTools.h"
#import "CLLotteryBetDetailPeriodModel.h"
//头部截止时间View
#import "CLDElevenBetHeaderView.h"
//底部视图
#import "CLDEBetDetailFooterView.h"
//主视图的cell
#import "CLSSQDetailCell.h"
#import "CLDEDetailTableFooterView.h"
//获取数据
#import "CLDLTDetailManager.h"
//期次和倍数
#import "CLLotteryChaseMultipleView.h"
//请求
#import "CLLotteryPeriodRequest.h"
#import "CLCreateOrderRequestHandler.h"

#import "CLLotteryDataManager.h"
#import "CLAlertController.h"

#import "CKNewPayViewController.h"
#import "CLCheckProgessManager.h"
#import "CLAppContext.h"
#import "CLLotteryDetailTableFooterView.h"
#import "CLJumpLotteryManager.h"
#import "UIImageView+CQWebImage.h"
#import "CLLotteryActivitiesModel.h"

#import "CLEndBetGuideView.h"

#import "CLBetDetailsTopView.h"

@interface CLDLTDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CLRequestCallBackDelegate, CLCreateOrderDelegate, CLAlertControllerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源

/**
 顶部按钮View
 */
@property (nonatomic, strong) CLBetDetailsTopView *topView;

@property (nonatomic, strong) UIImageView *tableViewHeaderImageView;//tableView上的头部 imageView
@property (nonatomic, strong) UIImageView *tableImageEmptyView;//白色
@property (nonatomic, strong) UIImageView *tableImageShadowView;//阴影

@property (nonatomic, strong) CLDEBetDetailFooterView *detailFooterView;//底部视图
@property (nonatomic, strong) CALayer *whiteLayer;//tableView下拉时的白色
@property (nonatomic, strong) CLDEDetailTableFooterView *tableFooterView;//tableview的底部视图
@property (nonatomic, strong) CLLotteryChaseMultipleView *chaseMutipleView;//期数和倍数
@property (nonatomic, strong) UIView *baffleView;//蒙版
@property (nonatomic, strong) CLLotteryPeriodRequest *request;//请求
@property (nonatomic, strong) CLCreateOrderRequestHandler *de_createOrderHandler;//创建订单请求
@property (nonatomic, strong) CLAlertController *alertController;//
@property (nonatomic, strong) NSString *lotteryGameEn;
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) CLAlertController *actionSheet;//保存弹窗
@property (nonatomic, strong) CLLotteryDetailTableFooterView *emptyTableFooterView;
@property (nonatomic, strong) CLAlertController *allClearAlert;//清空按钮弹窗
@property (nonatomic, strong) CLEndBetGuideView *endBetGuideView;//截止View

@end

@implementation CLDLTDetailViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.lotteryGameEn = params[@"gameEn"];
    }
    return self;
}
- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    //从后台进入前台
    [self.request start];
    [self getData];
    [self assignFooterViewData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.request start];
    [self addKeyBoardNotification];
    [self addPeriodCutDownNotification];
    [self assignFooterViewData];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self getData];
}
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
    [self.view addSubview:self.tableViewHeaderImageView];
    [self.view addSubview:self.tableImageEmptyView];
    [self.view addSubview:self.tableImageShadowView];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainTableView];
    
    [self.view addSubview:self.baffleView];
    [self.view addSubview:self.chaseMutipleView];
    [self.view addSubview:self.detailFooterView];
    [self.mainTableView.layer addSublayer:self.whiteLayer];
    self.mainTableView.tableFooterView = self.tableFooterView;
    [self configConstraint];
    [self getData];
    //添加返回按钮
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.whiteLayer.frame = __Rect(0, - SCREEN_HEIGHT, self.mainTableView.frame.size.width, SCREEN_HEIGHT);
}
#pragma mark ------------ create Delegate ------------
- (void)requestFinishWithOrderInfo:(id)OrderInfo{
    
    NSLog(@"%@", OrderInfo);
    NSDictionary *retInfo = OrderInfo;
    if (!(retInfo && retInfo.count > 0)) return;
    
    if ([retInfo[@"isBetAvailable"] integerValue] == 0) {
        
        self.endBetGuideView = [[CLEndBetGuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.endBetGuideView.type = (((NSString *)retInfo[@"saleInfo"]).length > 0) ? CLEndBetGuideTypeEnd : CLEndBetGuideTypeNoSale;
        self.endBetGuideView.title = retInfo[@"saleInfo"];
        self.endBetGuideView.jumpButtonTitle = retInfo[@"buttonTips"];
        self.endBetGuideView.desText = retInfo[@"message"];
        WS(_weakSelf)
        self.endBetGuideView.jumpLotteryBlock = ^{
          
            if (retInfo[@"gameEn"] && ((NSString *)retInfo[@"gameEn"]).length > 0) {
                //跳转其他页面 清空缓存
                [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:_weakSelf.lotteryGameEn];
                [CLJumpLotteryManager jumpLotteryDestoryWithGameEn:retInfo[@"gameEn"] isJudgeCache:YES];
            }
        };
        [self.view.window addSubview:self.endBetGuideView];
        
    }else{
        
        CKNewPayViewController *paymentController = [[CKNewPayViewController alloc] init];
        paymentController.lotteryGameEn = self.lotteryGameEn;
        paymentController.pushType = CKPayPushTypeBet;
        paymentController.period = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentSubPeriod;
        paymentController.periodTime = [[CLLotteryAllInfo shareLotteryAllInfo] getMainRequestDataWithGameEn:self.lotteryGameEn].currentPeriod.saleEndTime;
        if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodWithLottery:self.lotteryGameEn] > 1) {
            //追号
            paymentController.orderType = CKOrderTypeFollow;
        }else{
            //普通订单
            paymentController.orderType = CKOrderTypeNormal;
        }
        paymentController.hidesBottomBarWhenPushed = YES;
        paymentController.payConfigure = OrderInfo;
        [self.navigationController pushDestroyViewController:paymentController animated:YES];
        [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:self.lotteryGameEn];
    }
}

- (void)requestFailWithOrderInfo:(id)OrderInfo{
    
    if (![CLAppContext context].isReachable) {
        [self show:@"当前网络不稳定，请重试"];
        return;
    }
    [self show:OrderInfo];
}
#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (self.request == request) {
        if (!request.urlResponse.resp || !request.urlResponse.success){
            [self.request start];
            return;
        }
        
        CLLotteryBetDetailPeriodModel *model = [CLLotteryBetDetailPeriodModel mj_objectWithKeyValues:request.urlResponse.resp];
        [CLLotteryDataManager storeCurrentPeriod:model.currentPeriod currentSubPeriod:model.subPeriod gameEn:self.lotteryGameEn];
        
        NSString *addText = model.activityMap.activityTips;
        NSString *addColor = model.activityMap.activityTipsType;
        NSString *activityIconUrl = model.activityMap.activityIconUrl;
        self.chaseMutipleView.additionalInfoLabel.text = addText ? addText : @"";
        self.chaseMutipleView.additionalInfoLabel.textColor = addColor ? UIColorFromStr(addColor) : UIColorFromRGB(0x999999);
        [self.chaseMutipleView.additionalImageView setImageWithURL:[NSURL URLWithString:activityIconUrl]];
        
        [self de_changePeriodInBetInfoWithPeriod:[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId];
    }
}
#pragma mark ------------ uitableview delegate ------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS(_weakSelf)
    static NSString *cellId = @"CLDLTDetailCell";
    CLSSQDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CLSSQDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    [cell assignBetDetailCellWithData:self.dataSourceArray[indexPath.row]];
    __weak CLSSQDetailCell *weakCell = cell;
    cell.deleteCellBlock = ^(){
        
        [_weakSelf deleteCellWithIndex:[tableView indexPathForCell:weakCell]];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [CLDLTViewController presentSSQViewControllerWithInitialVC:self selectedIndex:self.dataSourceArray.count - indexPath.row - 1 isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:^{
        
    }];
}
#pragma mark ------------ alert delegate ------------
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (self.alertController == alertController) {
        if (index == 1) {
            [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId lottery:self.lotteryGameEn];
            
            [self.de_createOrderHandler createOrderRequestWithType:self.lotteryGameEn];
        }
        
    }else if (self.actionSheet == alertController){
        
        if (index == 1) {
            //清空操作
            [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:self.lotteryGameEn];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (index == 2){
            //保存
            //只保存投注号码，不保存投注期次
            [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:@"" lottery:self.lotteryGameEn];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.allClearAlert == alertController){
        
        if (index == 1) {
            [self clearAll];
        }
    }
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(self.view);
        
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
        make.height.mas_equalTo(__SCALE(kDevice_Is_iPhoneX ? 69 : 49));
    }];
    [self.chaseMutipleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.detailFooterView.mas_top);
    }];
    [self.baffleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark - 获取数据
- (void)getData{
    
    CLDLTDetailManager *dataManager = [[CLDLTDetailManager alloc] init];
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:[dataManager getBetDetailModelWithGameEn:self.lotteryGameEn]];
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    [self.mainTableView reloadData];
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
#pragma mark - 添加倒计时通知
- (void)addPeriodCutDownNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(periodCutDown:) name:GlobalTimerRuning object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(periodEnd:) name:self.lotteryGameEn object:nil];
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
#pragma mark - 配置底部View的数据
- (void)assignFooterViewData{
    
    NSInteger note = [[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn];
    NSInteger period = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodWithLottery:self.lotteryGameEn];
    NSInteger mul = [[CLNewLotteryBetInfo shareLotteryBetInfo] getMultipleWithLottery:self.lotteryGameEn];
    
    self.chaseMutipleView.periodTextField.text = [NSString stringWithFormat:@"%zi", period];;
    self.chaseMutipleView.multipleTextField.text = [NSString stringWithFormat:@"%zi", mul];
    self.chaseMutipleView.setAdditional = [[CLNewLotteryBetInfo shareLotteryBetInfo] getIsAdditionalWithLottery:self.lotteryGameEn];
    
    
    [self.detailFooterView assignBetNote:note period:period multiple:mul money:note * period * mul * ([[CLNewLotteryBetInfo shareLotteryBetInfo] getIsAdditionalWithLottery:self.lotteryGameEn] ? 3 : 2)];
}
#pragma mark ------------ event Response ------------
#pragma mark - 返回按钮
- (void)navBackButtonOnClick:(UIButton *)btn{
    //如果有投注项则提示，没有则直接返回
    if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn] > 0) {
        
        [self.actionSheet show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
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
    [[CLNewLotteryBetInfo shareLotteryBetInfo] randomAddOneBetInfoWithLottery:self.lotteryGameEn];
    //获取数据
    CLDLTDetailManager *dataManager = [[CLDLTDetailManager alloc] init];
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:[dataManager getBetDetailModelWithGameEn:self.lotteryGameEn]];
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.mainTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self assignFooterViewData];
}
#pragma mark - 清空列表
- (void)clearButtonOnClick
{
    if (self.dataSourceArray.count == 0) return;
    
    [self.allClearAlert show];
    
}
#pragma mark - 清空所有
- (void)clearAll{
    
    [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:self.lotteryGameEn];
    //获取数据
    [self getData];
    [self assignFooterViewData];
}
#pragma mark - 删除一行
- (void)deleteCellWithIndex:(NSIndexPath *)index{
    
    [self.dataSourceArray removeObjectAtIndex:index.row];
    [self.mainTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteOneBetInfoWithIndex:(self.dataSourceArray.count - index.row) lottery:self.lotteryGameEn];
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    [self assignFooterViewData];
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
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setMultiple:[self.chaseMutipleView.chaseMultiple integerValue] lottery:self.lotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriod:[self.chaseMutipleView.chasePeriod integerValue] lottery:self.lotteryGameEn];
    
    NSInteger note = [[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn];
    NSInteger period = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodWithLottery:self.lotteryGameEn];
    NSInteger mul = [[CLNewLotteryBetInfo shareLotteryBetInfo] getMultipleWithLottery:self.lotteryGameEn];
    [self.detailFooterView assignBetNote:note period:period multiple:mul money:note * period * mul * ([[CLNewLotteryBetInfo shareLotteryBetInfo] getIsAdditionalWithLottery:self.lotteryGameEn] ? 3 : 2)];
}
#pragma mark - 点击了蒙版
- (void)tapBaffleViewOnClick:(UITapGestureRecognizer *)tap{
    
    //失去第一响应
    [self.chaseMutipleView lotteryChaseMultipleViewResignResponse];
}
#pragma mark - 期次倒计时事件
- (void)periodCutDown:(NSNotification *)noti{
    
    CLLotteryPeriodModel *periodModel = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn];
    if (!(periodModel.periodId && periodModel.periodId.length > 0)) {
        [self.request start];
    }
//    [self.betDetailHeaderView assigBetHeaderCurrentPeriodWithData:[CLDEDataManager getAllInfoDataGameEn:self.lotteryGameEn]];
}
#pragma mark - 倒计时截止
- (void)periodEnd:(NSNotification *)noti{
    
    [self.request start];
}
#pragma mark - 点击了付款按钮
- (void)payButtonOnClick{
    
    WS(_weakSelf)
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        [_weakSelf confirmPay];
    }];
}

- (void)confirmPay{
    
    NSString *period = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn];
    if (!(period && period.length > 0)) {
        [self show:@"当前期次已截止，请等待下期"];
        return;
    }
    CLNewLotteryBetInfo *betInfo = [CLNewLotteryBetInfo shareLotteryBetInfo];
    
    if ([betInfo getAllNoteWithLottery:self.lotteryGameEn] < 1) {
        [self show:@"请至少投一注"];
        return;
    }
    
    [betInfo setFollowMode:self.chaseMutipleView.isStopChase ? @"1" : @"0" lottery:self.lotteryGameEn];
    [betInfo setFollowType:@"0" lottery:self.lotteryGameEn];
    //判断当前期次与存储期次是否一致，一致则直接支付，不一致 弹窗提示
    if (![[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId isEqualToString:[[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn]]) {
        
        NSString *alertTitle = @"期次改变提示";
        NSString *alertTitleContent = [NSString stringWithFormat:@"第%@期已截止，当前是%@期，确定继续投注？" , [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn] , [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId];
        
        self.alertController = [CLAlertController alertControllerWithTitle:alertTitle message:alertTitleContent style:CLAlertControllerStyleAlert delegate:self];
        self.alertController.buttonItems = @[@"取消", @"确定"];
        [self.alertController show];
        
    }else{
        
        [self.de_createOrderHandler createOrderRequestWithType:self.lotteryGameEn];
    }
}
#pragma mark -  period 改变
- (void)de_changePeriodInBetInfoWithPeriod:(NSString *)period{
    
    NSString *lastPeriod = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn];
    
    if (lastPeriod && lastPeriod.length > 0) {
        
        if ([period isEqualToString:lastPeriod]) return;
        
        NSString *showHUD = [NSString stringWithFormat:@"当前期次已修改为：%@", period];
        [self show:showHUD];
    }else{
        //没有期次 直接保存
        [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:period lottery:self.lotteryGameEn];
        [[CLNewLotteryBetInfo shareLotteryBetInfo] setGameId:[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].gameId lottery:self.lotteryGameEn];
    }
}
#pragma mark ------------ getter Mothed ------------
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 200;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = CLEARCOLOR;
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, __SCALE(25.f), 0);
    }
    return _mainTableView;
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
        _chaseMutipleView.gameEn = self.lotteryGameEn;
        WS(_weakSelf)
        _chaseMutipleView.additionalOnClickBlock = ^(BOOL isAdd){
            
            [[CLNewLotteryBetInfo shareLotteryBetInfo] setIsAdditional:isAdd lottery:_weakSelf.lotteryGameEn];
            [_weakSelf getData];
            [_weakSelf assignFooterViewData];
        };
        _chaseMutipleView.isShowAdditional = YES;
        _chaseMutipleView.additionalImageViewHidden = ^(BOOL isHidden){
            
            _weakSelf.mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        };
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
- (CLLotteryPeriodRequest *)request{
    
    if (!_request) {
        _request = [[CLLotteryPeriodRequest alloc] init];
        _request.gameEn = self.lotteryGameEn;
        _request.delegate = self;
    }
    return _request;
}
- (CLCreateOrderRequestHandler *)de_createOrderHandler{
    
    if (!_de_createOrderHandler) {
        _de_createOrderHandler = [[CLCreateOrderRequestHandler alloc] init];
        _de_createOrderHandler.delegate = self;
    }
    return _de_createOrderHandler;
}

- (UIButton *)backButton{
    
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -18, 0, 0)];
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
