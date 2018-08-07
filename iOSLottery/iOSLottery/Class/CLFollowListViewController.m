//
//  CLFollowListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowListViewController.h"
#import "CLFollowListAPI.h"
#import "CLlotteryFollowListCell.h"
#import "CLFollowListModel.h"

#import "UIScrollView+CLRefresh.h"
#import "Masonry.h"

#import "CLFollowDetailViewController.h"
#import "CLEmptyPageService.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"

#import "CLAlertPromptMessageView.h"



@interface CLFollowListViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate, CLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView* followTableView;

@property (nonatomic, strong) NSMutableArray* followDataSource;

@property (nonatomic, strong) CLFollowListAPI* followListAPI;

@property (nonatomic, strong) CLEmptyPageService *emptyPageService;

@property (nonatomic, strong) CLAlertPromptMessageView *alertView;

@end

@implementation CLFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"追号方案";
    [self.view addSubview:self.followTableView];
    
    
    [self.followTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.followTableView startRefreshAnimating];
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        NSError* error = nil;
        //请求完成
        [self.followListAPI arrangeListWithAPIData:request.urlResponse.resp error:&error];
        [_followDataSource removeAllObjects];
        [_followDataSource addObjectsFromArray:[self.followListAPI pullFollowList]];
        [self.followTableView reloadData];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self.emptyPageService showEmptyWithType:(self.followDataSource.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.followTableView];
    [self endRefreshing];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self.emptyPageService showEmptyWithType:(self.followDataSource.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.followTableView];
    [self endRefreshing];
}

#pragma mark ------------ emptyservice delegate ------------
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    //跳转首页
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    ((CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController).selectedIndex = 0;
}

- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.followListAPI start];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.followDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return __SCALE(60);
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLlotteryFollowListCell* cell = [CLlotteryFollowListCell createLotteryFollowListCellWith:tableView];
    CLFollowListModel* model = self.followDataSource[indexPath.row];
    
    cell.listModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLFollowListModel* data = self.followDataSource[indexPath.row];
    //判断是否可以点击跳转详情
    if (data.ifSkipDetail) {
        
        CLFollowDetailViewController* vc = [[CLFollowDetailViewController alloc] init];
        vc.followID = data.followId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        //判断是否有线上版本
        self.alertView = nil;
        self.alertView = [[CLAlertPromptMessageView alloc] init];
        self.alertView.desTitle = self.followListAPI.bulletTips;
        
        if (self.followListAPI.ifSkipDownload == 1) {
            self.alertView.cancelTitle = @"立即更新";
            [self.alertView showInView:self.view];
            WS(_weakSelf)
            self.alertView.btnOnClickBlock = ^(){
                 if (_weakSelf.followListAPI.ifSkipDownload == 1) {
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_weakSelf.followListAPI.skipUrl]];
                 }
            };
        }else{
            self.alertView.cancelTitle = @"知道了";
            self.alertView.btnOnClickBlock = nil;
        }
        [self.alertView showInWindow];
    }
    
}


#pragma mark - 

- (void)endRefreshing {
    [_followTableView stopRefreshAnimating];
    [_followTableView stopLoadingAnimating];
    
    if ((self.followTableView.contentSize.height < self.followTableView.bounds.size.height) ||
        !self.followListAPI.canLoadMore  ) {
        [_followTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_followTableView resetNoMoreData];
    }
}

#pragma mark - getter

- (UITableView *)followTableView {
    
    if (!_followTableView) {
        _followTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _followTableView.delegate = self;
        _followTableView.dataSource = self;
        _followTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WS(_weakSelf)
        [_followTableView addRefresh:^{
            [_weakSelf.followListAPI refresh];
        }];
        
        [_followTableView addLoading:^{
            [_weakSelf.followListAPI nextPage];
        }];
    }
    return _followTableView;
}

- (NSMutableArray *)followDataSource {
    
    if (!_followDataSource) {
        _followDataSource = [NSMutableArray new];
    }
    return _followDataSource;
}

- (CLFollowListAPI *)followListAPI {
    
    if (!_followListAPI) {
        _followListAPI = [[CLFollowListAPI alloc] init];
        _followListAPI.delegate = self;
    }
    return _followListAPI;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.delegate = self;
        _emptyPageService.contentString = @"追号投注，中奖更容易呦！";
        _emptyPageService.butTitleArray = @[@"立即追一单"];
        _emptyPageService.emptyImageName = @"empty_followOrder.png";
        
    }
    return _emptyPageService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
