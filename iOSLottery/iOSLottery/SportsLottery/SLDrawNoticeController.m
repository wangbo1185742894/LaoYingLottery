//
//  SLDrawNoticeController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeController.h"
#import "UIViewController+SLBaseViewController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "SLConfigMessage.h"
#import "SLDrawNoticeCell.h"
#import "SLDrawNoticeNoDataCell.h"
#import "SLDrawNoticeHeaderView.h"
#import "SLDrawNoticeDateSelectView.h"

#import "SLDrawNoticeRequest.h"
#import "SLDrawNoticeGroupModel.h"
#import "SLDrawNoticeModel.h"

#import "SLRefreshHeaderView.h"

#import "SLListViewController.h"
#import "SLExternalService.h"

#import "SLEmptyPageService.h"

@interface SLDrawNoticeController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,SLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SLDrawNoticeRequest *request;

@property (nonatomic,strong) UIBarButtonItem *dateSelectItem;

/**
 日期选择View
 */
@property (nonatomic, strong) SLDrawNoticeDateSelectView *dateSelectView;

/**
 底部立即投注按钮
 */
@property (nonatomic, strong) UIView *bottomView;

/**
 空数据页面
 */
@property (nonatomic, strong) SLEmptyPageService *emptyService;

@property (nonatomic, strong) UIButton *betButton;

@end

@implementation SLDrawNoticeController

- (void)dealloc
{

    NSLog(@"i am dealloc");
    
}

#pragma mark --- Life Cycle ---

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //结束网络请求
    [self.request cancel];
    self.request.delegate = nil;
    
    //结束刷新
    [self.listTableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.request.delegate = self;
    
}

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
    
    [self.request start];
    

    [self.listTableView.mj_header beginRefreshing];
    
}


- (void)configNavigation
{
    [self setNavTitle:@"竞彩足球"];
    
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

#pragma mark --- 立即投注 ----
- (void)goBetClick
{
    if (self.isBackHomeController == YES) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }

    SLListViewController *betListVC = [[SLListViewController alloc] init];
    
    betListVC.isBackDrawNoticeController = YES;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:betListVC] animated:YES completion:nil];
}

- (void)requestFinished:(CLBaseRequest *)request
{

    [self.listTableView.mj_header endRefreshing];
    
    if (request.urlResponse.success) {
    
        [self configNavigation];
    
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
        
    }else{
        
        [self.dateSelectItem sl_setItemHidden:YES];
        
        [SLExternalService showError:request.urlResponse.errorMessage];
    }
    
     self.dataArray = [self.request getDataArray];
    
    
    if (self.dataArray.count == 0) {
        
        [self.emptyService sl_showNoWebWithSuperView:self.listTableView];
    }else{

        [self.emptyService sl_removeEmptyView];
    }
    
        self.bottomView.hidden = !(self.dataArray.count > 0);
}

- (void)requestFailed:(CLBaseRequest *)request
{
    
    [self.listTableView.mj_header endRefreshing];
    
    [self.dateSelectItem sl_setItemHidden:YES];

    NSString *errorMessage = request.urlResponse.errorMessage;
    
    if (!([errorMessage isKindOfClass:[NSString class]] && errorMessage && errorMessage.length > 0)) {
        
        errorMessage = @"请求失败，请下拉列表重新获取";
    }
    [SLExternalService showError:errorMessage];
    
    self.bottomView.hidden = !(self.dataArray.count > 0);
}


- (void)sl_noWebOnClickWithEmpty:(SLEmptyPageView *)emptyView
{

    [self.request start];
}


#pragma mark --- TableViewDelegate ---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.request getDateArrayCount];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    SLDrawNoticeGroupModel *groupModel = [self.request getGroupModelWithSection:section];
    
    return groupModel.isVisible ? groupModel.noticeInfo.count : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return SL__SCALE(40.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    SLDrawNoticeModel *model = [self.request getNoticeModelWithSection:indexPath.section row:indexPath.row];
    
    id cell = [model.className creatDrawNoticeCellWithTableViewNew:tableView];
    
    [cell setCellModel:model];
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SLDrawNoticeHeaderView *headView = [SLDrawNoticeHeaderView createDrawNoticeHeaderViewWithTableView:tableView];
    
    SLDrawNoticeGroupModel *groupModel = [self.request getGroupModelWithSection:section];
    
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

- (NSMutableArray *)dataArray
{

    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray new];
    }
    
    return _dataArray;
}

- (SLDrawNoticeRequest *)request
{

    if (_request == nil) {
        
        _request = [[SLDrawNoticeRequest alloc] init];
        _request.delegate = self;
        _request.gameEn = self.gameEn;
    }
    
    return _request;
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

- (SLEmptyPageService *)emptyService{
    
    if (!_emptyService) {
        _emptyService = [[SLEmptyPageService alloc] init];
        _emptyService.delegate = self;
//        _emptyService.butTitleArray = @[@"去首页看看"];
//        _emptyService.contentString = @"当前无足球比赛开奖信息";
//        _emptyService.emptyImageName = @"empty_football";
    }
    return _emptyService;
}

- (UIView *)bottomView
{

    if (_bottomView == nil) {
        
        _bottomView = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        _bottomView.hidden = YES;
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
