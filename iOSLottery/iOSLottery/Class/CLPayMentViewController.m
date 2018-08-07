//
//  CLPayMentViewController.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPayMentViewController.h"
#import "UINavigationItem+CLNavigationCustom.h"
#import "UINavigationController+CLDestroyCurrentController.h"
/** Controller */
#import "CLPaymentSelectedRedViewController.h"
/** Model */
#import "CLPaymentChannelInfo.h"
#import "CLQuickRedPacketsModel.h"
#import "CLUserPayAccountInfo.h"
#import "CLAccountInfoModel.h"
#import "CLUserPaymentInfo.h"
/** Public */
#import "CLPayMentService.h"
#import "UIImageView+CQWebImage.h"
/** API */
#import "CLPayMentIPA.h"
/** QuickView */
#import "CLQuickBetHomeView.h"
#import "CLQuickBetPaySelectedView.h"
#import "CLQuickBetRedParketsView.h"
/** NormalView */
#import "CLPaymentCell.h"
#import "CLPaymentInfoShowCell.h"

#import "CQLotteryPaySource.h"
#import "CLCheckProgessManager.h"
//放弃支付View
//#import "CLAbandonPayView.h"
//彩票店抢单动画
#import "CLLotteryBespeakService.h"

#import "CLAllJumpManager.h"
//全局缓存
#import "CLTools.h"
#import "CLAlertController.h"
#import "CLJumpLotteryManager.h"
//小额免密
#import "CQFreeOfPayService.h"
//
#import "CLPayCardListViewController.h"
@interface CLPayMentViewController ()<CLRequestCallBackDelegate,UITableViewDelegate,UITableViewDataSource, CLAlertControllerDelegate>
//最上方的倒计时
@property (nonatomic, strong) UIView *timeBaseView;//倒计时基本View
@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *timeLabel;//timeLabel
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CLAlertController *alertController;

/** quickPayMent */
/** view */
@property (nonatomic, strong) UIView *quickContentView;
@property (nonatomic, strong) UIImageView *quickBackIMG;
@property (nonatomic, strong) CLQuickBetHomeView *quickHomeView;
@property (nonatomic, strong) CLQuickBetPaySelectedView *quickPaySelectedView;
@property (nonatomic, strong) CLQuickBetRedParketsView *quickRedSelectedView;
/** modelOrDataSource */
@property (nonatomic, strong) NSMutableArray *quickPayDataSource;
/** configure */
/** API */
@property (nonatomic, strong) CLPayMentIPA* paymentAPI;
/** NormalPayMent */

/** view*/
@property (nonatomic, strong) UITableView *normalTableView;
@property (nonatomic, strong) UIView *normalTableViewFooterView;
@property (nonatomic, strong) UIButton *confirmButton;
/** modelOrDataSource */
@property (nonatomic, strong) NSMutableArray *payChannelArrays;
/** configure */
@property (nonatomic, assign) NSInteger cntAvailPayChannelIndex;

/** publicService */
@property (nonatomic, strong) CLPayMentService *paymentService;
//lotterySource
@property (nonatomic, strong) CQLotteryPaySource *lotterySource;

@property (nonatomic, strong) UIButton *navBackButton;//返回按钮

@property (nonatomic, assign) BOOL isGotoPayBack;//是否是跳出支付后回来

@property (nonatomic, assign) BOOL isAlowShowAlert;//是否允许弹窗

@property (nonatomic, strong) CLAlertController *abandonAlert;
//check 小额免密
@property (nonatomic, strong) CQFreeOfPayService *freeService;

@end

