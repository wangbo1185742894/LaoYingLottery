//
//  CQBetOrderDetailProcessView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetOrderDetailHeaderView.h"
#import "CQDefinition.h"
#import "SLConfigMessage.h"

#import "NSString+SLString.h"

#import "SLBetODHeaderProcessView.h"
#import "SLBetODHeaderMoneyView.h"

#import "SLBODAllModel.h"
//#import "CQVirtualBet.h"
@interface SLBetOrderDetailHeaderView ()
/**
 竞彩足球标题
 */
@property (nonatomic, strong) SLBetODHeaderTitleView *titleView;
//流程视图
@property (nonatomic, strong) SLBetODHeaderProcessView *processView;
//订单金额中奖金额视图
@property (nonatomic, strong) SLBetODHeaderMoneyView *moneyView;
//下方的小提示
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, strong) SLBetODHeaderRefundView *refundView;
//最下方的波浪线
@property (nonatomic, strong) UIView *picView;
//头部视图的数据
@property (nonatomic, strong) SLBODHeaderViewModel *mainHeaderModel;

@property (nonatomic, assign) BOOL isFirstAllocView;//标记是否第一次创建视图，第一次创建时中奖图片有动画效果

@end

@implementation SLBetOrderDetailHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFirstAllocView  = YES;
        self.frame = __Rect(0, 0, [[UIScreen mainScreen] bounds].size.width, __SCALE(120));
        [self addSubview:self.titleView];
        [self addSubview:self.processView];

        [self addSubview:self.moneyView];

        [self addSubview:self.refundView];
        [self addSubview:self.picView];
        
        self.backgroundColor = SL_UIColorFromRGB(0xffffff);
    }
    return self;
}
#pragma mark - 根据数据搭建UI
- (void)assignUIWithData:(id)data{
    //配置订单金额View
    self.mainHeaderModel = data;

    [self.titleView setTitleName:self.mainHeaderModel.gameTypeCn detail:self.mainHeaderModel.gameName isBasketBall:self.mainHeaderModel.isBasketBall];

    [self.processView assignHeaderProcessWithData:self.mainHeaderModel.processModel];
    [self.moneyView assignHeaderMoneyWithData:self.mainHeaderModel];
    
    if (self.mainHeaderModel.ifShowRefundDesc == 1) {

        self.refundView.orderStatus = self.mainHeaderModel.orderStatusCn;
        
    }else{
    
        self.refundView.height = 0;
    }
    //更新frame
    [self updateFrame];
    
    self.isFirstAllocView = NO;
}
#pragma mark - 重置再接再厉图片
- (void)resetImageAndStatus:(NSString *)dyImage bgImage:(NSString *)bgImage{
    
    [self.moneyView resetImageAndStatus:dyImage bgImage:bgImage];
}
#pragma mark - 更新frame
- (void)updateFrame{
    
    self.titleView.frame = __Rect(0, 0, CGRectGetWidth(self.bounds), __SCALE(35));
    
    self.processView.frame = __Rect(0, CGRectGetMaxY(self.titleView.frame) + SL__SCALE(25.f), CGRectGetWidth(self.bounds), __SCALE(50));
    
    self.moneyView.frame = __Rect(0, CGRectGetMaxY(self.processView.frame), CGRectGetWidth(self.bounds), __SCALE(70));
    
    self.refundView.frame = __Rect(0,CGRectGetMaxY(self.moneyView.frame), CGRectGetWidth(self.bounds), self.refundView.height);
    
    self.picView.frame = __Rect(0, CGRectGetMaxY(self.refundView.frame) + __SCALE(3), CGRectGetWidth(self.bounds), __SCALE(13.f));
    
    self.frame = __Rect(0, 0, [[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY(self.picView.frame));
    
}

- (void)stopTimer{
    
    [self.moneyView stopTimer];
}

#pragma mark - setterMothed
//set 继续支付block
- (void)setContinuePayBlock:(void (^)(UIButton *))continuePayBlock{
    
    _continuePayBlock = continuePayBlock;
    if (_continuePayBlock) {
        self.moneyView.continuePayBlock = _continuePayBlock;
    }else{
        self.moneyView.continuePayBlock = nil;
    }
}
- (void)setNotWinImageViewClick:(void (^)())notWinImageViewClick{
    _notWinImageViewClick = notWinImageViewClick;
    if (_notWinImageViewClick) {
        self.moneyView.notWinImageViewClick = notWinImageViewClick;
    }else{
        self.moneyView.notWinImageViewClick = nil;
    }
}
- (void)setAwardImageViewClick:(void (^)())awardImageViewClick{
    _awardImageViewClick = awardImageViewClick;
    if (_awardImageViewClick) {
        self.moneyView.awarImageViewCilck = _awardImageViewClick;
    }else{
        self.moneyView.awarImageViewCilck = nil;
    }
}

- (void)setRefundClick:(void (^)())refundClick
{
    _refundClick = refundClick;
    
    if (_refundClick) {
        
        self.refundView.refundBlock = refundClick;
    }else{
    
        self.refundView.refundBlock = nil;
    }
}

#pragma mark - getterMothed

- (SLBetODHeaderTitleView *)titleView
{

    if (_titleView == nil) {
        
        _titleView = [[SLBetODHeaderTitleView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.bounds), __SCALE(35))];
        _titleView.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
    }
    
    return _titleView;
}

- (SLBetODHeaderProcessView *)processView{
    if (!_processView) {
        _processView = [[SLBetODHeaderProcessView alloc] initWithFrame:__Rect(0, CGRectGetMaxY(self.titleView.frame), CGRectGetWidth(self.bounds), __SCALE(50))];
        _processView.backgroundColor = SL_UIColorFromRGB(0xffffff);
    }
    return _processView;
}
- (SLBetODHeaderMoneyView *)moneyView{
    if (!_moneyView) {
        
        _moneyView = [[SLBetODHeaderMoneyView alloc] initWithFrame:__Rect(0, CGRectGetMaxY(self.processView.frame), CGRectGetWidth(self.bounds), __SCALE(70))];
        _moneyView.backgroundColor = SL_UIColorFromRGB(0xffffff);
    }
    _moneyView.isFirstAllocView = self.isFirstAllocView;
    return _moneyView;
}

- (SLBetODHeaderRefundView *)refundView
{

    if (_refundView == nil) {
        
        _refundView = [[SLBetODHeaderRefundView alloc] initWithFrame:(CGRectMake(__SCALE(10), CGRectGetMaxY(self.moneyView.frame) - __SCALE(15.f), CGRectGetWidth(self.bounds), __SCALE(15.f)))];
    }
    return _refundView;

}

- (UIView *)picView
{
    
    if (!_picView) {
        
        _picView = [[UIView alloc] initWithFrame:__Rect(0, CGRectGetMaxY(self.promptLabel.frame), CGRectGetWidth(self.bounds), __SCALE(12.f))];
        
        _picView.backgroundColor = SL_UIColorFromRGB(0xFAF9F6);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(_picView.frame), 3.f)];
        
        imageView.image = [UIImage imageNamed:@"CMTWareLine"];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_picView addSubview:imageView];
        
    }
    return _picView;
}
@end


