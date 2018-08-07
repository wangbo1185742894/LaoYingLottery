//
//  CKRechargeViewController.m
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKRechargeHomeView.h"
#import "CKRechargeCashView.h"
#import "CKRechargeApi.h"
#import "Masonry.h"
#import "CKRechargeManager.h"
#import "CKPayCell.h"
#import "CKPayChannelUISource.h"
#import "UIImageView+CKWebImage.h"
#import "CKCashDepositPaySource.h"
#import "CKPayClient.h"
#import "CKRechargeHintView.h"

#import "CKDefinition.h"

#import "CKRechargeManager.h"
@interface CKRechargeHomeView ()<UITableViewDelegate,UITableViewDataSource,CKRechargeCashViewDelegate,CLRequestCallBackDelegate,CKRechargeManagerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

//@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
/**
 api
 */
@property (nonatomic, strong) CKRechargeApi *rechargeApi;

/**
 顶部金额输入视图
 */
@property (nonatomic, strong) CKRechargeCashView *cashView;

/**
 充值背景view
 */
@property (nonatomic, strong) UIView *rechargeView;

/**
 充值背景阴影
 */
@property (nonatomic, strong) CALayer *rechargeBacklayer;

/**
 充值按钮
 */
@property (nonatomic, strong) UIButton* rechargeBtn;

/**
 打电话的webView
 */
@property (nonatomic, strong) UIWebView *telWebView;

/**
 充值管理者
 */
@property (nonatomic, strong) CKRechargeManager *rechargeManager;

/**
 充值金额
 */
@property (nonatomic, assign) long long rechargeMoney;

/**
 充值source
 */
@property (nonatomic, strong) CKCashDepositPaySource *depositPaySource;

/**
 弹窗
 */
@property (nonatomic, strong) CKRechargeHintView *hintView;

@property (nonatomic, strong) CKRechargeConfig *config;

/**
 用于回收键盘的view
 */
@property (nonatomic, strong) UIView *touchView;

@property (nonatomic, assign) NSInteger limitMoney;

@property (nonatomic, strong) NSString *limitMsg;


@end

@implementation CKRechargeHomeView

+ (instancetype)rechargeViewController:(UIViewController __weak *)pushController paymentActionBlock:(void(^)(CKPaymentBaseSource *,NSString *))paymentActionBlock
{
    CKRechargeHomeView *homeView = [[CKRechargeHomeView alloc] init];
    homeView.pushController = pushController;
    homeView.paymentActionBlock = paymentActionBlock;
    return homeView;
}

- (void)startRequest
{
    [[CKPayClient sharedManager].intermediary startLoading];
    [self.rechargeApi start];
}

- (void)startPayment
{
    [self configCashWithChannelData:[self.rechargeManager selectChannelDataSource]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xF5F5F5);
        [self addSubview:self.cashView];
        [self addSubview:self.mainTableView];
        [self addSubview:self.rechargeView];
        
        [self addObserverForKeyboard];
        
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.cashView.mas_bottom);
            make.bottom.equalTo(self.rechargeBtn.mas_top);
        }];
        
        [self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(__SCALE(62));
            
        }];
        
        [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.rechargeView.mas_left).offset(__SCALE(10));
            make.right.equalTo(self.rechargeView.mas_right).offset(__SCALE(-10));
            make.bottom.equalTo(self.rechargeView.mas_bottom).offset(__SCALE(-10));
            make.height.mas_equalTo(__SCALE(37));
            
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.rechargeBacklayer.frame = __Rect(0, 0, CGRectGetWidth(_rechargeView.frame), CGRectGetHeight(_rechargeView.frame));
}

//配置充值按钮颜色
- (void)configRechargeBtnWithTitleColor:(UIColor *)titleColor backgoundColor:(UIColor *)backgoundColor
{
    [self.rechargeBtn setTitleColor:titleColor forState:(UIControlStateNormal)];
    [self.rechargeBtn setBackgroundColor:backgoundColor];
}

