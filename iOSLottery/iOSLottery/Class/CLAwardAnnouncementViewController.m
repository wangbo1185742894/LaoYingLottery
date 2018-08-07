//
//  CLAwardAnnouncementViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardAnnouncementViewController.h"
#import "UIScrollView+CLRefresh.h"
#import "CLAwardListViewController.h"

#import "CLSLDrawNoticeCell.h"
#import "CLAwardK3Cell.h"
#import "CLAwardD11Cell.h"
#import "CLSSQAwardNoticeCell.h"
#import "CLAwardVoModel.h"

#import "CLAwardNoticeAPI.h"
#import "CLCacheManager.h"
#import "CLEmptyPageService.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
//无网 浮层
#import "CLNoNetFloatView.h"
#import "CLNetworkReachabilityManager.h"

#import "SLDrawNoticeController.h"
#import "BBDrawNoticeController.h"

//自定义cell
#import "CLATDrawNoticeCell.h"

#import "CLQLCDrawNoticeCell.h"

#import "CLSFCDrawNoticeCell.h"

@interface CLAwardAnnouncementViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate, CLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView* mainTableView;

@property (nonatomic, strong) CLAwardNoticeAPI* noticeAPI;

@property (nonatomic, strong) CLEmptyPageService *emptyPageService;

@property (nonatomic, strong) CLNoNetFloatView *noNetFloatView;//无网浮层

@end

@implementation CLAwardAnnouncementViewController

-  (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    self.navTitleText = @"开奖公告";
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(IOS_VERSION >= 11 ? -TABLEBAR_HEIGHT : 0);
    }];
    
    [self.mainTableView startRefreshAnimating];
    
    //处理缓存数据
    [self.noticeAPI deallingWithData:[CLCacheManager getCacheFormLocationFileWithName:CLCacheFileNameAwardAnnouncement]];
    [self.mainTableView reloadData];
    
    //添加 网络监听通知
    [self addNoNetNotification];
}
#pragma mark - 添加无网络通知
- (void)addNoNetNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkHasChange:) name:@"CLNetworkReachabilityDidChangeNotificationName" object:nil];
    [CLNetworkReachabilityManager startMonitoring];
}
#pragma mark - 无网浮层
- (void)networkHasChange:(NSNotification *)userInfo{
    if ([[userInfo.userInfo objectForKey:APP_HASNET] integerValue] == 0) {//联网成功
        [self.view addSubview:self.noNetFloatView];
        self.noNetFloatView.hidden = NO;
    }else{//无网络连接
        [self.noNetFloatView removeFromSuperview];
        self.noNetFloatView.hidden = YES;
    }
}
#pragma mark ------------ empty page delegate ------------
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    if (index == 0) {
        //跳首页
        ((CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController).selectedIndex = 0;
    }
}
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView{
    
    [self.noticeAPI start];
}
#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [CLCacheManager saveToCacheWithContent:request.urlResponse.resp cacheFile:CLCacheFileNameAwardAnnouncement];
        [self.noticeAPI deallingWithData:request.urlResponse.resp];
        [self.mainTableView reloadData];
    }else{
        [self show:request.urlResponse.errorMessage];
    }
    
    [self.emptyPageService showEmptyWithType:([self.noticeAPI pullData].count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.mainTableView];
    
    [self endRefreshing];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    
    [self.emptyPageService showEmptyWithType:([self.noticeAPI pullData].count > 0) ? CLEmptyTypeNormal : CLEmptyTypeNoData superView:self.mainTableView];
    
    [self endRefreshing];
}

