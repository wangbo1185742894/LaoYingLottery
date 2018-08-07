//
//  CLFTBetDetailViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetDetailViewController.h"
#import "CLConfigMessage.h"
#import "UINavigationController+CLDestroyCurrentController.h"
//cell
#import "CLFTBetDetailTableViewCell.h"
//tableView footer
#import "CLBetDetailTableFooterView.h"
//viewController footer
#import "CLFTBetDetailFooterView.h"
//期次和倍数
#import "CLLotteryChaseMultipleView.h"
//数据
#import "CLFTBetDetailDataManager.h"
#import "CLLotteryBetDetailPeriodModel.h"
//全局缓存
#import "CLNewLotteryBetInfo.h"
#import "CLLotteryAllInfo.h"
#import "CLLotteryMainBetModel.h"
#import "CLTools.h"
#import "CLLotteryDataManager.h"
#import "CLLotteryPeriodModel.h"
//
#import "CLFastThreeViewController.h"
//请求
#import "CLLotteryPeriodRequest.h"
//创建订单请求
#import "CLCreateOrderRequestHandler.h"
//引用弹窗
#import "CLAlertController.h"
//支付
#import "CKNewPayViewController.h"
#import "CLAppContext.h"
#import "CLAllJumpManager.h"
//校验付款流程
#import "CLCheckProgessManager.h"
#import "CLLotteryDetailTableFooterView.h"

#import "CLJumpLotteryManager.h"
#import "CLEndBetGuideView.h"
@interface CLFTBetDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CLCreateOrderDelegate, CLRequestCallBackDelegate, CLAlertControllerDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *timeLabel;//倒计时label

@property (nonatomic, strong) UIButton *optionalButton;//自选按钮
@property (nonatomic, strong) UIButton * randomButton;//随机按钮
@property (nonatomic, strong) UIButton *clearButton;//清空列表按钮
@property (nonatomic, strong) UIImageView *tableImageView;//tableView 上的图片
@property (nonatomic, strong) UIImageView *tableImageEmptyView;//白色
@property (nonatomic, strong) UIImageView *tableImageShadowView;//阴影


@property (nonatomic, strong) NSMutableArray *dataSourceArray;//tableview 数据
@property (nonatomic, strong) CLFTBetDetailFooterView *footerView;//底部view
@property (nonatomic, strong) CLLotteryChaseMultipleView *chaseMutipleView;//选期次和倍数
@property (nonatomic, strong) CALayer *whiteLayer; // tableView 下拉的空白
@property (nonatomic, strong) CLBetDetailTableFooterView *tableFooterView;//tableview footer
@property (nonatomic, strong) UIView *baffleView;//蒙版
@property (nonatomic, strong) CLLotteryPeriodRequest *ft_request;//请求
@property (nonatomic, strong) CLCreateOrderRequestHandler *ft_createOrderHandler;
@property (nonatomic, strong) CLAlertController *alertController;//保存弹窗
@property (nonatomic, strong) NSString *lotteryGameEn;
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) CLAlertController *actionSheet;//保存弹窗
@property (nonatomic, strong) CLLotteryDetailTableFooterView *emptyTableFooterView;
@property (nonatomic, strong) CLAlertController *allClearAlert;//清空按钮弹窗
@property (nonatomic, strong) CLEndBetGuideView *endBetGuideView;

@end

