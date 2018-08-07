//
//  SLListViewController.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//  足球投注列表
#import "SLListViewController.h"

#import "SLConfigMessage.h"
#import "SLMatchBetCell.h"
#import "SLMatchSectionHeaderView.h"
#import "SLMatchBetHelperView.h"
#import "SLMatchBetBottomView.h"
#import "SLAllOddsView.h"
#import "SLMatchSelectView.h"
#import "UIViewController+SLBaseViewController.h"
#import "SLMatchBetRequest.h"
#import "SLMatchBetGroupModel.h"
#import "SLMatchBetModel.h"
#import "SLBetInfoManager.h"
#import "SLBetDetailsController.h"
#import "SLBetSelectInfo.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "SLDrawNoticeController.h"
#import "SLTicketDetailsController.h"

#import "SLBetOrderDetailsController.h"
#import "SLWebViewController.h"

#import "SLRefreshHeaderView.h"
#import "SLExternalService.h"
#import "SLBetInfoCache.h"
#import "SLEmptyPageService.h"
#import "AppDelegate.h"
#import "SLChuanGuanModel.h"

#import "SLAllOddsView.h"

@interface SLListViewController ()<UITableViewDataSource, UITableViewDelegate,CLRequestCallBackDelegate, SLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

/**
 帮助view
 */
@property (nonatomic, strong) SLMatchBetHelperView *helperView;

/**
 筛选view
 */
@property (nonatomic, strong) SLMatchSelectView *selectView;

@property (nonatomic, strong) UIBarButtonItem *selectItem;

/**
 底部投注View
 */
@property (nonatomic, strong) SLMatchBetBottomView *betBottomView;

/**
 网络请求
 */
@property (nonatomic, strong) SLMatchBetRequest *request;


/**
 dataSource
 */
@property (nonatomic, strong) NSMutableArray *dataSource;


/**
 空数据页面
 */
@property (nonatomic, strong) SLEmptyPageService *emptyService;

/**
 用于取消用户交互的View
 */
@property (nonatomic, strong) UIView *userInface;

/**
 全部倍率View
 */
@property (nonatomic, strong) SLAllOddsView *allOddsView;

@end

@implementation SLListViewController

- (void)dealloc
{

    NSLog(@"我死了");
}

//老鹰彩票 主工程 统跳需要实现此方法
- (instancetype)initWithRouterParams:(NSDictionary *)param{
    
    if (self = [super init]) {
        self.isBackDrawNoticeController = [(param[@"isBackDraw"]?:@"0") integerValue] == 1;
    }
    return self;
}

#pragma mark --- Life Cycle ---

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //结束网络请求
    [self.request cancel];
    self.request.delegate = nil;
    
    //结束刷新
    [self.mainTableView.mj_header endRefreshing];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    [self configUIData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.request.delegate = self;
    
    [self.view.window addSubview:self.helperView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    
    if (!SL_kDevice_Is_iPhoneX) {
        
        [SLExternalService showFootBallNewbieGuidance];
    }
    
    
    [self configNavigationItem];
    
    [self.view addSubview:self.mainTableView];
    
    [self.view addSubview:self.betBottomView];
    
    [self.view addSubview:self.userInface];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.betBottomView.mas_top);
    }];
    
    [self.betBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(self.view);
        
    }];
    
    WS_SL(_weakSelf);
    
    self.mainTableView.mj_header = [SLRefreshHeaderView headerWithRefreshingBlock:^{
        
        [_weakSelf.request start];
        
    }];
    
    [self.mainTableView.mj_header beginRefreshing];
    
}

//设置navigation属性
- (void)configNavigationItem
{
    
    [self setNavTitle:@"竞彩足球"];
    
    for (UIView *view in self.navigationController.navigationBar
         .subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1) {
            view.hidden = YES;
        }
    }

    
    self.navigationController.navigationBar.barTintColor = SL_UIColorFromRGB(0xE63222);
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *spaceItem1 = [UIBarButtonItem sl_spaceItemWithWidth:-5];
    UIBarButtonItem *spaceItem2 = [UIBarButtonItem sl_spaceItemWithWidth:-30];
    
    UIBarButtonItem *moreItem = [UIBarButtonItem sl_itemWithImage:@"play_more" target:self action:@selector(moreItemClick)];

    self.navigationItem.rightBarButtonItems= @[spaceItem1,moreItem,spaceItem2,self.selectItem];
    
    UIBarButtonItem *leftSpace = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
    UIBarButtonItem *leftItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(leftItemClick)];
    
    self.navigationItem.leftBarButtonItems = @[leftSpace,leftItem];
}

- (void)leftItemClick
{
    [SLBetInfoManager clearMatch];
        
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configUIData{
    
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:[SLBetInfoManager getNeedShowMatchs]];
    
    
    [self.mainTableView reloadData];
    [self.betBottomView reloadUI];
}

