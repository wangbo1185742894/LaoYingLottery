//
//  CKQuickBetRedParketsView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKQuickBetRedParketsView.h"
#import "CKDefinition.h"
#import "Masonry.h"
#import "CKPayRedSelectCell.h"
#import "CKQuickBetPublicHeaderView.h"
#import "CKRedPacketUISource.h"
#define CKQuickBetViewWidth (SCREEN_WIDTH - (2 * 30))
#define CKQuickRedCellHeight __SCALE(40.f)
@interface CKQuickBetRedParketsView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) CKQuickBetPublicHeaderView *headView;

@end

@implementation CKQuickBetRedParketsView

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
            make.height.mas_equalTo(CKQuickBetPublicHeaderViewHeight);
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headView.mas_bottom).offset(.5);
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(CKQuickRedCellHeight * 4);
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
    
    return CKQuickRedCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKPayRedSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLQuickBetRedParketsID"];
    if (!cell) {
        cell = [[CKPayRedSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLQuickBetRedParketsID"];
    }
    
    cell.isSelectState = ((CKRedPacketUISource *)self.mainDataSource[indexPath.row]).selected;
    cell.redAmount = ((CKRedPacketUISource *)self.mainDataSource[indexPath.row]).title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (CKQuickBetPublicHeaderView *)headView{
    
    WS(_weakSelf)
    if (!_headView) {
        _headView = [CKQuickBetPublicHeaderView quickBetPublicHeaderViewWithTitle:@"可用红包" backBlock:^{
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