@implementation CLPayMentViewController
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = THEME_COLOR;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAlowShowAlert = YES;
    self.navTitleText = @"支付";
    [self.view addSubview:self.timeBaseView];
    [self.timeBaseView addSubview:self.periodLabel];
    [self.timeBaseView addSubview:self.timeLabel];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.normalTableView];
    [self.view addSubview:self.quickContentView];
    
    self.normalTableView.tableFooterView = self.normalTableViewFooterView;
    
    [self.timeBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(__SCALE(5.f));
        make.centerX.equalTo(self.view);
    }];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timeBaseView);
        make.top.bottom.equalTo(self.timeBaseView);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.periodLabel.mas_right);
        make.right.equalTo(self.timeBaseView);
        make.width.mas_greaterThanOrEqualTo(__SCALE(40.f));
        make.centerY.equalTo(self.periodLabel);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.normalTableView).offset(__SCALE(-0.5f));
        make.height.mas_equalTo(.5f);
    }];
    [self.normalTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeBaseView.mas_bottom).offset(__SCALE(5.f));
        make.bottom.left.right.equalTo(self.view);
    }];
    [self.quickContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self configPayMentType];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.navBackButton]];
    // Do any additional setup after loading the view.
}
#pragma mark ------------ 客户端被重新唤起时 ------------
- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    WS(_weakSelf)
    if (self.isGotoPayBack) {
        //是去支付后又回到客户端  校验是否展示小额免密
        [self.freeService isAlreadyFreeOfPayServiceWithChannalType:self.lotterySource.channel_type complete:^{
            
            // 跳转彩票点抢单
            [CLLotteryBespeakService runBespeakServiceWithOrderId:_weakSelf.payConfigure[@"order_id"]  completion:^{
                
                [self.navigationController popViewControllerAnimated:NO];
                [_weakSelf pushOrderOrFollow];
            }];
        }];
        self.isGotoPayBack = NO;
    }
}

