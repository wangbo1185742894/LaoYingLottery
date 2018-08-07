//
//  CLHomeViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeViewController.h"
#import "UIScrollView+CLRefresh.h"
#import "UITableView+CLScreenCapture.h"

#import "CQHomeBannerView.h"
#import "CLHomeQuickBetCell.h"
#import "CLHomeQuickBetNewCell.h"
#import "CLHomeCellHeaderView.h"
#import "CLHomeLottSelectCell.h"
#import "CLHomeFocusCell.h"
#import "CLHomeModuleTableViewCell.h"

#import "CLHomeAPI.h"

#import "CLHomeModuleModel.h"
#import "CLHomeGameEnteranceModel.h"
#import "CLHomeViewHandler.h"
//跳转彩票投注
#import "CLJumpLotteryManager.h"
//快速支付
#import "CKNewQuickPayViewController.h"
//校验token
#import "CLCheckTokenManager.h"
//缓存
#import "CLCacheManager.h"
//跳转
#import "CLAllJumpManager.h"
//无网 浮层
#import "CLNoNetFloatView.h"
#import "CLNetworkReachabilityManager.h"
#import "CLNativePushService.h"
//新手引导
#import "CLNewbieGuidanceService.h"
#import "UIViewController+CQProxy.h"
#import "AppDelegate.h"
#import "CLLaunchActivityView.h"
#import "CLLaunchActivityManager.h"
#import "CLHomeHotBetModel.h"
#import "CLHomeGamePeriodModel.h"
//
#import "CLUpgradeRequest.h"
#import "CLUpgradePromptView.h"
#import "CLUpgradeModel.h"
#import "CLTools.h"
#import "CLNotificationUtils.h"
@interface CLHomeViewController () <UITableViewDelegate,UITableViewDataSource,CLHomeLottSelectCellDelegate,CLRequestCallBackDelegate,CLHomeQuickBetCellDelegate>{
    
    CLCheckTokenManager * __checkTokenManager;
}

@property (nonatomic, strong) UITableView* homeTableView;
@property (nonatomic, strong) CQHomeBannerView* bannerView;
@property (nonatomic, strong) CLUpgradePromptView *updateWindow;

@property (nonatomic, strong) CLHomeAPI* homeAPI;

@property (nonatomic, strong) CLHomeViewHandler* homeHandler;

@property (nonatomic, strong) CKNewQuickPayViewController *quickViewController;//快速投注

@property (nonatomic, assign) BOOL isShouldRequestHot;//表示该页面是否应该刷新快速投注

@property (nonatomic, strong) CLNoNetFloatView *noNetFloatView;//无网浮层

@property (nonatomic, strong) CLUpgradeRequest *upgradeRequest;
@end

@implementation CLHomeViewController
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.isShouldRequestHot = YES;
    [self addKeyBoardNotification];
    //添加 网络监听通知
    [self addNoNetNotification];
    
    //1.5V 多级界面跳首页，需隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.isShouldRequestHot = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    //升级弹窗
    [self.upgradeRequest start];
    
    if ([CLLaunchActivityManager getLaunchActivityImageData]) {
        [self addAlterToservice:[[CLLaunchActivityView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] withSuperView:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window option:CQAlertViewDisPlayedOptionHightHighest + 1];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:CLLaunchActivityViewClose object:nil userInfo:nil];
    }
    
    
    UIView *newbieView = [CLNewbieGuidanceService getNewGuidanceViewWithType:CLNewbieGuidanceTypeHome];
    if (newbieView) {
        [self addAlterToservice:newbieView withSuperView:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window option:CQAlertViewDisPlayedOptionNormal];
    }
    self.pageStatisticsName = @"首页";
    
    [self createUI];
    [self.homeTableView startRefreshAnimating];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = UIColorFromRGB(0xffffff);

    //configUI data
    [self configData];
    
    //校验token
    __checkTokenManager = [[CLCheckTokenManager alloc] init];
    __checkTokenManager.destroyCheckTokenManager = ^(){
        
        __checkTokenManager = nil;
    };
    [__checkTokenManager checkUserToken];
    
