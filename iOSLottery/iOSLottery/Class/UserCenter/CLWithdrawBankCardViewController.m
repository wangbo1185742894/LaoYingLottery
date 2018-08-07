//
//  CLWithdrawBankCardViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawBankCardViewController.h"
#import "CLWithdrawListAPI.h"
#import "CLWithdrawBankCardCell.h"
#import "CQUserCashWithdrawFooterView.h"
#import "CLAllJumpManager.h"
#import "CLUserCenterPageConfigure.h"
#import "UIScrollView+CLRefresh.h"
@interface CLWithdrawBankCardViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) CQUserCashWithdrawFooterView* footerView;

@property (nonatomic, strong) CLWithdrawListAPI* withdrawInfoAPI;

@property (nonatomic, strong) NSMutableArray* withdrawCards;

@property (nonatomic) NSInteger defaultSelectCardIndex;

@end

@implementation CLWithdrawBankCardViewController

- (instancetype) initWithCardIndex:(NSInteger)index bankCards:(NSArray*)cards {
    self = [super init];
    if (self) {
        self.defaultSelectCardIndex = index;
        self.bankCards = cards;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.mainTableView startRefreshAnimating];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"选择银行卡";
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setBankCards:(NSArray *)bankCards {
    
    if (self.withdrawCards.count > 0) {
        [self.withdrawCards removeAllObjects];
    }
    
    [self.withdrawCards addObjectsFromArray:bankCards];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.withdrawInfoAPI dealingWithDrawDataFromDict:[request.urlResponse.resp firstObject]];
        self.bankCards = [self.withdrawInfoAPI pullChannelInfos];
        [self.mainTableView reloadData];
    }
    [self.mainTableView stopRefreshAnimating];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self.mainTableView stopRefreshAnimating];
}

#pragma mark - private

//添加银行卡
- (void)addBankCard {
    
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLAddBankCardViewController_push/1//"]];
}

//显示提现支持银行卡
- (void)showSuppleBankList {
    
    [[CLAllJumpManager shareAllJumpManager] open:url_WithdrawBankCard];
}

#pragma mark - tableView delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.withdrawCards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLWithdrawBankCardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLWithdrawBankCardCell"];
    if (!cell) {
        cell = [[CLWithdrawBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLWithdrawBankCardCell"];
    }
    [cell configureData:self.withdrawCards[indexPath.row]];
    cell.cellStyle = CLWithdrawBankCardCellSelect;
    cell.isSelect = (indexPath.row == self.defaultSelectCardIndex);
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.defaultSelectCardIndex = indexPath.row;
    
    if ([self.delegate respondsToSelector:@selector(useSelectedBankCardIndex:)]) {
        [self.delegate useSelectedBankCardIndex:self.defaultSelectCardIndex];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = [CLWithdrawBankCardCell cellHeight];
        _mainTableView.tableFooterView = self.footerView;
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        WS(_weakSelf)
        [_mainTableView addRefresh:^{
            
            [_weakSelf.withdrawInfoAPI start];
        }];
    }
    return _mainTableView;
}

- (NSMutableArray *)withdrawCards {
    
    if (!_withdrawCards) {
        _withdrawCards = [NSMutableArray new];
    }
    return _withdrawCards;
}

- (CQUserCashWithdrawFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[CQUserCashWithdrawFooterView alloc] init];
        
        WS(_weakSelf)
        CQFooterAction* addBankCardAction = [CQFooterAction initWithTitle:@"" actionStyle:CQFooterActionAppendBankCard frame:__Rect(0, 0, 0, 1)];
        
        addBankCardAction.footerActionEvent = ^{
            [_weakSelf addBankCard];
        };
        
        CQFooterAction* suppleBankListAction = [CQFooterAction initWithTitle:@"查看支持银行卡列表" actionStyle:CQFooterActionEvent frame:__Rect(0, 0, SCREEN_WIDTH, 30)];
        suppleBankListAction.titleColor = [UIColor blueColor];
        suppleBankListAction.font = FONT_SCALE(12);
        suppleBankListAction.footerActionEvent = ^{
            [_weakSelf showSuppleBankList];
        };
        
        _footerView.topMarginValues = @[@(0),@(5)];
        _footerView.items = @[addBankCardAction,suppleBankListAction];
        
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