- (void)navBackButtonOnClick:(UIButton *)btn{
    
//    NSLog(@"点击了返回按钮");
    [self.abandonAlert show];
    
}
- (void)timeCutDown:(NSNotification *)notification{
    
    if (self.periodTime == 0) {
        [self timeOut];
        return;
    }
    self.periodTime--;
    self.timeLabel.text = [CLTools timeFormatted:self.periodTime];
    if (self.period.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"距%@期截止:", self.period];
    }else{
        self.periodLabel.text = [NSString stringWithFormat:@"距本期截止:"];
    }
}
- (void)timeOut{
    
    if (self.isAlowShowAlert) {
        [self.alertController show];
        self.isAlowShowAlert = NO;
    }
}
#pragma mark ------------ alertControllerDelegate ------------
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (alertController == self.alertController) {
        if (index == 0) {
            if (self.pushType == CLPayPushTypeBet) {
                [CLJumpLotteryManager jumpLotteryDestoryWithGameEn:self.lotteryGameEn];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if (alertController == self.abandonAlert) {
        
        if (index == 1) {
            
            [self confirmPayAction];
        }else if (index == 0){
            NSString *orderId = self.payConfigure[@"order_id"];
            if (orderId && orderId.length > 0) {
                if (self.orderType == CLOrderTypeNormal) {
                    [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLLottBetOrdDetaViewController_push/%@", self.payConfigure[@"order_id"]]];
                }else if (self.orderType == CLOrderTypeFollow){
                    [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFollowDetailViewController_push/%@", self.payConfigure[@"order_id"]]];
                }
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    
}
#pragma mark ------------ private Mothed ------------
- (void)configPayMentType{
    
    if (self.payMentType == CLPayMentTypeQuick) {
        /** 快速支付 */
        //self.navTitleText = @"快速支付";
        self.normalTableView.hidden = YES;
        self.timeBaseView.hidden = YES;
        self.lineView.hidden = YES;
        self.paymentService.isQuickPayment = YES;
        self.view.backgroundColor = UIColorFromRGBandAlpha(0x000000, 0.75);
    }else{
        /** 正常支付 */
        self.navTitleText = @"支付";
        self.normalTableView.hidden = NO;
        self.timeBaseView.hidden = NO;
        self.lineView.hidden = NO;
        self.quickContentView.hidden = YES;
        self.paymentService.isQuickPayment = NO;
        self.view.backgroundColor = UIColorFromRGB(0xffffff);
        //配置倒计时
        //添加timer监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
    }
    
}
#pragma mark - 跳转详情页
- (void)pushOrderOrFollow{
    
    if (self.orderType == CLOrderTypeNormal) {
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLLottBetOrdDetaViewController_push/%@", self.payConfigure[@"order_id"]]];
    }else if (self.orderType == CLOrderTypeFollow){
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFollowDetailViewController_push/%@", self.payConfigure[@"order_id"]]];
    }
}
#pragma mark --------- ServiceAction ---------
#pragma mark - 配置数据源
- (void)configurePaymentData
{
    /** 配置数据源 */
    if (self.paymentService.isQuickPayment) {
        self.quickHomeView.quickDataSource = [self.paymentService paymentDataSource];
        //还需支付的金额
        if ((self.paymentService.redSelectedIndex != -1)) {
            NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lld",self.paymentService.needPayAmount]];
            number = [number decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            self.quickHomeView.needPayAmount = [NSString stringWithFormat:@"还需支付：%@元",number.stringValue];
        }else{
            self.quickHomeView.needPayAmount = @"";
        }
        
    }else{
        if ([self.paymentService paymentDataSource].count == 0) return;
        [self.payChannelArrays removeAllObjects];
        [self.payChannelArrays addObjectsFromArray:[self.paymentService paymentDataSource]];
        self.confirmButton.hidden = self.payChannelArrays.count == 0;
        [self.normalTableView reloadData];
    }
}
#pragma mark - 确认支付
- (void)confirmPayAction
{
    /** 唤起支付 */
    //如果支付方式选择位置小于0，只有红包支付
    
    paymentChannelType paymentChannel = self.paymentService.payChannelID;
    
    //** 支付按钮点击 */

    if ((paymentChannel == paymentChannelTypeAccountBalance) && (self.paymentService.userBalance < self.paymentService.needPayAmount))
    {
        [self show:@"账户余额不足"];
        return;
    }
    
    /** 如果是微信支付 并且金额小于2元 提示 */
    if (paymentChannel == paymentChannelTypeWx && self.paymentService.needPayAmount < 200)
    {
        //微信低于两元弹窗
        [self show:@"微信支付最低2元"];
        return;
    }
    //如果数据校验成功 则关闭快速投注窗口
    if (self.paymentService.isQuickPayment) {
        [self.view removeFromSuperview];
    }
    /** 判断是否实名认证 */
    WS(_weakSelf)
    if (paymentChannel != paymentChannelTypeWx) {
        
        if (self.lotterySource.channel_type == paymentChannelTypeYiLian || (self.lotterySource.channel_type >= paymentChannelTypeSupportCardPreposing && self.lotterySource.channel_type < paymentChannelTypeOther)) {
            [_weakSelf confirmPay_userCertify];
        }else{
            [[CLCheckProgessManager shareCheckProcessManager] checkIsUserCertifyWithCallBack:^{
                [_weakSelf confirmPay_userCertify];
            }];
        }
    }else{
        [_weakSelf confirmPay_userCertify];
    }
}
#pragma mark - 确认支付 -- 实名校验成功
- (void)confirmPay_userCertify{
    
    /** 唤起支付 */
    //如果支付方式选择位置小于0，只有红包支付
    
    if (self.paymentService.paymentArr.count == 0) {
        [self show:@"请选择支付方式"];
        return;
    }
    CLAccountInfoModel* channel = (CLAccountInfoModel*)self.paymentService.paymentArr[self.paymentService.channelIndex >= 0 ? self.paymentService.channelIndex:0];
    paymentChannelType paymentChannel = self.paymentService.payChannelID;
    //配置参数
    //** 支付方式 */
    self.lotterySource.total_amount = [NSString stringWithFormat:@"%lld",self.paymentService.paymentInfo.pre_handle_token.amount];
    self.lotterySource.channel_type = paymentChannel;
    //如果只有红包支付，则支付地址是现金账户的支付地址
    self.lotterySource.url_prefix = channel.backup_1;
    self.lotterySource.transitionType = transitionTypeTicketPayment;
    
    self.lotterySource.flow_id = self.paymentService.paymentInfo.pre_handle_token.flow_id;
    //需支付金额
    self.lotterySource.need_pay_amount = [NSString stringWithFormat:@"%lld",self.paymentService.needPayAmount];
    self.lotterySource.has_redPacket = (self.paymentService.redSelectedIndex != -1);
    self.lotterySource.order_id = self.paymentService.customObj[@"order_id"];
    //校验红包数据
    CLQuickRedPacketsModel *redModel = self.paymentService.redSelectedIndex != -1 ? self.paymentService.redModelArr[self.paymentService.redSelectedIndex] : nil;
    //判断有红包则传红包余额，没有红包则传0
    self.lotterySource.redPa_amount = self.lotterySource.has_redPacket ? [NSString stringWithFormat:@"%lld",redModel.balance_num] : 0;
    self.lotterySource.launch_class = self;
    self.lotterySource.redPa_program_id = redModel ? redModel.fid : @"";
    
    WS(_weakSelf)
    self.lotterySource.didOpenSafari = ^{
        
        //打开网页 支付
        _weakSelf.isGotoPayBack = YES;
        _weakSelf.isAlowShowAlert = NO;
    };
    self.lotterySource.createPayForToken = ^(BOOL createState, id responeData){
        
        if (createState) {
            
        } else {
            if ([responeData isKindOfClass:NSString.class]) {
                //支付失败  展示信息 跳转详情页
                [_weakSelf show:responeData];
            }
            [_weakSelf pushOrderOrFollow];
        }
    };
    
    if (self.lotterySource.channel_type == paymentChannelTypeYiLian || (self.lotterySource.channel_type >= paymentChannelTypeSupportCardPreposing && self.lotterySource.channel_type < paymentChannelTypeOther)) {
        
        CLPayCardListViewController *vc = [[CLPayCardListViewController alloc] init];
        vc.lotteryPaySource = self.lotterySource;
        vc.orderType = self.orderType;
        vc.payConfigure = self.payConfigure;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self.lotterySource runPayment];
    }
}
#pragma mark --------- APIDelegate ---------

- (void)requestFinished:(CLBaseRequest *)request
{
    
    if (request.urlResponse.success) {
        self.paymentService.paymentInfo = [self.paymentAPI dealingWithRedEnvelopListFromDict:[request.urlResponse.resp firstObject]];
        /** 更新数据 */
        [self configurePaymentData];
    }
    [self stopLoading];
}
- (void)requestFailed:(CLBaseRequest *)request
{
    [self stopLoading];
}

#pragma mark --------- QuickPayMent ---------
- (void)changeRedParketWith:(id)redModel
{
    /** 更换红包 */
    [self.paymentService changeRedModelWith:redModel];
    [self configurePaymentData];
}

- (void)changePaychannelWith:(id)payMentModel
{
    /** 更换支付方式 */
    [self.paymentService changePaychannelWith:payMentModel];
    [self configurePaymentData];
}

#pragma mark --------- TableViewDelegate -----------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.payChannelArrays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.payChannelArrays[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id payMentData = self.payChannelArrays[indexPath.section][indexPath.row];
    /** 支付信息 */
    if ([payMentData isKindOfClass:[CLUserPayAccountInfo class]] || [payMentData isKindOfClass:[CLQuickRedPacketsModel class]]) {
        CLPaymentInfoShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLPaymentInfoShowCellID"];
        if (!cell) {
            cell = [[CLPaymentInfoShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLPaymentInfoShowCellID"];
        }
        [cell assignUserCashDepositCellWithObj:payMentData];
        return cell;
    }
    /** 支付方式 */
    CLPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLRedEnvePayCellId"];
    if (!cell) {
        cell = [[CLPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLRedEnvePayCellId"];
    }
    
    CLAccountInfoModel* channel = payMentData;
    cell.textLbl.text = channel.account_type_nm;
    cell.subTextLbl.text = channel.memo;
    if (channel.account_type_id == paymentChannelTypeAccountBalance) {
        cell.markTextLbl.text = [NSString stringWithFormat:@"%.2lf元", channel.balance];
        cell.textLbl.textColor = cell.markTextLbl.textColor = channel.useStatus?[UIColor blackColor]:UIColorFromRGB(0x666666);
    }
    cell.cellType = channel.account_type_id == 999 ? PaymentCellTypeMarking : (channel.useStatus ? PaymentCellTypeSelect : PaymentCellTypeNormal);
    cell.onlyShowTitle = !([channel.memo isKindOfClass:[NSString class]] && [channel.memo length] > 0);
    [cell.icon setImageWithURL:[NSURL URLWithString:channel.img_url]];
    cell.isSelectState = channel.selectedStatus;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /** 区分点击红包还是支付方式 */
    id payMentSelectedObj =  self.payChannelArrays[indexPath.section][indexPath.row];
    if ([payMentSelectedObj isKindOfClass:[CLAccountInfoModel class]]) {
        CLAccountInfoModel* channel = payMentSelectedObj;
        if (!channel.useStatus) return;
        [self changePaychannelWith:channel];
    }else if([payMentSelectedObj isKindOfClass:[CLQuickRedPacketsModel class]]){
        /** 点击切换红包 */
        WS(_weakSelf);
        CLPaymentSelectedRedViewController *redViewController = [[CLPaymentSelectedRedViewController alloc] init];
        [redViewController.dataSource addObjectsFromArray:self.paymentService.redModelArr];
        redViewController.selectedBlock = ^(id Model){
            [_weakSelf changeRedParketWith:Model];
        };
        redViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:redViewController animated:YES];
    }
    
}

#pragma mark --------- SettringMethod ---------
- (void)setPayConfigure:(id)payConfigure
{
    _payConfigure = payConfigure;
    self.paymentService.customObj = payConfigure;
    self.paymentAPI.preforeToken = payConfigure[@"pre_handle_token"];
    [self showLoading];
    [self.paymentAPI start];
}
- (void)setPayAccount:(NSInteger)payAccount{
    
    _payAccount = payAccount;
    self.quickHomeView.quickBetTitle = [NSString stringWithFormat:@"投注：%zi元", payAccount];
}
#pragma mark --------- GettingMethod ---------
- (CQLotteryPaySource *)lotterySource{
    
    if (!_lotterySource) {
        _lotterySource = [[CQLotteryPaySource alloc] init];
    }
    return _lotterySource;
}
#pragma mark - normalView
- (CQFreeOfPayService *)freeService{
    
    if (!_freeService) {
        _freeService = [CQFreeOfPayService allocWithWeakViewController:self];
    }
    return _freeService;
}
- (UITableView *)normalTableView
{
    if (!_normalTableView) {
        _normalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _normalTableView.delegate = self;
        _normalTableView.dataSource = self;
        _normalTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _normalTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _normalTableView;
}

- (UIView *)normalTableViewFooterView
{
    if (!_normalTableViewFooterView) {
        _normalTableViewFooterView = [[UIView alloc] init];
        _normalTableViewFooterView.frame = __Rect(0, 0, SCREEN_WIDTH, 120);
        [_normalTableViewFooterView addSubview:self.confirmButton];
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_normalTableViewFooterView).offset(-10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(40.f);
        }];
    }
    return _normalTableViewFooterView;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTintColor:UIColorFromRGB(0xffffff)];
        [_confirmButton setBackgroundColor:THEME_COLOR];
        _confirmButton.layer.cornerRadius = 2.f;
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.titleLabel.font = FONT_SCALE(15);
        [_confirmButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmPayAction) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.hidden = YES;
    }
    return _confirmButton;
}

#pragma mark - quickPayView

- (UIView *)timeBaseView{
    
    if (!_timeBaseView) {
        _timeBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _timeBaseView.backgroundColor = CLEARCOLOR;
    }
    return _timeBaseView;
}
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.textColor = UIColorFromRGB(0x333333);
        _periodLabel.font = FONT_SCALE(13.f);
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}
- (UILabel *)timeLabel{
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textColor = THEME_COLOR;
        _timeLabel.font = FONT_SCALE(13.f);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = SEPARATE_COLOR;
    }
    return _lineView;
}
- (CLAlertController *)alertController{
    
    if (!_alertController) {
        _alertController = [CLAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前期次(%@期)已截止" ,self.period] message:@"" style:CLAlertControllerStyleAlert delegate:self];
        _alertController.buttonItems = @[@"确定"];
    }
    return _alertController;
}

- (CLAlertController *)abandonAlert{
    
    if (!_abandonAlert) {
        _abandonAlert = [CLAlertController alertControllerWithTitle:@"距离奖金到手只有一步之遥" message:@"确定要放弃吗？" style:CLAlertControllerStyleAlert delegate:self];
        _abandonAlert.buttonItems = @[@"放弃", @"继续支付"];
    }
    return _abandonAlert;
}

- (UIView *)quickContentView
{
    if (!_quickContentView) {
        _quickContentView = [[UIView alloc] init];
        [_quickContentView addSubview:self.quickBackIMG];
        [_quickContentView addSubview:self.quickHomeView];
        [_quickContentView addSubview:self.quickPaySelectedView];
        [_quickContentView addSubview:self.quickRedSelectedView];
        [self.quickBackIMG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_quickContentView);
        }];
        [self.quickHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(__SCALE(20.f));
            make.right.mas_equalTo(__SCALE(- 20.f));
        }];
        [self.quickPaySelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(__SCALE(20.f));
            make.right.mas_equalTo(__SCALE(- 20.f));
        }];
        [self.quickRedSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(__SCALE(20.f));
            make.right.mas_equalTo(__SCALE(- 20.f));
        }];
    }
    return _quickContentView;
}

