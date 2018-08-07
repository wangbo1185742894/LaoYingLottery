//
//  CKCustomPaymentHomeView.m
//  CKPayClient
//
//  Created by 小铭 on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKCustomPaymentHomeView.h"
#import "CKPayFlowFilter.h"
#import "CKPayCell.h"
#import "CKPayChannelUISource.h"
#import "UIImageView+CKWebImage.h"

#import "Masonry.h"
#import "CKDefinition.h"

#import "CKPayHeaderView.h"

#import "CKRedPacketUISource.h"

#import "CKPayRedSelectViewController.h"
/** API */
#import "CKPayApi.h"
#import "CKPayRedApi.h"

/** source */
#import "CKLotteryPaySource.h"
#import "CKRedPacketPaySource.h"
#import "CKPayMentInfoModel.h"
#import "CKPayHandleModel.h"

#import "CKPayClient.h"

#import "CKRechargeHintView.h"

#import "CKSettingGuidanceController.h"
#import "CKNotificationUtils.h"

@interface CKCustomPaymentHomeView ()<UITableViewDelegate, UITableViewDataSource,CKPayFlowFilterDelegate,CLRequestCallBackDelegate>

//data
@property (nonatomic, strong) CKPayFlowFilter *payFlowFilter;
//request

@property (nonatomic, strong) CKPayMentInfoModel *preForTokenModel;

//UI
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) CKPayHeaderView *tableHeaderView;
@property (nonatomic, strong) UIView *payBaseView;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *nextUnjumpButton;//点击下一部没反应

@property (nonatomic, strong) CALayer *payLayer;
@property (nonatomic, strong) CAGradientLayer *marginLayer;
/** API */
@property (nonatomic, strong) CKPayApi *paymentAPI;
@property (nonatomic, strong) CKPayRedApi *redPayAPI;

@property (nonatomic, strong) CKPaymentBaseSource *lotterySource;

@property (nonatomic, strong) CKRechargeHintView* hintView;

@property (nonatomic, strong) NSTimer *canNotOpenTimer;

@end

@implementation CKCustomPaymentHomeView

- (void)dealloc{
    
    [self.canNotOpenTimer invalidate];
    self.canNotOpenTimer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)CustomPaymentViewIsBuyRed:(BOOL)isRed preHandleToken:(NSString *)prehandleToken viewController:(UIViewController *__weak)pushController paymentActionBlock:(void (^)(CKPaymentBaseSource *,NSString *))paymentActionBlock
{
    CKCustomPaymentHomeView *homeView = [[CKCustomPaymentHomeView alloc] init];
    homeView.prehandleToken = prehandleToken;
    homeView.paymentActionBlock = paymentActionBlock;
    homeView.isRed = isRed;
    homeView.pushController = pushController;
    return homeView;
}

- (void)startRequest
{
    [[CKPayClient sharedManager].intermediary startLoading];
    if (self.isRed) {
        self.redPayAPI.preHandleToken = self.prehandleToken;
        [self.redPayAPI start];
    }else{
        self.paymentAPI.preHandleToken = self.prehandleToken;
        [self.paymentAPI start];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self assignSubview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canNotOpenSafari:) name:CK_CanNotOpenSafari object:nil];
    }
    return self;
}

