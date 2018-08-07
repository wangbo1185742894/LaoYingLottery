//
//  CLLoginPwdSettingViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLoginPwdSettingViewController.h"
#import "CLSettingCell.h"
#import "CLModifyLoginPwdViewController.h"
#import "CLSettingAdapter.h"
#import "CLUserCenterPageConfigure.h"
#import "CQCustomerEntrancerService.h"
@interface CLLoginPwdSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* settingTableView;

@property (nonatomic, strong) NSMutableArray* settingData;

@end

@implementation CLLoginPwdSettingViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.settingData removeAllObjects];
    if ([CLSettingAdapter hasLoginPwdStatus]) {
        [self.settingData addObjectsFromArray:@[[CLSettingCellModel settingTitle:@"修改登录密码"],[CLSettingCellModel settingTitle:@"忘记登录密码"]]];
    } else {
        [self.settingData addObjectsFromArray:@[[CLSettingCellModel settingTitle:@"设置登录密码"]]];
    }
    
    [self.settingTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"登录密码设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingTableView];
    
    
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingData count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id key = [self.settingData objectAtIndex:indexPath.row];
    CLSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingCellID"];
    if (!cell) {
        cell = [[CLSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLSettingCellID"];
    }
    [cell configureSettingCellWithModel:key];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLSettingCellModel* model = self.settingData[indexPath.row];
    if ([model.title isEqualToString:@"修改登录密码"]) {
        [CLUserCenterPageConfigure pushModifyLoginPasswordController];
    } else if ([model.title isEqualToString:@"忘记登录密码"]) {
        
        WS(_weakSelf)
        [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_weakSelf];
        
    } else if ([model.title isEqualToString:@"设置登录密码"]) {
        [CLUserCenterPageConfigure pushSetLoginPasswordController];
    }
}

#pragma mark - getter

- (UITableView *)settingTableView {
    
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _settingTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _settingTableView;
}

- (NSMutableArray *)settingData {
    
    if (!_settingData) {
        _settingData = [NSMutableArray new];
    }
    return _settingData;
}


@end
