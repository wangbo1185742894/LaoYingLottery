//
//  CKQuickPayHomeView.m
//  CKPayClient
//
//  Created by 小铭 on 2017/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKQuickPayHomeView.h"
#import "Masonry.h"
/** Controller */
/** Model */
/** Public */
#import "UIImageView+CKWebImage.h"
#import "CKDefinition.h"
/** API */
#import "CKPayFlowFilter.h"
#import "CKPayClient.h"
/** QuickView */
#import "CKQuickBetHomeView.h"
#import "CKQuickBetPaySelectedView.h"
#import "CKQuickBetRedParketsView.h"
/** NormalView */
/** protocol */
#import "CKPayConfigFile.h"
#import "CKQuickPayApi.h"
#import "CKPayFlowFilter.h"
#import "CKPayMentInfoModel.h"
#import "CKLotteryPaySource.h"
#import "CKPayHandleModel.h"

//全局缓存
@interface CKQuickPayHomeView ()<CKPayFlowFilterDelegate,CLRequestCallBackDelegate>
//最上方的倒计时

/** quickPayMent */
/** view */
@property (nonatomic, strong) UIView *quickContentView;
@property (nonatomic, strong) UIImageView *quickBackIMG;
@property (nonatomic, strong) CKQuickBetHomeView *quickHomeView;
@property (nonatomic, strong) CKQuickBetPaySelectedView *quickPaySelectedView;
@property (nonatomic, strong) CKQuickBetRedParketsView *quickRedSelectedView;
/** modelOrDataSource */
@property (nonatomic, strong) NSMutableArray *quickPayDataSource;
@property (nonatomic, strong) CKPayFlowFilter *quickFilter;
@property (nonatomic, strong) CKQuickPayApi *quickApi;
/** NormalPayMent */

/** view*/
/** modelOrDataSource */
@property (nonatomic, strong) CKPayMentInfoModel *preForTokenModel;
/** configure */

/** publicService */

@property (nonatomic, strong) CKLotteryPaySource *lotterySource;

//lotterySource
@end

@implementation CKQuickPayHomeView

+ (instancetype)QuickPaymentViewPreHandleToken:(NSString *)prehandleToken viewController:(UIViewController *__weak)pushController paymentActionBlock:(void (^)(CKPaymentBaseSource *,NSString *))paymentActionBlock
{
    CKQuickPayHomeView *homeView = [[CKQuickPayHomeView alloc] init];
    homeView.pushController = pushController;
    homeView.prehandleToken = prehandleToken;
    homeView.paymentActionBlock = paymentActionBlock;
    return homeView;
}

- (void)startRequest
{
    self.quickApi.preHandleToken = self.prehandleToken;
    [[CKPayClient sharedManager].intermediary startLoading];
    [self.quickApi start];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.quickContentView];
        [self.quickContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
        
    }
    return self;
}

#pragma mark --------- ServiceAction ---------

- (void)startPayment
{
    /** 配置支付相关参数 */
    //** 支付方式 */
    self.lotterySource = [[CKLotteryPaySource alloc] init];
    self.lotterySource.total_amount = [NSString stringWithFormat:@"%lld",self.preForTokenModel.pre_handle_token.amount];
    self.lotterySource.channel_type = [self.quickFilter selectChannelDataSource].channel_id;
    //如果只有红包支付，则支付地址是现金账户的支付地址
    self.lotterySource.url_prefix = [self.quickFilter selectChannelDataSource].url_prefix;
    self.lotterySource.transitionType = CKTransitionTypeTicketPayment;
    
    self.lotterySource.flow_id = self.preForTokenModel.pre_handle_token.flow_id;
    //需支付金额
    self.lotterySource.need_pay_amount = [NSString stringWithFormat:@"%lld",self.quickFilter.needPayAmount];
    self.lotterySource.has_redPacket = self.quickFilter.isUseRedPacket;
    /** 需要订单号 */
    self.lotterySource.order_id = self.preForTokenModel.pre_handle_token.handle_id;
    //判断有红包则传红包余额，没有红包则传0
    self.lotterySource.redPa_amount = self.quickFilter.isUseRedPacket ? [NSString stringWithFormat:@"%ld",[self.quickFilter selectRedPacketDataSource].redPacketBalance] : 0;
    self.lotterySource.launch_class = self.pushController;
    self.lotterySource.redPa_program_id = [self.quickFilter selectRedPacketDataSource].redPacketFid;
    
    [CKPayClient sharedManager].channel = [self.quickFilter selectChannelDataSource];
    [CKPayClient sharedManager].source = self.lotterySource;
    [CKPayClient sharedManager].launchViewController = self.pushController;
    
    self.paymentActionBlock ? self.paymentActionBlock(self.lotterySource,self.preForTokenModel.pre_handle_token.handle_id) : nil;
}

