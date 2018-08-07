//
//  BBDrawNoticeController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDrawNoticeController.h"
#import "BBMatchBetListController.h"


#import "SLConfigMessage.h"
#import "UIViewController+SLBaseViewController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "BBDrawNoticeHeaderView.h"
#import "BBDrawNoticeCell.h"

#import "BBDrawNoticeRequest.h"

#import "SLRefreshHeaderView.h"

#import "SLExternalService.h"

#import "BBDrawNoticeGroupModel.h"
#import "BBDrawNoticeModel.h"

#import "SLDrawNoticeDateSelectView.h"

#import "BBMatchInfoManager.h"
@interface BBDrawNoticeController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic,strong) UIBarButtonItem *dateSelectItem;

/**
 底部立即投注按钮
 */
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *betButton;

@property (nonatomic, strong) BBDrawNoticeRequest *request;

/**
 日期选择View
 */
@property (nonatomic, strong) SLDrawNoticeDateSelectView *dateSelectView;

@end

@implementation BBDrawNoticeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    
    [self configNavigation];
    
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.bottomView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
        
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(SL__SCALE(50.f));
    }];
    
    WS_SL(_weakSelf);
    
    self.listTableView.mj_header = [SLRefreshHeaderView headerWithRefreshingBlock:^{
        
        [_weakSelf.request start];
        
    }];
    
    [self.listTableView.mj_header beginRefreshing];
    
}


- (void)configNavigation
{
    [self setNavTitle:@"竞彩篮球"];
    
    UIBarButtonItem *backItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(backItemClick)];
    
    UIBarButtonItem *space = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
    self.navigationItem.leftBarButtonItems = @[space,backItem];
    
    self.navigationItem.rightBarButtonItems = @[self.dateSelectItem];
}

- (void)backItemClick
{
    
    if (self.isBackHomeController == YES) {
        
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//日期筛选
- (void)dateItemClick
{
    [self.dateSelectView showInWindow];
}


#pragma mark ---- 网络请求回调 ----
- (void)requestFinished:(CLBaseRequest *)request
{
    [self.listTableView.mj_header endRefreshing];
    
    if (request.urlResponse.success) {
        
        NSDictionary *temp = request.urlResponse.resp;
        
        //数据校验
        if (![temp isKindOfClass:[NSDictionary class]] && temp.count > 0) return;
        
        [self.dateSelectItem sl_setItemHidden:NO];
        
        [self.request disposeDataWithDictionary:temp];
        
        [self.listTableView reloadData];
        NSString *firstDateString = [[self.request getGroupModelWithSection:0].msg componentsSeparatedByString:@"_"].firstObject?:@"";
        if([firstDateString componentsSeparatedByString:@"-"].count == 3)
        {
            self.dateSelectView.defaultSelectDate = firstDateString;
        }
        self.dateSelectView.dataArray = [self.request getDateSelectArray];
        NSLog(@"######");
    }else{
        
        [self.dateSelectItem sl_setItemHidden:YES];
        
        [SLExternalService showError:request.urlResponse.errorMessage];
    }
    
}

- (void)requestFailed:(CLBaseRequest *)request
{
    
    NSLog(@"请求失败");
    
}


#pragma mark --- 立即投注 ----
- (void)goBetClick
{
    if (self.isBackHomeController == YES) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    BBMatchBetListController *betListVC = [[BBMatchBetListController alloc] init];
    
    betListVC.isBackDrawNoticeController = YES;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:betListVC] animated:YES completion:nil];
}

#pragma mark --- TableViewDelegate ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.request getDateArrayCount];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    BBDrawNoticeGroupModel *groupModel = [self.request getGroupModelWithSection:section];
    
    return groupModel.isVisible ? groupModel.noticeInfo.count : 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return SL__SCALE(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    BBDrawNoticeModel *model = [self.request getNoticeModelWithSection:indexPath.section row:indexPath.row];
    
    id cell = [model.className creatDrawNoticeCellWithTableViewNew:tableView];
    
    [cell setCellModel:model];
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BBDrawNoticeHeaderView *headView = [BBDrawNoticeHeaderView createBBDrawNoticeHeaderViewWithTableView:tableView];
    
    BBDrawNoticeGroupModel *groupModel = [self.request getGroupModelWithSection:section];
    
    
    headView.headerModel = groupModel;
    
    [headView returnHeaderTapClick:^{
    
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    
    return headView;

}


#pragma mark --- Get Method ---
- (UITableView *)listTableView
{
    
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.estimatedRowHeight = 400;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.showsHorizontalScrollIndicator = NO;
        
        _listTableView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        
    }
    
    return _listTableView;
}

- (UIBarButtonItem *)dateSelectItem
{
    
    if (_dateSelectItem == nil) {
        
        _dateSelectItem = [UIBarButtonItem sl_itemWithImage:@"date_select" target:self action:@selector(dateItemClick)];
        
        [_dateSelectItem sl_setItemHidden:YES];
    }
    return _dateSelectItem;
}

- (SLDrawNoticeDateSelectView *)dateSelectView
{
    
    if (_dateSelectView == nil) {
        
        _dateSelectView = [[SLDrawNoticeDateSelectView alloc] initWithFrame:(CGRectZero)];
        
        WS_SL(_weakSelf);
        
        _dateSelectView.sureBtnClock = ^(NSString *selectDate) {
            
            _weakSelf.request.drawNoticeTime = selectDate;
            
            [_weakSelf.request start];
            
            [_weakSelf.listTableView.mj_header beginRefreshing];
        };
    }
    
    return _dateSelectView;
}


- (UIView *)bottomView
{
    
    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        _bottomView.hidden = NO;
        
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        [_bottomView addSubview:self.betButton];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = SL_UIColorFromRGB(0xcccccc);
        [_bottomView addSubview:lineView];
        [self.betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_offset(SL__SCALE(280.f));
            make.height.mas_offset(SL__SCALE(35.f));
            make.centerX.centerY.equalTo(_bottomView);
            
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(_bottomView);
            make.height.mas_equalTo(.5f);
        }];
    }
    return _bottomView;
}

- (UIButton *)betButton
{
    
    if (_betButton == nil) {
        
        _betButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_betButton setTitle:@"立即投注" forState:(UIControlStateNormal)];
        [_betButton setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
        _betButton.backgroundColor = SL_UIColorFromRGB(0xE63222);
        
        _betButton.layer.cornerRadius = 4.f;
        
        _betButton.titleLabel.font = SL_FONT_SCALE(16);
        
        [_betButton addTarget:self action:@selector(goBetClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _betButton;
}

- (BBDrawNoticeRequest *)request
{

    if (_request == nil) {
        
        _request = [[BBDrawNoticeRequest alloc] init];
        
        _request.delegate = self;
        
        _request.gameEn = self.gameEn;
    }
    return _request;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