//    if (@available(iOS 11.0, *)) {
//        self.homeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
}
- (void)ViewContorlBecomeActive:(NSNotification *)notification{
    
    [super ViewContorlBecomeActive:notification];
    [self.quickViewController ViewContorlBecomeActive:notification];
}
#pragma mark - 添加键盘通知
- (void) addKeyBoardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    UITableViewCell * selectCell = nil;
    if ([firstResponder.superview.superview isKindOfClass:[UITableViewCell class]]) {
        selectCell = (UITableViewCell *)firstResponder.superview.superview;
    }
    CGRect selectRect = [self.homeTableView rectForRowAtIndexPath:[self.homeTableView indexPathForCell:selectCell]];
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //判断键盘是否挡住了cell
    CGFloat offset = (selectRect.origin.y + selectRect.size.height - self.homeTableView.contentOffset.y) - (SCREEN_HEIGHT - keyboardSize.height);
    if (offset > 0) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.homeTableView.contentOffset = CGPointMake(self.homeTableView.contentOffset.x, self.homeTableView.contentOffset.y + offset);
        
        [UIView commitAnimations];
        
    }
}
#pragma mark - 键盘消失
- (void)keyboardWillHide:(NSNotification *)noti{
    
    
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
#pragma mark - 升级弹窗
- (void)upgradeShow:(CLUpgradeModel *)model{
    
    //打开弹窗
    self.updateWindow = [[CLUpgradePromptView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.updateWindow.updatePromptText = model.versionDescribe;
    self.updateWindow.updateBlock = ^{
        //通用跳转
        NSLog(@"触发跳转...");
        if (model.downloadAddress && model.downloadAddress.length > 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.downloadAddress]];
        }
    };
    [self addAlterToservice:self.updateWindow withSuperView:((AppDelegate *)[[UIApplication sharedApplication] delegate]).window option:CQAlertViewDisPlayedOptionDefault];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.upgradeRequest) {
        if (request.urlResponse.success) {
            
            CLUpgradeModel *model = [CLUpgradeModel mj_objectWithKeyValues:request.urlResponse.resp];
            if (model.isUpgrade == 1 && model.isPopUp == 1) {
                [self upgradeShow:model];
            }
            
        }
    }else{
        if (request.urlResponse.success) {
            
            //存缓存
            [CLCacheManager saveToCacheWithContent:request.urlResponse.resp cacheFile:CLCacheFileNameHome];
            [self.homeHandler homeDataDealingWithDict:request.urlResponse.resp];
            [self.bannerView configureBanners:self.homeHandler.banners marquees:[self.homeHandler reports]];
            [self.homeTableView reloadData];
        }else{
            [self show:request.urlResponse.errorMessage];
        }
        self.isShouldRequestHot = YES;
        [self endRefreshing];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    self.isShouldRequestHot = YES;
    [self show:request.urlResponse.errorMessage];
    [self endRefreshing];
}

- (void)cancelRequest:(CLBaseRequest *)request {
    
    [self endRefreshing];

}

- (void) endRefreshing {
    
    [self.homeTableView stopRefreshAnimating];
}

#pragma mark - CLHomeLottSelectCellDelegate

- (void)selectCellLott:(CLHomeGameEnteranceModel *)lott index:(NSIndexPath *)index
{
    if (lott.ifGameSeries) {
        NSInteger groupIndex = index.row * 2 + 1;
        CLHomeModuleModel* module = [self.homeHandler homeData][index.section];
        CLHomeGameEnteranceModel *rightModel =((NSArray *)module.moduleObjc).count <= groupIndex + 1 ? ((NSArray *)module.moduleObjc)[groupIndex]  : nil;
        CLHomeGameEnteranceModel *leftModel = ((NSArray *)module.moduleObjc)[groupIndex - 1];
        lott.subEntranceIsShow = !lott.subEntranceIsShow;
        if ([lott isEqual:leftModel]) {
            if (rightModel && rightModel.subEntranceIsShow) {
                rightModel.subEntranceIsShow = NO;
            }
        }else if ([lott isEqual:rightModel] && leftModel.subEntranceIsShow){
            leftModel.subEntranceIsShow = NO;
        }
        
        [self.homeTableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:index.section + 1] withRowAnimation:UITableViewRowAnimationNone];
        [self.homeTableView scrollToAllShowArea:index];
    }else{
        if (lott.contentUrl && lott.contentUrl.length > 0) {
            if (lott.ifActivity == 1) {
                [CLNativePushService pushNativeUrl:lott.contentUrl];
            }else{
                [CLJumpLotteryManager jumpLotteryWithGameEn:lott.contentUrl];
            }
        }
    }
    
}
#pragma mark - CLHomeQuickBetCellDelegate

