//
//  CLLotteryListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

/** 投注列表 */

#import "CLLotteryBetOrderListViewController.h"
#import "Masonry.h"
#import "CLLotteryOrderListCell.h"
#import "CLOrderListSegmentControl.h"
#import "UIScrollView+CLRefresh.h"
#import "CLOrderListModel.h"
#import "CLOrderStatus.h"

#import "CLOrderListAllOrderAPI.h"
#import "CLOrderListBonusAPI.h"
#import "CLOrderListWaitAPI.h"

#import "CLLottBetOrdDetaViewController.h"

#import "CLEmptyPageService.h"

#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
//新手引导
//#import "CLNewbieGuidanceService.h"
#import "CLAlertPromptMessageView.h"
#import "UIImageView+CQWebImage.h"
#import "CLAllJumpManager.h"
@interface CLLotteryBetOrderListViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLOrderListSegmentControlDelegate, CLEmptyPageServiceDelegate>

/**
 顶部分段选择View
 */
@property (nonatomic, strong) CLOrderListSegmentControl *sectionHeaderView;

@property (nonatomic, strong) UITableView *betTableView;

@property (nonatomic, strong) NSMutableArray* dataSource;

/**
 全部订单api
 */
@property (nonatomic, strong) CLOrderListAllOrderAPI* allListAPI;

/**
 中奖订单api
 */
@property (nonatomic, strong) CLOrderListBonusAPI* bonusListAPI;

/**
 待支付订单api
 */
@property (nonatomic, strong) CLOrderListWaitAPI* waitListAPI;

@property (nonatomic, strong) id<CLOrderListAPIDataHandler> apiHandler;

@property (nonatomic, strong) CLEmptyPageService *emptyService;

/**
 弹窗
 */
@property (nonatomic, strong) CLAlertPromptMessageView *alertView;

@end

@implementation CLLotteryBetOrderListViewController

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    //[self initData];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [CLNewbieGuidanceService checkNewGuidanceWithType:CLNewbieGuidanceTypeOrderList];
    self.navTitleText = @"投注订单";
    [self.view addSubview:self.betTableView];
    [self.view addSubview:self.sectionHeaderView];
    
    
    [self.betTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.sectionHeaderView).offset( __SCALE(35) - 0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
    
    [self.sectionHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(35.f));
    }];
    
    [self initData];
    
}

- (void)initData {
    
    self.sectionHeaderView.selectedIndex = 0;
    [self controlItemChange:0];
    
}

- (void)controlItemChange:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            self.apiHandler = self.allListAPI;
            self.emptyService.contentString = @"暂无投注订单";
            self.emptyService.butTitleArray = @[@"去首页看看"];
            self.emptyService.emptyImageName = @"empty_allOrder.png";
        }  break;
        case 1:
        {
            self.apiHandler = self.bonusListAPI;
            self.emptyService.contentString = @"没有中奖呢，要努力啦";
            self.emptyService.butTitleArray = @[@"去首页看看"];
            self.emptyService.emptyImageName = @"empty_award.png";
        }  break;
        case 2:
        {
            self.apiHandler = self.waitListAPI;
            self.emptyService.contentString = @"暂无待开奖订单";
            self.emptyService.butTitleArray = @[@"去首页看看"];
            self.emptyService.emptyImageName = @"empty_waitAward.png";
        }  break;

        default:
            break;
    }
    if ([self.apiHandler pullOrderList].count == 0) {
        [self.betTableView startRefreshAnimating];
    }
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[self.apiHandler pullOrderList]];
    
    if (self.dataSource.count > 0) {
        [self.emptyService showEmptyWithType:CLEmptyTypeNormal superView:self.betTableView];
    }
    [self.betTableView reloadData];
}

#pragma mark ------------ emptydelegate ------------
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    //跳转首页
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    ((CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController).selectedIndex = 0;
    
}
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.betTableView startRefreshAnimating];
}

#pragma mark - CLOrderListSegmentControlDelegate

