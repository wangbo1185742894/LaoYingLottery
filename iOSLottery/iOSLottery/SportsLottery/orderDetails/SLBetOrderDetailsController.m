//
//  CQBetOrderDetailViewController.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetOrderDetailsController.h"

#import "UIViewController+SLBaseViewController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "CQDefinition.h"

#import "SLConfigMessage.h"

#import "SLBetOrderDetailHeaderView.h"
#import "SLBetODContentTableViewCell.h"
#import "SLBODAllModel.h"

#import "CQBasicAnimation.h"

#import "SLBetODBottomView.h"

#import "SLRefreshHeaderView.h"

#import "SLOrderDetailsRequest.h"

#import "SLOrderContinuePayRequest.h"

#import "SLExternalService.h"

#import "SLTicketDetailsController.h"

#import "SLWebViewController.h"

#import "SLListViewController.h"

#import "SLEmptyPageService.h"

#import "SLOrderDetailsMessageCell.h"
#import "BBMatchBetListController.h"
@interface SLBetOrderDetailsController ()<UITableViewDelegate, UITableViewDataSource,CLRequestCallBackDelegate,SLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView *mainTableView;


@property (nonatomic, strong) SLBODAllModel *mainDataModel;//全部数据

/**
 区头View
 */
@property (nonatomic, strong) SLBetOrderDetailHeaderView *mainHeaderView;

@property (nonatomic, strong) UIBarButtonItem *shareItem;

@property (nonatomic, strong) SLBetODBottomView *bottomView;

/**
 网络请求
 */
@property (nonatomic, strong) SLOrderDetailsRequest *request;
/**
 继续支付网络请求
 */
@property (nonatomic, strong) SLOrderContinuePayRequest *continuePayRequest;

/**
 用来区分是否是正常网络请求
 */
@property (nonatomic, assign) BOOL isNormalRequest;

/**
 空白页
 */
@property (nonatomic, strong) SLEmptyPageService *emptyPage;

@property (nonatomic, strong) NSDictionary *dataDictionary;

@property (nonatomic, strong) NSString *shareText;

@end

@implementation SLBetOrderDetailsController
{
    UILabel * _contentLongLabel;
}

