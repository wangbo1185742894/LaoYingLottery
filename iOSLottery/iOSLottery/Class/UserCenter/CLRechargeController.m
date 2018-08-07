//
//  CLRechargeController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRechargeController.h"
#import "CLRechargeCashView.h"
#import "CLPaymentCell.h"
#import "CLRechargeListAPI.h"
#import "CLPaymentChannelInfo.h"
#import "UIImageView+CQWebImage.h"

#import "CQCashDepositPaySource.h"
#import "UINavigationItem+CLNavigationCustom.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"
#import "CLCheckProgessManager.h"
@interface CLRechargeController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLRechargeCashViewDelegate> {
    
    CQCashDepositPaySource* depositPaySource;
}

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) CLRechargeCashView* cashView;
@property (nonatomic, strong) CLRechargeListAPI* rechargeAPI;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIButton* rechargeBtn;
@property (nonatomic, strong) UIWebView *telWebView;//打电话的webView
@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;
@property (nonatomic) NSInteger cntPayChannelIndex;
@property (nonatomic, assign) BOOL isGotoSafari;
@end

@implementation CLRechargeController

- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    if (self.isGotoSafari) {
        [self.navigationController popViewControllerAnimated:YES];
        self.isGotoSafari = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleText = @"充值";
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self showLoading];
    [self.rechargeAPI start];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
}

#pragma mark - eventRespone
- (void)queryAction:(UIButton *)btn{
    
    [self.alertPromptMessageView showInView:self.view.window];
}

- (void)rechargeEvent:(id)sender {
    
    if (self.cntPayChannelIndex < 0 || (self.cntPayChannelIndex >= [self.rechargeAPI pullChannel].count)) {
        [self show:@"未选择支付方式"];
        return;
    }
    long long money = [self.cashView getRechargeMoney];
    if (money < 50) {
        [self show:@"至少充值50元"];
        return;
    }
    
    /** 判断是否实名认证 */
    CLPaymentChannelInfo* channel = [self.rechargeAPI pullChannel][self.cntPayChannelIndex];
    WS(_weakSelf)
    if (channel.account_type_id != paymentChannelTypeWx) {
        [[CLCheckProgessManager shareCheckProcessManager] checkIsUserCertifyWithCallBack:^{
            [_weakSelf configureRechargeParams];
        }];
    }else{
        [self configureRechargeParams];
    }
    
    
    
}

