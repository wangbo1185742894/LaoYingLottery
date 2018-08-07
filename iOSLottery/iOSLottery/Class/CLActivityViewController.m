//
//  CLActivityViewController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLActivityViewController.h"

#import "CLActivityCell.h"

#import "CLActivityRequset.h"

#import "CLActivityModel.h"

#import "CLAllJumpManager.h"

#import "CLLoadingAnimationView.h"

#import "CLEmptyPageService.h"

#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"

@interface CLActivityViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLEmptyPageServiceDelegate>

/**
 活动列表
 */
@property (nonatomic, strong) UITableView *listTableView;

/**
 网络请求实例
 */
@property (nonatomic, strong) CLActivityRequset *request;

/**
 空白页
 */
@property (nonatomic, strong) CLEmptyPageService *emptyPageService;

@end

@implementation CLActivityViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navTitleText = @"活动";
    
    [self.view addSubview:self.listTableView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    //请求动画
    [[CLLoadingAnimationView shareLoadingAnimationView] showLoadingAnimationWithView:self.view type:(CLLoadingAnimationTypeNormal)];
    
    //开始请求数据
    [self.request start];
    
}

#pragma mark --- Network Request Delegate ---

//请求成功
- (void)requestFinished:(CLBaseRequest *)request
{
    if (request.urlResponse.success) {
        
        NSMutableArray *temp = request.urlResponse.resp[@"activityVos"];
    
        [self.request dealingActivityArrayForDictionary:temp];
        
        [self.listTableView reloadData];
        
    }
    
    [self.emptyPageService showEmptyWithType:([self.request pullActivityDate].count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.listTableView];
    
    [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
}
//请求失败
- (void)requestFailed:(CLBaseRequest *)request
{
    
   [self.emptyPageService showEmptyWithType:([self.request pullActivityDate].count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.listTableView];
    
   [[CLLoadingAnimationView shareLoadingAnimationView] stop];
    
}

#pragma mark --- Empty page delegate ---
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    if (index == 0) {
        //跳首页
        ((CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController).selectedIndex = 0;
    }
}
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.request start];
}

#pragma mark --- tableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.request.pullActivityDate.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    CLActivityCell *cell = [CLActivityCell activityCellCreateWithTableView:tableView];
    
    CLActivityModel *activityModel = self.request.pullActivityDate[indexPath.row];
    
    cell.model = activityModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CLActivityModel *activityModel = self.request.pullActivityDate[indexPath.row];
    
    [[CLAllJumpManager shareAllJumpManager] open:activityModel.activityUrl];

}

#pragma mark --- lazyLoad --- 

- (UITableView *)listTableView
{
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _listTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.contentInset = UIEdgeInsetsMake(__SCALE(4.f), 0, 0, 0);
        _listTableView.estimatedRowHeight = 200;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
  
    return _listTableView;
}

- (CLActivityRequset *)request
{
    if (_request == nil) {
        
        _request = [[CLActivityRequset alloc] init];
        
        _request.delegate = self;
    }

    return _request;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.delegate = self;
        _emptyPageService.butTitleArray = @[@"去首页看看"];
        _emptyPageService.contentString = @"暂无活动记录";
        _emptyPageService.emptyImageName = @"empty_Activity";
    }
    return _emptyPageService;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