- (instancetype)initWithRouterParams:(NSDictionary *)param{
    
    if (self = [super init]) {
        
        self.order_ID = param[@"order_id"];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


- (void)dealloc
{

    NSLog(@"我要被销毁了");
}



#pragma mark --- Life Cycle ---

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //注销长按文本隐藏响应
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //结束网络请求
    [self.request cancel];
    self.request.delegate = nil;
    
    [self.continuePayRequest cancel];
    self.continuePayRequest.delegate = nil;
    
    //结束刷新
    [self.mainTableView.mj_header endRefreshing];
    
    [self.mainHeaderView stopTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.request.delegate = self;
    self.continuePayRequest.delegate = self;
    
    [self.mainTableView.mj_header beginRefreshing];
    
    //注册长按文本隐藏响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerHidden:) name:UIMenuControllerDidHideMenuNotification object:nil];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownEnd) name:@"SLOrderDetailsCountDownEnd" object:nil];
}

#pragma mark ---- 倒计时结束通知 ----
- (void)countDownEnd
{

    [self.request start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configNavigation];
    
    [self.view addSubview:self.mainTableView];

    self.view.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    
    [self.view addSubview:self.bottomView];
}

- (void)configNavigation
{
    [self setNavTitle:@"订单详情"];

//    UIBarButtonItem *backItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(backItemClick)];
//
//    UIBarButtonItem *space = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
//    self.navigationItem.leftBarButtonItems = @[space,backItem];
    
    self.navigationItem.rightBarButtonItems = @[self.shareItem];
    
}
- (void)backItemClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)shareItemClick
{

    [SLExternalService shareMessageWithTitle:self.shareText tableView:self.mainTableView];
    
}

#pragma mark --- CLRequestCallBackDelegate ---

- (void)requestFinished:(CLBaseRequest *)request
{
    [self.mainTableView.mj_header endRefreshing];
    
    
    if (request.urlResponse.success) {
        
        if (request == self.continuePayRequest) {
            
            self.isNormalRequest = NO;
            
            self.dataDictionary = request.urlResponse.resp;
            
            NSString *orderID = request.urlResponse.resp[@"order_id"];
            
            if (orderID && [orderID isKindOfClass:[NSString class]] && orderID.length > 0) {
                
                self.order_ID = orderID;
            }
            NSMutableDictionary *orderInfo = [NSMutableDictionary dictionary];
            [orderInfo addEntriesFromDictionary:request.urlResponse.resp];
            if (self.mainDataModel.endPayTime != NSNotFound) [orderInfo setObject:@(self.mainDataModel.endPayTime) forKey:@"endTime"];
            [[SLExternalService sl_ShareExternalService].externalService createContinueOrderSuccess:orderInfo origin:self];
            
        }else if(request == self.request){
        
            self.isNormalRequest = YES;
        
            
            NSDictionary *temp = request.urlResponse.resp;
            
            self.shareText = temp[@"shareText"];
            
            self.dataDictionary = temp;
            
            if (temp.count == 0) {
                
                [self.emptyPage sl_showNoWebWithSuperView:self.view];
    
                self.mainDataModel = nil;
                
                self.mainTableView.tableHeaderView = nil;
                
                [self.mainTableView reloadData];
                
                return;
                
            }
            
            
            [self.emptyPage sl_removeEmptyView];
            
            [self.request disposeDataDictionary:temp];
            

            [self.mainHeaderView assignUIWithData:[self.request getHeaderViewModel]];
            
            self.mainTableView.tableHeaderView = self.mainHeaderView;
            
            self.mainDataModel = [self.request getAllModel];
            

            [self.shareItem sl_setItemHidden:(self.mainDataModel.ifShowShareButton == 1) ? NO : YES];
            
            [self.mainTableView reloadData];
            
            self.mainTableView.frame = __Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (self.mainDataModel.ifShowBetButton?49:0) - 64);
            self.bottomView.hidden = !self.mainDataModel.ifShowBetButton;
        }
        
    }else{
    
        if (request == self.continuePayRequest) {
            
            [SLExternalService showError:request.urlResponse.errorMessage];
            
            [self.mainTableView.mj_header beginRefreshing];
        }
    
    }
    
    
    
}

- (void)requestFailed:(CLBaseRequest *)request
{
    [self.mainTableView.mj_header endRefreshing];
    
    self.mainDataModel = nil;
    
    self.mainTableView.tableHeaderView = nil;
    
    [self.mainTableView reloadData];
    

    
    self.isNormalRequest = self.request == request ? YES : NO;
    
    [self.emptyPage sl_showNoWebWithSuperView:self.view];
    
    [self.shareItem sl_setItemHidden:YES];;


    
    self.bottomView.hidden = YES;
    
    [SLExternalService showError:request.urlResponse.errorMessage];

}

- (void)sl_noWebOnClickWithEmpty:(SLEmptyPageView *)emptyView
{
    
    self.isNormalRequest ? [self.mainTableView.mj_header beginRefreshing] : [self.continuePayRequest start];
    
}


