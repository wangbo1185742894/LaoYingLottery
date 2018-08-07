//
//  CLOtherSettingViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLOtherSettingViewController.h"
#import "CLPushManagerViewController.h"
@interface CLOtherSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@end

@implementation CLOtherSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"推送设置";
    [self.dataSource addObjectsFromArray:@[@"推送管理"]];
    [self.view addSubview:self.mainTableView];

    // Do any additional setup after loading the view.
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellId = @"CQSafeTableViewCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        CALayer* underLine = [CALayer layer];
        underLine.backgroundColor = UIColorFromRGB(0xdcdcdc).CGColor;
        underLine.frame = __Rect(0, 43.5f, SCREEN_WIDTH, .5f);
        [cell.contentView.layer addSublayer:underLine];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = FONT_SCALE(13.f);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (IOS_VERSION >= 8.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
    }
    else
    {
        CLPushManagerViewController* pushManager = [[CLPushManagerViewController alloc] init];
        [self.navigationController pushViewController:pushManager animated:YES];
        
    }
    
}


#pragma mark - getter

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _mainTableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
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