#pragma mark - 确认支付
- (void)confirmPayAction
{
    [self startPayment];
}

#pragma mark --------- APIDelegate ---------
- (void)requestFinished:(CLBaseRequest *)request
{
    if (request.urlResponse.success) {
        /** 接口数据源 */
        self.preForTokenModel = [CKPayMentInfoModel objectWithKeyValues:[request.urlResponse.resp firstObject]];
        /** 配置可用支付渠道和红包 */
        [self.quickFilter setAvailableChannelList:self.preForTokenModel.account_infos VIPChannelSource:self.preForTokenModel.big_moneny.count > 0 ? self.preForTokenModel.big_moneny[0] : nil redPacketList:self.preForTokenModel.red_list totalAmount:self.preForTokenModel.pre_handle_token.amount];
    }else{
        self.cancelButtonBlock?self.cancelButtonBlock():nil;
        [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
    }
    [[CKPayClient sharedManager].intermediary stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request
{
    [[CKPayClient sharedManager].intermediary stopLoading];
    [[CKPayClient sharedManager].intermediary showError:request.urlResponse.errorMessage];
}


#pragma mark --------- FilterDelegate ---------

- (void)flowFilterFinish
{
    NSLog(@"支付方式配置成功");
    
    self.quickHomeView.hidden = NO;
    self.quickHomeView.needPayAmount = [NSString stringWithFormat:@"还需支付：%lld元",self.quickFilter.needPayAmount/100];
//    self.quickHomeView.quickBetTitle = [NSString stringWithFormat:@"投注：%lld元",self.preForTokenModel.pre_handle_token.amount];
    self.quickHomeView.quickDataSource = self.quickPayDataSource;
    /** 底部View */
    self.quickHomeView.quickBetTitle = [NSString stringWithFormat:@"支付总额：%lld元", [self.quickFilter totalAmount] / 100];
    self.quickHomeView.quickConfirmTitle = [self.quickFilter channelGuidTitle].title;
    self.quickHomeView.subTitle = [self.quickFilter channelGuidTitle].subTitle;
}

#pragma mark --------- QuickPayMent ---------
- (void)changeRedParketWith:(id)redModel
{
    /** 更换红包 */
    [self.quickFilter changeRedPacketId:((CKRedPacketUISource *)redModel).fid];
    self.quickHomeView.quickDataSource = self.quickPayDataSource;
}

- (void)changePaychannelWith:(id)payMentModel
{
    /** 更换支付方式 */
    [self.quickFilter changeChannelId:@(((CKPayChannelUISource *)payMentModel).channel_id)];
    self.quickHomeView.quickDataSource = self.quickPayDataSource;
}

- (void)cancelQuickPay
{
    self.cancelButtonBlock?self.cancelButtonBlock():nil;
    [self removeFromSuperview];
}

#pragma mark - SttingMothed

- (void)setButtonStatus:(BOOL)buttonStatus
{
    self.quickHomeView.buttonStatus = buttonStatus;
}

#pragma mark --------- GettingMethod ---------

#pragma mark - quickPayView
- (UIView *)quickContentView
{
    if (!_quickContentView) {
        _quickContentView = [[UIView alloc] init];
        [_quickContentView addSubview:self.quickBackIMG];
        [_quickContentView addSubview:self.quickHomeView];
        [_quickContentView addSubview:self.quickPaySelectedView];
        [_quickContentView addSubview:self.quickRedSelectedView];
        [self.quickBackIMG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(SCREEN_HEIGHT);
        }];
        [self.quickHomeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(__SCALE(25.f));
            make.right.mas_equalTo(__SCALE(-25.f));
        }];
        [self.quickPaySelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(self.quickHomeView);
            make.right.mas_equalTo(self.quickHomeView);
        }];
        [self.quickRedSelectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_quickContentView);
            make.left.mas_equalTo(self.quickHomeView);
            make.right.mas_equalTo(self.quickHomeView);
        }];
    }
    return _quickContentView;
}

