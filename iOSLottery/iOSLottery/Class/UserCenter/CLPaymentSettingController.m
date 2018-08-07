//
//  CLPaymentSettingController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentSettingController.h"

#import "CLSettingCell.h"
#import "CLSettingAdapter.h"

#import "CLSetFreePayQuotaAPI.h"
#import "CLUserCenterPageConfigure.h"
#import "CQCustomerEntrancerService.h"

@interface CLPaymentSettingController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* settingTableView;

@property (nonatomic, strong) NSMutableArray* settingData;

@property (nonatomic, strong) CLSetFreePayQuotaAPI* freePayQuotaAPI;

@property (nonatomic) BOOL freePayQuetaStatus;

@end

@implementation CLPaymentSettingController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self updateDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"支付设置";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingTableView];
    
    
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

- (void) updateDataSource {
    
    //配置各种状态
    BOOL existPayPwd = [CLSettingAdapter hasPayPwdStatus];
    BOOL freePayState = [CLSettingAdapter getFreePayPwdStatus];
    long long freePayAmount = [CLSettingAdapter getFreePayPwdAmount];
    
    NSArray* sectionOne = nil;
    NSArray* sectionTwo = nil;
    
    
    if (existPayPwd) {
        sectionOne = @[[CLSettingCellModel settingTitle:@"修改支付密码"],[CLSettingCellModel settingTitle:@"忘记支付密码"]];
    } else {
        sectionOne = @[[CLSettingCellModel settingTitle:@"设置支付密码"]];
    }
    
    if ([CLSettingAdapter hasPayPwdStatus]) {
        if (freePayState) {
            sectionTwo = @[[CLSettingCellModel settingTitle:@"小额免密支付" remark:nil isOn:freePayState],[CLSettingCellModel settingTitle:[NSString stringWithFormat:@"单笔不超过%lld",freePayAmount]]];
        } else {
            sectionTwo = @[[CLSettingCellModel settingTitle:@"小额免密支付" remark:nil isOn:freePayState]];
        }
    }
    if (self.settingData.count > 0) [self.settingData removeAllObjects];
    if (sectionTwo) {
        [self.settingData addObjectsFromArray:@[sectionOne,sectionTwo]];
    }else{
        [self.settingData addObjectsFromArray:@[sectionOne]];
    }
    [self.settingTableView reloadData];
    
}

#pragma mark - switch on / off

- (void) freePaySwitch:(BOOL)isOn {
    
    self.freePayQuetaStatus = isOn;
    self.freePayQuotaAPI.free_pay_amount = @"";
    self.freePayQuotaAPI.free_pay_status = (isOn)?@"1":@"0";
    
    [self.freePayQuotaAPI start];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        
        NSDictionary* dict = [request.urlResponse.resp firstObject];
        if ([dict isKindOfClass:NSDictionary.class]) {
            long long amount = [dict[@"free_pay_pwd_quota"] longLongValue];
            BOOL status = [dict[@"free_pay_pwd_status"] boolValue];
            
            [CLSettingAdapter updateFreePayPwdStatus:status];
            [CLSettingAdapter updateFreePayPwdAmount:amount];
            [self updateDataSource];
        }
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.settingData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settingData[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    id key = [self.settingData[indexPath.section] objectAtIndex:indexPath.row];
    CLSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingCellID"];
    if (!cell) {
        cell = [[CLSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLSettingCellID"];
    }
    [cell configureSettingCellWithModel:key];

    WS(_ws)
    cell.SwitchChange = ^(BOOL isOn){

        [_ws freePaySwitch:isOn];
    };
    if (indexPath.row == ((NSArray *)self.settingData[indexPath.section]).count - 1) {
        cell.has_bottomLine = NO;
    }else{
        cell.has_bottomLine = YES;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLSettingCellModel* model = self.settingData[indexPath.section][indexPath.row];
    
    if ([model.title isEqualToString:@"忘记支付密码"]) {
        WS(_weakSelf)
        [CQCustomerEntrancerService pushSessionViewControllerWithInitiator:_weakSelf];
    } else if ([model.title isEqualToString:@"设置支付密码"]) {
        [CLUserCenterPageConfigure pushSetPayPasswordViewController];
        
    } else if ([model.title isEqualToString:@"修改支付密码"]) {
        [CLUserCenterPageConfigure pushModifyPayPasswordController];
    } else if ([model.title isEqualToString:@"小额免密支付"]) {
        //不支持点击
    } else if ([model.title hasPrefix:@"单笔不超过"]) {
        [CLUserCenterPageConfigure pushMicroPaymentViewController];
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

- (CLSetFreePayQuotaAPI *)freePayQuotaAPI {
    
    if (!_freePayQuotaAPI) {
        _freePayQuotaAPI = [[CLSetFreePayQuotaAPI alloc] init];
        _freePayQuotaAPI.delegate = self;
    }
    return _freePayQuotaAPI;
}

- (void)dealloc {
    
    if (_freePayQuotaAPI) {
        _freePayQuotaAPI.delegate = nil;
        [_freePayQuotaAPI cancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