@implementation CLFTBetDetailViewController
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.lotteryGameEn = params[@"gameEn"];
    }
    return self;
}
- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    //从后台进入前台
    [self.ft_request start];
    [self getTableViewData];
    [self assignFooterViewData];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //添加键盘监听
    [self addKeyBoardNotification];
    //添加倒计时监听
    [self addPeriodCutDownNotifiation];
    //获取数据
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x000000);
    
    [self assignFooterViewData];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self getTableViewData];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = [[CLAppContext context] getGameNameWithGameEn:self.lotteryGameEn];
    self.pageStatisticsName = self.lotteryGameEn;//防止没取到gameName,友盟依然可以统计到
    //防止tableview 底部空白 或 顶部空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.tableImageView];
    [self.view addSubview:self.tableImageEmptyView];
    [self.view addSubview:self.tableImageShadowView];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.periodLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.optionalButton];
    [self.view addSubview:self.randomButton];
    [self.view addSubview:self.clearButton];
    [self.view addSubview:self.baffleView];
    [self.view addSubview:self.footerView];
    [self.view addSubview:self.chaseMutipleView];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.mainTableView.layer addSublayer:self.whiteLayer];
    self.mainTableView.tableFooterView = self.tableFooterView;
    self.view.backgroundColor = UIColorFromRGB(0x339966);
    [self configConstraint];
    
    [self getTableViewData];
    //添加返回按钮
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.backButton]];
    
    [self.ft_request start];
    // Do any additional setup after loading the view.
}
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.whiteLayer.frame = __Rect(0, - SCREEN_HEIGHT, self.mainTableView.frame.size.width, SCREEN_HEIGHT);
}
#pragma mark ------------ create Delegate ------------
- (void)requestFinishWithOrderInfo:(id)OrderInfo{
    
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
        //清空投注项
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
#pragma mark ------------ request Delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (self.ft_request == request) {
        //存缓存
        if (!request.urlResponse.resp || !request.urlResponse.success) {
            
            [self.ft_request start];
            return;
        }
        CLLotteryBetDetailPeriodModel *betDetailPeriodmodel = [CLLotteryBetDetailPeriodModel mj_objectWithKeyValues:request.urlResponse.resp];
        self.navTitleText = betDetailPeriodmodel.currentPeriod.gameName;
        //缓存数据
        [CLLotteryDataManager storeCurrentPeriod:betDetailPeriodmodel.currentPeriod currentSubPeriod:betDetailPeriodmodel.subPeriod gameEn:self.lotteryGameEn];
        NSString *period = betDetailPeriodmodel.subPeriod;
        long time = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].saleEndTime;
        if (period && period.length > 0) {
            
            self.periodLabel.text = [NSString stringWithFormat:@"距离%@期截止:", period];
            self.timeLabel.text = [CLTools timeFormatted:time];
        }else{
            self.periodLabel.text = @"未能获取彩期";
            self.timeLabel.text = @"";
        }
        if (![betDetailPeriodmodel.currentPeriod.periodId isEqualToString:[[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn]]) {
            //修改投注项的期次
            [self ft_changePeriodInBetInfoWithPeriod:betDetailPeriodmodel.currentPeriod.periodId];
        }
        
    }
}
#pragma mark ------ tableView delegate ------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(_weakSelf)
    static NSString *cellID = @"BetDetailCell";
    CLFTBetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLFTBetDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell assignBetDetailCellWithData:self.dataSourceArray[self.dataSourceArray.count - indexPath.row - 1]];
    __weak CLFTBetDetailTableViewCell *weakCell = cell;
    cell.deleteCellBlock = ^(){
        
        [_weakSelf deleteCellWithIndex:[tableView indexPathForCell:weakCell]];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [CLFastThreeViewController presentFastThreeViewControllerWithInitialVC:self selectedIndex:(self.dataSourceArray.count - indexPath.row - 1) isSelectBetInfo:YES gameEn:self.lotteryGameEn completion:^{
        
    }];
}