- (void)startPayment
{
    /** 配置支付相关参数 */
    //** 支付方式 */
    /** 红包 */
    if (self.isRed) {
        self.lotterySource = [[CKRedPacketPaySource alloc] init];
        ((CKRedPacketPaySource *)self.lotterySource).redPaTradingInfo = @[@{@"channel_type":[NSString stringWithFormat:@"%zi",[self.payFlowFilter selectChannelDataSource].channel_id],@"amount":[NSString stringWithFormat:@"%lld",self.preForTokenModel.pre_handle_token.amount]}];
        /** 需要订单号 */
        ((CKRedPacketPaySource *)self.lotterySource).orderId = self.preForTokenModel.pre_handle_token.handle_id;
        self.lotterySource.transitionType = CKTransitionTypeRedPacketPayment;
    }else{
        /** 支付 */
        self.lotterySource = [[CKLotteryPaySource alloc] init];
        ((CKLotteryPaySource *)self.lotterySource).redPa_amount = self.payFlowFilter.isUseRedPacket ? [NSString stringWithFormat:@"%ld",[self.payFlowFilter selectRedPacketDataSource].redPacketBalance] : 0;
        ((CKLotteryPaySource *)self.lotterySource).redPa_program_id = [self.payFlowFilter selectRedPacketDataSource].redPacketFid;
        ((CKLotteryPaySource *)self.lotterySource).has_redPacket = self.payFlowFilter.isUseRedPacket;
        /** 需要订单号 */
        ((CKLotteryPaySource *)self.lotterySource).order_id = self.preForTokenModel.pre_handle_token.handle_id;
        self.lotterySource.transitionType = CKTransitionTypeTicketPayment;
    }
    
    self.lotterySource.total_amount = [NSString stringWithFormat:@"%lld",self.preForTokenModel.pre_handle_token.amount];
    self.lotterySource.channel_type = [self.payFlowFilter selectChannelDataSource].channel_id;
    //如果只有红包支付，则支付地址是现金账户的支付地址
    self.lotterySource.url_prefix = [self.payFlowFilter selectChannelDataSource].url_prefix;
    
    
    self.lotterySource.flow_id = self.preForTokenModel.pre_handle_token.flow_id;
    //需支付金额
    self.lotterySource.need_pay_amount = [NSString stringWithFormat:@"%lld",self.payFlowFilter.needPayAmount];
    
    self.lotterySource.launch_class = self.pushController;
    
    
    [CKPayClient sharedManager].channel = [self.payFlowFilter selectChannelDataSource];
    [CKPayClient sharedManager].source = self.lotterySource;
    [CKPayClient sharedManager].launchViewController = self.pushController;
    
    self.paymentActionBlock ? self.paymentActionBlock(self.lotterySource,self.preForTokenModel.pre_handle_token.handle_id) : nil;
}

#pragma mark ------------ event Response ------------
- (void)btnOnClick:(UIButton *)btn{
    
    CKPayChannelVerifyMark* mark = [self.payFlowFilter channelGuidTitle];
    if (mark.isAuthenticate) {
        
        [self.hintView showTitleText:mark.subTitle buttonTitle:mark.title];
        
    } else {
        [self startPayment];
        //添加计时器 记录若3秒后无法跳转则显示 为什么下一步无法跳转 按钮
        self.canNotOpenTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerCutDown:) userInfo:nil repeats:NO];
    }
}

- (void)nextUnjumpButtonOnClick:(UIButton *)btn{
    
    [self.pushController.navigationController pushViewController:[[CKSettingGuidanceController alloc] init] animated:YES];
}

- (void)canNotOpenSafari:(NSNotification *)noti{
    
    [self nextUnjumpButtonOnClick:nil];
}

- (void)timerCutDown:(NSTimer *)timer{

    if (self.pushController.isViewLoaded && self.pushController.view.window && [UIApplication sharedApplication].applicationState == UIApplicationStateActive && ![CKPayClient sharedManager].isSDKPayment) {
        //停留在当前页
        self.nextUnjumpButton.hidden = NO;
        [self nextUnjumpButtonOnClick:nil];
    }
    [self.canNotOpenTimer invalidate];
    self.canNotOpenTimer = nil;
}
#pragma mark - requestDelegate

- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        CKPayMentInfoModel *model = self.preForTokenModel = [CKPayMentInfoModel objectWithKeyValues:[request.urlResponse.resp firstObject]];
        [self.payFlowFilter setAvailableChannelList:model.account_infos VIPChannelSource:model.big_moneny.count > 0 ? model.big_moneny[0] : nil redPacketList:model.red_list?: nil totalAmount:model.pre_handle_token.amount];
        self.payBaseView.hidden = NO;
    }else{
        [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
    }
    [[CKPayClient sharedManager].intermediary stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request{
    [[CKPayClient sharedManager].intermediary stopLoading];
    [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
}

#pragma mark ------------ pay delegate ------------
- (void)flowFilterFinish
{
    self.tableHeaderView.hasRedPacket = self.payFlowFilter.existRedPacket;
    self.mainTableView.tableHeaderView = self.tableHeaderView;
    [self reloadTableHeaderView];
    [self reloadPayButton];
    self.payBaseView.hidden = NO;
    [self.mainTableView reloadData];
}

#pragma mark ------------ UITableviewDelegate ------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.payFlowFilter channelUISource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier = @"CKPayCell";
    CKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        
        cell = [[CKPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    CKPayChannelUISource *source = (CKPayChannelUISource *)[self.payFlowFilter channelUISource][indexPath.row];
    cell.onlyShowTitle = source.onlyShowChannelNm;
    cell.textLbl.text = source.channel_name;
    if (source.channel_subtitle && source.channel_subtitle.length > 0) {
        
        cell.subTextLbl.text = source.channel_subtitle;
    }else{
        cell.onlyShowTitle = YES;
    }
    
    [cell.icon setImageWithURL:[NSURL URLWithString:source.channel_icon_str]];
    if (source.usability) {
        //渠道是否可用
        cell.cellType = CKPayCellTypeSelect;
        cell.isSelectState = source.isSelected;
        cell.userInteractionEnabled = YES;
    }else{
        //不可用展示状态信息
        cell.cellType = CKPayCellTypeMarking;
        cell.markTextLbl.text = source.channel_state_msg;
        cell.userInteractionEnabled = NO;
    }
    
    
    NSLog(@"%@", source);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.payFlowFilter changeChannelId:@(((CKPayChannelUISource *)[[self.payFlowFilter channelUISource] objectAtIndex:indexPath.row]).channel_id)];
    
    [self.mainTableView reloadData];
}


#pragma mark ------------ private Mothed ------------
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.payLayer.frame = __Rect(0, 0, CGRectGetWidth(self.payBaseView.frame), CGRectGetHeight(self.payBaseView.frame));
}
- (void)assignSubview{
    
    [self addSubview:self.mainTableView];
    [self addSubview:self.nextUnjumpButton];
    [self addSubview:self.payBaseView];
    self.payBaseView.hidden = YES;
    [self.payBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(__SCALE(58));
        
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.payBaseView.mas_left).offset(__SCALE(10));
        make.right.equalTo(self.payBaseView.mas_right).offset(__SCALE(-10));
        make.bottom.equalTo(self.payBaseView.mas_bottom).offset(__SCALE(-10));
        make.height.mas_equalTo(__SCALE(37));
        
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.bottom.mas_equalTo(self.payBaseView.mas_top).offset(1.f);
    }];
    
    [self.nextUnjumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mainTableView).offset(__SCALE(- 5.f));
        make.centerX.equalTo(self.mainTableView);
    }];
}
- (void)reloadTableHeaderView{
    
    self.tableHeaderView.titleLabel.leftLabel.text = @"支付总额：";
    self.tableHeaderView.titleLabel.rightLabel.text = [NSString stringWithFormat:@"%lld元", [self.payFlowFilter totalAmount] / 100];
    self.tableHeaderView.redLabel.leftLabel.text = ((CKRedPacketUISource *)[self.payFlowFilter selectRedPacketUISource]).selectedTitle;
    self.tableHeaderView.redLabel.rightLabel.text = @"";
    
    self.tableHeaderView.needPayLabel.leftLabel.text = @"还需支付：";
    self.tableHeaderView.needPayLabel.rightLabel.text = [NSString stringWithFormat:@"%lld元", [self.payFlowFilter needPayAmount] / 100];
}
- (void)reloadPayButton{
    
    [self.payButton setTitle:[self.payFlowFilter channelGuidTitle].isVIP ? [self.payFlowFilter channelGuidTitle].title:@"立即支付" forState:UIControlStateNormal];
}

//弹窗事件

- (void) recommendBtnClick {
    
    [self.hintView removeFromSuperview];
    [self startPayment];
}

#pragma mark - SttingMothed

- (void)setButtonStatus:(BOOL)buttonStatus
{
    self.payButton.enabled = buttonStatus;
}

#pragma mark ------------ getter Mothed ------------