- (void) endRefreshing {
    
    [self.mainTableView stopRefreshAnimating];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CL__SCALE(100);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.noticeAPI pullData].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLAwardVoModel* vo = [self.noticeAPI pullData][indexPath.row];
    
    if ([vo.gameEn hasSuffix:@"Kuai3"]){
        
        CLAwardK3Cell* cell = [CLAwardK3Cell createAwardK3CellWithTableView:tableView];
        [cell configureKuai3Data:vo];
        
        return cell;
        
    } else if ([vo.gameEn hasSuffix:@"11"]) {
        
        CLAwardD11Cell* cell = [CLAwardD11Cell createAwardD11CellWithTableView:tableView];
        [cell configureD11Data:vo];
        
        return cell;
        
    } else if ([vo.gameEn hasSuffix:@"ssq"]){
        CLSSQAwardNoticeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLSSQAwardNoticeCell"];
        if (!cell) {
            cell = [[CLSSQAwardNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLSSQAwardNoticeCell"];
        }
        [cell configureSQQData:vo type:CLAwardLotteryTypeSSQ];
        return cell;
    } else if ([vo.gameEn hasSuffix:@"dlt"]){
        CLSSQAwardNoticeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLSSQAwardNoticeCell"];
        if (!cell) {
            cell = [[CLSSQAwardNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLDLTAwardNoticeCell"];
        }
        [cell configureSQQData:vo type:CLAwardLotteryTypeDLT];
        return cell;
    }else if ([vo.gameEn hasSuffix:@"jczq_mix_p"]){
        
        CLSLDrawNoticeCell *cell = [CLSLDrawNoticeCell createSLDrawNoticeCellWithTableView:tableView];
        cell.drawNoticeModel = vo;
        
        return cell;
    }else if ([vo.gameEn hasSuffix:@"jclq_mix_p"]){
        CLSLDrawNoticeCell *cell = [CLSLDrawNoticeCell createSLDrawNoticeCellWithTableView:tableView];
        cell.drawNoticeModel = vo;
        return cell;
    }else if ([vo.gameEn hasSuffix:@"pl3"] || [vo.gameEn hasSuffix:@"pl5"] || [vo.gameEn hasSuffix:@"fc3d"]){
    
        CLATDrawNoticeCell *cell = [CLATDrawNoticeCell createATDrawNoticeCellWithTableView:tableView];
        
        
        
        [cell setData:vo];
        
        return cell;
    }else if ([vo.gameEn hasSuffix:@"qxc"] || [vo.gameEn hasSuffix:@"qlc"]){
    
        CLQLCDrawNoticeCell *cell = [CLQLCDrawNoticeCell createDrawNoticeCellWithTableView:tableView];
        [cell setData:vo];
        
        return cell;
    }else if ([vo.gameEn hasSuffix:@"sfc"]){
    
        CLSFCDrawNoticeCell *cell = [CLSFCDrawNoticeCell createDrawNoticeCellWithTableView:tableView];
        
        [cell setData:vo];
        
        return cell;
    }
    return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"defauleCell"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLAwardVoModel* vo = [self.noticeAPI pullData][indexPath.row];
    
    //缓存点击次数
    NSMutableDictionary *sortDic = [NSMutableDictionary dictionaryWithDictionary:[CLCacheManager getCacheFormLocationFileWithName:CLCacheFileNameAwardAnnouncementSort]];
    if ([sortDic.allKeys containsObject:vo.gameEn]) {
        
        NSInteger count = [sortDic[vo.gameEn] integerValue];
        count++;
        [sortDic setObject:@(count) forKey:vo.gameEn];
    }else{
        [sortDic setObject:@(1) forKey:vo.gameEn];
    }
    [CLCacheManager saveToCacheWithContent:sortDic cacheFile:CLCacheFileNameAwardAnnouncementSort];
    
    //跳转对应页面
    if ([vo.gameEn isEqualToString:@"jczq_mix_p"]) {
        
        SLDrawNoticeController *drawNotice = [[SLDrawNoticeController alloc] init];
        drawNotice.hidesBottomBarWhenPushed = YES;
        drawNotice.gameEn = vo.gameEn;
        [self.navigationController pushViewController:drawNotice animated:YES];
    }else if([vo.gameEn isEqualToString:@"jclq_mix_p"]){
        /** 跳转篮球中奖列表 */
        BBDrawNoticeController *drawNotice = [[BBDrawNoticeController alloc] init];
        drawNotice.hidesBottomBarWhenPushed = YES;
        drawNotice.gameEn = vo.gameEn;
        [self.navigationController pushViewController:drawNotice animated:YES];
    }else{
        
        CLAwardListViewController* awardListVC = [[CLAwardListViewController alloc] init];
        awardListVC.gameEn = vo.gameEn;
        awardListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:awardListVC animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS(_weakSelf)
        [_mainTableView addRefresh:^{
            [_weakSelf.noticeAPI start];
        }];
    }
    return _mainTableView;
}

- (CLAwardNoticeAPI *)noticeAPI {
    
    if (!_noticeAPI) {
        _noticeAPI = [[CLAwardNoticeAPI alloc] init];
        _noticeAPI.delegate = self;
    }
    return _noticeAPI;
}

- (CLEmptyPageService *)emptyPageService{
    
    if (!_emptyPageService) {
        
        _emptyPageService = [[CLEmptyPageService alloc] init];
        _emptyPageService.delegate = self;
        _emptyPageService.butTitleArray = @[@"去首页看看"];
        _emptyPageService.contentString = @"暂无开奖信息";
        _emptyPageService.emptyImageName = @"empty_AwardAnnouncement.png";
    }
    return _emptyPageService;
}

- (CLNoNetFloatView *)noNetFloatView{
    
    if (!_noNetFloatView) {
        _noNetFloatView = [[CLNoNetFloatView alloc] initWithFrame:__Rect(0, SCREEN_HEIGHT - 64 - 49-  __SCALE(38), SCREEN_WIDTH, __SCALE(38))];
    }
    return _noNetFloatView;
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
