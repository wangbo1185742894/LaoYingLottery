//
//  CLTicketDetailsController.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLTicketDetailsController.h"
#import "UIViewController+SLBaseViewController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"
#import "SLConfigMessage.h"

#import "SLTicketDetailsCell.h"

#import "SLTicketDetailsRequest.h"

#import "SLTicketDetailsModel.h"

#import "SLExternalService.h"

#import "SLRefreshHeaderView.h"

@interface SLTicketDetailsController ()<UITableViewDataSource,UITableViewDelegate,CLRequestCallBackDelegate>

/**
 出票列表
 */
@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) SLTicketDetailsRequest *request;

@end

@implementation SLTicketDetailsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self.view addSubview:self.listTableView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    WS_SL(weakSelf);
    self.listTableView.mj_header = [SLRefreshHeaderView headerWithRefreshingBlock:^{
       
        [weakSelf.request start];
    }];
    
    [self.listTableView.mj_header beginRefreshing];
    
}

- (void)configNavigation
{
    [self setNavTitle:@"出票详情"];
    
    UIBarButtonItem *backItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(backItemClick)];
    
    UIBarButtonItem *space = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
    self.navigationItem.leftBarButtonItems = @[space,backItem];
}

- (void)backItemClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark --- 
- (void)requestFinished:(CLBaseRequest *)request
{

    [self.listTableView.mj_header endRefreshing];
    
    if (request.urlResponse.success) {
        
        NSArray *temp = request.urlResponse.resp;
        
        if (temp.count ==0 && temp == nil) return;
        
        [self.request disposeDataWithArray:temp];
        
        [self.listTableView reloadData];
    }
}

- (void)requestFailed:(CLBaseRequest *)request
{

    [SLExternalService showError:request.urlResponse.errorMessage];
}

#pragma mark --- TableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.request getDataArrayCount];;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    SLTicketDetailsCell *cell = [SLTicketDetailsCell createTicketDetailsCellWithTableView:tableView];
    
    cell.ticketModel = [self.request getTicketModelAtIndex:indexPath.row];
    
    return cell;

}

#pragma mark --- lazyLoad ---

- (UITableView *)listTableView
{
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        
        _listTableView.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        _listTableView.dataSource = self;
        _listTableView.delegate = self;
        _listTableView.estimatedRowHeight = 200;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.showsHorizontalScrollIndicator = NO;
    }
    
    return _listTableView;
}

- (SLTicketDetailsRequest *)request
{

    if (_request == nil) {
        
        _request = [[SLTicketDetailsRequest alloc] init];
        _request.delegate = self;
        _request.order_id = self.order_id;
    }
    return  _request;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