@interface SLBetODHeaderTitleView ()

/**
 竞猜篮球/足球 图片
 */
@property (nonatomic, strong) NSString *icon;

/**
 玩法标题
 */
@property (nonatomic, strong) NSString *title;

/**
 玩法详情
 */
@property (nonatomic, strong) NSString *detail;
/** 是不是篮球 */
@property (nonatomic, readwrite) BOOL isBasketBall;

@end

@implementation SLBetODHeaderTitleView

- (void)setTitleName:(NSString *)title detail:(NSString *)detail isBasketBall:(BOOL)isBas
{
 
    _title = title;
    _detail = detail;
    _isBasketBall = isBas;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:_isBasketBall?@"order_datails_basketball":@"order_datails_football"];
    
    //绘制图片
    [image drawInRect:(CGRectMake(SL__SCALE(15.f), SL__SCALE(6.f), SL__SCALE(30.f), SL__SCALE(28.f)))];
    
    //计算玩法名文字大小
    CGSize titleSize = [_title sizeWithAttributes:@{NSFontAttributeName : SL_FONT_SCALE(16.f)}];
    
    //绘制文字
    [_title drawInRect:(CGRectMake(SL__SCALE(53.f), SL__SCALE(11.f), titleSize.width, SL__SCALE(19.f))) withAttributes:@{NSFontAttributeName : SL_FONT_SCALE(16.f)}];
    

    //计算玩法内容文字大小
    CGSize detailSize = [_detail sizeWithAttributes:@{NSFontAttributeName : SL_FONT_SCALE(12.f)}];
    
    //绘制文字
    [_detail drawInRect:(CGRectMake(SL__SCALE(53.f) + titleSize.width, SL__SCALE(14.f), detailSize.width, SL__SCALE(14.f))) withAttributes:@{NSFontAttributeName : SL_FONT_SCALE(12.f)}];
    
    UIColor *color = SL_UIColorFromRGB(0xECE5DD);
    [color set]; //设置线条颜色
    
    //绘制底部分割线路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.origin.x,rect.size.height - 0.5)];
    [path addLineToPoint:CGPointMake(rect.size.width,rect.size.height - 0.5)];
    
    path.lineWidth = 0.5;
    
    [path stroke];//渲染到图层
    
}
@end

