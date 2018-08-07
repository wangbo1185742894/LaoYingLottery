//
//  CLAwardListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardListViewController.h"
#import "CLAwardK3Cell.h"
#import "CLAwardD11Cell.h"
#import "CLSSQAwardNoticeCell.h"
#import "UIScrollView+CLRefresh.h"
#import "CLAwardGameListAPI.h"
#import "CLAwardVoModel.h"

#import "CLAwardBottomBetView.h"

#import "CLAwardDetailViewController.h"

#import "CLJumpLotteryManager.h"
#import "CLAppContext.h"

#import "CLEmptyPageService.h"

#import "CLATDrawNoticeCell.h"
#import "CLQLCDrawNoticeCell.h"
#import "CLSFCDrawNoticeCell.h"

#import "UIBarButtonItem+CLBarButtomItem.h"

@interface CLAwardListViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) CLAwardBottomBetView* bottomButton;
@property (nonatomic, strong) CLAwardGameListAPI* listAPI;

/**
 空白页
 */
@property (nonatomic, strong) CLEmptyPageService *emptyPage;

@end

@implementation CLAwardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = [[CLAppContext context] getGameNameWithGameEn:self.gameEn];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self.view addSubview:self.mainTableView];
    
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(__SCALE(kDevice_Is_iPhoneX ? -70 : -50));
    }];
    
    [self.mainTableView startRefreshAnimating];

}

#pragma mark - private

