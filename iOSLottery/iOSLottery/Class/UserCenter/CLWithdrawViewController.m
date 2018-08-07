//
//  CLWithdrawViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawViewController.h"
#import "CLConfigMessage.h"
#import "CLTools.h"
#import "UIScrollView+CLRefresh.h"
#import "CLOrderListSegmentControl.h"
#import "CLWithdrawBankCardCell.h"
#import "CLWithdrawCashCell.h"
#import "CQUserCashWithdrawFooterView.h"
#import "CQUsePaymentPwdViewController.h"

#import "CLWithdrawFollowCell.h"
#import "CLWithdrawAddBankCardCell.h"
#import "CLWithdrawHeaderView.h"

#import "CLWithdrawListAPI.h"
#import "CLWithdrawInfoModel.h"

#import "CLWithdrawFollowAPI.h"
#import "CLWithdrawHeaderView.h"
#import "CLWithdrawFollowModuleModel.h"

#import "CLWithdrawCashAPI.h"
#import "CLWithdrawBankCardViewController.h"
#import "CLWithdrawDetailViewController.h"

#import "CLPersonalMsgHandler.h"
#import "CLUserCenterPageConfigure.h"
#import "CLSettingAdapter.h"

#import "CLBankCardInfoModel.h"
#import "CLWithdrawSuccessViewController.h"
#import "CLCheckProgessManager.h"

#import "UINavigationItem+CLNavigationCustom.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"
#import "CLEmptyPageService.h"
#import "UINavigationController+CLDestroyCurrentController.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
#import "CLAllJumpManager.h"
@interface CLWithdrawViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLOrderListSegmentControlDelegate,CLWithdrawBankCardChangeDelegate,CLWithdrawCashCellDelegate>

@property (nonatomic, strong) CLOrderListSegmentControl* sectionHeaderView;
@property (nonatomic, strong) UITableView* withdrawTableView;
@property (nonatomic, strong) UITableView* withdrawFollowTableView;
@property (nonatomic, strong) CQUserCashWithdrawFooterView* footerView;
@property (nonatomic, strong) CQFooterAction* withdrawBtn;

@property (nonatomic) NSInteger withdrawCardIndex;

@property (nonatomic, strong) CLWithdrawListAPI* withdrawInfoAPI;
@property (nonatomic, strong) CLWithdrawFollowAPI* withdrawFollowAPI;
@property (nonatomic, strong) CLWithdrawCashAPI* withdrawCashAPI;

@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;
@property (nonatomic) long long userWithdrawMoney;

@property (nonatomic, strong) CLEmptyPageService *emptyPageService;//空数据页面
@property (nonatomic, strong) CQFooterAction* suppleBankListAction;


@end

@implementation CLWithdrawViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.withdrawInfoAPI start];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"提现";
    // Do any additional setup after loading the view.
    self.withdrawCardIndex = 0;
    self.userWithdrawMoney = - 1;
    [self.view addSubview:self.sectionHeaderView];
    [self.view addSubview:self.withdrawTableView];
    [self.view addSubview:self.withdrawFollowTableView];
    
    [self.sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(40));
        make.top.equalTo(self.view).offset(0);
    }];
    
    [self.withdrawTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.sectionHeaderView.mas_bottom);
    }];
    
    [self.withdrawFollowTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.withdrawTableView);
    }];

    self.withdrawFollowTableView.hidden = YES;
    self.sectionHeaderView.selectedIndex = 0;
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
}