- (void)segmentControlSelectChange:(NSInteger)selectedIndex {
 
    [self controlItemChange:selectedIndex];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return __SCALE(60);
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CLLotteryOrderListCell *cell = [CLLotteryOrderListCell createLotteryOrderListCell:tableView];
    
    CLOrderListModel* list = self.dataSource[indexPath.row];
    cell.titleLable.text = list.gameName;
    cell.timerLabel.text = list.createTime;
    cell.contentLable.text = list.orderStatusCn;
    cell.contentLable.textColor = UIColorFromStr(list.statusCnColor);
    cell.cashLable.text = [NSString stringWithFormat:@"%@元",@(list.orderAmount)];
    if (list.gameIcon && list.gameIcon.length > 0) {
    
        [cell.iconImageView setImageWithURL:[NSURL URLWithString:list.gameIcon]];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLOrderListModel* list = self.dataSource[indexPath.row];
    //判断是否可以点击跳转详情
    if (list.ifSkipDetail) {
        if (list.gameType == CLLotteryOrderTypeDPC || list.gameType == CLLotteryOrderTypeGPC || list.gameType == CLLotteryOrderTypeSFC) {
            CLLottBetOrdDetaViewController* orderVC = [[CLLottBetOrdDetaViewController alloc] init];
            
            orderVC.orderId = list.orderId;
            [self.navigationController pushViewController:orderVC animated:YES];
        }else if (list.gameType == CLLotteryOrderTypeFootBall || list.gameType == CLLotteryOrderTypeBasketBall){
            [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@", list.orderId] dissmissPresent:YES animation:NO];
        }
        
    }else{
        
        //判断是否有线上版本
        self.alertView = nil;
        self.alertView = [[CLAlertPromptMessageView alloc] init];
        self.alertView.desTitle = ((CLOrderListAPI *)self.apiHandler).bulletTips;
        
        if (((CLOrderListAPI *)self.apiHandler).ifSkipDownload == 1) {
            self.alertView.cancelTitle = @"立即更新";
            [self.alertView showInView:self.view];
            WS(_weakSelf)
            self.alertView.btnOnClickBlock = ^(){
                if (((CLOrderListAPI *)_weakSelf.apiHandler).ifSkipDownload == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:((CLOrderListAPI *)_weakSelf.apiHandler).skipUrl]];
                }
            };
        }else{
            self.alertView.cancelTitle = @"知道了";
            self.alertView.btnOnClickBlock = nil;
        }
        [self.alertView showInWindow];
    }
}

#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        NSError* error = nil;
        //请求完成 针对不同api 设置不同数据
        
        if (request == self.allListAPI) {
            [self.allListAPI arrangeListWithAPIData:request.urlResponse.resp error:&error];
        } else if (request == self.bonusListAPI) {
            [self.bonusListAPI arrangeListWithAPIData:request.urlResponse.resp error:&error];
        } else if (request == self.waitListAPI) {
            [self.waitListAPI arrangeListWithAPIData:request.urlResponse.resp error:&error];
        }
        
        //当前请求回调与当前页卡相同 刷新页面
        if (self.apiHandler == (id <CLOrderListAPIDataHandler>)request) {
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:[self.apiHandler pullOrderList]];
            [self.betTableView reloadData];
        }

    }else{
        [self show:request.urlResponse.errorMessage];
    }
    
    [self endRefreshing];
    
    [self.emptyService showEmptyWithType:(self.dataSource.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.betTableView];
    
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    //如有数据 列表底部提示网络不稳定  无数据 底层提示网络不稳定提示图
    [self.emptyService showEmptyWithType:(self.dataSource.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.betTableView];
    
    [self endRefreshing];
}

#pragma mark - endRefresh

- (void)endRefreshing {
    [_betTableView stopRefreshAnimating];
    [_betTableView stopLoadingAnimating];
    
    
    if ((self.betTableView.contentSize.height < self.betTableView.bounds.size.height)) {
        [_betTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_betTableView resetNoMoreData];
    }
    
    if (((CLOrderListAPI *)self.apiHandler).canLoadMore) {
        [_betTableView resetNoMoreData];
    }else{
        [_betTableView stopLoadingAnimatingWithNoMoreData];
    }
}

#pragma mark - getter 

- (UITableView *)betTableView {
    
    if (!_betTableView) {
        _betTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _betTableView.delegate = self;
        _betTableView.dataSource = self;
        _betTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS(_weakSelf)
        [_betTableView addRefresh:^{
            
            [_weakSelf.apiHandler refresh];
        }];

        [_betTableView addLoading:^{
            
            [_weakSelf.apiHandler nextPage];
        }];
        
    }
    return _betTableView;
}

- (CLOrderListSegmentControl *)sectionHeaderView {
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[CLOrderListSegmentControl alloc] initWithFrame:CGRectZero];
        [_sectionHeaderView setItems:@[@"全部",@"中奖",@"待开奖"]];
        _sectionHeaderView.delegate = self;
    }
    return _sectionHeaderView;
}

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (CLOrderListAllOrderAPI *)allListAPI {
    
    if (!_allListAPI) {
        _allListAPI = [[CLOrderListAllOrderAPI alloc] init];
        _allListAPI.apiListType = CLAPIOrderListTypeALL;
        _allListAPI.delegate = self;
    }
    return _allListAPI;
}

- (CLOrderListBonusAPI *)bonusListAPI {
    
    if (!_bonusListAPI) {
        _bonusListAPI = [[CLOrderListBonusAPI alloc] init];
        _bonusListAPI.apiListType = CLAPIOrderListTypeBonus;
        _bonusListAPI.delegate = self;
    }
    return _bonusListAPI;
}

- (CLOrderListWaitAPI *)waitListAPI {
    
    if (!_waitListAPI) {
        _waitListAPI = [[CLOrderListWaitAPI alloc] init];
        _waitListAPI.apiListType = CLAPIOrderListTypeWait;
        _waitListAPI.delegate = self;
    }
    return _waitListAPI;
}

- (CLEmptyPageService *)emptyService{
    
    if (!_emptyService) {
        _emptyService = [[CLEmptyPageService alloc] init];
        _emptyService.delegate = self;
    }
    return _emptyService;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