- (void)gotoBetLottery {
    
    NSArray *array = [self.listAPI pullData];
    if (array && array.count > 0) {
        CLAwardVoModel *model = [self.listAPI pullData][0];
        [CLJumpLotteryManager jumpLotteryWithGameEn:model.gameEn];
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    [self endRefreshing];
    
    if (request.urlResponse.success) {
        [self.listAPI deallingWithData:request.urlResponse.resp];
        
        if (([self.listAPI pullData] && [self.listAPI pullData].count > 0)) {
            CLAwardVoModel *model = [self.listAPI pullData][0];
            self.navTitleText = model.gameName;
            
            if (![self.view.subviews containsObject:self.bottomButton] && model.ifAuditing == 0) {
                [self.view addSubview:self.bottomButton];
                [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.bottom.right.equalTo(self.view);
                    make.height.mas_equalTo(__SCALE(kDevice_Is_iPhoneX ? 69 : 49));
                }];
            }
            [self.mainTableView reloadData];
        }
    }else{
        [self show:request.urlResponse.errorMessage];
    }
    

    if ([self.listAPI pullData].count == 0) {
        
        [self.emptyPage showNoWebWithSuperView:self.mainTableView];

    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    
    [self endRefreshing];
    
    
    if ([self.listAPI pullData].count == 0) {
        
        [self.emptyPage showNoWebWithSuperView:self.mainTableView];
        
    }
}

- (void) endRefreshing {
    
    [self.mainTableView stopRefreshAnimating];
}


#pragma mark --- CLEmptyPageServiceDelegate ---
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView
{

    [self.listAPI start];
}


#pragma mrak - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.listAPI pullData].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CLAwardVoModel* vo = [self.listAPI pullData][indexPath.row];
    
    if ([vo.gameEn hasSuffix:@"Kuai3"]){
        CLAwardK3Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLAwardK3Cell11"];
        if (!cell) {
            cell = [[CLAwardK3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLAwardK3Cell11"];
            cell.isShowLotteryName = NO;
        }
        [cell configureKuai3Data:vo];
        
        return cell;
    } else if ([vo.gameEn hasSuffix:@"11"]) {
        CLAwardD11Cell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLAwardD11Cell"];
        if (!cell) {
            cell = [[CLAwardD11Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLAwardD11Cell"];
            cell.isShowLotteryName = NO;
        }
        
        cell.isShowLotteryName = NO;
        [cell configureD11Data:vo];
        return cell;
        
        
    }else if ([vo.gameEn hasSuffix:@"ssq"]) {
        
        CLSSQAwardNoticeCell* cell = [CLSSQAwardNoticeCell createSSQAwardNoticeCellWithTableView:tableView];
        
        cell.isShowLotteryName = NO;
        [cell setOnlyShowNumberText:indexPath.row == 0 ? NO : YES];
        [cell configureSQQData:vo type:CLAwardLotteryTypeSSQ];
        
        return cell;
        
    }else if ([vo.gameEn hasSuffix:@"dlt"]) {
        
        CLSSQAwardNoticeCell* cell = [CLSSQAwardNoticeCell createSSQAwardNoticeCellWithTableView:tableView];
        
        cell.isShowLotteryName = NO;
        [cell setOnlyShowNumberText:indexPath.row == 0 ? NO : YES];
        [cell configureSQQData:vo type:CLAwardLotteryTypeDLT];
        
        return cell;
        
    }else if ([vo.gameEn hasSuffix:@"pl3"] || [vo.gameEn hasSuffix:@"pl5"] ||[vo.gameEn hasSuffix:@"fc3d"]){
    
        CLATDrawNoticeCell *cell = [CLATDrawNoticeCell createATDrawNoticeCellWithTableView:tableView];
        
        [cell setShowLotteryName:NO];
        [cell setOnlyShowNumberText:indexPath.row == 0 ? NO : YES];
        [cell setData:vo];
        
        return cell;
    }else if ([vo.gameEn hasSuffix:@"qlc"] || [vo.gameEn hasSuffix:@"qxc"]){

        CLQLCDrawNoticeCell *cell = [CLQLCDrawNoticeCell createDrawNoticeCellWithTableView:tableView];
        
        [cell setShowLotteryName:NO];
        [cell setOnlyShowNumberText:indexPath.row == 0 ? NO : YES];
        [cell setData:vo];
        
        return cell;
        
    }else if ([vo.gameEn hasSuffix:@"sfc"]){
    
        CLSFCDrawNoticeCell *cell = [CLSFCDrawNoticeCell createDrawNoticeCellWithTableView:tableView];
        
        [cell setShowLotteryName:NO];
        [cell setOnlyShowNumberText:indexPath.row == 0 ? NO : YES];
        [cell setData:vo];
        
        return cell;
        
    }
    return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"dafault"];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLAwardDetailViewController* awardDetailVC = [[CLAwardDetailViewController alloc] init];
    awardDetailVC.awardVo = [self.listAPI pullData][indexPath.row];
    [self.navigationController pushViewController:awardDetailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return CL__SCALE(100.f);
}


#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.rowHeight = __SCALE(90.f);
        WS(_weakSelf)
        [_mainTableView addRefresh:^{
            _weakSelf.listAPI.gameEn = _weakSelf.gameEn;
            [_weakSelf.listAPI start];
        }];
    }
    return _mainTableView;
}

- (CLAwardGameListAPI *)listAPI {
    
    if (!_listAPI) {
        _listAPI = [[CLAwardGameListAPI alloc] init];
        _listAPI.delegate = self;
    }
    return _listAPI;
}

- (CLAwardBottomBetView *)bottomButton
{
    
    WS(weakSelf);
    if (!_bottomButton) {
        
        _bottomButton = [CLAwardBottomBetView awardBottomWithType:(CLAwardBottomTypeSFC)];
        
        _bottomButton = [CLAwardBottomBetView awardBottomWithType:([self.gameEn isEqualToString:@"sfc"] || [self.gameEn isEqualToString:@"rx9"]) ? CLAwardBottomTypeSFC : CLAwardBottomTypeNormal];
        
        [_bottomButton returnLeftButtonBlock:^{
           
            [weakSelf gotoBetLottery];
        }];
        
        [_bottomButton returnRightButtonBlock:^{
           
            [CLJumpLotteryManager jumpLotteryWithGameEn:@"rx9"];
            
        }];
        
    }
    return _bottomButton;
}

- (CLEmptyPageService *)emptyPage
{

    if (_emptyPage == nil) {
        
        _emptyPage = [[CLEmptyPageService alloc] init];
        
        _emptyPage.delegate = self;
    }
    return _emptyPage;
}

- (void)viewDidLayoutSubviews {
    
    self.mainTableView.contentInset = UIEdgeInsetsMake(self.mainTableView.contentInset.top, 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
