//
//  CKQuickBetPaySelectedView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKQuickBetPaySelectedView.h"
#import "Masonry.h"
#import "CKDefinition.h"
#import "CKPayCell.h"
#import "CKQuickBetPublicHeaderView.h"
#import "CKPayChannelUISource.h"
#import "UIImageView+CKWebImage.h"
#define CKQuickBetViewWidth (SCREEN_WIDTH - (2 * 30))
#define CKQuickBetCellHeight __SCALE(40.f)
@interface CKQuickBetPaySelectedView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
//@property (nonatomic, strong) UIActionSheet *serviceSheet;

@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) CKQuickBetPublicHeaderView *headView;

@property (nonatomic, assign) NSInteger paymentSelected;


@end

@implementation CKQuickBetPaySelectedView

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
            make.top.mas_equalTo(self.headView.mas_bottom);
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(__SCALE(40.f) * 4);
        }];
    }
    return self;
}

- (void)updataPaymentWithData:(NSArray *)dataArr
{
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:dataArr];
    
    [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
    
        make.height.mas_equalTo(CKQuickBetCellHeight * ((self.mainDataSource.count > 4) ? 4 : self.mainDataSource.count));
    }];
    [self layoutIfNeeded];
    [self.mainTableView reloadData];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CKQuickBetCellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuickBetPaySelectedCellID"];
    if (!cell) {
        cell = [[CKPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuickBetPaySelectedCellID"];
    }
    CKPayChannelUISource *source = (CKPayChannelUISource *)self.mainDataSource[indexPath.row];
    cell.onlyShowTitle = YES;
    cell.textLbl.text = source.channel_name;
    [cell.icon setImageWithURL:[NSURL URLWithString:source.channel_icon_str]];
    if (source.usability) {
        //渠道是否可用
        cell.cellType = CKPayCellTypeSelect;
        cell.isSelectState = source.isSelected;
    }else{
        //不可用展示状态信息
        cell.cellType = CKPayCellTypeMarking;
        cell.markTextLbl.text = source.channel_state_msg;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!((CKPayChannelUISource *)self.mainDataSource[indexPath.row]).usability)return;
    self.selectedPaymentBlock?self.selectedPaymentBlock(self.mainDataSource[indexPath.row]):nil;
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, CKQuickBetViewWidth, 150.f) style:UITableViewStylePlain];
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

- (CKQuickBetPublicHeaderView *)headView{
    
    WS(_weakSelf)
    if (!_headView) {
        _headView = [CKQuickBetPublicHeaderView quickBetPublicHeaderViewWithTitle:@"支付方式" backBlock:^{
            if (_weakSelf.paymentBackBlock) _weakSelf.paymentBackBlock();
        }];
    }
    return _headView;
}






@end
