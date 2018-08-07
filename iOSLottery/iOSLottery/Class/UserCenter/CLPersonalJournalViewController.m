//
//  CLPersonalJournalViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalJournalViewController.h"
#import "UILabel+CLAttributeLabel.h"

#import "CQUserBalanceHeaderView.h"
#import "CLJournalRecordCell.h"
#import "CLJournalSectionHeadView.h"

#import "UIScrollView+CLRefresh.h"
#import "CLAccountJournalAPI.h"

#import "CLUserCashJournalModel.h"
#import "CLUserCashJournalDeailModel.h"

#import "CLPersJourDetailViewController.h"

#import "CLUserCenterPageConfigure.h"
#import "UINavigationController+CLDestroyCurrentController.h"
#import "CLAllAlertInfo.h"
#import "CLAlertPromptMessageView.h"

#import "CLEmptyPageService.h"
@interface CLPersonalJournalViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSString *lastDayTime;
@property (nonatomic, assign) BOOL isNOFirstRequest;

@property (nonatomic, strong) CLAccountJournalAPI* journalAPI;
@property (nonatomic, strong) CQUserBalanceHeaderView* headerView;
@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;
@property (nonatomic, strong) CLEmptyPageService *emptyService;

@end

@implementation CLPersonalJournalViewController


#pragma mark - ViewPeriod

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navTitleText = @"余额";
//    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(106));
    }];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom).offset(- 0);
    }];
    [self.mainTableView startRefreshAnimating];
}

- (void)queryAction
{

    [self.alertPromptMessageView showInView:self.view.window];
}

#pragma mark - userBalanceHeaderViewClick
- (void)userBalanceHeaderViewClickAction:(userBalanceHeaderViewClickStyle)clickStyle
{
    switch (clickStyle) {
        case userBalanceHeaderViewDepositClick:
        {
            //** 用户充值事件 */
            [CLUserCenterPageConfigure pushVoucherCenterViewController];
        }
            break;
        case userBalanceHeaderViewWithdrawClick:
        {
            //** 用户提现事件 */
            [CLUserCenterPageConfigure pushDFViewController];
        }
            break;
        case userBalanceHeaderViewConversionClick:
        {
            //** 用户购买红包事件 */
            [CLUserCenterPageConfigure pushBuyRedEnvolopeViewController];
        }
            break;
    }
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.journalAPI.cashLog.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CLUserCashJournalModel* m = self.journalAPI.cashLog[section];
    return m.flows.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CLJournalSectionHeadView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CLJournalSectionHeadViewId"];
    if (!headView) {
        headView = [[CLJournalSectionHeadView alloc] initWithReuseIdentifier:@"CLJournalSectionHeadViewId"];
    }
    CLUserCashJournalModel* m = self.journalAPI.cashLog[section];
    headView.timeLbl.text = m.title;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return __SCALE(20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  __SCALE(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLJournalRecordCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLJournalRecordCellId"];
    if (!cell) {
        cell = [[CLJournalRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLJournalRecordCellId"];
    }
    CLUserCashJournalModel* m = self.journalAPI.cashLog[indexPath.section];
    [cell configureJournalData:m.flows[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CLPersJourDetailViewController* vc = [[CLPersJourDetailViewController alloc] init];
    CLUserCashJournalModel* m = self.journalAPI.cashLog[indexPath.section];
    [vc assignDataSource:m.flows[indexPath.row]];    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CLRequestCallBackDelegate

/** 请求成功 */
- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.journalAPI updateJournalListArrayWith:[request.urlResponse.resp firstObject]];
        
        [self.headerView assignDataWithObject:[self.journalAPI accountInfo]];
        
        [self.mainTableView reloadData];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
    [self.emptyService showEmptyWithType:(self.journalAPI.cashLog.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.mainTableView];
    
    [self endRefreshing];
}

/** 请求失败 */
- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self.emptyService showEmptyWithType:CLEmptyTypeNoData superView:self.mainTableView];
    [self endRefreshing];
}

- (void) endRefreshing {
    
    [_mainTableView stopRefreshAnimating];
    [_mainTableView stopLoadingAnimating];

    
    if ((self.mainTableView.contentSize.height < self.mainTableView.bounds.size.height) || !self.journalAPI.isCanLoadMore) {
        [_mainTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_mainTableView resetNoMoreData];
    }
}

#pragma mark - getter

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        WS(_weakSelf);
        [_mainTableView addRefresh:^{
            [_weakSelf.journalAPI refresh];
        }];
        
        [_mainTableView addLoading:^{
            [_weakSelf.journalAPI nextPage];
        }];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}
- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setTitle:@"余额说明" forState:UIControlStateNormal];
        rightFuncBtn.titleLabel.font = FONT_SCALE(15);
        [rightFuncBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, __SCALE(65.f), __SCALE(30.f));
        [rightFuncBtn addTarget:self action:@selector(queryAction) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLAccountJournalAPI *)journalAPI {
    
    if (!_journalAPI) {
        _journalAPI = [[CLAccountJournalAPI alloc] init];
        _journalAPI.delegate = self;
    }
    return _journalAPI;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_Balance;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
}

- (CQUserBalanceHeaderView *)headerView{
    
    if (!_headerView) {
        
        WS(_weakSelf)
        _headerView = [[CQUserBalanceHeaderView alloc] init];
        _headerView.backgroundColor = UIColorFromRGB(0xffffff);
        _headerView.clickActionBlock = ^(userBalanceHeaderViewClickStyle clickStyle) {
            [_weakSelf userBalanceHeaderViewClickAction:clickStyle];
        };
        
    }
    return _headerView;
}

- (CLEmptyPageService *)emptyService{
    
    if (!_emptyService) {
        _emptyService = [[CLEmptyPageService alloc] init];
        _emptyService.contentString = @"暂无流水记录";
        _emptyService.emptyImageName = @"empty_PersonalJournal.png";
    }
    return _emptyService;
}
#pragma mark dealloc 

- (void)dealloc {
    
    
    if (_journalAPI) {
        _journalAPI.delegate = nil;
        [_journalAPI cancel];
    }
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