- (void) createOrderSuccess:(id)data payAccount:(NSInteger)payAccount{
    
    CKNewQuickPayViewController *quick = [[CKNewQuickPayViewController alloc] init];
    quick.orderType = CKQuickOrderTypeNormal;
    quick.preHandleToken = data[@"pre_handle_token"];
    quick.backImage = snapshot(self.view.window);
    [self presentViewController:[[CLBaseNavigationViewController alloc] initWithRootViewController:quick] animated:NO completion:nil];
}
- (void)createOrderFail:(id)data{
    
    [self show:data];
}
- (void) timeOut {
    //倒计时结束
    if (self.isShouldRequestHot) {
        self.isShouldRequestHot = NO;
        [self.homeAPI start];
    }
}
- (void)refreshData{
    
    [self.homeAPI start];
}
#pragma mark --- UITableViewDelegate ---

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.homeHandler homeData].count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CLHomeModuleModel* module = [self.homeHandler homeData][section];
    return [module count];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CLHomeModuleModel* module = [self.homeHandler homeData][indexPath.section];
    
    if (module.style == HomeModuleStyleQuickBet) {
        
        CLHomeHotBetModel *model = ((NSArray *)module.moduleObjc)[indexPath.row];
        NSString *tpye = model.periodVo.gameEn;
        if ([[tpye lowercaseString] hasSuffix:@"ssq"]||[[tpye lowercaseString] hasSuffix:@"dlt"])
        {
            
            if (((NSArray *)module.moduleObjc).count == indexPath.row + 1){
            
                return __SCALE(120);
            
            }else{
            
                return __SCALE(125);
            
            }
            
        
        }else if ((((NSArray *)module.moduleObjc).count == indexPath.row + 1)){
            
            return [module cellHeight] - __SCALE(5.f);//如果是快速投注且是最后一条，则不显示下方的灰色横线
        }
    }else if (module.style == HomeModuleStyleLottery){
        NSInteger groupIndex = indexPath.row * 2 + 1;
        CLHomeGameEnteranceModel *rightModel =((NSArray *)module.moduleObjc).count >= groupIndex + 1 ? ((NSArray *)module.moduleObjc)[groupIndex] : nil;
        CLHomeGameEnteranceModel *leftModel = ((NSArray *)module.moduleObjc)[groupIndex - 1];
        BOOL isCanShowSub = (rightModel ? (rightModel.ifGameSeries || leftModel.ifGameSeries) : leftModel.ifGameSeries);
        if (isCanShowSub) {
            if (rightModel && rightModel.subEntranceIsShow) {
                return (((rightModel.subEntrances.count % 2)?rightModel.subEntrances.count/2+1:rightModel.subEntrances.count/2) + 1) * [module cellHeight];
            }else if(leftModel.subEntranceIsShow){
                return (((leftModel.subEntrances.count % 2)?leftModel.subEntrances.count/2+1:leftModel.subEntrances.count/2) + 1) * [module cellHeight];
            }
        }
        
    }
    return [module cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    CLHomeModuleModel* module = [self.homeHandler homeData][section];
//    if (module.style == HomeModuleStyleQuickBet) {
//        return nil;
//    }
//    CLHomeCellHeaderView* headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CLHomeCellHeaderViewId"];
//    if (!headView) {
//        headView = [[CLHomeCellHeaderView alloc] initWithReuseIdentifier:@"CLHomeCellHeaderView"];
//    }
//    headView.title = module.title;
    return nil;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //数据校验
    if (indexPath.section >= [self.homeHandler homeData].count) return nil;
    
    CLHomeModuleModel* module = [self.homeHandler homeData][indexPath.section];
    //数据校验
    if (!module) return nil;
    
    if (module.style == HomeModuleStyleQuickBet) {
        
        CLHomeHotBetModel *hotBetModel = module.moduleObjc[indexPath.row];
        NSString *tpye = hotBetModel.periodVo.gameEn;
        if ([[tpye lowercaseString] hasSuffix:@"ssq"]||[[tpye lowercaseString] hasSuffix:@"dlt"]){
        
            CLHomeQuickBetNewCell *cell = [CLHomeQuickBetNewCell homeQuickBetNewCellCreateWithTableView:tableView];
            
            cell.delegate = self;
            cell.hotBetModel = hotBetModel;
            cell.isShowBottomLine = !(((NSArray *)module.moduleObjc).count == indexPath.row + 1);
            
            return cell;
        
        }else{
        
        
            CLHomeQuickBetCell* cell = [CLHomeQuickBetCell homeQuickBetCellCreateWithTableView:tableView];
            
            cell.delegate = self;
            cell.isShowBottomLine = !(((NSArray *)module.moduleObjc).count == indexPath.row + 1);
            cell.hotBetModel = hotBetModel;
            
            return cell;
        
        
        }
        
//        CLHomeQuickBetCell* cell = [CLHomeQuickBetCell homeQuickBetCellCreateWithTableView:tableView];
//        
//        cell.delegate = self;
//        cell.isShowBottomLine = !(((NSArray *)module.moduleObjc).count == indexPath.row + 1);
//        cell.hotBetModel = hotBetModel;
//        
//        return cell;
        
    } else if (module.style == HomeModuleStyleLottery){
        CLHomeLottSelectCell* cell = [CLHomeLottSelectCell lottSelectCellInitWith:tableView];
        if ((((NSArray*)module.moduleObjc).count - indexPath.row * 2) >= 2) {
            [cell configureLottery:[((NSArray*)module.moduleObjc) objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row * 2, 2)]]];
        }else{
            
            [cell configureLottery:[((NSArray*)module.moduleObjc) objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row * 2, 1)]]];
        }
        
        cell.delegate = self;
        return cell;
    } else if (module.style == HomeModuleStyleFocus){
        
        if (module.moduleObjc && ((NSArray *)module.moduleObjc).count > 0) {
            return [CLHomeFocusCell focusCellInitWith:tableView data:module.moduleObjc[indexPath.row]];
        }else{
            return nil;
        }
        
    }else if (module.style == HomeModuleStyleMargin){
        CLHomeModuleTableViewCell *cell = [[CLHomeModuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLHomeModuleTableViewCellID"];
        cell.titleString = module.title;
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLHomeModuleModel* module = [self.homeHandler homeData][indexPath.section];
    
    if (module.style == HomeModuleStyleFocus) {
        if (module.moduleObjc && ((NSArray *)module.moduleObjc).count > indexPath.row) {
            CLHomeGameEnteranceModel *gameEnteranceModel = module.moduleObjc[indexPath.row];
            
            if ([gameEnteranceModel.contentUrl hasPrefix:@"eaglegames"]) {
                [CLNativePushService pushNativeUrl:gameEnteranceModel.contentUrl];
            }else if ([gameEnteranceModel.contentUrl hasPrefix:@"http"]){
                [[CLAllJumpManager shareAllJumpManager] open:gameEnteranceModel.contentUrl];
            }
        }
    }
}

- (void)createUI {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(5.f))];
    view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    
    self.homeTableView.tableFooterView = view;
    WS(_weakSelf)
    
    [self.homeTableView addRefresh:^{
        [_weakSelf.homeAPI start];
    }];
    
    [self.view addSubview:self.homeTableView];
    
    
    
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(SCREEN_HEIGHT - TABLEBAR_HEIGHT + (IOS_VERSION >= 11 ? 0 : 20) + (kDevice_Is_iPhoneX ? - 35 : 0));
        make.bottom.equalTo(self.view).offset(IOS_VERSION >= 11 ? -self.tabBarController.tabBar.frame.size.height : 0);
        make.top.equalTo(self.view).offset(IOS_VERSION >= 11 ? 0 : -20);
    }];
}
//从缓存中取数据 配置UI
- (void)configData{
    
    [self.homeHandler homeDataDealingWithDict:[CLCacheManager getCacheFormLocationFileWithName:CLCacheFileNameHome]];
    [self.bannerView configureBanners:self.homeHandler.banners marquees:[self.homeHandler reports]];
    
    [self.homeTableView reloadData];
}
#pragma mark ------------ getter Mothed ------------

