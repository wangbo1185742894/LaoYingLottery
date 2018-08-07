//
//  CLPersonalMsgViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalMsgViewController.h"
#import "CLPersonalMsgCell.h"
#import "CLPersonalMsgAPI.h"
#import "CLPersonalMsgHandler.h"
#import "CLPersonalMsgViewModel.h"

#import "CLUserCenterPageConfigure.h"

@interface CLPersonalMsgViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* perTableView;

@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, strong) CLPersonalMsgAPI* api;

@end

@implementation CLPersonalMsgViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self showLoading];
    [self.api start];
    [self updatePersonalView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"个人资料";
    [self.view addSubview:self.perTableView];
    
    [self.perTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0.f;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak UITableView* _weakTableView = self.perTableView;
    CLPersonalMsgCell* cell = [CLPersonalMsgCell getPersonalMsgCellWithTableView:_weakTableView];
    [cell configurePersonalMessage:self.dataSource[indexPath.section][indexPath.row]];
    if (indexPath.row == ((NSArray *)self.dataSource[indexPath.section]).count - 1) {
        cell.has_BottomLine = NO;
    }else{
        cell.has_BottomLine = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLPersonalMsgViewModel* vm = self.dataSource[indexPath.section][indexPath.row];
    if (!vm.canClicking)
        return;
    
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [CLUserCenterPageConfigure pushChangeSystemHeadImgViewController];
                break;
            case 1:
                [CLUserCenterPageConfigure pushModifyNickNameViewController];
                break;
            case 2: break;
            case 3:
                [CLUserCenterPageConfigure pushModifyMobileViewController];
                break;
                
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                [CLUserCenterPageConfigure pushIdAuthenViewController];
                break;
            case 1:
                [CLUserCenterPageConfigure pushBankCardListViewController];
                break;
            default:
                break;
        }
    }
}

#pragma mark - CLPersonalMsgAPI

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        (self.dataSource.count == 0)?:[self.dataSource removeAllObjects];
        [[CLPersonalMsgHandler sharedPersonal] updatePersonalMesssageFrom:[request.urlResponse.resp firstObject]];
        [self updatePersonalView];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self stopLoading];
}

- (void) updatePersonalView {
    
    if (self.dataSource && self.dataSource.count > 0) {
        [self.dataSource removeAllObjects];
    }
    [self.dataSource addObjectsFromArray:[CLPersonalMsgHandler personalMessage]];
    if (self.dataSource.count > 0) {
        [self stopLoading];
    }
    [self.perTableView reloadData];
}

#pragma mark - getter

- (UITableView *)perTableView {
    
    if (!_perTableView) {
        _perTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _perTableView.delegate = self;
        _perTableView.dataSource = self;
        _perTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _perTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _perTableView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (CLPersonalMsgAPI *)api {
    
    if (!_api) {
        _api = [[CLPersonalMsgAPI alloc] init];
        _api.delegate = self;
    }
    return _api;
}

#pragma mark - 

- (void)dealloc {
    
    if (_api) {
        _api.delegate = nil;
        [_api cancel];
    }
   
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