- (UIImageView *)quickBackIMG
{
    if (!_quickBackIMG) {
        _quickBackIMG = [[UIImageView alloc] init];
    }
    return _quickBackIMG;
}

- (CLQuickBetHomeView *)quickHomeView
{
    if (!_quickHomeView) {
        _quickHomeView = [[CLQuickBetHomeView alloc] init];
        WS(_weakSelf);
        _quickHomeView.selectedPaymentBlock = ^(id method, CLQuickHomeShowType showType){
            _weakSelf.quickHomeView.hidden = YES;
            if (showType == quickHomePayChannelType) {
               /** 选择支付方式 */
                if ([_weakSelf.paymentService paymentArr].count > 1) {
                    _weakSelf.quickPaySelectedView.hidden = NO;
                    [_weakSelf.quickPaySelectedView updataPaymentWithData:[_weakSelf.paymentService paymentArr]];
                }else{
                    _weakSelf.quickHomeView.hidden = NO;
                    [_weakSelf show:@"暂无其他支付渠道"];
                }
                
            }else if (showType == quickHomeRedParketsType){
                /** 跳转切换红包 */
                _weakSelf.quickRedSelectedView.hidden = NO;
                [_weakSelf.quickRedSelectedView assignQuickBetpaymentViewWithMethod:[_weakSelf.paymentService redModelArr]];
            }
        };
        _quickHomeView.dissmissBlock = ^{
            /** 取消支付 */
//            [_weakSelf dismissViewControllerAnimated:NO completion:nil];
            _weakSelf.cancelQuickPayBlock ? _weakSelf.cancelQuickPayBlock() : nil;
        };
        _quickHomeView.nextActionBlock = ^{
            /** 支付按钮 */
            [_weakSelf confirmPayAction];
        };
    }
    return _quickHomeView;
}

