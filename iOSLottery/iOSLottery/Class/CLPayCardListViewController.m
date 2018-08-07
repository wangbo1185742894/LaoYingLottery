//
//  CLPayCardListViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLPayCardListViewController.h"
#import "CQImgAndTextView.h"
#import "CLPayCardListCell.h"
#import "CLAllJumpManager.h"
#import "CLBankCardListAPI.h"
#import "CKLotteryPaySource.h"
#import "CLLoadingAnimationView.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLBankCardInfoModel.h"
#import "CLLotteryBespeakService.h"
@interface CLPayCardListViewController ()<UITableViewDelegate, UITableViewDataSource, CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UILabel *headLabel;//头部视图
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) CQImgAndTextView *addBankCardView;
@property (nonatomic, strong) UIButton *showBankListButton;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) CLBankCardListAPI *request;
@property (nonatomic, strong) NSIndexPath* cardSelectIndexPath;
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, assign) BOOL isGotoPayBack;

@property (nonatomic, copy) void(^success)(id);
@property (nonatomic, assign) BOOL isToast;
@end

@implementation CLPayCardListViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (!self.isGotoPayBack) {
        
        self.request.account_type_id = [NSString stringWithFormat:@"%zi", self.lotteryPaySource.channel_type];
        [self showLoading];
        [self.request start];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isToast = NO;
    self.navTitleText = @"选择支付银行卡";
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = self.headView;
    self.mainTableView.tableFooterView = self.footerView;
    
    // Do any additional setup after loading the view.
}

- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    WS(_weakSelf)
    if (self.isGotoPayBack) {
            
        // 跳转彩票点抢单
        [CLLotteryBespeakService runBespeakServiceWithOrderId:_weakSelf.payConfigure[@"order_id"]  completion:^{
            
            [self.navigationController popViewControllerAnimated:NO];
            [_weakSelf pushOrderOrFollow];
        }];
        self.isGotoPayBack = NO;
    }
}

- (void)assignHeadData{
    
    CGFloat needPayAmout = [self.lotteryPaySource.need_pay_amount floatValue] / 100.f;
    NSString *payAccount = [NSString stringWithFormat:@"支付金额：%@元", @(needPayAmout)];
    
    AttributedTextParams *param = [AttributedTextParams attributeRange:NSMakeRange(5, payAccount.length - 5) Color:THEME_COLOR];
    [self.headLabel attributeWithText:payAccount controParams:@[param]];
}

- (void)verifySuccessForMethod:(void (^)(id))callBack{
    
    self.success = callBack;
}
- (void)setPersonalPaymentSource:(CKPaymentBaseSource *)source{
    
    self.lotteryPaySource = (CKLotteryPaySource *)source;
}

#pragma mark - 跳转详情页
- (void)pushOrderOrFollow{
    
    if (self.orderType == 0) {
        
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLLottBetOrdDetaViewController_push/%@", self.payConfigure[@"order_id"]]];
    }else if (self.orderType == 1){
        [[CLAllJumpManager shareAllJumpManager] openDestoryWithURL:[NSString stringWithFormat:@"CLFollowDetailViewController_push/%@", self.payConfigure[@"order_id"]]];
    }
}

- (void)assignButtonEnable:(BOOL)enable{
    
    self.payButton.enabled = enable;
    self.payButton.backgroundColor = enable ? UIColorFromRGB(0xe63222) : UNABLE_COLOR;
}

#pragma mark ------------ event Response ------------
//支持银行卡列表展示 (WebView)
- (void)showBanklistClick:(id)sender {
    
    [[CLAllJumpManager shareAllJumpManager] open:url_BankCard];
}
- (void)gotoPay:(UIButton *)btn
{
    CLBankCardInfoModel* bankInfo = self.dataSource[self.cardSelectIndexPath.row];
    self.lotteryPaySource.card_no = bankInfo.card_no;
    self.lotteryPaySource.launch_class = self;
    
    !self.success ? : self.success(bankInfo.card_no);

    
//    [self.lotteryPaySource runPayment];
}
#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        [self.request dealingWithCardListInfomationWithDict:[request.urlResponse.resp firstObject]];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[self.request pullData]];
    if (self.dataSource.count > 0) {
        self.cardSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [self assignHeadData];
    
    [self assignButtonEnable:(self.dataSource.count > 0)];
    
    if (!self.isToast && self.dataSource.count == 0) {
        
        self.isToast = YES;
        [self show:@"根据支付渠道要求，你需要先绑定银行卡"];
    }
    
    [self.mainTableView reloadData];
    [self stopLoading];
}
- (void)requestFailed:(CLBaseRequest *)request{
    
    [self show:request.urlResponse.errorMessage];
    [self stopLoading];
}