#pragma mark - eventRespone
- (void)queryAction:(UIButton *)btn{
    
    [self.alertPromptMessageView showInView:self.view.window];
}
//提现按钮
- (void)payNextClickButton:(id)sender {
    
    if (self.userWithdrawMoney == -1) {
        [self show:@"请输入提现金额"];
        return;
    }
    
    if (self.userWithdrawMoney == 0) {
        [self show:@"提现金额应大于0"];
        return;
    }
    if (self.withdrawCardIndex < 0) {
        
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLAddBankCardViewController_push/1//"]];
    }else if (![CLPersonalMsgHandler identityAuthentication]){
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLUserCertifyViewController_push/"]];
    }else if (![CLSettingAdapter hasPayPwdStatus]){
        [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CQSettingPaymentPwdViewController_present/"]];
    }else{
        [self confirmWithdraw];
    }
}
#pragma mark - 确定提现
- (void)confirmWithdraw{
    
    if (self.userWithdrawMoney <= 1000) {
        // 金额 小于 10元的时候 弹窗提醒
        
        [self withdrawOperation];
        return;
    }else{
        [self withdrawOperation];
    }
}
- (void) withdrawOperation {
    
    CLMainTabbarViewController *mainVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    //有支付密码 验证
    WS(_weakSelf)
    CQUsePaymentPwdViewController* paymentVC = [[CQUsePaymentPwdViewController alloc] initWithCommonParam:snapshot(mainVC.view)];
    paymentVC.passwordCheckSuccess = ^{
        
        _weakSelf.withdrawCashAPI.amount = [NSString stringWithFormat:@"%lld",self.userWithdrawMoney];
        _weakSelf.withdrawCashAPI.channel_type = [_weakSelf.withdrawInfoAPI getChannelType];
        _weakSelf.withdrawCashAPI.channel_info = [[_weakSelf.withdrawInfoAPI pullChannelInfos][_weakSelf.withdrawCardIndex] mj_keyValues];
        
        [_weakSelf showLoading];
        [_weakSelf.withdrawCashAPI start];
        
    };
    [self presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:paymentVC] animated:NO completion:nil];
}

#pragma mark - CLWithdrawCashCellDelegate

- (void)userInputWithdrawCash:(NSString*)money {
    
    if (money.length == 0) {
        self.userWithdrawMoney = - 1;//空数据
    } else {
        self.userWithdrawMoney = [NSDecimalNumber decimalNumberWithString:money].longLongValue;
    }
}

#pragma mark - CLWithdrawBankCardChangeDelegate

//选择不同银行卡回调
- (void)useSelectedBankCardIndex:(NSInteger)index {
    
    self.withdrawCardIndex = index;
    [self.withdrawTableView reloadData];
}

//提现银行卡因添加操作更改回调
- (void) bankCardsChange:(NSArray*)cards {
    
    
}

#pragma mark - CLOrderListSegmentControlDelegate

