//
//  CLPaymentSelectedRedViewController.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentSelectedRedViewController.h"
#import "CLPaymentSelectedRedCell.h"
#import "CLQuickRedPacketsModel.h"
#import "CLRedSelectedHeaderView.h"
@interface CLPaymentSelectedRedViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) CLQuickRedPacketsModel *selectedModel;

@end

@implementation CLPaymentSelectedRedViewController

+ (instancetype)pushUserPayMentSelectedRedParketsWithDataSource:(NSArray *)dataSource
                                                  selectedBlock:(void (^)(id ))selectedBlock
{
//    CQUserPaymentSelectedRedParketsViewController *userPaymentController = [[CQUserPaymentSelectedRedParketsViewController alloc] init];
//    userPaymentController.hidesBottomBarWhenPushed = YES;
//    /** 校验是否有选择红包 */
//    BOOL isNoSelected = YES;
//    for (CQUserRedPacketsModel *redModel in dataSource) {
//        if (redModel.isSelected) {
//            userPaymentController.selectedModel = redModel;
//            isNoSelected = NO;
//            break;
//        }
//    }
//    userPaymentController.dataSource.clear().addObjectFromArray(dataSource);
//    if (userPaymentController.dataSource.count) {
//        CQUserRedPacketsModel *lastModel = [[CQUserRedPacketsModel alloc] init];
//        lastModel.noRedSelected = YES;
//        lastModel.isSelected = isNoSelected;
//        /** 如果不选择支付方式 默认模型选择该模型 */
//        if (isNoSelected) userPaymentController.selectedModel = lastModel;
//        [userPaymentController.dataSource addObject:lastModel];
//    }
//    userPaymentController.selectedBlock = selectedBlock;
//    return userPaymentController;
    return nil;
}

- (void)updataRedViewWithDataSource:(NSMutableArray *)dataSource
{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:dataSource];
    [self.mainTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"红包";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.mainTableView.tableHeaderView = [CLRedSelectedHeaderView userRedSelectedHeaderView];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    /** 修复：如果进入选择红包列表页没有操作返回更新选择支付方式问题 */
    if (self.selectedBlock && self.selectedModel) {
        self.selectedBlock(self.selectedModel);
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLPaymentSelectedRedCell *cell = [[CLPaymentSelectedRedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLPaymentSelectedRedCellID"];
    if (!cell) {
        cell = [[CLPaymentSelectedRedCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"CLPaymentSelectedRedCellID"];
    }
    [cell assignPaymentSelectedUserRedPacketsListCellWithObj:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource enumerateObjectsUsingBlock:^(CLQuickRedPacketsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isSelected = NO;
    }];
    [self.dataSource[indexPath.row] setIsSelected:YES];
    [self.mainTableView reloadData];
    self.selectedModel = self.dataSource[indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.rowHeight = 50.f;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
