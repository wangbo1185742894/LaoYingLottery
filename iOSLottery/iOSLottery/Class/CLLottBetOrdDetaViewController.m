//
//  CLLottBetOrdDetaViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLottBetOrdDetaViewController.h"
#import "CLOrdDetaHeaderView.h"
#import "CLOrderDetaBasicMsgCell.h"
#import "CLOrderDetailBetNumCell.h"
#import "CLFollowDetailNumberBottomCell.h"

#import "CLOrderDetaDataAPI.h"
#import "CLContinueToPayAPI.h"
#import "CLLottBetOrdDetaHandler.h"

#import "Masonry.h"
#import "UIScrollView+CLRefresh.h"

#import "CLAppContext.h"
#import "CLOrderStatus.h"

#import "CLTicketDetailViewController.h"
#import "CKNewPayViewController.h"

#import "CLJumpLotteryManager.h"

#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"

#import "CLSFCMatchResultCell.h"

#import "CLUmengShareManager.h"
#import "CLScreenCaptureView.h"
#import <UMSocialUIManager.h>
#import "UITableView+CLScreenCapture.h"
#import "CLOrderDLTHintView.h"
@interface CLLottBetOrdDetaViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestParamSource,CLRequestCallBackDelegate,UMSocialShareMenuViewDelegate>

@property (nonatomic, strong) UITableView* detailTableView;

@property (nonatomic, strong) UIView *headView;//真正的头部视图//为了高度自适应
@property (nonatomic, strong) CLOrdDetaHeaderView* orderHeaderView;

@property (nonatomic, strong) CLOrderDetaDataAPI* orderDetailAPI;
@property (nonatomic, strong) CLContinueToPayAPI* continuePay;
@property (nonatomic, strong) NSMutableArray* orderDataSource;

@property (nonatomic, strong) CLLottBetOrdDetaHandler* dataHandler;

@property (nonatomic) BOOL isShowAllNumber;

@property (nonatomic, strong) UIView *detailFooterView;//底部的再来一单按钮
@property (nonatomic, strong) UIButton *betAgainBtn;//再来一单按钮
@property (nonatomic, strong) UIView *lineView;//再来一单的上方的线
@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, strong) CLAlertPromptMessageView *alertView;

/**
 截屏View
 */
@property (nonatomic, strong) CLScreenCaptureView *captureView;

@property (nonatomic, strong) NSString *shareText;


@end

@implementation CLLottBetOrdDetaViewController

{
    UILabel * _contentLongLabel;
}

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        self.orderId = params[@"order_id"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    //注册长按文本隐藏响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerHidden:) name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{

    [super viewDidDisappear:animated];
    
    //注销长按文本隐藏响应
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"订单详情";
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:(UIBarButtonItemStylePlain) target:self action:@selector(shareItemClick)];
    
    self.navigationItem.rightBarButtonItem = shareItem;
    
    // Do any additional setup after loading the view.
    self.isShowAllNumber = NO;
    [self.view addSubview:self.detailFooterView];
    [self.detailFooterView addSubview:self.betAgainBtn];
    [self.detailFooterView addSubview:self.lineView];
    [self.view addSubview:self.detailTableView];
    [self.headView addSubview:self.orderHeaderView];
    
    
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    
    [self.detailFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(49.f));
    }];
    
    [self.betAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.detailFooterView);
        make.height.width.equalTo(self.detailFooterView).multipliedBy(.7);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.detailFooterView);
        make.left.equalTo(self.detailFooterView);
        make.right.equalTo(self.detailFooterView);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.detailTableView startRefreshAnimating];
}

- (void)shareItemClick
{
    
    self.captureView.captureImage = [self.detailTableView cl_captureImageOfFrame];
    
    self.captureView.topTitle = self.shareText;
    
    [UMSocialUIManager setShareMenuViewDelegate:self];
    
    [CLUmengShareManager umengShareMessageWithImage:[self.detailTableView cl_captureShareImageOfContentAndAppIcon:nil]];

    [[UIApplication sharedApplication].keyWindow addSubview:self.captureView];

}

- (void)UMSocialShareMenuViewDidDisappear
{
    [self.captureView removeFromSuperview];
}

- (void)showBetNumbers:(id)sender {
    
    self.isShowAllNumber = !self.isShowAllNumber;
    [self.detailTableView reloadData];
}

- (void) continueToPay {
    
    self.continuePay.orderId = [self.dataHandler orderId];
    [self showLoading];
    [self.continuePay start];
}