#pragma mark ------------ alert delegate ------------
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (self.alertController == alertController) {
        if (index == 1) {
            
            [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:[CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId lottery:self.lotteryGameEn];
            
            [self.ft_createOrderHandler createOrderRequestWithType:self.lotteryGameEn];
        }
    }else if (self.actionSheet == alertController){
        
        if (index == 1) {
            //清空操作
            [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:self.lotteryGameEn];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if (index == 2){
            //保存
            //只保存号码，不保存期次，  将期次置为@""
            [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:@"" lottery:self.lotteryGameEn];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.allClearAlert == alertController){
        
        if (index == 1) {
        
            [self clearAll];
        }
    }
    
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(__SCALE(- 20.f));
        make.top.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.periodLabel.mas_right).offset(3.f);
        make.width.mas_greaterThanOrEqualTo(__SCALE(40));
        make.centerY.equalTo(self.periodLabel);
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.optionalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(__SCALE(10.f));
        make.top.equalTo(self.periodLabel.mas_bottom);
        make.height.mas_equalTo(__SCALE(30.f));
    }];
    [self.randomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.optionalButton.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.optionalButton);
        make.height.width.equalTo(self.optionalButton);
        
    }];
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.randomButton.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.optionalButton);
        make.height.width.equalTo(self.optionalButton);
        make.right.equalTo(self.view).offset(__SCALE(-10.f));
    }];
    [self.tableImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(__SCALE(10.f));
        make.right.equalTo(self.view).offset(__SCALE(-10.f));
        make.top.equalTo(self.optionalButton.mas_bottom).offset(__SCALE(10.f));
        make.height.mas_equalTo(__SCALE(13.f));
    }];
    [self.tableImageShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.tableImageView);
    }];
    [self.tableImageEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tableImageView.mas_top).offset(__SCALE(5.f));
        make.left.equalTo(self.tableImageView).offset(__SCALE(8.f));
        make.right.equalTo(self.tableImageView).offset(__SCALE(- 8.f));
        make.height.mas_equalTo(__SCALE(11));
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableImageEmptyView.mas_bottom).offset(-1.f);
        make.left.equalTo(self.tableImageEmptyView);
        make.right.equalTo(self.tableImageEmptyView);
        make.bottom.equalTo(self.chaseMutipleView.mas_top);
    }];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(49));
    }];
    [self.chaseMutipleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.footerView.mas_top);
    }];
    [self.baffleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.chaseMutipleView.mas_top);
    }];
}
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
#pragma mark - 添加期次倒计时通知
- (void)addPeriodCutDownNotifiation{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ft_periodCutDown:) name:GlobalTimerRuning object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ft_periodEnd:) name:self.lotteryGameEn object:nil];
}
#pragma mark - 获取tableview数据
- (void)getTableViewData{

    NSArray *tempArray = [NSArray arrayWithArray:self.dataSourceArray];
    CLFTBetDetailDataManager *dataManager = [[CLFTBetDetailDataManager alloc] init];
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:[dataManager getBetDetailModelWithGameEn:self.lotteryGameEn]];
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
- (void)assignFooterViewData{
    
    self.chaseMutipleView.periodTextField.text = [NSString stringWithFormat:@"%zi", [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodWithLottery:self.lotteryGameEn]];;
    self.chaseMutipleView.multipleTextField.text = [NSString stringWithFormat:@"%zi", [[CLNewLotteryBetInfo shareLotteryBetInfo] getMultipleWithLottery:self.lotteryGameEn]];
    [self.footerView assignBetNote:[[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn] period:[[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodWithLottery:self.lotteryGameEn] multiple:[[CLNewLotteryBetInfo shareLotteryBetInfo] getMultipleWithLottery:self.lotteryGameEn]];
}
#pragma mark ------ event Response ------
#pragma mark - 返回按钮
- (void)navBackButtonOnClick:(UIButton *)btn{
    //如果有投注项则提示，没有则直接返回
    if ([[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn] > 0) {
        
        [self.actionSheet show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - 键盘出现
- (void)keyboardWillShow:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:NO];
}
#pragma mark - 键盘消失
- (void)keyboardWillHide:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:YES];
}
#pragma mark - textfield值改变
- (void)textFieldChange{
    
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setMultiple:[self.chaseMutipleView.chaseMultiple integerValue] lottery:self.lotteryGameEn];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriod:[self.chaseMutipleView.chasePeriod integerValue] lottery:self.lotteryGameEn];
    [self.footerView assignBetNote:[[CLNewLotteryBetInfo shareLotteryBetInfo] getAllNoteWithLottery:self.lotteryGameEn] period:[self.chaseMutipleView.chasePeriod integerValue] multiple:[self.chaseMutipleView.chaseMultiple integerValue]];
}
- (void)keyboardAnimationWithNoti:(NSNotification *)noti isHidden:(BOOL)isHidden{
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//动画时间
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];//动画曲线
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger height = isHidden ? 0 : - keyboardRect.size.height;
    [self.footerView mas_remakeConstraints:^(MASConstraintMaker *make) {
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
#pragma mark - 自选事件
- (void)optionalButtonOnClick:(UIButton *)btn{
    
    [CLJumpLotteryManager jumpLotteryWithGameEn:self.lotteryGameEn isJudgeCache:NO];
}
#pragma mark - 机选事件
- (void)randomButtonOnClick:(UIButton *)btn{
    
    [CLTools vibrate];
    //机选一注
    [[CLNewLotteryBetInfo shareLotteryBetInfo] randomAddOneBetInfoWithLottery:self.lotteryGameEn];
    //获取数据
    CLFTBetDetailDataManager *dataManager = [[CLFTBetDetailDataManager alloc] init];
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:[dataManager getBetDetailModelWithGameEn:self.lotteryGameEn]];
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
- (void)clearButtonOnClick:(UIButton *)btn{
    
    if (self.dataSourceArray.count == 0) return;
    
    [self.allClearAlert show];
}
#pragma mark - 清空所有
- (void)clearAll{
    
    [self.dataSourceArray removeAllObjects];
    [[CLNewLotteryBetInfo shareLotteryBetInfo] deleteAllBetInfoWithLottery:self.lotteryGameEn];
    if (self.dataSourceArray.count == 0) {
        self.mainTableView.tableFooterView = self.emptyTableFooterView;
    }else{
        self.mainTableView.tableFooterView = self.tableFooterView;
    }
    [self.mainTableView reloadData];
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
#pragma mark - 点击了蒙版
- (void)tapBaffleViewOnClick:(UITapGestureRecognizer *)tap{
    
    //失去第一响应
    [self.chaseMutipleView lotteryChaseMultipleViewResignResponse];
}
#pragma mark - 点击了付款
- (void)payButtonOnClick{
    
    WS(_weakSelf)
    //判断是否登录
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        [_weakSelf confirmPay];
    }];
}

- (void)confirmPay{
    
    //投注详情中的期次信息
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
        
        NSString *alertTitleContent = [NSString stringWithFormat:@"第%@期已截止，当前是%@期，确定继续投注？", [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn] , [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId];
        
        self.alertController = [CLAlertController alertControllerWithTitle:@"" message:alertTitleContent style:CLAlertControllerStyleAlert delegate:self];
        self.alertController.buttonItems = @[@"取消", @"确定"];
        [self.alertController show];
        
    }else{
        
        [self.ft_createOrderHandler createOrderRequestWithType:self.lotteryGameEn];
    }

}

#pragma mark - 倒计时正在进行
- (void)ft_periodCutDown:(NSNotification *)noti{
    
    NSString *period = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].periodId;
    if (period && period.length > 0) {
        long time = [CLLotteryDataManager getCurrentPeriodInfoDataGameEn:self.lotteryGameEn].saleEndTime;
        if (time == 0) {
            self.periodLabel.text = [NSString stringWithFormat:@"第%@期已截止",[period substringFromIndex:period.length - 2]];
            self.timeLabel.text = @"";
        }else{
            self.periodLabel.text = [NSString stringWithFormat:@"距离%@期截止:", [period substringFromIndex:period.length - 2]];
            self.timeLabel.text = [CLTools timeFormatted:time];
        }
    }else{
        self.periodLabel.text = @"未能获取彩期";
        self.timeLabel.text = @"";
        [self.ft_request start];
    }
}
#pragma mark - 倒计时结束
- (void)ft_periodEnd:(NSNotification *)noti{
    
    [self.ft_request start];
}
#pragma mark - period 改变
- (void)ft_changePeriodInBetInfoWithPeriod:(NSString *)period{
    
    NSString *storePeriod = [[CLNewLotteryBetInfo shareLotteryBetInfo] getPeriodIdWithLottery:self.lotteryGameEn];
    if ([storePeriod isEqualToString:@""]) {
        //证明是上次保存的号码，不需要弹窗，直接保存
        [[CLNewLotteryBetInfo shareLotteryBetInfo] setPeriodId:period lottery:self.lotteryGameEn];
    }else{
        if ([period isEqualToString:storePeriod]) return;
        NSString *showHUD = [NSString stringWithFormat:@"当前期次已修改为：%@", period];
        [self show:showHUD];
    }
}
#pragma mark ------ getter Mothed ------
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
    }
    return _backgroundImageView;
}
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 200;
        _mainTableView.backgroundColor = CLEARCOLOR;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期次";
        _periodLabel.textColor = UIColorFromRGB(0xffffff);
        _periodLabel.font = FONT_SCALE(13);
    }
    return _periodLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"00:00";
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = UIColorFromRGB(0xffff00);
        _timeLabel.font = FONT_SCALE(13);
    }
    return _timeLabel;
}
- (UIButton *)optionalButton{
    
    if (!_optionalButton) {
        _optionalButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _optionalButton.adjustsImageWhenHighlighted = NO;
        [_optionalButton setTitle:@"自选号码" forState:UIControlStateNormal];
        [_optionalButton setTitleColor:UIColorFromRGB(0x71bb99) forState:UIControlStateNormal];
        _optionalButton.titleLabel.font = FONT_SCALE(14);
        _optionalButton.layer.cornerRadius = 2.f;
        _optionalButton.layer.masksToBounds = YES;
        [_optionalButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .25)] forState:UIControlStateNormal];
        [_optionalButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .4)] forState:UIControlStateHighlighted];
        [_optionalButton setImage:[UIImage imageNamed:@"ft_betDetailAdd.png"] forState:UIControlStateNormal];
        [_optionalButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.f)];
        [_optionalButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, 0)];
        [_optionalButton addTarget:self action:@selector(optionalButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _optionalButton;
}
- (UIButton *)randomButton{
    
    if (!_randomButton) {
        _randomButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_randomButton setTitle:@"机选一注" forState:UIControlStateNormal];
        [_randomButton setTitleColor:UIColorFromRGB(0x71bb99) forState:UIControlStateNormal];
        _randomButton.titleLabel.font = FONT_SCALE(14);
        [_randomButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .25)] forState:UIControlStateNormal];
        [_randomButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .4)] forState:UIControlStateHighlighted];
        _randomButton.layer.cornerRadius = 2.f;
        _randomButton.layer.masksToBounds = YES;
        [_randomButton setImage:[UIImage imageNamed:@"ft_betDetailAdd.png"] forState:UIControlStateNormal];
        _randomButton.adjustsImageWhenHighlighted = NO;
        [_randomButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.f)];
        [_randomButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, 0)];
        [_randomButton addTarget:self action:@selector(randomButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _randomButton;
}
- (UIButton *)clearButton{
    
    if (!_clearButton) {
        _clearButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _clearButton.adjustsImageWhenHighlighted = NO;
        [_clearButton setTitle:@"清空列表" forState:UIControlStateNormal];
        [_clearButton setTitleColor:UIColorFromRGB(0x71bb99) forState:UIControlStateNormal];
        _clearButton.titleLabel.font = FONT_SCALE(14);
        [_clearButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .25)] forState:UIControlStateNormal];
        [_clearButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGBandAlpha(0x000000, .4)] forState:UIControlStateHighlighted];
        _clearButton.layer.cornerRadius = 2.f;
        _clearButton.layer.masksToBounds = YES;
        [_clearButton setImage:[UIImage imageNamed:@"ft_betDetailTrash.png"] forState:UIControlStateNormal];
        [_clearButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10.f)];
        [_clearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, 0)];
        [_clearButton addTarget:self action:@selector(clearButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearButton;
}
- (UIImageView *)tableImageView{
    
    if (!_tableImageView) {
        _tableImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tableImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tableImageView.image = [UIImage imageNamed:@"lotteryCreateTicket.png"];
    }
    return _tableImageView;
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
- (CLFTBetDetailFooterView *)footerView{
    WS(_weakSelf)
    if (!_footerView) {
        _footerView = [[CLFTBetDetailFooterView alloc] initWithFrame:CGRectZero];
        _footerView.payButtonClickBlock = ^(){
            
            [_weakSelf payButtonOnClick];
        };
        _footerView.clearButtonClickBlock = ^(){
            
            [_weakSelf clearButtonOnClick:nil];
        };
        _footerView.chaseButtonClickBlock = ^(){
            [_weakSelf randomButtonOnClick:nil];
        };
    }
    return _footerView;
}
- (CLLotteryChaseMultipleView *)chaseMutipleView{
    
    if (!_chaseMutipleView) {
        _chaseMutipleView = [[CLLotteryChaseMultipleView alloc] initWithFrame:CGRectZero];
        _chaseMutipleView.topLineImageView.hidden = YES;
        [_chaseMutipleView.agreeImageButton setImage:[UIImage imageNamed:@"ft_NoCheckRight.png"] forState:UIControlStateNormal];
        [_chaseMutipleView.agreeImageButton setImage:[UIImage imageNamed:@"ft_checkRight.png"] forState:UIControlStateSelected];
        [_chaseMutipleView.questionButton setImage:[UIImage imageNamed:@"ft_betDetailPrompt.png"] forState:UIControlStateNormal];
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
- (CLBetDetailTableFooterView *)tableFooterView{
    
    if (!_tableFooterView) {
        _tableFooterView = [[CLBetDetailTableFooterView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH - __SCALE(20.f), __SCALE(40.f))];
    }
    return _tableFooterView;
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
- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}
- (CLLotteryPeriodRequest *)ft_request{
    
    if (!_ft_request) {
        _ft_request = [[CLLotteryPeriodRequest alloc] init];
        _ft_request.gameEn = self.lotteryGameEn;
        _ft_request.delegate = self;
    }
    return _ft_request;
}
- (CLCreateOrderRequestHandler *)ft_createOrderHandler{
    
    if (!_ft_createOrderHandler) {
        _ft_createOrderHandler = [[CLCreateOrderRequestHandler alloc] init];
        _ft_createOrderHandler.delegate = self;
    }
    return _ft_createOrderHandler;
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
- (CLAlertController *)allClearAlert{
    
    if (!_allClearAlert) {
        _allClearAlert = [CLAlertController alertControllerWithTitle:@"清空" message:@"您确定要清空当前的投注内容么？" style:CLAlertControllerStyleAlert delegate:self];
        _allClearAlert.buttonItems = @[@"取消", @"确定"];
    }
    return _allClearAlert;
}
- (CLLotteryDetailTableFooterView *)emptyTableFooterView{
    
    if (!_emptyTableFooterView) {
        _emptyTableFooterView = [[CLLotteryDetailTableFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(60.f))];
    }
    return _emptyTableFooterView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