#pragma mark --- NSNotificationCenter ----
- (void)addObserverForKeyboard
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTouchView) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)addTouchView
{
    [self addSubview:self.touchView];
}


#pragma mark --- CLRequestCallBackDelegate ---

- (void)requestFinished:(CLBaseRequest *)request
{

    if (request.urlResponse.success) {
        
        [self.rechargeApi dealingWithRechargeData:[request.urlResponse.resp firstObject]];
        
        [self.cashView configureFillList:[self.rechargeApi pullFillList] bigMoney:[self.rechargeApi pullBigMoney] template:[self.rechargeApi pullTemplate]];
        
        [self.cashView configminRechargeMoney:[self.rechargeApi pullLimit_list]];
        
        
        self.cashView.hidden = NO;
        
        [self.rechargeManager setAvailableChannelList:[self.rechargeApi pullChannel] VIPChannelSource:[self.rechargeApi pullBigMoney].count > 0 ? [self.rechargeApi pullBigMoney][0] : nil];
        
    
        [self.mainTableView reloadData];
        
        if (self.defaultAmount > 0) {
        
            self.cashView.defaultAmount = self.defaultAmount;
        }
        self.rechargeView.hidden = NO;
    }else{
        [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
    }
    [[CKPayClient sharedManager].intermediary stopLoading];
}


- (void)requestFailed:(CLBaseRequest *)request
{
    [[CKPayClient sharedManager].intermediary stopLoading];
    [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage]; 
}

#pragma mark --- CKRechargeManagerDelegate ---

- (void)rechargeChannelFilterFinish
{
    
     [self.mainTableView reloadData];

}

#pragma mark --- TableViewDelegate ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.rechargeManager channelUISource].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * reuseIdentifier = @"CKPayCell";
    
    CKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        
        cell = [[CKPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    CKPayChannelUISource *source = (CKPayChannelUISource *)[self.rechargeManager channelUISource][indexPath.row];
    
    [cell.icon setImageWithURL:[NSURL URLWithString:source.channel_icon_str]];
    
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.rechargeManager changeChannelId:@(((CKPayChannelUISource *)[[self.rechargeManager channelUISource] objectAtIndex:indexPath.row]).channel_id)];

}

#pragma mark --- Button Click ---

- (void)rechargeEvent:(UIButton*)btn
{
 
    if (self.rechargeMoney < self.limitMoney) {
        
        [[CKPayClient sharedManager].intermediary showError:self.limitMsg];
        
        return;
    }
    
    
    CKRechargeConfig *config = [self.rechargeManager checkAvailableChannelWithAmount:self.rechargeMoney];
    
    self.config = config;
    
    if (config.channelVaildStatus) {
        
//        NSLog(@"%@ -- %@",config.recommendChannelTitle,config.reasonTitle);

        [self configCashWithChannelData:[self.rechargeManager selectChannelDataSource]];
        
    }else{
    
        [self.hintView showTitleText:config.reasonTitle buttonTitle:config.recommendChannelTitle];
    }
    
}


/**
 使用推荐渠道按钮
 */
- (void)recommendBtnClick
{

    [self configCashWithChannelData:self.config.recommendChannelData];
}

#pragma mark - 配置充值
- (void)configCashWithChannelData:(id<CKPaychannelDataInterface>)channelData
{
    
    /** 充值参数配置 */
    _depositPaySource = [[CKCashDepositPaySource alloc] init];
    
    _depositPaySource.total_amount = [NSString stringWithFormat:@"%lld",self.rechargeMoney];
    _depositPaySource.channel_type = channelData.channel_id;
    _depositPaySource.need_pay_amount = _depositPaySource.total_amount;
    _depositPaySource.url_prefix = channelData.url_prefix;
    _depositPaySource.launch_class = self.pushController;
    _depositPaySource.transitionType = CKTransitionTypeRecharge;
    
    _depositPaySource.pay_trading_info = @[@{@"channel_type":[NSString stringWithFormat:@"%zi",_depositPaySource.channel_type],@"amount":_depositPaySource.total_amount}];
    /** 开始进行充值 */
    [CKPayClient sharedManager].channel = channelData;
    [CKPayClient sharedManager].source = self.depositPaySource;
    [CKPayClient sharedManager].launchViewController = self.pushController;
    
    self.paymentActionBlock ? self.paymentActionBlock(self.depositPaySource,@"") : nil;
}

//键盘回收
- (void)returnKeyBoard
{
    [self endEditing:YES];
    [self.touchView removeFromSuperview];

}

#pragma mark --- CKRechargeCashViewDelegate ---

- (void)vipService
{
    NSURL *url = [NSURL URLWithString:@"tel://4006892227"];
    [self.telWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

/**
 获取当前输入金额
 */
- (void)rechargeCashChange:(long long)cash
{

    self.rechargeMoney = cash * 100;
    
//    NSLog(@"%lld",self.rechargeMoney);

}

- (void)limitMoney:(NSInteger)limitMoney limit_msg:(NSString *)msg
{
    self.limitMoney = limitMoney;
    self.limitMsg = msg;
}


#pragma mark --------- setting ---------

- (void)setButtonStatus:(BOOL)buttonStatus
{
    self.rechargeBtn.enabled = buttonStatus;
}

#pragma mark --- Get Method ---

- (CKRechargeApi *)rechargeApi
{
    if (_rechargeApi == nil) {
        
        _rechargeApi = [[CKRechargeApi alloc] init];
        _rechargeApi.delegate = self;
    }

    return _rechargeApi;;
}


- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _mainTableView.bounces = NO;
        _mainTableView.rowHeight = __SCALE(45);
    }
    return _mainTableView;
}

- (CKRechargeCashView *)cashView {
    
    if (!_cashView) {
        _cashView = [[CKRechargeCashView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(300))];
        _cashView.delegate = self;
        //_cashView.backgroundColor = [UIColor redColor];
        _cashView.hidden = YES;
    }
    return _cashView;
}

- (UIView *)rechargeView
{
    if (!_rechargeView) {
        _rechargeView = [[UIView alloc] init];
        _rechargeView.hidden = YES;
        _rechargeView.backgroundColor = CLEARCOLOR;
        
        [_rechargeView.layer addSublayer:self.rechargeBacklayer];
        [_rechargeView addSubview:self.rechargeBtn];
        
    }
    return _rechargeView;
}

- (CALayer *)rechargeBacklayer
{
    if (_rechargeBacklayer == nil) {
        
        _rechargeBacklayer = [[CALayer alloc] init];
        _rechargeBacklayer.contents = (id)[UIImage imageNamed:@"ck_orderDetailBetBtnBackground.png"].CGImage;
        
    }

    return _rechargeBacklayer;
}

- (UIButton *)rechargeBtn {
    
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeBtn.layer.cornerRadius = 2.f;
        _rechargeBtn.titleLabel.font = FONT_SCALE(15);
        [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:UIColorFromRGB(0x5797FC)];
        [_rechargeBtn addTarget:self action:@selector(rechargeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

- (UIWebView *)telWebView{
    
    if (!_telWebView) {
        _telWebView = [[UIWebView alloc] init];
    }
    return _telWebView;
}

- (CKRechargeManager *)rechargeManager
{

    if (_rechargeManager == nil) {
        
        _rechargeManager = [[CKRechargeManager alloc] init];
        _rechargeManager.delegate = self;
        
    }
    return _rechargeManager;

}

- (CKRechargeHintView *)hintView
{

    if (_hintView == nil) {
        
        _hintView = [[CKRechargeHintView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        
        [_hintView.recommendBtn addTarget:self action:@selector(recommendBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hintView;

}

- (UIView *)touchView
{
    if (_touchView == nil) {
        
        _touchView = [[UIView alloc] initWithFrame:self.frame];
        _touchView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnKeyBoard)];
        [_touchView addGestureRecognizer:tap];
    }

    return _touchView;
}

@end