- (CKPayFlowFilter *)payFlowFilter{
    
    if (!_payFlowFilter) {
        _payFlowFilter = [[CKPayFlowFilter alloc] init];
        _payFlowFilter.delegate = self;
    }
    return _payFlowFilter;
}

- (CKPayRedApi *)redPayAPI
{
    if (!_redPayAPI) {
        _redPayAPI = [[CKPayRedApi alloc] init];
        _redPayAPI.delegate = self;
    }
    return _redPayAPI;
}

- (CKPayApi *)paymentAPI
{
    if (!_paymentAPI) {
        _paymentAPI = [[CKPayApi alloc] init];
        _paymentAPI.delegate = self;
    }
    return _paymentAPI;
}

//UI
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.estimatedRowHeight = 200.f;
        
        _mainTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 1.f, 0);
    }
    return _mainTableView;
}
- (CKPayHeaderView *)tableHeaderView{
    
    if (!_tableHeaderView) {
        _tableHeaderView = [[CKPayHeaderView alloc] init];
        WS(_weakSelf)
        _tableHeaderView.clickRedBlock = ^(){
            
            CKPayRedSelectViewController *vc = [[CKPayRedSelectViewController alloc] init];
            
            vc.redList = [_weakSelf.payFlowFilter redPacketUISource];
            vc.selectRedIdBlock = ^(NSString *fidString) {
                
                [_weakSelf.payFlowFilter changeRedPacketId:fidString];
                [_weakSelf reloadTableHeaderView];
            };
            [_weakSelf.pushController.navigationController pushViewController:vc animated:YES];
        };
    }
    return _tableHeaderView;
}
- (UIView *)payBaseView
{
    if (!_payBaseView) {
        _payBaseView = [[UIView alloc] init];
        _payBaseView.hidden = YES;
        _payBaseView.backgroundColor = CLEARCOLOR;
        //        [_payBaseView.layer addSublayer:self.payLayer];
        [_payBaseView.layer addSublayer:self.marginLayer];
        [_payBaseView addSubview:self.payButton];
    }
    return _payBaseView;
}

- (CALayer *)payLayer
{
    if (_payLayer == nil) {
        
        _payLayer = [[CALayer alloc] init];
        _payLayer.contents = (id)[UIImage imageNamed:@"ck_orderDetailBetBtnBackground.png"].CGImage;
        
    }
    
    return _payLayer;
}

- (CAGradientLayer *)marginLayer
{
    if (!_marginLayer) {
        _marginLayer = [CAGradientLayer layer];  // 设置渐变效果
        _marginLayer.frame = __Rect(0, 0, SCREEN_WIDTH, 1.f);
        _marginLayer.colors = [NSArray arrayWithObjects:
                               (id)[CLEARCOLOR CGColor],
                               (id)[UIColorFromRGBandAlpha(0xdddddd, 0.2) CGColor], nil];
        _marginLayer.startPoint = CGPointMake(0.f, .0f);
        _marginLayer.endPoint = CGPointMake(0.f, 1.0f);
    }
    return _marginLayer;
}

- (UIButton *)payButton {
    
    if (!_payButton) {
        _payButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_payButton setTitle:@"立即支付" forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 2.f;
        _payButton.layer.masksToBounds = YES;
        _payButton.titleLabel.font = FONT_SCALE(15);
        [_payButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_payButton setBackgroundColor:UIColorFromRGB(0x5797FC)];
        [_payButton addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UIButton *)nextUnjumpButton{
    
    if (!_nextUnjumpButton ) {
        _nextUnjumpButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_nextUnjumpButton setTitle:@"点击“立即支付”为什么没有反应" forState:UIControlStateNormal];
        _nextUnjumpButton.titleLabel.font = FONT_SCALE(11);
        _nextUnjumpButton.hidden = YES;
        [_nextUnjumpButton setTitleColor:UIColorFromRGB(0x5cc3ff) forState:UIControlStateNormal];
        [_nextUnjumpButton addTarget:self action:@selector(nextUnjumpButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextUnjumpButton;
}

- (CKRechargeHintView *)hintView {
    
    if (!_hintView) {
        _hintView = [[CKRechargeHintView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [_hintView.recommendBtn addTarget:self action:@selector(recommendBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hintView;
}


@end