#pragma mark ------------ event Response ------------
- (void)betAgainBtnOnClick:(UIButton *)btn{
    
    if (self.gameEn.length > 0) {
        [CLJumpLotteryManager jumpLotteryWithGameEn:self.gameEn];
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.orderDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CLOrderDetailListViewModel* listVM = self.orderDataSource[section];
    if (listVM.dataType == CLOrderDetaDataTypeLottNum) {
        return self.isShowAllNumber?listVM.dataArrays.count:MIN(listVM.dataArrays.count, 3);
    }
    return listVM.dataArrays.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WS(_weakSelf)
    
    CLOrderDetailListViewModel* listVM = self.orderDataSource[indexPath.section];
    if (listVM.dataType == CLOrderDetaDataTypeOrderState ||
        listVM.dataType == CLOrderDetaDataTypeOrderMsg) {
        
        CLOrderDetaBasicMsgCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLOrderDetaBasicMegCellId"];
        if (!cell) {
            cell = [[CLOrderDetaBasicMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLOrderDetaBasicMegCellId"];
        }
        
        cell.GestureTableView = tableView;
        
        cell.contentLongBlock = ^(CGRect contentCellRect, UILabel *contentLabel) {
          
            _contentLongLabel = contentLabel;
            UIMenuController *contentMenuContro = [UIMenuController sharedMenuController];
            UIMenuItem *flag = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(contentTextLabelCopy:)];
            CGRect menuRect = __Rect(0, CGRectGetMinY(contentCellRect), contentCellRect.size.width,contentCellRect.size.height);
            [contentMenuContro setTargetRect:menuRect inView:_weakSelf.detailTableView];
            [contentMenuContro setMenuItems:@[flag]];
            [contentMenuContro setMenuVisible:YES];
            
        };
        
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
        
    } else if (listVM.dataType == CLOrderDetaDataTypeBonusNum ||
               listVM.dataType == CLOrderDetaDataTypeLottNum) {
        
        CLOrderDetailBetNumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLOrderDetailBetNumCellId"];
        if (!cell) {
            cell = [[CLOrderDetailBetNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLOrderDetailBetNumCellId"];
        }
        
        if (listVM.dataType == CLOrderDetaDataTypeBonusNum) {
            if (indexPath.row == 0) {
                cell.isTop = YES;
            }else{
                cell.isTop = NO;
            }
        }
        if (listVM.dataType == CLOrderDetaDataTypeLottNum) {
            cell.isTop = NO;
        }
        
        [cell configureData:listVM.dataArrays[indexPath.row]];
        
        return cell;
        
    } else if (listVM.dataType == CLORderDetaDataTypeLottNumBottom) {
        
        CLFollowDetailNumberBottomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLFollowDetailNumberBottomCellId"];
        if (!cell) {
            cell = [[CLFollowDetailNumberBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLFollowDetailNumberBottomCellId"];
        }
        cell.titleLabel.text = self.isShowAllNumber?@"收起":@"展开";
        cell.contentImageView.image = [UIImage imageNamed:!self.isShowAllNumber?@"order_downArrow.png":@"order_upArrow"];
        cell.cellEventTouchUp = ^(){
            
            [self showBetNumbers:nil];
        };
        return cell;
        
        
    }else if (listVM.dataType == CLOrderDetaDataTypeMatchList){
    
        CLSFCMatchResultCell *cell = [CLSFCMatchResultCell createCellWithTableView:tableView type:CLSFCMatchResultOrderType];
        
        [cell setModel:listVM.dataArrays[indexPath.row]];
        
        return cell;
    }
    
    else {
        return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"defaultCell"];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

- (void)configureCell:(CLOrderDetaBasicMsgCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    CLOrderDetailListViewModel* listVM = self.orderDataSource[indexPath.section];
    CLOrderDetailLineViewModel* line = listVM.dataArrays[indexPath.row];
    [cell setUpBasicMsg:line];
    
    cell.cellContentClick = ^(CLOrderDetailLineViewModel* model) {

        if ([model.title hasPrefix:@"出票详情"]) {
            CLTicketDetailViewController* vc = [[CLTicketDetailViewController alloc] init];
            vc.orderId = self.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.title hasPrefix:@"订单状态"]){
            [self.alertView showInView:self.view];
        }
    };
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
        _contentLongLabel.backgroundColor = CLEARCOLOR;
    }
}


#pragma mark - CLRequestParamSource

- (NSDictionary *)paramsForPostApi:(CLBaseRequest *)request {
    
    return @{@"orderId":self.orderId};
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.continuePay) {
        [self stopLoading];
        //继续支付
        if (request.urlResponse.success) {
            
            CKNewPayViewController *paymentController = [[CKNewPayViewController alloc] init];
            paymentController.lotteryGameEn = self.gameEn;
            paymentController.periodTime = self.orderHeaderView.saleTime;
            paymentController.period = self.orderHeaderView.currentPeriod;
            paymentController.pushType = CKPayPushTypeOrderAndFollow;
            paymentController.hidesBottomBarWhenPushed = YES;
            paymentController.orderType = CKOrderTypeNormal;
            paymentController.payConfigure = request.urlResponse.resp;
            [self.navigationController pushViewController:paymentController animated:YES];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    } else if (request == self.orderDetailAPI) {
        //订单详情
        if (request.urlResponse.success) {
            
            self.shareText = request.urlResponse.resp[@"shareText"];
            
            CLOrderDetailModel* data = [self.dataHandler dealingWithOrderDetaViewData:request.urlResponse.resp lotteryCodeAdapter:nil];
            if (data.isLeshan) {
                self.isShowAllNumber = YES;
            }
            if (self.detailTableView.tableHeaderView == nil) {
                self.detailTableView.tableHeaderView = self.headView;
            }
            [self.orderHeaderView setUpHeaderViewModel:data.orderHeaderData];
            //动弹计算头部视图的高度
            [self.orderHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(self.headView);
            }];
            
            CGFloat height = [self.headView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            self.headView.frame = __Rect(0, 0, SCREEN_WIDTH, height);
            
            if (self.orderDataSource.count > 0) {
                [self.orderDataSource removeAllObjects];
            }
            [self.orderDataSource addObjectsFromArray:data.orderDetailData];
            [self configFooterViewWithData:data];
            [self.detailTableView reloadData];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
        [self.detailTableView stopRefreshAnimating];
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self.detailTableView stopRefreshAnimating];
}
#pragma mark ------------ private Mothed ------------
- (void)configFooterViewWithData:(CLOrderDetailModel *)model{
    
    if (model.isShowFooterView) {
        
        self.detailFooterView.hidden = NO;
        [self.detailTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).offset(__SCALE(- 49));
        }];
        
    }else{
        
        self.detailFooterView.hidden = YES;
        [self.detailTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
    [self.view updateConstraintsIfNeeded];
    self.gameEn = model.gameEn;
}

#pragma mark - getter

- (UITableView *)detailTableView {
    
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _detailTableView.estimatedRowHeight = __SCALE(80);
        _detailTableView.rowHeight = UITableViewAutomaticDimension;
        _detailTableView.backgroundColor = UIColorFromRGB(0xF7F7EE);
        
        WS(_weakSelf)
        [_detailTableView addRefresh:^{
            //移除提示View
            [_weakSelf.detailTableView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:CLOrderDLTHintView.class]) {
                    [obj removeFromSuperview];
                }
            }];
            [_weakSelf.orderDetailAPI start];
        }];
    }
    return _detailTableView;
}
- (UIView *)headView{
    
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectZero];
        _headView.backgroundColor = CLEARCOLOR;
    }
    return _headView;
}
- (CLOrdDetaHeaderView *)orderHeaderView {
    
    if (!_orderHeaderView) {
        _orderHeaderView = [[CLOrdDetaHeaderView alloc] initWithFrame:CGRectZero];
        WS(_ws)
        _orderHeaderView.detaHeadPayment =^{
            [_ws continueToPay];
        };
    }
    return _orderHeaderView;
    
}