#pragma mark - tableView 的delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.mainDataModel == nil) return 0;

    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0){
        return 0;
    }
    if (indexPath.section == 1){
        return [SLBetODTitleTableViewCell cellHeight];
    }
    if (indexPath.section == 2){
        return self.mainDataModel.betMatchVos[indexPath.row].programmeInfoHeight;
    }
    if (indexPath.section == 3) {
        return __SCALE(25.f);
    }
    if (indexPath.section == 4){
        
        return self.mainDataModel.orderMessageModel[indexPath.row].messageHeight;

    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.mainDataModel.awardStatusArr.count;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return self.mainDataModel.betMatchVos.count;
    }
    if (section == 3) {
        return 1;
    }
    if (section == 4) {
        return self.mainDataModel.orderMessageModel.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WS(_weakSelf)
    
    if (indexPath.section == 0)
    {
        //订单状态 中奖状态
        static NSString *IDcell = @"orderMessageTableViewCell";
        
        CQBetODMessageTableViewCell *cell = [CQBetODMessageTableViewCell createBODMessageTableViewCellWithTableView:tableView Data:self.mainDataModel.awardStatusArr[indexPath.row] Identifier:IDcell];
        
        return cell;
    }
    if (indexPath.section == 1) {
        //赛事信息的title
        
        SLBetODTitleTableViewCell *cell = [SLBetODTitleTableViewCell createBODTitleTableViewCellWithTableView:tableView];
        
        return cell;
    }
    if (indexPath.section == 2) {
        //赛事信息
        static NSString *IDcell = @"ContentTableViewCell";
        SLBetODContentTableViewCell *cell = [SLBetODContentTableViewCell createBODContentTableViewCellWithTableView:tableView Data:self.mainDataModel.betMatchVos[indexPath.row] Identifier:IDcell lotteryCode:self.mainDataModel.lottery_code];
        WS(_weakSelf)
        
        cell.sessionBlock = ^(NSString *pageUrl){
            NSLog(@"点击了场次按钮");

            SLWebViewController *webVC = [[SLWebViewController alloc] init];
            
            webVC.activityUrlString = pageUrl;
            
            [_weakSelf.navigationController pushViewController:webVC animated:YES];
        };
        return cell;
    }
    if (indexPath.section == 3) {
        //中奖怎么算?
        WS(_weakSelf);
        
        SLBetODAwardTableViewCell *cell = [SLBetODAwardTableViewCell createBODAwardCellWithTableView:tableView Data:nil];
        
        cell.winAwardBlock = ^(){
            
            SLWebViewController *web = [[SLWebViewController alloc] init];
            if ([_weakSelf.mainDataModel.gameEn isEqualToString:@"jczq_mix_p"]) {
                
                web.activityUrlString = @"https://m.laoyingcp.com/help/wanfashuoming/index.htm";
            }else if ([_weakSelf.mainDataModel.gameEn isEqualToString:@"jclq_mix_p"]){
                web.activityUrlString = @"https://m.caiqr.com/daily/wanfashuoming2/index.htm";
            }
            [_weakSelf.navigationController pushViewController:web animated:YES];
        };
        return cell;
    }
    if (indexPath.section == 4) {

        SLOrderDetailsMessageCell *messageCell = [SLOrderDetailsMessageCell createOrderDetailsMessageCellWithTableView:tableView];
        
        messageCell.messageModel = self.mainDataModel.orderMessageModel[indexPath.row];
        
        messageCell.messageCellBlock = ^{
          
            SLTicketDetailsController *ticketDetailsVC = [[SLTicketDetailsController alloc] init];
            ticketDetailsVC.order_id = _weakSelf.mainDataModel.orderId;

            [_weakSelf.navigationController pushViewController:ticketDetailsVC animated:YES];
        };
        
        messageCell.contentLongBlock = ^(CGRect contentCellRect, UILabel *contentLabel) {
            _contentLongLabel = contentLabel;
            UIMenuController *contentMenuContro = [UIMenuController sharedMenuController];
            UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(contentTextLabelCopy:)];
            CGRect menuRect = __Rect(0, CGRectGetMinY(contentCellRect), contentCellRect.size.width,contentCellRect.size.height);
            [contentMenuContro setTargetRect:menuRect inView:_weakSelf.self.mainTableView];
            [contentMenuContro setMenuItems:@[flag]];
            [contentMenuContro setMenuVisible:YES];
        };
        
        return messageCell;
       
    }
    
    //异常情况
    return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"abnormalCell"];
}

#pragma mark - MenuControllerCopyAcion
/**
 *  menu复制点击调用
 */
- (void)contentTextLabelCopy:(id)copyMenuController
{
    //复制文本到粘贴板
    [UIPasteboard generalPasteboard].string = _contentLongLabel.text;
}