- (void)segmentControlSelectChange:(NSInteger)selectedIndex {
    
    self.withdrawTableView.hidden = !(selectedIndex == 0);
    self.withdrawFollowTableView.hidden = (selectedIndex == 0);
    
    if (selectedIndex == 1) {
        if ([self.withdrawFollowAPI pullFollowData].count == 0) {
            [self.withdrawFollowTableView startRefreshAnimating];
        }
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.withdrawInfoAPI) {
        //提现信息
        if (request.urlResponse.success) {
            [self.withdrawInfoAPI dealingWithDrawDataFromDict:[request.urlResponse.resp firstObject]];
            
            
            CLWithdrawAccountInfo *accountModel = self.withdrawInfoAPI.accountData;
            if ([accountModel isKindOfClass:[CLWithdrawAccountInfo class]] && accountModel.withdraw_message && accountModel.withdraw_message.length > 0) {
                self.suppleBankListAction = [CQFooterAction initWithTitle:accountModel.withdraw_message actionStyle:CQFooterActionEvent frame:__Rect(0, 0, SCREEN_WIDTH, 30)];
            }else{
                self.suppleBankListAction = [CQFooterAction initWithTitle:@"该笔手续费由老鹰彩票承担" actionStyle:CQFooterActionEvent frame:__Rect(0, 0, SCREEN_WIDTH, 30)];
            }
            self.suppleBankListAction.titleColor = UIColorFromRGB(0xe00000);
            self.suppleBankListAction.font = FONT_SCALE(12);
            self.footerView.items = @[self.suppleBankListAction,self.withdrawBtn];
            
            [self.withdrawTableView reloadData];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    } else if (request == self.withdrawFollowAPI) {
        
        if (request.urlResponse.success) {
            [self.withdrawFollowAPI dealingWithFollowDict:[request.urlResponse.resp firstObject]];
            [self.withdrawFollowTableView reloadData];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
        [self.emptyPageService showEmptyWithType:([self.withdrawFollowAPI pullFollowData].count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.withdrawFollowTableView];
        [self endRefreshing];
    } else if (request == self.withdrawCashAPI) {
        
        if (request.urlResponse.success && request.urlResponse.resp) {
            [self.navigationController pushDestroyViewController:[CLWithdrawSuccessViewController withdrawSuccessWithTitile:@"提现申请已提交" method:request.urlResponse.resp definiteAction:^{
                
            }] animated:YES];
        }else{
            [self show:request.urlResponse.errorMessage];
        }
        [self stopLoading];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    if (request == self.withdrawFollowAPI) {
        [self endRefreshing];
        [self.emptyPageService showEmptyWithType: CLEmptyTypeNoData superView:self.withdrawFollowTableView];
    }else if (request == self.withdrawCashAPI){
        [self stopLoading];
    }else if (request == self.withdrawInfoAPI){
        [self stopLoading];
    }
}

- (void)endRefreshing {
    [_withdrawFollowTableView stopRefreshAnimating];
    [_withdrawFollowTableView stopLoadingAnimating];
    
    if ((self.withdrawFollowTableView.contentSize.height < self.withdrawFollowTableView.bounds.size.height) &&
        !self.withdrawFollowAPI.canLoadMore  ) {
        [_withdrawFollowTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_withdrawFollowTableView resetNoMoreData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.withdrawTableView) {
        return 2;
    }
    return [self.withdrawFollowAPI pullFollowData].count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.withdrawFollowTableView) {
        return [CLWithdrawHeaderView headerHeight];
    }
    return (section == 0)?5:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView == self.withdrawFollowTableView) {return 0;}
    
    return (section == 0)?5:0;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.withdrawFollowTableView) {
        CLWithdrawHeaderView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CLWithdrawHeaderViewId"];
        if (!headView) {
            headView = [[CLWithdrawHeaderView alloc] initWithReuseIdentifier:@"CLWithdrawHeaderViewId"];
        }
        CLWithdrawFollowModuleModel* module = [self.withdrawFollowAPI pullFollowData][section];
        headView.timeLbl.text = module.title;
        return headView;
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf1f1f1);
        return view;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return view;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.withdrawFollowTableView) {
        CLWithdrawFollowModuleModel* module = [self.withdrawFollowAPI pullFollowData][section];
        return module.flows.count;
    }
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.withdrawFollowTableView) {
        return [CLWithdrawFollowCell cellHeight];
    }
    
    if (indexPath.section == 0) {
        return [CLWithdrawBankCardCell cellHeight];
    } else if (indexPath.section == 1) {
        return [CLWithdrawCashCell cellHeight];
    } else {
        
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.withdrawFollowTableView) {
        
        CLWithdrawFollowCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLWithdrawFollowCellId"];
        if (!cell) {
            cell = [[CLWithdrawFollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLWithdrawFollowCellId"];
        }
        CLWithdrawFollowModuleModel* module = [self.withdrawFollowAPI pullFollowData][indexPath.section];
        [cell configureWithFollow:module.flows[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 0) {
        id draw = [self.withdrawInfoAPI bankCardDataAtIndex:&_withdrawCardIndex];
        if (draw == nil) {
            CLWithdrawAddBankCardCell* cell1 = [tableView dequeueReusableCellWithIdentifier:@"CLWithdrawAddBankCardCellId"];
            if (!cell1) {
                cell1 = [[CLWithdrawAddBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLWithdrawAddBankCardCellId"];
            }
            return cell1;
        } else {
            CLWithdrawBankCardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLWithdrawBankCardCellId"];
            if (!cell) {
                cell = [[CLWithdrawBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLWithdrawBankCardCellId"];
            }
            [cell configureData:draw];
            
            return cell;
        }
    } else {
        CLWithdrawCashCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLWithdrawCashCellId"];
        if (!cell) {
            cell = [[CLWithdrawCashCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLWithdrawCashCellId"];
        }
        cell.delegate = self;
        CLWithdrawAccountInfo* account = [self.withdrawInfoAPI accountData];
        if (account == nil) {
            cell.withdrawCashLbl.text = @"";
            cell.availWithdrawCash = 0;
        } else {
            cell.withdrawCashLbl.text = [NSString stringWithFormat:@"可提现金额 %@",account.balancestr];
            cell.availWithdrawCash = account.balance;
        }
        return cell;
    }
    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.withdrawFollowTableView) {
        //提现记录
        CLWithdrawFollowModuleModel* module = [self.withdrawFollowAPI pullFollowData][indexPath.section];
        CLWithdrawDetailViewController* vc = [[CLWithdrawDetailViewController alloc] init];
        vc.model = module.flows[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    } else {
        //申请提现
        if (indexPath.section == 0) {
            //切换银行卡
            id draw = [self.withdrawInfoAPI bankCardDataAtIndex:&_withdrawCardIndex];
            if (draw == nil) {
                //添加银行卡
                [CLUserCenterPageConfigure pushAddBankCardViewController];
            } else {
                CLWithdrawBankCardViewController* cardVC = [[CLWithdrawBankCardViewController alloc] initWithCardIndex:self.withdrawCardIndex bankCards:[self.withdrawInfoAPI pullChannelInfos]];
                cardVC.delegate = self;
                [self.navigationController pushViewController:cardVC animated:YES];
            }
            
        }
    }
}


#pragma mark - getter

- (UITableView *)withdrawTableView {
    
    if (!_withdrawTableView) {
        _withdrawTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _withdrawTableView.delegate = self;
        _withdrawTableView.dataSource = self;
        _withdrawTableView.scrollEnabled = NO;
        _withdrawTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _withdrawTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _withdrawTableView.tableFooterView = self.footerView;
        
    }
    return _withdrawTableView;
}

- (UITableView *)withdrawFollowTableView {
    
    if (!_withdrawFollowTableView) {
        _withdrawFollowTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _withdrawFollowTableView.delegate = self;
        _withdrawFollowTableView.dataSource = self;
        _withdrawFollowTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _withdrawFollowTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS(_weakSelf);
        [_withdrawFollowTableView addRefresh:^{
            
            [_weakSelf.withdrawFollowAPI refresh];
        }];
        
        [_withdrawFollowTableView addLoading:^{
            
            [_weakSelf.withdrawFollowAPI nextPage];
        }];
    }
    return _withdrawFollowTableView;
}

- (CLOrderListSegmentControl *)sectionHeaderView {
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[CLOrderListSegmentControl alloc] initWithFrame:CGRectZero];
        _sectionHeaderView.has_VerticalLine = YES;
        [_sectionHeaderView setItems:@[@"申请提现",@"提现记录"]];
        _sectionHeaderView.delegate = self;
    }
    return _sectionHeaderView;
}

- (CQUserCashWithdrawFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[CQUserCashWithdrawFooterView alloc] init];
        
        WS(_weakSelf)
        self.withdrawBtn = [CQFooterAction initWithTitle:@"提交申请" actionStyle:CQFooterActionEvent frame:__Rect(__SCALE(10.f), 0, SCREEN_WIDTH - __SCALE(10.f) * 2, __SCALE(37.f))];
        self.withdrawBtn.titleColor = [UIColor whiteColor];
        self.withdrawBtn.font = FONT_SCALE(15.f);
        self.withdrawBtn.backgroundColor = THEME_COLOR;
        self.withdrawBtn.footerActionEvent = ^{
            [_weakSelf payNextClickButton:nil];
        };
        _footerView.topMarginValues = @[@(0),@(5)];
    }
    return _footerView;
}


- (CLWithdrawListAPI *)withdrawInfoAPI {
    
    if (!_withdrawInfoAPI) {
        _withdrawInfoAPI = [[CLWithdrawListAPI alloc] init];
        _withdrawInfoAPI.delegate = self;
    }
    return _withdrawInfoAPI;
}

- (CLWithdrawFollowAPI *)withdrawFollowAPI {
    
    if (!_withdrawFollowAPI) {
        _withdrawFollowAPI = [[CLWithdrawFollowAPI alloc] init];
        _withdrawFollowAPI.delegate = self;
    }
    return _withdrawFollowAPI;
}

- (CLWithdrawCashAPI *)withdrawCashAPI {
    
    if (!_withdrawCashAPI) {
        _withdrawCashAPI = [[CLWithdrawCashAPI alloc] init];
        _withdrawCashAPI.delegate = self;
    }
    return _withdrawCashAPI;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setTitle:@"提现说明" forState:UIControlStateNormal];
        rightFuncBtn.titleLabel.font = FONT_SCALE(15);
        [rightFuncBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, __SCALE(65.f), __SCALE(30.f));
        [rightFuncBtn addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.butTitleArray = @[];
        _emptyPageService.contentString = @"暂无提现记录";
        _emptyPageService.emptyImageName = @"empty_withdraw.png";
    }
    return _emptyPageService;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_withdraw;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
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