#pragma mark --- Empty page delegate ---
- (void)sl_noDataOnClickWithEmpty:(SLEmptyPageView *)emptyView clickIndex:(NSInteger)index{
    
    if (index == 0) {
        //跳首页
        [SLExternalService goToHomeViewController];
    }
}
- (void)sl_noWebOnClickWithEmpty:(SLEmptyPageView *)emptyView{
    
    [self.request start];
}


#pragma mark ---- CLRequestCallBackDelegate ----

- (void)requestFinished:(CLBaseRequest *)request
{
    
   [self.mainTableView.mj_header endRefreshing];

   if (request.urlResponse.success) {
    
       
       NSDictionary *temp = request.urlResponse.resp;
       
       //数据校验
       if (![temp isKindOfClass:[NSDictionary class]] && temp.count > 0) return;
       
       [SLBetInfoManager saveAndclassifyAllMatchsInfo:temp];
       
       [self configUIData];
    }
    
    [self.emptyService sl_showEmptyWithType:self.dataSource.count > 0 ? SLEmptyTypeHasData : SLEmptyTypeNoData superView:self.mainTableView];
    
    self.betBottomView.hidden = !(self.dataSource.count > 0);
    
    [self.selectItem sl_setItemHidden:!(self.dataSource.count > 0)];
}

- (void)requestFailed:(CLBaseRequest *)request
{

    [self.mainTableView.mj_header endRefreshing];
    
    [self.emptyService sl_showEmptyWithType:self.dataSource.count > 0 ? SLEmptyTypeHasData : SLEmptyTypeNoData superView:self.mainTableView];
    
    self.betBottomView.hidden = !(self.dataSource.count > 0);
    
    [self.selectItem sl_setItemHidden:!(self.dataSource.count > 0)];
    
    [SLExternalService showError:request.urlResponse.errorMessage];

}

//赛事筛选
- (void)selectItemClick
{
    if (self.dataSource.count) {
        [self.selectView show];
    }
}

//更多方法(帮助)
- (void)moreItemClick
{

    self.helperView.hidden = NO;
    
    [self.view.window bringSubviewToFront:self.helperView];
}

