//
//  CLWithdrawDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawDetailViewController.h"
#import "CLWithdrawFollowModel.h"
#import "CLWithdrawDetailContent.h"
#import "CLWithdrawDetailCell.h"
#import "CLWithdrawDetailTopView.h"
#import "CQImgAndTextView.h"
#import "CQCustomerEntrancerService.h"

@interface CLWithdrawDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) NSMutableArray* mainDataSource;
@property (nonatomic, strong) CQImgAndTextView *footerView;

@end

@implementation CLWithdrawDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"提现详情";
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self congigureData:self.model];
    
}

- (void) congigureData:(CLWithdrawFollowModel*)model {
    
    
    CLWithdrawDetailTopView* topView = [[CLWithdrawDetailTopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    [topView configureWithdrawDetailData:model];
    self.mainTableView.tableHeaderView = topView;
    UIView *tempView = [[UIView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(50))];
    tempView.backgroundColor = UIColorFromRGB(0xefefef);
    [tempView addSubview:self.footerView];
    self.mainTableView.tableFooterView = tempView;
    
    CLWithdrawDetailContent *cellModel1 = [[CLWithdrawDetailContent alloc] init];
    cellModel1.title = @"手续费：";
    cellModel1.content = model.fee_str;
    CLWithdrawDetailContent *cellModel2 = [[CLWithdrawDetailContent alloc] init];
    cellModel2.title = @"申请时间：";
    cellModel2.content = [self dealingDrawTime:model.create_time];
    CLWithdrawDetailContent *cellModel3 = [[CLWithdrawDetailContent alloc] init];
    cellModel3.title = @"交易单号：";
    cellModel3.content = model.order_id;
    CLWithdrawDetailContent *cellModel4 = [[CLWithdrawDetailContent alloc] init];
    cellModel4.title = @"预计到账时间：";
    cellModel4.content = model.day_over.length > 0 ? model.day_over : @"预计2-3个工作日到账";
    [self.mainDataSource addObject:cellModel1];
    [self.mainDataSource addObject:cellModel2];
    [self.mainDataSource addObject:cellModel3];
    [self.mainDataSource addObject:cellModel4];
    [self.mainTableView reloadData];

}
#pragma mark - 跳转客服
- (void)pushSessionViewController{
    WS(_weakSelf);
    [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_weakSelf];
}

- (NSString *)dealingDrawTime:(NSString*)time {
    
    NSArray* tempArr = [time componentsSeparatedByString:@" "];
    if (tempArr.count < 2) return @"";
    
    return [NSString stringWithFormat:@"%@ %@",tempArr[0],tempArr[1]];

}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mainDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [CLWithdrawDetailCell createDetailCellWithTableView:tableView withData:self.mainDataSource[indexPath.row]];
}

#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = __SCALE(26.f);
        _mainTableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    }
    return _mainTableView;
}

- (NSMutableArray *)mainDataSource {
    
    if (!_mainDataSource) {
        _mainDataSource = [NSMutableArray new];
    }
    return _mainDataSource;
}

- (CQImgAndTextView *)footerView{
    
    if (!_footerView) {
        WS(_weakSelf)
        _footerView = [[CQImgAndTextView alloc] initWithFrame:__Rect(0, __SCALE(5), SCREEN_WIDTH, __SCALE(45))];
        _footerView.title = @"联系客服";
        _footerView.backgroundColor = UIColorFromRGB(0xffffff);
        _footerView.titleColor = LINK_COLOR;
        _footerView.titleFont = FONT_SCALE(14);
        _footerView.img = [UIImage imageNamed:@"serviceIcon.png"];
        _footerView.imgToHeightScale = .5f;
        _footerView.tapGestureHandler = ^{
            [_weakSelf pushSessionViewController];
        };
    }
    return _footerView;
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
