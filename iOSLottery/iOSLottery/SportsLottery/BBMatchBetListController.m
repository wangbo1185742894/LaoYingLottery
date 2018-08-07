//
//  BBMatchBetListController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchBetListController.h"

#import "BBDrawNoticeController.h"
#import "SLWebViewController.h"

#import "BBMatchInfoManager.h"

#import "SLConfigMessage.h"
#import "UIViewController+SLBaseViewController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "SLMatchBetHelperView.h"

#import "BBSectionHeaderView.h"
#import "BBMatchBetListCell.h"

#import "BBMatchBetBottomView.h"

#import "BBMatchListRequest.h"
#import "BBMatchDataHandle.h"

#import "BBMatchGroupModel.h"
#import "BBMatchModel.h"

#import "SLEmptyPageView.h"
#import "SLEmptyPageService.h"
#import "SLExternalService.h"
#import "SLRefreshHeaderView.h"

#import "BBMatchSelectView.h"
#import "SLMatchSelectView.h"

#import "BBBetDetailsController.h"

@interface BBMatchBetListController ()<UITableViewDataSource,UITableViewDelegate,CLRequestCallBackDelegate,SLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIBarButtonItem *selectItem;

@property (nonatomic, strong) BBMatchSelectView *selectView;

/**
 帮助view
 */
@property (nonatomic, strong) SLMatchBetHelperView *helperView;

/**
 底部投注View
 */
@property (nonatomic, strong) BBMatchBetBottomView *betBottomView;

@property (nonatomic, strong) BBMatchListRequest *listRequest;

@property (nonatomic, strong) BBMatchDataHandle *dataHandle;

@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 空数据页面
 */
@property (nonatomic, strong) SLEmptyPageService *emptyService;

@end

@implementation BBMatchBetListController

//老鹰彩票 主工程 统跳需要实现此方法
- (instancetype)initWithRouterParams:(NSDictionary *)param{
    
    if (self = [super init]) {
        self.isBackDrawNoticeController = [(param[@"isBackDraw"]?:@"0") integerValue] == 1;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    [self.view.window addSubview:self.helperView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self configUIData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    
    if (!SL_kDevice_Is_iPhoneX) {
        
        [SLExternalService showBasketBallNewbieGuidance];
    }
    
    [self configNavigationItem];
    
    [self.view addSubview:self.mainTableView];
    
    [self.view addSubview:self.betBottomView];
    
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.betBottomView.mas_top);
    }];
    
    [self.betBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.view);

    }];
    
    
    WS_SL(_weakSelf);
    
    self.mainTableView.mj_header = [SLRefreshHeaderView headerWithRefreshingBlock:^{
        
        [_weakSelf.listRequest start];
        
    }];
    
    [self.mainTableView.mj_header beginRefreshing];

}

