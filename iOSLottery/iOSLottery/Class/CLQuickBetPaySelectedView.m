//
//  CLQuickBetPaySelectedView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLQuickBetPaySelectedView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "CLAccountInfoModel.h"
#import "CLQuickPaySelectedCell.h"
#import "CLQuickBetPublicHeaderView.h"
#import "CLAlertController.h"
#define CQQuickBetViewWidth (SCREEN_WIDTH - (2 * 30))

@interface CLQuickBetPaySelectedView()<UITableViewDelegate,UITableViewDataSource,CLAlertControllerDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
//@property (nonatomic, strong) UIActionSheet *serviceSheet;
@property (nonatomic, strong) CLAlertController *serviceActionSheet;

@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) CLQuickBetPublicHeaderView *headView;

@property (nonatomic, assign) NSInteger paymentSelected;


@end

@implementation CLQuickBetPaySelectedView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.headView];
        [self addSubview:self.mainTableView];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5.f;
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(CLQuickBetPublicHeaderViewHeight);
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headView.mas_bottom);
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updataPaymentWithData:(NSArray *)dataArr
{
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:dataArr];
    
    [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {

        make.height.mas_equalTo([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] * ((self.mainDataSource.count > 4) ? 4 : self.mainDataSource.count));
    }];
    [self layoutIfNeeded];
    [self.mainTableView reloadData];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLQuickPaySelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickBetPaySelectedCellID"];
    if (!cell) {
        cell = [[CLQuickPaySelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickBetPaySelectedCellID"];
    }
    [cell assignQuickBetCellWithMethod:self.mainDataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLAccountInfoModel *payChannelInfo = self.mainDataSource[indexPath.row];
    if (!payChannelInfo.useStatus) return;
    if(payChannelInfo.account_type_id != 999 && self.selectedPaymentBlock)
    {
        self.paymentSelected = indexPath.row;
        self.selectedPaymentBlock(payChannelInfo);
    }else if (payChannelInfo.account_type_id == 999){
        [self.serviceActionSheet show];
    }
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, CQQuickBetViewWidth, 150.f) style:UITableViewStylePlain];
        _mainTableView.bounces = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.rowHeight = 30.f;
    }
    return _mainTableView;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}

- (CLAlertController *)serviceActionSheet{
    
    if (!_serviceActionSheet) {
        
        _serviceActionSheet = [CLAlertController alertControllerWithTitle:@"请联系客服寻求帮助" message:nil style:CLAlertControllerStyleActionSheet delegate:self];
        _serviceActionSheet.buttonItems = @[@"取消", @"呼叫 400-689-2227"];
        _serviceActionSheet.destructiveButtonIndex = 1;
    }
    return _serviceActionSheet;
}
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (index == 1) {
        NSString *phoneNum = @"400-689-2227";// 电话号码
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]]];
    }
}
- (CLQuickBetPublicHeaderView *)headView{
    
    WS(_weakSelf)
    if (!_headView) {
        _headView = [CLQuickBetPublicHeaderView quickBetPublicHeaderViewWithTitle:@"支付方式" backBlock:^{
            if (_weakSelf.paymentBackBlock) _weakSelf.paymentBackBlock();
        }];
    }
    return _headView;
}






@end
