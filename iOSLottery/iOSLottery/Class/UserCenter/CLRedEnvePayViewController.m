//
//  CLRedEnvePayViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnvePayViewController.h"
#import "CLPaymentCell.h"
#import "CLBuyRedEnveModel.h"
#import "CLPaymentChannelInfo.h"
#import "UIImageView+CQWebImage.h"
#import "CLBuyRedEnveSelectModel.h"
#import "CQRedPacketPaySource.h"
#import "CLCheckProgessManager.h"
@interface CLRedEnvePayViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    CQRedPacketPaySource* paySource;
}

@property (nonatomic, strong) UITableView* payTableView;
@property (nonatomic, strong) UIButton* paymentButton;

@property (nonatomic) NSInteger cntAvailPayChannelIndex;

@property (nonatomic, assign) BOOL isgotoSafari;
@end

@implementation CLRedEnvePayViewController

- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    if (self.isgotoSafari) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.isgotoSafari = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"支付方式";
    
    [self.view addSubview:self.payTableView];
    
    [self.payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self configureAvaliablePaychannel];
}

- (void)paymentClicked:(id)sender {
    
    if ((self.payChannelArrays.count <= _cntAvailPayChannelIndex) ||
        (_cntAvailPayChannelIndex < 0)) {
        [self show:@"请选择支付方式"];
        return;
    }
    CLPaymentChannelInfo* channel = (CLPaymentChannelInfo*)self.payChannelArrays[_cntAvailPayChannelIndex];
    /** 判断是否实名认证 */
    WS(_weakSelf)
    if (channel.account_type_id != paymentChannelTypeWx) {
        [[CLCheckProgessManager shareCheckProcessManager] checkIsUserCertifyWithCallBack:^{
            [_weakSelf confirmPayMent];
        }];
    }else{
        [_weakSelf confirmPayMent];
    }
    
}

- (void)confirmPayMent{
    
    
    
    CLPaymentChannelInfo* channel = (CLPaymentChannelInfo*)self.payChannelArrays[_cntAvailPayChannelIndex];
    paymentChannelType paymentChannel = channel.account_type_id;
    //** 支付方式 */
    
    paySource = [[CQRedPacketPaySource alloc] init];
    
    paySource.total_amount = [NSString stringWithFormat:@"%lld",self.userSelectModel.amount_value * 100];
    paySource.need_pay_amount = paySource.total_amount;
    paySource.url_prefix = channel.backup_1;
    paySource.channel_type = channel.account_type_id;
    paySource.launch_class = self;
    paySource.transitionType = transitionTypeRedPacketPayment;
    
    paySource.redPaProgramId = [NSString stringWithFormat:@"%@:%lld",self.userSelectModel.red_program_id,self.userSelectModel.red_amount*100];
    paySource.redPaTradingInfo = @[@{@"channel_type":[NSString stringWithFormat:@"%zi",paymentChannel],@"amount":paySource.total_amount}];
    
    /** 红包购买 易连支付配置卡信息 */
    if (paySource.channel_type == paymentChannelTypeYiLian || (paySource.channel_type >= paymentChannelTypeSupportCardPreposing && paySource.channel_type < paymentChannelTypeOther)) {
        id viewController = [[NSClassFromString(@"CQCardFrontBindViewController") alloc] init];
        [viewController setValue:paySource forKey:@"paymentSource"];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    
    
    WS(_weakSelf);
    paySource.createPayForToken = ^(BOOL createState , id responData){
        if (createState) {
            //            _weakSelf.currentRechagreInfo = responData;
        } else {
            //            _weakSelf.needToShowLoadingAnimate = NO;
            [_weakSelf updatePayButtonState:YES];
            if ([responData isKindOfClass:NSString.class]) {
                [_weakSelf show:responData];
            }
        }
    };
    
    paySource.willOpenSafari = ^(){
        _weakSelf.isgotoSafari = YES;
    };
    
    [self updatePayButtonState:NO];
    [paySource runPayment];

}

- (void) updatePayButtonState:(BOOL)state {
    
    self.paymentButton.enabled = state;
    self.paymentButton.backgroundColor = state?THEME_COLOR:UNABLE_COLOR;
}

#pragma mark - setter

- (void) configureAvaliablePaychannel{
    
    //amount
    //limit
    
    double amount = (double)self.userSelectModel.amount_value;
    
    [self.paymentButton setTitle:[NSString stringWithFormat:@"支付%zi元", (long)amount] forState:UIControlStateNormal];
    
    NSInteger useIndex = -1;
    
    //1 遍历默认支付渠道
    __block NSInteger defaultIndex = -1;
    __block NSInteger avaliableIndex = -1;
    
    [self.payChannelArrays enumerateObjectsUsingBlock:^(CLPaymentChannelInfo* channel, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( (avaliableIndex == -1) && (channel.payLimitAmount <= amount)) {
            avaliableIndex = idx;
        }
        
        //查找默认
        
    }];
    
    if (defaultIndex != -1) {
        useIndex = defaultIndex;
    } else if(avaliableIndex != -1) {
        useIndex = avaliableIndex;
    }
    
    if (useIndex != -1 && useIndex < self.payChannelArrays.count) {
        CLPaymentChannelInfo* channel = self.payChannelArrays[useIndex];
        channel.isSelected = YES;
        self.cntAvailPayChannelIndex = useIndex;
    }
    
    [self.payTableView reloadData];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.payChannelArrays.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLRedEnvePayCellId"];
    if (!cell) {
        cell = [[CLPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLRedEnvePayCellId"];
    }
    CLPaymentChannelInfo* channel = self.payChannelArrays[indexPath.row];
    
    cell.textLbl.text = channel.account_type_nm;
    cell.subTextLbl.text = channel.memo;
    if (channel.account_type_id == paymentChannelTypeAccountBalance) {
        
        if (channel.balance && channel.balance.length > 0) {
            cell.markTextLbl.text = [NSString stringWithFormat:@"%@元", channel.balance];
        }
    }
    cell.cellType = PaymentCellTypeSelect;
    cell.onlyShowTitle = !([channel.memo isKindOfClass:[NSString class]] && [channel.memo length] > 0);
    [cell.icon setImageWithURL:[NSURL URLWithString:channel.img_url]];
    cell.isSelectState = channel.isSelected;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPaymentChannelInfo* channel = self.payChannelArrays[indexPath.row];
    if (channel.isUnused) return;
    ((CLPaymentChannelInfo*)self.payChannelArrays[self.cntAvailPayChannelIndex]).isSelected = NO;
    channel.isSelected = YES;
    self.cntAvailPayChannelIndex = indexPath.row;
    [self.payTableView reloadData];
}

#pragma mark -

- (UITableView *)payTableView {
    
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _payTableView.rowHeight = 50.f;
        
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, __SCALE(80))];
        footerView.backgroundColor = [UIColor clearColor];
        [footerView addSubview:self.paymentButton];
        [self.paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footerView);
            make.width.equalTo(footerView).multipliedBy(.8f);
            make.height.mas_equalTo(__SCALE(35));
        }];
        _payTableView.tableFooterView = footerView;
        
    }
    return _payTableView;
}

- (UIButton *)paymentButton {
    
    if (!_paymentButton) {
        _paymentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_paymentButton setTitle:@"支付" forState:UIControlStateNormal];
        _paymentButton.titleLabel.font = FONT_SCALE(15);
        _paymentButton.backgroundColor = THEME_COLOR;
        [_paymentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_paymentButton addTarget:self action:@selector(paymentClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paymentButton;
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