- (UIImageView *)quickBackIMG
{
    if (!_quickBackIMG) {
        _quickBackIMG = [[UIImageView alloc] init];
        _quickBackIMG.alpha = .3f;
    }
    return _quickBackIMG;
}

- (CKQuickBetHomeView *)quickHomeView
{
    if (!_quickHomeView) {
        _quickHomeView = [[CKQuickBetHomeView alloc] init];
        _quickHomeView.hidden = YES;
        WS(_weakSelf);
        _quickHomeView.selectedPaymentBlock = ^(id method, CLQuickHomeShowType showType){
            _weakSelf.quickHomeView.hidden = YES;
            if (showType == quickHomePayChannelType) {
                /** 选择支付方式 */
                _weakSelf.quickPaySelectedView.hidden = NO;
                [_weakSelf.quickPaySelectedView updataPaymentWithData:[_weakSelf.quickFilter channelUISource]];
            }else if (showType == quickHomeRedParketsType){
                /** 跳转切换红包 */
                _weakSelf.quickRedSelectedView.hidden = NO;
                [_weakSelf.quickRedSelectedView assignQuickBetpaymentViewWithMethod:[_weakSelf.quickFilter redPacketUISource]];
            }
        };
        _quickHomeView.dissmissBlock = ^{
            /** 取消支付 */
            NSLog(@"取消支付");
            [_weakSelf cancelQuickPay];
        };
        _quickHomeView.nextActionBlock = ^{
            /** 支付按钮 */
            [_weakSelf confirmPayAction];
        };
    }
    return _quickHomeView;
}

- (CKQuickBetPaySelectedView *)quickPaySelectedView
{
    if (!_quickPaySelectedView) {
        _quickPaySelectedView = [[CKQuickBetPaySelectedView alloc] init];
        _quickPaySelectedView.hidden = YES;
        WS(_weakSelf);
        _quickPaySelectedView.selectedPaymentBlock = ^(id obj){
            //_weakSelf.quickPaySelectedView.hidden = YES;
            /** 通知Service切换支付方式 */
            [_weakSelf changePaychannelWith:obj];
            _weakSelf.quickHomeView.hidden = NO;
            _weakSelf.quickPaySelectedView.hidden = YES;
        };
        _quickPaySelectedView.paymentBackBlock = ^{
            _weakSelf.quickPaySelectedView.hidden = YES;
            _weakSelf.quickHomeView.hidden = NO;
        };
    }
    return _quickPaySelectedView;
}

- (CKQuickBetRedParketsView *)quickRedSelectedView
{
    if (!_quickRedSelectedView) {
        _quickRedSelectedView = [[CKQuickBetRedParketsView alloc] init];
        _quickRedSelectedView.hidden = YES;
        WS(_weakSelf);
        _quickRedSelectedView.selectedRedParketsBlock = ^(id obj , BOOL selectStatus){
            //_weakSelf.quickRedSelectedView.hidden = YES;
            /** 通知service切换红包 */
            [_weakSelf changeRedParketWith:obj];
            _weakSelf.quickHomeView.hidden = NO;
            _weakSelf.quickRedSelectedView.hidden = YES;
        };
        _quickRedSelectedView.redParketsBackBlock = ^{
            _weakSelf.quickRedSelectedView.hidden = YES;
            _weakSelf.quickHomeView.hidden = NO;
        };
    }
    return _quickRedSelectedView;
}

- (CKPayFlowFilter *)quickFilter
{
    if (!_quickFilter) {
        _quickFilter = [[CKPayFlowFilter alloc] init];
        _quickFilter.delegate = self;
    }
    return _quickFilter;
}

- (CKQuickPayApi *)quickApi
{
    if (!_quickApi) {
        _quickApi = [[CKQuickPayApi alloc] init];
        _quickApi.delegate = self;
    }
    return _quickApi;
}

- (CKPayMentInfoModel *)preForTokenModel
{
    if (!_preForTokenModel) {
        _preForTokenModel = [[CKPayMentInfoModel alloc] init];
    }
    return _preForTokenModel;
}

/** dataSource */

- (NSMutableArray *)quickPayDataSource
{
    NSMutableArray *quickHomeDataSource = [NSMutableArray array];
    [self.quickFilter selectRedPacketUISource]?[quickHomeDataSource addObject:[self.quickFilter selectRedPacketUISource]]:nil;
    [self.quickFilter selectChannelUISource]?[quickHomeDataSource addObject:[self.quickFilter selectChannelUISource]]:nil;
    return quickHomeDataSource;
}

@end