- (void)menuControllerHidden:(NSNotification *)notif
{
    if (_contentLongLabel) {
        _contentLongLabel.backgroundColor = SL_CLEARCOLOR;
    }
}

#pragma mark - getterMothed

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 64) style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
        _mainTableView.backgroundColor = SL_UIColorFromRGB(0xFAF9F6);
        
        _mainTableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        //请求数据
        
        WS_SL(_weakSelf);
        
        _mainTableView.mj_header = [SLRefreshHeaderView headerWithRefreshingBlock:^{
            
            [_weakSelf.request start];
            
        }];

    }
    return _mainTableView;
}
- (SLBetOrderDetailHeaderView *)mainHeaderView
{
    if (!_mainHeaderView) {
        
        _mainHeaderView = [[SLBetOrderDetailHeaderView alloc] initWithFrame:CGRectZero];
        
        WS(_weakSelf);

        _mainHeaderView.continuePayBlock = ^(UIButton *btn){

            //继续支付
            [_weakSelf.continuePayRequest start];
            
        };
        
        _mainHeaderView.refundClick = ^{
           
            //退款说明
            [SLExternalService showRefundExplain];
        };
        
        
    }
    return _mainHeaderView;
}

- (SLOrderDetailsRequest *)request
{

    if (_request == nil) {
        
        _request = [[SLOrderDetailsRequest alloc] init];
        _request.order_id = self.order_ID;
        _request.delegate = self;
    }
    
    return _request;
}

- (SLOrderContinuePayRequest *)continuePayRequest
{

    if (_continuePayRequest == nil) {
        
        _continuePayRequest = [[SLOrderContinuePayRequest alloc] init];
        
        _continuePayRequest.orderId = self.order_ID;
        
        _continuePayRequest.delegate = self;
    }
    return _continuePayRequest;
}

- (void)setOrder_ID:(NSString *)order_ID
{
    _order_ID = order_ID;
    
    self.request.order_id = order_ID;
    
    self.continuePayRequest.orderId = order_ID;
}

- (UIBarButtonItem *)shareItem
{

    if (_shareItem == nil) {
        
        _shareItem = [UIBarButtonItem sl_itemWithTitle:@"分享" font:SL_FONT_SCALE(14.f) color:SL_UIColorFromRGB(0XFFFFFF) target:self action:@selector(shareItemClick)];
        
        [_shareItem sl_setItemHidden:YES];
    }
    return _shareItem;
}

- (SLBetODBottomView *)bottomView
{

    if (_bottomView == nil) {
        
        _bottomView = [[SLBetODBottomView alloc] initWithFrame:(CGRectZero)];
        
        _bottomView.frame = CGRectMake(0, SL_SCREEN_HEIGHT - 50 - 64, SL_SCREEN_WIDTH, 50);
        
        _bottomView.hidden = YES;
        
        WS_SL(weakSelf);
        
        _bottomView.btnClick = ^{
           
            if ([weakSelf.mainDataModel.gameEn isEqualToString:@"jczq_mix_p"]) {
                /** 足球投注列表 */
                SLListViewController *betListVC = [[SLListViewController alloc] init];
                
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:betListVC] animated:YES completion:nil];
            }else if ([weakSelf.mainDataModel.gameEn isEqualToString:@"jclq_mix_p"]){
                /** 篮球投注列表 */
                BBMatchBetListController *bBetListVC = [[BBMatchBetListController alloc] init];
                [weakSelf presentViewController:[[UINavigationController alloc] initWithRootViewController:bBetListVC] animated:YES completion:nil];
            }
           
        };

    }
    
    return _bottomView;
}

- (SLEmptyPageService *)emptyPage
{

    if (_emptyPage == nil) {
        
        _emptyPage = [[SLEmptyPageService alloc] init];
        
        _emptyPage.delegate = self;
    }
    return _emptyPage;
}

- (NSDictionary *)dataDictionary
{

    if (_dataDictionary == nil) {
        
        _dataDictionary = [NSDictionary dictionary];
    }
    return _dataDictionary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