@interface SLBetODHeaderRefundView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *refondStatus;

@property (nonatomic, strong) UIButton *refondExplain;

@property (nonatomic, assign) NSInteger labelWidth;

@end

@implementation SLBetODHeaderRefundView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.refondStatus];
        [self addSubview:self.refondExplain];
        
        self.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
    }
    return self;
}

- (void)setOrderStatus:(NSString *)orderStatus
{

    _orderStatus = orderStatus;
    
    self.refondStatus.text = [NSString stringWithFormat:@"%@",orderStatus];
    
    CGSize size = [self.refondStatus.text sizeWithAttributes:@{NSFontAttributeName:SL_FONT_SCALE(12.f)}];
    
    _labelWidth = size.width + 2;
    _height = size.height + 1;
    
    if (size.width >= SL__SCALE(245.f)) {
        
        self.refondStatus.numberOfLines = 0;
        
        self.titleLabel.text = @"订单状态:\n";
        self.titleLabel.numberOfLines = 0;
        
        CGRect rect = [self.refondStatus.text boundingRectFontOptionWithSize:(CGSizeMake(SL__SCALE(245.f), MAXFLOAT)) Font:SL_FONT_SCALE(12.f)];
        
        _height = rect.size.height + 1;
        _labelWidth = rect.size.width + 1;
    }
    
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    if (_height == 0) {
        
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    
    self.titleLabel.frame = CGRectMake(SL__SCALE(15.f), 0, SL__SCALE(60.f), _height);
    
    self.refondStatus.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, _labelWidth, _height);
    
    self.refondExplain.frame = CGRectMake(CGRectGetMaxX(self.refondStatus.frame) + SL__SCALE(4.f), CGRectGetMinY(self.refondStatus.frame), SL__SCALE(59.f), SL__SCALE(14.f));
    
}

- (void)refondExplainClick
{

    self.refundBlock ? self.refundBlock() : nil;
    
}

#pragma mark --- Get Method ---

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _titleLabel.text = @"订单状态:";
        _titleLabel.textColor = SL_UIColorFromRGB(0x999999);
        _titleLabel.font = SL_FONT_SCALE(12.f);
    }
    return _titleLabel;
    
}

- (UILabel *)refondStatus
{

    if (_refondStatus == nil) {
        
        _refondStatus = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _refondStatus.text = @"订单退款中";
        _refondStatus.textColor = SL_UIColorFromRGB(0x999999);
        _refondStatus.font = SL_FONT_SCALE(12.f);
    }
    return _refondStatus;
}

- (UIButton *)refondExplain
{

    if (_refondExplain == nil) {
        
        _refondExplain = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_refondExplain setTitle:@"退款说明" forState:(UIControlStateNormal)];
        [_refondExplain setTitleColor:SL_UIColorFromRGB(0x45A2F7) forState:(UIControlStateNormal)];
        
        _refondExplain.titleLabel.font = SL_FONT_SCALE(12.f);
        
        [_refondExplain addTarget:self action:@selector(refondExplainClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refondExplain;
}

@end
