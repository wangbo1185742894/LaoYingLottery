//
//  CLRedEnveConsumeListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveConsumeListViewController.h"
#import "CLRedEnveConsumeAPI.h"
#import "UIScrollView+CLRefresh.h"
#import "CQUserRedPacketsConsumeTableViewCell.h"
#import "CLCheckOrderTypeAPI.h"

#import "CLLottBetOrdDetaViewController.h"
#import "CLFollowDetailViewController.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllJumpManager.h"
@interface CLRedEnveConsumeListViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* listTableView;
@property (nonatomic, strong) CLRedEnveConsumeAPI* consumeAPI;
@property (nonatomic, strong) CLCheckOrderTypeAPI* checkOrderTypeAPI;
@property (nonatomic, strong) CLAlertPromptMessageView *alertView;


@end

@implementation CLRedEnveConsumeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"消费记录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.listTableView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    self.consumeAPI.user_fid = self.user_fid;
    
    [self.listTableView startRefreshAnimating];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.consumeAPI pullData].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(_weakSelf);
    return [CQUserRedPacketsConsumeTableViewCell userRedPacketConsumeTableView:tableView Method:[self.consumeAPI pullData][indexPath.row] clickOrder:^(NSString *orderIDSring) {
        //跳转订单详情
        _weakSelf.checkOrderTypeAPI.orderId = orderIDSring;
        [_weakSelf showLoading];
        [_weakSelf.checkOrderTypeAPI start];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)judgeIsCanPushDetail:(NSDictionary *)dict{
    
    //判断是否可以跳转
    if ([dict[@"ifSkipDetail"] integerValue] == 1) {
        [self gotoOrderDetailViewController:[self.checkOrderTypeAPI orderTypeForDict:dict]];
    }else{
        
        //判断是否有线上版本
        self.alertView = nil;
        self.alertView = [[CLAlertPromptMessageView alloc] init];
        self.alertView.desTitle = self.checkOrderTypeAPI.bulletTips;
        
        if (self.checkOrderTypeAPI.ifSkipDownload == 1) {
            self.alertView.cancelTitle = @"立即更新";
            [self.alertView showInView:self.view];
            WS(_weakSelf)
            self.alertView.btnOnClickBlock = ^(){
                if (_weakSelf.checkOrderTypeAPI.ifSkipDownload == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_weakSelf.checkOrderTypeAPI.skipUrl]];
                }
            };
        }else{
            self.alertView.cancelTitle = @"知道了";
            self.alertView.btnOnClickBlock = nil;
        }
        [self.alertView showInWindow];
    }
}

- (void)gotoOrderDetailViewController:(OrderType) type {
    
    if (type == OrderTypeNormal) {
        if (self.checkOrderTypeAPI.gameType > 0) {
            /** 如果是高频，大盘彩，竞彩，北单 */
            if (self.checkOrderTypeAPI.gameType == 3) {
                /** 如果是竞彩 */
                [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@", self.checkOrderTypeAPI.orderId] dissmissPresent:YES animation:NO];
            }else if (self.checkOrderTypeAPI.gameType || self.checkOrderTypeAPI.gameType == 2){
                /** 大盘彩或高频彩 */
                CLLottBetOrdDetaViewController* orderVC = [[CLLottBetOrdDetaViewController alloc] init];
                orderVC.orderId = self.checkOrderTypeAPI.orderId;
                [self.navigationController pushViewController:orderVC animated:YES];
            }
        }
    } else if (type == OrderTypeFollow) {
        CLFollowDetailViewController* followVC = [[CLFollowDetailViewController alloc] init];
        followVC.followID = self.checkOrderTypeAPI.orderId;
        [self.navigationController pushViewController:followVC animated:YES];
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {

    if (request == self.checkOrderTypeAPI) {
        if (request.urlResponse.success) {
            [self judgeIsCanPushDetail:request.urlResponse.resp];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    } else {
        if (request.urlResponse.success) {
            [self.consumeAPI configureConsumeFollowDataWithArr:request.urlResponse.resp];
            [self.listTableView reloadData];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
        [self endRefreshing];
    }
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self endRefreshing];
    [self stopLoading];
}

- (void) endRefreshing {
    
    [_listTableView stopRefreshAnimating];
    [_listTableView stopLoadingAnimating];
    
    BOOL ret = [self.consumeAPI canLoadMore];
    if (!ret) {
        [_listTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_listTableView resetNoMoreData];
    }
    
}

#pragma mark - getter

- (UITableView *)listTableView {
    
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS(_weakSelf);
        [_listTableView addLoading:^{
            
            [_weakSelf.consumeAPI nextPage];
        }];
        [_listTableView addRefresh:^{
           
            [_weakSelf.consumeAPI refresh];
        }];
    }
    return _listTableView;
}

- (CLRedEnveConsumeAPI *)consumeAPI {
    
    if (!_consumeAPI) {
        _consumeAPI = [[CLRedEnveConsumeAPI alloc] init];
        _consumeAPI.delegate = self;
    }
    return _consumeAPI;
}

- (CLCheckOrderTypeAPI *)checkOrderTypeAPI {
    
    if (!_checkOrderTypeAPI) {
        _checkOrderTypeAPI = [[CLCheckOrderTypeAPI alloc] init];
        _checkOrderTypeAPI.delegate = self;
    }
    return _checkOrderTypeAPI;
}

- (void)dealloc {
    
    if (_consumeAPI) {
        _consumeAPI.delegate = nil;
        [_consumeAPI cancel];
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