- (CLQuickBetPaySelectedView *)quickPaySelectedView
{
    if (!_quickPaySelectedView) {
        _quickPaySelectedView = [[CLQuickBetPaySelectedView alloc] init];
        _quickPaySelectedView.hidden = YES;
        WS(_weakSelf);
        _quickPaySelectedView.selectedPaymentBlock = ^(id obj){
            //_weakSelf.quickPaySelectedView.hidden = YES;
            /** 通知Service切换支付方式 */
            [_weakSelf changePaychannelWith:obj];
            _weakSelf.quickHomeView.hidden = NO;
            _weakSelf.quickPaySelectedView.hidden = YES;
        };
        _quickPaySelectedView.paymentBackBlock = ^{
            _weakSelf.quickPaySelectedView.hidden = YES;
            _weakSelf.quickHomeView.hidden = NO;
        };
    }
    return _quickPaySelectedView;
}

- (CLQuickBetRedParketsView *)quickRedSelectedView
{
    if (!_quickRedSelectedView) {
        _quickRedSelectedView = [[CLQuickBetRedParketsView alloc] init];
        _quickRedSelectedView.hidden = YES;
        WS(_weakSelf);
        _quickRedSelectedView.selectedRedParketsBlock = ^(id obj , BOOL selectStatus){
            //_weakSelf.quickRedSelectedView.hidden = YES;
            /** 通知service切换红包 */
            [_weakSelf changeRedParketWith:obj];
            _weakSelf.quickHomeView.hidden = NO;
            _weakSelf.quickRedSelectedView.hidden = YES;
        };
        _quickRedSelectedView.redParketsBackBlock = ^{
            _weakSelf.quickRedSelectedView.hidden = YES;
            _weakSelf.quickHomeView.hidden = NO;
        };
    }
    return _quickRedSelectedView;
}

/** API */
- (CLPayMentIPA *)paymentAPI
{
    if (!_paymentAPI) {
        _paymentAPI = [[CLPayMentIPA alloc] init];
        _paymentAPI.delegate = self;
    }
    return _paymentAPI;
}

/** Service */
- (CLPayMentService *)paymentService
{
    if (!_paymentService) {
        _paymentService = [[CLPayMentService alloc] init];
    }
    return _paymentService;
}

/** dataSource */

- (NSMutableArray *)payChannelArrays
{
    if (!_payChannelArrays) {
        _payChannelArrays = [[NSMutableArray alloc] init];
    }
    return _payChannelArrays;
}

- (NSMutableArray *)quickPayDataSource
{
    if (!_quickPayDataSource) {
        _quickPayDataSource = [[NSMutableArray alloc] init];
    }
    return _quickPayDataSource;
}
- (UIButton *)navBackButton{
    
    if (!_navBackButton) {
        _navBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_navBackButton setImage:[UIImage imageNamed:@"allBack.png"] forState:UIControlStateNormal];
        _navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, - 15, 0, 0);

        [_navBackButton addTarget:self action:@selector(navBackButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navBackButton;
}

@end