//设置navigation属性
- (void)configNavigationItem
{
    
    [self setNavTitle:@"竞彩篮球"];
    
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

//赛事筛选
- (void)selectItemClick
{
    if (self.dataArray.count) {
        [self.selectView show];
    }
}

//更多方法(帮助)
- (void)moreItemClick
{
    
    self.helperView.hidden = NO;
    
    [self.view.window bringSubviewToFront:self.helperView];
}

- (void)leftItemClick
{
    [[BBMatchInfoManager shareManager] clearMatch];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- ButtonClick ---
//点击助手
- (void)clickHelperViewWithButton:(UIButton *)btn
{

    switch (btn.tag) {
        
        case 0:{
        
            if (self.isBackDrawNoticeController == YES) {
                
                if (self.presentationController) {
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }else{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                return;
            }
            
            BBDrawNoticeController *drawNotice = [[BBDrawNoticeController alloc] init];
            drawNotice.gameEn = @"jclq_mix_p";

            drawNotice.isBackHomeController = YES;

            [self.navigationController pushViewController:drawNotice animated:YES];
            
        }
            break;
            
        case 1:{
        
            SLWebViewController *web = [[SLWebViewController alloc] init];
            web.activityUrlString = @"https://m.caiqr.com/help/introdution_of_basketball.html";

            [self.navigationController pushViewController:web animated:YES];
            
            break;
        }
            
        default:
            break;
    }
}

//点击了确定按钮
- (void)goBetDeteilsButtonClick:(UIButton *)btn
{
    
    //判断当前是否有选中的串关  如果没有则赋值默认的
    if ([[BBMatchInfoManager shareManager] getSelectChuanGuanArrayCount] == 0) {
        if ([[BBMatchInfoManager shareManager] getCurrentMaxChuanGuanCount] > 0) {
            
            [[BBMatchInfoManager shareManager] saveSelectChuanGuan:[NSString stringWithFormat:@"%zi",[[BBMatchInfoManager shareManager] getCurrentMaxChuanGuanCount]]];
        }
    }
    
    if (btn.enabled == NO) return;
    
    BBBetDetailsController *details = [[BBBetDetailsController alloc] init];
    [self.navigationController pushViewController:details animated:YES];
}



#pragma mark ---- 网络请求回调 ----
- (void)requestFinished:(CLBaseRequest *)request
{
    [self.mainTableView.mj_header endRefreshing];
    
    if (request.urlResponse.success) {
        
        [[BBMatchInfoManager shareManager] saveAndclassifyAllMatchsInfo:request.urlResponse.resp];
        
        [self configUIData];
        

    }else{
    
        NSLog(@"请求失败");
    }
    
    [self.emptyService sl_showEmptyWithType:self.dataArray.count > 0 ? SLEmptyTypeHasData : SLEmptyTypeNoData superView:self.mainTableView];
    
    [self.selectItem sl_setItemHidden:!(self.dataArray.count > 0)];
    
    self.betBottomView.hidden = !(self.dataArray.count > 0);

    
}

- (void)requestFailed:(CLBaseRequest *)request
{

    [self.mainTableView.mj_header endRefreshing];
    
    [self.emptyService sl_showEmptyWithType:self.dataArray.count > 0 ? SLEmptyTypeHasData : SLEmptyTypeNoData superView:self.mainTableView];
    
    self.betBottomView.hidden = !(self.dataArray.count > 0);
    
    [self.selectItem sl_setItemHidden:!(self.dataArray.count > 0)];
    
    [SLExternalService showError:request.urlResponse.errorMessage];
    
}


- (void)configUIData
{

    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[[BBMatchInfoManager shareManager] getNeedShowMatchs]];
    
    
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
    
    [self.listRequest start];
}


#pragma mark ---- UITableViewDelegate ----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    BBMatchGroupModel *groupModel = self.dataArray[section];
    
    return groupModel.isVisible ? groupModel.matches.count : 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    BBMatchBetListCell *cell = [BBMatchBetListCell createMatchBetListCellWithTableView:tableView];
    
    BBMatchGroupModel *groupModel = self.dataArray[indexPath.section];
    
    BBMatchModel *model = groupModel.matches[indexPath.row];
    
    cell.matchModel = model;

    cell.seletedModel = [[BBMatchInfoManager shareManager] getSingleMatchSelectInfoWithMatchIssue:model.match_issue];

    WS_SL(_weakSelf);
    
    cell.reloadButtomViewBlock = ^{
        [_weakSelf configUIData];
        [_weakSelf.betBottomView reloadUI];
    };
    
    cell.showHistoryBlock = ^{
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
    };
    
    cell.historyClickBlock = ^(NSString *urlString) {
        SLWebViewController *webView = [[SLWebViewController alloc] init];
        webView.activityUrlString = urlString;
        [_weakSelf.navigationController pushViewController:webView animated:YES];
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    BBMatchGroupModel *groupModel = self.dataArray[section];
    if ((groupModel.add_top == 2)) {
        return 0;
    }
    return SL__SCALE(40.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BBSectionHeaderView *headView = [BBSectionHeaderView createBBSectionHeaderViewWithTableView:tableView];
    
    BBMatchGroupModel *groupModel = self.dataArray[section];
    
    headView.visible = groupModel.isVisible;

    if (groupModel.title.length > 0) {
        if ([groupModel.title rangeOfString:@"%s"].location != NSNotFound) {
            
            NSString *str = [groupModel.title stringByReplacingOccurrencesOfString:@"%s" withString:@"%zi"];
            headView.headerTitle = [NSString stringWithFormat:str, groupModel.matches.count];
        }
    }else{
        
        headView.headerTitle = @"";
    }
    
    [headView returnHeaderTapClick:^(BOOL visible) {
        
        groupModel.visible = visible;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    }];
    
    return headView;
}


#pragma mark ---- lazyLoad ----
- (UITableView *)mainTableView
{

    if (_mainTableView == nil) {
        
        _mainTableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        
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

- (UIBarButtonItem *)selectItem
{

    if (_selectItem == nil) {
        
       _selectItem = [UIBarButtonItem sl_itemWithImage:@"play_select" target:self action:@selector(selectItemClick)];
        
        [_selectItem sl_setItemHidden:YES];
    }
    return _selectItem;
}

- (BBMatchSelectView *)selectView
{
    
    if (_selectView == nil) {
        WS_SL(_weakSelf)
        _selectView = [[BBMatchSelectView alloc] initWithFrame:(CGRectZero)];
        _selectView.reloadLeagueMatchs = ^{
            
            [_weakSelf.dataArray removeAllObjects];
            [_weakSelf.dataArray addObjectsFromArray:[[BBMatchInfoManager shareManager] getNeedShowMatchs]];
            [_weakSelf.mainTableView scrollToRowAtIndexPath:[_weakSelf.mainTableView indexPathForCell:_weakSelf.mainTableView.visibleCells.firstObject] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [_weakSelf.mainTableView reloadData];
        };
    }
    
    return _selectView;
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

- (BBMatchListRequest *)listRequest
{

    if (_listRequest == nil) {
        
        _listRequest = [[BBMatchListRequest alloc] init];
        
        _listRequest.delegate = self;
    }
    return _listRequest;
}

- (BBMatchDataHandle *)dataHandle
{

    if (_dataHandle == nil) {
        
        _dataHandle = [[BBMatchDataHandle alloc] init];
    }
    return _dataHandle;
}

- (BBMatchBetBottomView *)betBottomView
{
    
    WS_SL(_weakSelf);
    if (_betBottomView == nil) {
        
        _betBottomView = [[BBMatchBetBottomView alloc] initWithFrame:(CGRectZero)];
        
        //点击确定
        [_betBottomView returnSureClick:^(UIButton *btn){
            
            [_weakSelf goBetDeteilsButtonClick:btn];
        }];
        
        //点击清空
        [_betBottomView returnEmpayClick:^ (UIButton *btn){
            
            [[BBMatchInfoManager shareManager] clearMatch];
            [_weakSelf.mainTableView reloadData];
        }];
    }
    
    return _betBottomView;
}


- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (SLEmptyPageService *)emptyService
{

    if (!_emptyService) {
        _emptyService = [[SLEmptyPageService alloc] init];
        _emptyService.delegate = self;
        _emptyService.butTitleArray = @[@"回首页看看"];
        _emptyService.contentString = @"当前无可投注的篮球比赛";
        _emptyService.emptyImageName = @"empty_basketball";
    }
    return _emptyService;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