//点击了确定按钮
- (void)confirmOnClick:(UIButton *)btn
{
    
    
    //判断当前是否有选中的串关  如果没有则赋值默认的
    if ([SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray.count == 0) {
        if ([SLBetInfoManager getCurrentMaxChuanGuanCount] > 0) {
        
            [SLBetInfoManager saveSelecrChuanGuan:[NSString stringWithFormat:@"%zi", [SLBetInfoManager getCurrentMaxChuanGuanCount]]];
        }
    }
    
    if (btn.enabled == NO) return;
    
    SLBetDetailsController *details = [[SLBetDetailsController alloc] init];
    [self.navigationController pushViewController:details animated:YES];
}
#pragma mark ------------ UITableView delegate ------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    SLMatchBetGroupModel *groupModel = self.dataSource[section];
    if ((groupModel.add_top == 2)) {
        
        return 0;
    }
    return SL__SCALE(40.f);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    SLMatchBetGroupModel *groupModel = self.dataSource[section];
    
    if (groupModel.isVisible == YES) return groupModel.matches.count;
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WS_SL(_weakSelf);
    SLMatchBetCell *cell = [SLMatchBetCell createBetCellWithTableView:tableView];
    SLMatchBetGroupModel *groupModel = self.dataSource[indexPath.section];
    SLMatchBetModel *betModel = groupModel.matches[indexPath.row];
    
    SLBetSelectSingleGameInfo *info = [SLBetInfoManager getSingleMatchSelectInfoWithMatchIssue:betModel.match_issue];
    
    cell.matchBetModel = betModel;
    cell.selectInfoModel = info;
    [cell selectPlayMothedItemNumber];
    cell.showHistoryBlock = ^(SLMatchBetCell *reCell) {
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    };
    
    cell.reloadSelectMatchBlock = ^(SLMatchBetCell *cell) {
       
        [_weakSelf.betBottomView reloadUI];
    };
    
    cell.historyOnClickBlock = ^(NSString *url){
        
        SLWebViewController *webView = [[SLWebViewController alloc] init];
        webView.activityUrlString = url;
        [_weakSelf.navigationController pushViewController:webView animated:YES];
        NSLog(@"点击了历史战绩");
    };
    cell.unfoldAllOddsBlock = ^{
        
        SLAllOddsView *allOddsView = [[SLAllOddsView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        allOddsView.reloadSelectDataBlock = ^(NSIndexPath *indexPath) {
            
            [_weakSelf.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [_weakSelf.betBottomView reloadUI];
            
            
        };

        

        
        allOddsView.selectIndexPath = indexPath;
        allOddsView.currentMatchInfo = betModel;
        
        [allOddsView showInWindow];
        
        
    };
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SLMatchSectionHeaderView *headView = [SLMatchSectionHeaderView createMatchSecionHeaderViewWithTableView:tableView];
    
    headView.clickSectionHeadviewBlock = ^(SLMatchSectionHeaderView *head) {
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    SLMatchBetGroupModel *groupModel = self.dataSource[section];
    
    headView.headerModel = groupModel;
    
    return headView;
}


#pragma mark --- ButtonClick ---
//点击助手
- (void)clickHelperViewWithButton:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:{
            //开奖公告
            
            if (self.isBackDrawNoticeController == YES) {
                
                if (self.presentingViewController) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } else {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
            }
            
            SLDrawNoticeController *drawNotice = [[SLDrawNoticeController alloc] init];
            drawNotice.gameEn = @"jczq_mix_p";
            
            drawNotice.isBackHomeController = YES;
            
            [self.navigationController pushViewController:drawNotice animated:YES];
        }
            break;
        case 1:{
            SLWebViewController *web = [[SLWebViewController alloc] init];
            web.activityUrlString = @"https://m.laoyingcp.com/help/wanfashuomingm/index.htm";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark ------------ getter Mothed ------------
- (UITableView *)mainTableView{
    
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.estimatedRowHeight = 400;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        _mainTableView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    }
    
    return _mainTableView;
}

- (SLMatchBetHelperView *)helperView
{

    WS_SL(_weakSelf);
    if (!_helperView) {
        _helperView = [[SLMatchBetHelperView alloc] initWithFrame:CGRectMake(0, 0, SL_SCREEN_WIDTH, SL_SCREEN_HEIGHT)];
        _helperView.titleArray = @[@"历史比分",@"玩法说明"];
        _helperView.helperButtonBlock = ^(UIButton *btn){
            
            [_weakSelf clickHelperViewWithButton:btn];
        };
        _helperView.hidden = YES;
        
    }
    return _helperView;
}

- (SLMatchBetBottomView *)betBottomView
{

    WS_SL(_weakSelf);
    if (_betBottomView == nil) {
        
        _betBottomView = [[SLMatchBetBottomView alloc] initWithFrame:(CGRectZero)];
        
        //点击确定
        [_betBottomView returnSureClick:^(UIButton *btn){
           
            [_weakSelf confirmOnClick:btn];
        }];
        
        //点击清空
        [_betBottomView returnEmpayClick:^ (UIButton *btn){
           
            [SLBetInfoManager clearMatch];
            [_weakSelf.mainTableView reloadData];
        }];
    }

    return _betBottomView;
}

- (SLMatchSelectView *)selectView
{

    if (_selectView == nil) {
        WS_SL(_weakSelf)
        _selectView = [[SLMatchSelectView alloc] initWithFrame:(CGRectZero)];
        _selectView.reloadLeagueMatchs = ^{
           
            [_weakSelf.dataSource removeAllObjects];
            [_weakSelf.dataSource addObjectsFromArray:[SLBetInfoManager getNeedShowMatchs]];
 
                [_weakSelf.mainTableView scrollToRowAtIndexPath:[_weakSelf.mainTableView indexPathForCell:_weakSelf.mainTableView.visibleCells.firstObject] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            [_weakSelf.mainTableView reloadData];
        };
    }
    
    return _selectView;
}

- (UIBarButtonItem *)selectItem
{
    
    if (_selectItem == nil) {
        
        _selectItem = [UIBarButtonItem sl_itemWithImage:@"play_select" target:self action:@selector(selectItemClick)];
        
        [_selectItem sl_setItemHidden:YES];
    }
    return _selectItem;
}

- (SLMatchBetRequest *)request
{

    if (_request == nil) {
        
        _request = [[SLMatchBetRequest alloc] init];
        
        _request.delegate = self;
    }
    
    return _request;
}

- (SLEmptyPageService *)emptyService{
    
    if (!_emptyService) {
        _emptyService = [[SLEmptyPageService alloc] init];
        _emptyService.delegate = self;
        _emptyService.butTitleArray = @[@"去首页看看"];
        _emptyService.contentString = @"当前无可投注的足球比赛";
        _emptyService.emptyImageName = @"empty_football";
    }
    return _emptyService;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSource;
}

- (UIView *)userInface
{

    if (_userInface == nil) {
        
        _userInface = [[UIView alloc] initWithFrame:(self.view.frame)];
        
        _userInface.hidden = YES;
        
        _userInface.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
    }
    return _userInface;
}

- (SLAllOddsView *)allOddsView
{

    if (_allOddsView == nil) {
        
        _allOddsView = [[SLAllOddsView alloc] initWithFrame:(CGRectZero)];
        
    }
    return _allOddsView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