- (UITableView *)homeTableView
{
    if (_homeTableView == nil) {
        
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _homeTableView.tableHeaderView = self.bannerView;
        _homeTableView.keyboardDismissMode = (UIScrollViewKeyboardDismissModeInteractive | UIScrollViewKeyboardDismissModeOnDrag);
    }

    return _homeTableView;

}

- (CQHomeBannerView *)bannerView {
    
    if (!_bannerView) {
        _bannerView = [[CQHomeBannerView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, kDevice_Is_iPhoneX ? CL__SCALE(235.f) : CL__SCALE(220.f))];
        
    }
    return _bannerView;
}

- (CLHomeAPI *)homeAPI {
    
    if (!_homeAPI) {
        _homeAPI = [[CLHomeAPI alloc] init];
        _homeAPI.delegate = self;
    }
    return _homeAPI;
}

- (CLHomeViewHandler *)homeHandler {
    
    if (!_homeHandler) {
        _homeHandler = [[CLHomeViewHandler alloc] init];
    }
    return _homeHandler;
}

- (CLNoNetFloatView *)noNetFloatView{
    
    if (!_noNetFloatView) {
        _noNetFloatView = [[CLNoNetFloatView alloc] initWithFrame:__Rect(0, SCREEN_HEIGHT - 49 -  __SCALE(38), SCREEN_WIDTH, __SCALE(38))];
    }
    return _noNetFloatView;
}

- (CLUpgradeRequest *)upgradeRequest{
    
    if (!_upgradeRequest) {
        _upgradeRequest = [[CLUpgradeRequest alloc] init];
        _upgradeRequest.delegate = self;
    }
    
    return _upgradeRequest;
}

- (void)dealloc {
    
    if (_homeAPI) {
        _homeAPI.delegate = nil;
        [_homeAPI cancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
