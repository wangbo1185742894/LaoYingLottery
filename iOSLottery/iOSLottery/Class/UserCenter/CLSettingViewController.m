//
//  CLSettingViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSettingViewController.h"
#import "CLSettingLogoutCell.h"
#import "CLSettingCell.h"
#import "CLAppContext.h"
#import "CLSafeSettingViewController.h"
#import "CLAlertController.h"
#import "CLLoginRegisterAdapter.h"
#import "CLAboutUsViewController.h"
#import "CLCacheManager.h"
#import "CLOtherSettingViewController.h"
@interface CLSettingViewController () <UITableViewDelegate,UITableViewDataSource,CLAlertControllerDelegate>

@property (nonatomic, strong) CLAlertController* alertView;
@property (nonatomic, strong) CLAlertController *clearCacheAlertView;//是否清空缓存

@property (nonatomic, strong) UITableView* settingTableView;
@property (nonatomic, strong) NSMutableArray* settingData;

@end

@implementation CLSettingViewController {
    
    NSString* __settingSafeString;
    NSString* __settingClearStoreString;
    NSString* __settingAboutUsString;
    NSString* __settingOtherString;
    NSString* __settingLogoutString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"设置";
    __settingSafeString = @"安全设置";
    
    __settingAboutUsString = @"关于我们";
    
    __settingClearStoreString = @"清理缓存";
    __settingOtherString = @"其他";
    __settingLogoutString = @"退出登录";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.settingTableView];
    
    
    [self.settingTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    //[CLSettingCellModel settingTitle:@"圈子中显示晒单" remark:nil isOn:YES]
    NSArray* sectionOne = @[[CLSettingCellModel settingTitle:__settingSafeString]];
//    [CLSettingCellModel settingTitle:@"推荐给好友"],[CLSettingCellModel settingTitle:@"赏我个赞"],
    NSArray* sectionTwo = @[[CLSettingCellModel settingTitle:__settingAboutUsString]];
    NSArray* sectionThree = @[[CLSettingCellModel settingTitle:__settingClearStoreString remark:[CLCacheManager calculateAllCacheFileCount]],[CLSettingCellModel settingTitle:__settingOtherString]];
    NSArray* sectionFour = @[[CLSettingCellModel settingTitle:__settingLogoutString]];
    
    if ([CLAppContext context].appLoginState) {
        [self.settingData addObjectsFromArray:@[sectionOne, sectionTwo,sectionThree,sectionFour]];
    } else {
        [self.settingData addObjectsFromArray:@[sectionTwo, sectionThree]];
    }
    
    [self.settingTableView reloadData];
}



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
        return 0.f;
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
    CLSettingCellModel* model = [self.settingData[indexPath.section] objectAtIndex:indexPath.row];
    
    if (![CLAppContext context].appLoginState) {
        if ([model.title isEqualToString:__settingLogoutString] || [model.title isEqualToString:__settingSafeString]) {
           return 0;
        }
    }
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CLSettingCellModel* key = [self.settingData[indexPath.section] objectAtIndex:indexPath.row];
    
    if ([key.title isEqualToString:__settingLogoutString])
    {
        return [CLSettingLogoutCell logoutCellInitWithTableView:tableView];
    
    } else {
        CLSettingCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLSettingCellID"];
        if (!cell) {
            cell = [[CLSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLSettingCellID"];
        }
        [cell configureSettingCellWithModel:key];
        
        if (indexPath.row == ((NSArray *)self.settingData[indexPath.section]).count - 1) {
            cell.has_bottomLine = NO;
        }else{
            cell.has_bottomLine = YES;
        }
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLSettingCellModel* key = [self.settingData[indexPath.section] objectAtIndex:indexPath.row];
    if ([key.title isEqualToString:__settingLogoutString]) {
        self.alertView = [CLAlertController alertControllerWithTitle:@"是否退出" message:nil style:CLAlertControllerStyleActionSheet delegate:self];
        self.alertView.buttonItems = @[@"取消",@"退出"];
        self.alertView.destructiveButtonIndex = 1;
        [self.alertView show];
    } else if ([key.title isEqualToString:__settingAboutUsString]) {
        [self.navigationController pushViewController:[[CLAboutUsViewController alloc] init] animated:YES];
    } else if ([key.title isEqualToString:__settingSafeString]) {
        [self.navigationController pushViewController:[[CLSafeSettingViewController alloc] init] animated:YES];
    } else if ([key.title isEqualToString:__settingClearStoreString]) {
        self.clearCacheAlertView = [CLAlertController alertControllerWithTitle:@"是否清空缓存" message:nil style:CLAlertControllerStyleActionSheet delegate:self];
        self.clearCacheAlertView.buttonItems = @[@"取消",@"清空"];
        self.clearCacheAlertView.destructiveButtonIndex = 1;
        [self.clearCacheAlertView show];
        
    } else if ([key.title isEqualToString:__settingOtherString]) {
        
        [self.navigationController pushViewController:[[CLOtherSettingViewController alloc] init] animated:YES];
    }
}

#pragma mark - CLAlertControllerDelegate

- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index {
    
    if (self.alertView == alertController) {
        if (index == 1) {
            //退出登录
            [CLLoginRegisterAdapter logout];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.clearCacheAlertView == alertController){
        
        if (index == 1) {
            //清空缓存
            WS(_weakSelf)
            [CLCacheManager clearAllCacheFileWith:^{
                
                [_weakSelf show:@"清理完成"];
                
                for (NSArray *array in self.settingData) {
                    for (id obj in array) {
                        if ([obj isKindOfClass:[CLSettingCellModel class]]) {
                            CLSettingCellModel *model = (CLSettingCellModel *)obj;
                            if ([model.title isEqualToString:@"清理缓存"]) {
                                model.remark = [CLCacheManager calculateAllCacheFileCount];
                            }
                        }
                        
                    }
                }
                [_weakSelf.settingTableView reloadData];
            }];
        }
    }
}

#pragma mark - getter

- (UITableView *)settingTableView {
    
    if (!_settingTableView) {
        _settingTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _settingTableView.delegate = self;
        _settingTableView.dataSource = self;
        _settingTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _settingTableView;
}

- (NSMutableArray *)settingData {
    
    if (!_settingData) {
        _settingData = [NSMutableArray new];
    }
    return _settingData;
}

- (void)dealloc {
    
    if (self.alertView) {
        self.alertView.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