- (void) configureRechargeParams {
    /** 充值参数配置 */
    depositPaySource = [[CQCashDepositPaySource alloc] init];
    
    depositPaySource.total_amount = [NSString stringWithFormat:@"%lld",[self.cashView getRechargeMoney] * 100];
    
    CLPaymentChannelInfo* channel = [self.rechargeAPI pullChannel][self.cntPayChannelIndex];
    
    depositPaySource.channel_type = channel.account_type_id;
    depositPaySource.need_pay_amount = depositPaySource.total_amount;
    depositPaySource.url_prefix = channel.backup_1;
    depositPaySource.launch_class = self;
    depositPaySource.transitionType = transitionTypeRecharge;
    
    depositPaySource.pay_trading_info = @[@{@"channel_type":[NSString stringWithFormat:@"%zi",depositPaySource.channel_type],@"amount":depositPaySource.total_amount}];
    
    /** 充值 易连支付配置卡信息 */
    if (depositPaySource.channel_type == paymentChannelTypeYiLian || (depositPaySource.channel_type >= paymentChannelTypeSupportCardPreposing && depositPaySource.channel_type < paymentChannelTypeOther)) {
        id viewController = [[NSClassFromString(@"CQCardFrontBindViewController") alloc] init];
        [viewController setValue:depositPaySource forKey:@"paymentSource"];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    WS(_weakSelf)
    depositPaySource.createPayForToken = ^(BOOL createState , id responData){
        if (!createState) {
            //_weakSelf.nextButtonStatus = YES;
            //_weakSelf.needToShowLoadingAnimate = NO;
            //[CQErrorManager showErrorInfo:responData];
        }
    };
    depositPaySource.didOpenSafari = ^{
        _weakSelf.isGotoSafari = YES;
    };
    /** 开始进行充值 */
    [depositPaySource runPayment];
}

- (void)updatePayChannel {
    
    if ([self.rechargeAPI pullChannel].count == 0) {
        return;
    }
    
    NSInteger defaultIdx = -1;
    
    if ((defaultIdx >= 0) && (defaultIdx < [self.rechargeAPI pullChannel].count)) {
        self.cntPayChannelIndex = defaultIdx;
    } else {
        self.cntPayChannelIndex = 0;
    }
    
    CLPaymentChannelInfo* channel = [self.rechargeAPI pullChannel][self.cntPayChannelIndex];
    channel.isSelected = YES;
    if (channel.account_type_id == paymentChannelTypeAliPay) {
        [self.cashView inputCashContentLimit:YES];
    }
}

#pragma mark - CLRechargeCashViewDelegate
- (void)rechargeCashChange:(NSInteger)cash{
    
    [self.rechargeBtn setTitle:[NSString stringWithFormat:@"充值%zi元", cash] forState:UIControlStateNormal];
}
- (void)vipService {
    
    NSURL *url = [NSURL URLWithString:@"tel://4006892227"];
    [self.telWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
//    NSLog(@"%@",request.urlResponse.resp);
    if (request.urlResponse.success) {
        [self.rechargeAPI dealingWithRechargeData:[request.urlResponse.resp firstObject]];
        [self.cashView configureFillList:[self.rechargeAPI pullFillList] bigMoney:[self.rechargeAPI pullBigMoney] template:[self.rechargeAPI pullTemplate]];
        self.mainTableView.tableHeaderView = self.cashView;
        //匹配合适支付渠道
        [self updatePayChannel];
        self.mainTableView.tableFooterView = self.bottomView;
        [self.mainTableView reloadData];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self stopLoading];
}

#pragma mark - tableView delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rechargeAPI pullChannel].count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLPaymentCellId"];
    if (!cell) {
        cell = [[CLPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLPaymentCellId"];
    }
    
    CLPaymentChannelInfo* channel = [self.rechargeAPI pullChannel][indexPath.row];
    
    cell.textLbl.text = channel.account_type_nm;
    cell.subTextLbl.text = channel.memo;
    cell.cellType = PaymentCellTypeSelect;
    cell.onlyShowTitle = !([channel.memo isKindOfClass:[NSString class]] && [channel.memo length] > 0);
    [cell.icon setImageWithURL:[NSURL URLWithString:channel.img_url]];
    cell.isSelectState = channel.isSelected;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPaymentChannelInfo* channel = [self.rechargeAPI pullChannel][indexPath.row];
    if (channel.isUnused) return;
    ((CLPaymentChannelInfo*)[self.rechargeAPI pullChannel][self.cntPayChannelIndex]).isSelected = NO;
    channel.isSelected = YES;
    self.cntPayChannelIndex = indexPath.row;
    [self.mainTableView reloadData];
    
    
    [self.cashView inputCashContentLimit:(channel.account_type_id == paymentChannelTypeAliPay)];
    
    

}

#pragma mark - getter

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

- (CLRechargeCashView *)cashView {
    
    if (!_cashView) {
        _cashView = [[CLRechargeCashView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(170))];
        _cashView.delegate = self;
    }
    return _cashView;
}

- (CLRechargeListAPI *)rechargeAPI {
    
    if (!_rechargeAPI) {
        _rechargeAPI = [[CLRechargeListAPI alloc] init];
        _rechargeAPI.delegate = self;
    }
    return _rechargeAPI;
}

- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(120))];
        _bottomView.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:self.rechargeBtn];
        [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bottomView);
            make.width.equalTo(_bottomView).multipliedBy(.8f);
            make.height.mas_equalTo(__SCALE(35));
        }];

    }
    return _bottomView;
}

- (UIButton *)rechargeBtn {
    
    if (!_rechargeBtn) {
        _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeBtn.layer.borderWidth = .5f;
        _rechargeBtn.layer.borderColor = UIColorFromRGB(0xe00000).CGColor;
        _rechargeBtn.layer.cornerRadius = 2.f;
        _rechargeBtn.titleLabel.font = FONT_SCALE(14);
        [_rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rechargeBtn setBackgroundColor:UIColorFromRGB(0xe00000)];
        [_rechargeBtn addTarget:self action:@selector(rechargeEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeBtn;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setTitle:@"充值说明" forState:UIControlStateNormal];
        rightFuncBtn.titleLabel.font = FONT_SCALE(15);
        [rightFuncBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, __SCALE(65.f), __SCALE(30.f));
        [rightFuncBtn addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_Recharge;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
}
- (UIWebView *)telWebView{
    
    if (!_telWebView) {
        _telWebView = [[UIWebView alloc] init];
    }
    return _telWebView;
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
