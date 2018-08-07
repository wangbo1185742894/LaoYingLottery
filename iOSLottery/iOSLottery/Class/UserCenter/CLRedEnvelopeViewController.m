//
//  CLRedEnvelopeViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnvelopeViewController.h"
#import "CLRedEnveHeadView.h"
#import "CQRedPacketsTableViewCell.h"
#import "CLRedEnvelopAPI.h"
#import "UIScrollView+CLRefresh.h"
#import "CQUserRedPacketsNewModel.h"

#import "CLRedEnveDetailViewController.h"

#import "AppDelegate.h"
#import "CLMainTabbarViewController.h"
#import "CLEmptyPageService.h"
#import "CLUserCenterPageConfigure.h"
@interface CLRedEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource,CLRedEnveHeadViewDelegate,CLRequestCallBackDelegate , CLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView* redEnveTableView;

@property (nonatomic, strong) CLRedEnveHeadView* headerView;

@property (nonatomic, strong) CLRedEnvelopAPI* availListAPI;
@property (nonatomic, strong) CLRedEnvelopAPI* unAvaliListAPI;

@property (nonatomic, strong) id<CLRedEnvelopAPIGetDataInterface> ctnApi;

@property (nonatomic, strong) CLEmptyPageService *emptyPageService;//空页面展示

@end

@implementation CLRedEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"红包";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.redEnveTableView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(0);
        make.height.mas_equalTo(130);
    }];
    
    [self.redEnveTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    [self showLoading];
    self.headerView.selectIdx = 0;
}
#pragma mark ------------ emptyService delegate ------------
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    [CLUserCenterPageConfigure pushBuyRedEnvolopeViewController];
    
}
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.ctnApi refresh];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.ctnApi redEnvelistData].red_list.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"redPacketsCell";
    CQRedPacketsTableViewCell *cell = [CQRedPacketsTableViewCell createRedPacketsCellWithInitiator:tableView cellId:cellid data:[self.ctnApi redEnvelistData].red_list[indexPath.row]];
    cell.redPacketsUseBlock = ^(){
//        NSLog(@"点击了使用红包");
        //跳转首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        CLMainTabbarViewController* rootTabbarVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
        rootTabbarVC.selectedIndex = 0;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CQUserRedPacketsListModel* vm = [self.ctnApi redEnvelistData].red_list[indexPath.row];
    CLRedEnveDetailViewController* viewC = [[CLRedEnveDetailViewController alloc] init];
    viewC.fid = vm.fid;
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - CLRedEnveHeadViewDelegate

- (void)switchREIndex:(NSInteger)selectIdx {
    
    self.ctnApi = (selectIdx == 0)?self.availListAPI:self.unAvaliListAPI;
    
    if ([self.ctnApi redEnvelistData]) {
        [self.emptyPageService showEmptyWithType:([self.ctnApi redEnvelistData].red_list.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.redEnveTableView];
        [self.redEnveTableView reloadData];
        [self updateFooterLoad];
    } else {
        [self.ctnApi refresh];
    }
    
    self.emptyPageService.butTitleArray = (selectIdx == 0) ? @[@"去买个红包吧"] : @[];
    self.emptyPageService.contentString = (selectIdx == 0) ? @"暂无可用红包" : @"暂无用完或过期期的红包";
    self.emptyPageService.emptyImageName = (selectIdx == 0) ? @"empty_redEnvelope.png" : @"empty_noUseRedEnvelope";
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        id<CLRedEnvelopAPIGetDataInterface> __api = (id<CLRedEnvelopAPIGetDataInterface>)request;
        
        if (request.urlResponse.resp && [request.urlResponse.resp count] > 0) {
            
            [__api configureRedEnveListDataFromDict:[request.urlResponse.resp firstObject]];
        }
        [self.headerView assignData:[__api redEnvelistData]];
        
        [self.redEnveTableView reloadData];
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    
    [self.emptyPageService showEmptyWithType:([self.ctnApi redEnvelistData].red_list.count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.redEnveTableView];
    [self endRefreshing];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    
    [self.emptyPageService showEmptyWithType:CLEmptyTypeNoData superView:self.redEnveTableView];
    
    [self endRefreshing];
}

- (void) refresh {
    
    [self.ctnApi refresh];
}

- (void) nextPage {

    [self.ctnApi nextPage];
}

- (void) endRefreshing {
    
    [_redEnveTableView stopRefreshAnimating];
    [_redEnveTableView stopLoadingAnimating];
    [self stopLoading];
    [self updateFooterLoad];
}

- (void) updateFooterLoad {
    
    BOOL ret = [self.ctnApi canLoadingMore];
    if (!ret) {
        [_redEnveTableView stopLoadingAnimatingWithNoMoreData];
    } else {
        [_redEnveTableView resetNoMoreData];
    }
}

#pragma mark - getter

- (UITableView *)redEnveTableView {
    
    if (!_redEnveTableView) {
        WS(_weakSelf);
        _redEnveTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _redEnveTableView.delegate = self;
        _redEnveTableView.dataSource = self;
        _redEnveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _redEnveTableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        
        [_redEnveTableView addRefresh:^{
            
            [_weakSelf refresh];
        }];
        
        [_redEnveTableView addLoading:^{
            
            [_weakSelf nextPage];
        }];
    }
    return _redEnveTableView;
}

- (CLRedEnveHeadView *)headerView {
    
    if (!_headerView) {
        _headerView = [[CLRedEnveHeadView alloc] initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (CLRedEnvelopAPI *)availListAPI  {
    
    if (!_availListAPI) {
        _availListAPI = [[CLRedEnvelopAPI alloc] init];
        _availListAPI.delegate = self;
        _availListAPI.listType = redEnveLoadTypeAvailable;
    }
    return _availListAPI;
}

- (CLRedEnvelopAPI *)unAvaliListAPI {
    
    if (!_unAvaliListAPI) {
        _unAvaliListAPI = [[CLRedEnvelopAPI alloc] init];
        _unAvaliListAPI.delegate = self;
        _unAvaliListAPI.listType = redEnveLoadTypeUnavailable;
    }
    return _unAvaliListAPI;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.delegate = self;
        
    }
    return _emptyPageService;
}

- (void)dealloc {
    
    if (_availListAPI) {
        _availListAPI.delegate = nil;
        [_availListAPI cancel];
    }
    if (_unAvaliListAPI) {
        _unAvaliListAPI.delegate = nil;
        [_unAvaliListAPI cancel];
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
