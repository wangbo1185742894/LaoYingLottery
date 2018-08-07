//
//  CLSafeSettingViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSafeSettingViewController.h"
#import "CLSettingCell.h"
#import "CLPaymentSettingController.h"
#import "CLLoginPwdSettingViewController.h"

@interface CLSafeSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView* settingTableView;

@property (nonatomic, strong) NSMutableArray* settingData;

@end

@implementation CLSafeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"安全设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingTableView];
    
    
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    
    if (DEFAULTS(bool, @"bet_limit_status")) {
        [self.settingData addObjectsFromArray:@[[CLSettingCellModel settingTitle:@"支付设置"],[CLSettingCellModel settingTitle:@"登录密码"]]];
    }else{
        [self.settingData addObjectsFromArray:@[[CLSettingCellModel settingTitle:@"登录密码"]]];
    }
    

    
    [self.settingTableView reloadData];
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
    
    if ([[(CLSettingCellModel *)self.settingData[indexPath.row] title] isEqualToString:@"支付设置"]) {
        [self.navigationController pushViewController:[[CLPaymentSettingController alloc] init] animated:YES];
    } else if ([[(CLSettingCellModel *)self.settingData[indexPath.row] title] isEqualToString:@"登录密码"]) {
        [self.navigationController pushViewController:[[CLLoginPwdSettingViewController alloc] init] animated:YES];
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