#pragma mark ------------ tableview delegate ------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"CLPayCardListCell";
    CLPayCardListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLPayCardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectedBackCard = (indexPath == self.cardSelectIndexPath);
    [cell assignData:self.dataSource[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cardSelectIndexPath = indexPath;
    [self.mainTableView reloadData];
}
#pragma mark ------------ getter Mothed ------------
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _mainTableView.estimatedRowHeight = 200;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _mainTableView;
}
- (UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(45.f))];
        _headView.backgroundColor = UIColorFromRGB(0xffffff);
        [_headView addSubview:self.headLabel];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headLabel.frame), SCREEN_WIDTH, __SCALE(5.f))];
        lineView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        [_headView addSubview:lineView];
    }
    return _headView;
}
- (UILabel *)headLabel{
    
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(__SCALE(10.f), 0, SCREEN_WIDTH - __SCALE(20.f), __SCALE(40.f))];
        _headLabel.textColor = UIColorFromRGB(0x333333);
        _headLabel.textAlignment = NSTextAlignmentLeft;
        _headLabel.font = FONT_SCALE(13.f);
    }
    return _headLabel;
}
- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = UIColorFromRGB(0xefefef);
        _footerView.frame = __Rect(0, 0, SCREEN_WIDTH, __SCALE(157));
        [_footerView addSubview:self.addBankCardView];
        [_footerView addSubview:self.showBankListButton];
        [_footerView addSubview:self.payButton];
    }
    return _footerView;
}

- (CQImgAndTextView *)addBankCardView
{
    if (!_addBankCardView) {
        _addBankCardView = [[CQImgAndTextView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(60.f))];
        _addBankCardView.title = @"添加银行卡";
        _addBankCardView.backgroundColor = UIColorFromRGB(0xffffff);
        _addBankCardView.titleColor = UIColorFromRGB(0xbbbbbb);
        _addBankCardView.titleFont = FONT_SCALE(14);
        _addBankCardView.img = [UIImage imageNamed:@"accountAddCard"];
        _addBankCardView.imgToHeightScale = .15f;
        WS(_weakSelf)
        _addBankCardView.tapGestureHandler = ^{
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLAddBankCardViewController_push/0/%zi/", _weakSelf.lotteryPaySource.channel_type]];
        };
    }
    return _addBankCardView;
}

- (UIButton *)showBankListButton
{
    if (!_showBankListButton) {
        _showBankListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBankListButton.frame = __Rect(0, __Obj_YH_Value(self.addBankCardView) + __SCALE(10.f), SCREEN_WIDTH, 30);
        [_showBankListButton setTitle:@"查看可支持银行卡" forState:UIControlStateNormal];
        [_showBankListButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _showBankListButton.titleLabel.font = FONT_SCALE(12.f);
        [_showBankListButton addTarget:self action:@selector(showBanklistClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBankListButton;
}
- (UIButton *)payButton{
    
    if (!_payButton) {
        _payButton = [[UIButton alloc] initWithFrame:CGRectMake(__SCALE(10.f), self.footerView.frame.size.height - __SCALE(37.f) - __SCALE(10.f), SCREEN_WIDTH - __SCALE(20.f), __SCALE(37.f))];
        [_payButton setTitle:@"支付" forState:UIControlStateNormal];
        _payButton.backgroundColor = UIColorFromRGB(0xe63222);
        [_payButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _payButton.titleLabel.font = FONT_SCALE(15.f);
        [_payButton addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
        _payButton.layer.cornerRadius = __SCALE(2.f);
        _payButton.layer.masksToBounds = YES;
    }
    
    return _payButton;
}

- (CLBankCardListAPI *)request{
    
    if (!_request) {
        _request = [[CLBankCardListAPI alloc] init];
        _request.delegate = self;
        _request.type = @"0";
    }
    return _request;
}


- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
