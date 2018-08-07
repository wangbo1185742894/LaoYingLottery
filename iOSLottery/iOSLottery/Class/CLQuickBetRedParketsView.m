//
//  CLQuickBetRedParketsView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLQuickBetRedParketsView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CLQuickPaySelectedCell.h"
#import "CLQuickBetPublicHeaderView.h"
#import "CLQuickRedPacketsModel.h"
#define CQQuickBetViewWidth (SCREEN_WIDTH - (2 * 30))

@interface CLQuickBetRedParketsView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) CLQuickBetPublicHeaderView *headView;

@end

@implementation CLQuickBetRedParketsView

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
            make.top.equalTo(self.headView.mas_bottom).offset(.5);
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] * 4);
        }];
    }
    return self;
}

- (void)assignQuickBetpaymentViewWithMethod:(NSArray *)paymentArr
{
    /** 如果不选择红包的选择状态 */
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:paymentArr];
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
    CLQuickPaySelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLQuickBetRedParketsID"];
    if (!cell) {
        cell = [[CLQuickPaySelectedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLQuickBetRedParketsID"];
    }
    
    [cell assignQuickBetCellWithMethod:self.mainDataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.mainDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CLQuickRedPacketsModel *model = obj;
        model.isSelected = (idx == indexPath.row);
    }];
    
    if (self.selectedRedParketsBlock) self.selectedRedParketsBlock(self.mainDataSource[indexPath.row],YES);
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}
- (CLQuickBetPublicHeaderView *)headView{
    
    WS(_weakSelf)
    if (!_headView) {
        _headView = [CLQuickBetPublicHeaderView quickBetPublicHeaderViewWithTitle:@"可用红包" backBlock:^{
            if (_weakSelf.redParketsBackBlock) _weakSelf.redParketsBackBlock();
        }];
    }
    return _headView;
}
- (NSMutableArray *)mainDataSource{
    
    if (!_mainDataSource) {
        _mainDataSource = [NSMutableArray arrayWithCapacity:0];
    }
    return _mainDataSource;
}
@end