- (NSMutableArray *)orderDataSource {
    
    if (!_orderDataSource) {
        _orderDataSource = [NSMutableArray new];
    }
    return _orderDataSource;
}

- (CLLottBetOrdDetaHandler *)dataHandler {
    
    if (!_dataHandler) {
        _dataHandler = [[CLLottBetOrdDetaHandler alloc] init];
    }
    return _dataHandler;
}

- (CLOrderDetaDataAPI *)orderDetailAPI {
    
    if (!_orderDetailAPI) {
        _orderDetailAPI = [[CLOrderDetaDataAPI alloc] init];
        _orderDetailAPI.delegate = self;
        _orderDetailAPI.paramSource = self;
    }
    return _orderDetailAPI;
}

- (CLContinueToPayAPI *)continuePay {
    
    if (!_continuePay) {
        _continuePay = [[CLContinueToPayAPI alloc] init];
        _continuePay.delegate = self;
    }
    return _continuePay;
}

- (UIView *)detailFooterView{
    
    if (!_detailFooterView) {
        _detailFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailFooterView.backgroundColor = UIColorFromRGB(0xffffff);
        _detailFooterView.hidden = YES;
    }
    return _detailFooterView;
}

- (UIButton *)betAgainBtn{
    
    if (!_betAgainBtn) {
        _betAgainBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_betAgainBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_betAgainBtn setBackgroundColor:THEME_COLOR];
        _betAgainBtn.layer.cornerRadius = 2.f;
        [_betAgainBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _betAgainBtn.titleLabel.font = FONT_SCALE(16);
        [_betAgainBtn addTarget:self action:@selector(betAgainBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betAgainBtn;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}

- (CLAlertPromptMessageView *)alertView{
    
    if (!_alertView) {
        _alertView = [[CLAlertPromptMessageView alloc] init];
        _alertView.desTitle = allAlertInfo_RefundInfo;
        _alertView.cancelTitle = @"知道了";
    }
    return _alertView;
}

- (CLScreenCaptureView *)captureView
{

    if (_captureView == nil) {
        
        _captureView = [[CLScreenCaptureView alloc] initWithFrame:(CGRectZero)];
    }
    
    return _captureView;

}

- (void)dealloc {
    
    if (_orderDetailAPI) {
        _orderDetailAPI.delegate = nil;
        _orderDetailAPI.paramSource = nil;
        [_orderDetailAPI cancel];
    }
    
    if (_continuePay) {
        _continuePay.delegate = nil;
        [_continuePay cancel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
