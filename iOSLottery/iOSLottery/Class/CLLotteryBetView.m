//
//  CLLotteryBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBetView.h"
#import "CQDefinition.h"
#define TOPVIEWOFFSET 30 //默认滑动边界  超过边界则下滑，不超过则上滑
@interface CLLotteryBetView ()<UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    BOOL _isAllowInertia;//是否允许惯性
    BOOL _isHiddenBottom;//是否是隐藏底部View的状态 （作用：判断滑动到一定距离时 应该隐藏还是显示）
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *mainView;
//@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIView *playMothedView;
@property (nonatomic, strong) UIScrollView *topScrollView;
//外部传入的自定义View
@property (nonatomic, strong) UIView *customHeaderView;//自定制 头部视图
@property (nonatomic, strong) UIView *customBetView;//自定制 投注页面
@property (nonatomic, strong) UIView *customAwardRecordView;//自定制 开奖记录
@property (nonatomic, strong) UIView *customFooterView;//自定制 底部视图
@property (nonatomic, strong) UIView *customPlayMothedView;//自定制 玩法筛选View

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@end
@implementation CLLotteryBetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headerView];
        [self addSubview:self.mainView];
        [self addSubview:self.footerView];
        [self.mainView addSubview:self.bottomView];
        [self.mainView addSubview:self.topScrollView];
        [self addSubview:self.playMothedView];
        _isAllowInertia = YES;
        _is_showBottomView = NO;
        _isHiddenBottom = YES;
        self.mainViewOffset = __SCALE(400);
        [self.mainView addGestureRecognizer:self.panGes];
    }
    return self;
}


#pragma mark ------------ scroll view delegate ------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!scrollView.tracking && self.topScrollView.frame.origin.y == 0) {
        //self.is_showBottomView = NO;
        return;
    }
    
    if (self.topScrollView.frame.origin.y > 0) {
        
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, 0);
        [self topViewSliderWithPoint:point];
    }else if (scrollView.contentOffset.y <= 0) {
        
        CGPoint point = scrollView.contentOffset;
        scrollView.contentOffset = CGPointMake(0, 0);
        [self topViewSliderWithPoint:point];
    }
    
    NSLog(@"==========  %@",NSStringFromCGPoint(scrollView.contentOffset));
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self amendViewPosition];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(!decelerate){
        [self amendViewPosition];
    }
}

#pragma mark - 添加自定义的View
- (void)lotteryBetViewReloadData{
    
    self.is_showBottomView = NO;
    self.is_showPlayMothed = NO;
    
    self.topScrollView.contentOffset = CGPointMake(0, 0);
    
    if ([self.delegate respondsToSelector:@selector(lotteryBetViewCustomBetView)]) {
        self.customBetView = [self.delegate lotteryBetViewCustomBetView];
    }else{
        NSAssert(NO, @"没有实现CLLotteryBetView相关代理");
    }
    if ([self.delegate respondsToSelector:@selector(lotteryBetViewCustomHeaderView)]) {
        self.customHeaderView = [self.delegate lotteryBetViewCustomHeaderView];
    }else{
        NSAssert(NO, @"没有实现CLLotteryBetView相关代理");
    }
    if ([self.delegate respondsToSelector:@selector(lotteryBetViewCustomFooterView)]) {
        self.customFooterView = [self.delegate lotteryBetViewCustomFooterView];
    }else{
        NSAssert(NO, @"没有实现CLLotteryBetView相关代理");
    }
    if ([self.delegate respondsToSelector:@selector(lotteryBetViewCustomAwardRecordView)]) {
        self.customAwardRecordView = [self.delegate lotteryBetViewCustomAwardRecordView];
    }else{
        NSAssert(NO, @"没有实现CLLotteryBetView相关代理");
    }
    if ([self.delegate respondsToSelector:@selector(lotteryBetViewCustomPlayMothedView)]) {
        self.customPlayMothedView = [self.delegate lotteryBetViewCustomPlayMothedView];
    }else{
        NSAssert(NO, @"没有实现CLLotteryBetView相关代理");
    }
}

#pragma mark - 拖拽手势滑动事件
- (void)panGestrueRespone:(UIScreenEdgePanGestureRecognizer *)panGes{
    
    CGPoint slidePoint = [panGes translationInView:self.mainView];
    slidePoint = CGPointMake(slidePoint.x,- slidePoint.y);
    //TopView随着滑动而移动
    [self topViewSliderWithPoint:slidePoint];
    //置零手势滑动偏移量
    [panGes setTranslation:CGPointZero inView:self.mainView];
    //当滑动结束时 修正视图的位置
    if (panGes.state == UIGestureRecognizerStateEnded || panGes.state == UIGestureRecognizerStateCancelled) {
        if (self.topScrollView.frame.origin.y == 0) {
            self.topScrollView.scrollEnabled = YES;
            self.panGes.enabled = NO;
            self.is_showBottomView = NO;
        }else{
            [self amendViewPosition];
        }
    }
}
#pragma mark - topView的滑动
- (void)topViewSliderWithPoint:(CGPoint)slidePoint{
    
    if (self.topScrollView.frame.origin.y - slidePoint.y < 0) {
        self.topScrollView.frame = CGRectMake(0,0, self.topScrollView.frame.size.width, self.topScrollView.frame.size.height);
    }else if (self.topScrollView.frame.origin.y - slidePoint.y > 500){
            
    }else{
        self.topScrollView.frame = CGRectMake(0,self.topScrollView.frame.origin.y - slidePoint.y, self.topScrollView.frame.size.width, self.topScrollView.frame.size.height);
    }
}
#pragma mark - 修正视图位置
- (void)amendViewPosition{
    
    NSInteger maxOffset = _isHiddenBottom ? TOPVIEWOFFSET : self.mainViewOffset - TOPVIEWOFFSET;
    if (self.topScrollView.frame.origin.y > maxOffset) {
        //在滑动手势结束时 如果视图的x值小于一定值的时候则直接进入显示状态
        [self showBottomView];
        _isHiddenBottom = NO;
    }else if (self.topScrollView.frame.origin.y > 0 && self.topScrollView.frame.origin.y <= maxOffset){
        //否则的话 则直接 恢复隐藏状态
        [self hiddenBottomView];
        _isHiddenBottom = YES;
    }else if (self.topScrollView.contentOffset.y > 0 || self.topScrollView.frame.origin.y == 0){
    
        self.is_showBottomView = NO;
    }
    
    NSLog(@"%@",NSStringFromCGRect(self.topScrollView.frame));
}
#pragma mark - bottomView进入显示状态
- (void)showBottomView{
    
    self.topScrollView.scrollEnabled = NO;
    self.panGes.enabled = YES;
    
    //强制初始化偏移量
    self.topScrollView.contentOffset = CGPointMake(0, 0);
    
    [UIView animateWithDuration:.5f animations:^{
        
        self.topScrollView.frame = CGRectMake(0, self.mainViewOffset, self.topScrollView.frame.size.width, self.topScrollView.frame.size.height);
        _isAllowInertia = NO;
    } completion:^(BOOL finished) {
        _isAllowInertia = YES;
    }];
    if (!self.is_showBottomView) {
        self.is_showBottomView = YES;
    }
    
    
}
#pragma mark - bottom进入隐藏状态
- (void)hiddenBottomView{
    
    self.topScrollView.scrollEnabled = YES;
    self.panGes.enabled = NO;
    [UIView animateWithDuration:.5f animations:^{
        self.topScrollView.frame = self.mainView.bounds;
        _isAllowInertia = NO;
    } completion:^(BOOL finished) {
        _isAllowInertia = YES;
    }];
    if (self.is_showBottomView) {
        self.is_showBottomView = NO;
    }
}
#pragma mark - 恢复contentOffset
- (void)recoverContentOffset{
    [UIView animateWithDuration:.3f animations:^{
        
        if (self.topScrollView.contentSize.height < self.topScrollView.frame.size.height) {
            self.topScrollView.contentOffset = CGPointZero;
        }else{
            self.topScrollView.contentOffset = CGPointMake(0, self.topScrollView.contentSize.height - self.topScrollView.frame.size.height);
        }
        _isAllowInertia = NO;
    } completion:^(BOOL finished) {
        _isAllowInertia = YES;
    }];
}
#pragma mark - contentOffset 置0
- (void)setzeroContentOffset{
    
    [UIView animateWithDuration:.3f animations:^{
        
        self.topScrollView.contentOffset = CGPointZero;
        _isAllowInertia = NO;
    } completion:^(BOOL finished) {
        _isAllowInertia = YES;
    }];
}
#pragma mark - 更新View的frame
- (void)updateViewFrame{
    
    self.mainView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.headerView.frame) - CGRectGetHeight(self.footerView.frame));
    self.topScrollView.frame = self.mainView.bounds;
    if (self.topScrollView.frame.size.height >= self.topScrollView.contentSize.height) {
        self.topScrollView.contentSize = CGSizeMake(self.topScrollView.frame.size.width, self.topScrollView.frame.size.height + 1.f);
    }
    self.bottomView.frame = self.mainView.bounds;
    self.topScrollView.frame = self.topScrollView.bounds;
}
#pragma mark ------ eventRespone ------
#pragma mark - 点击了玩法筛选View的自身
- (void)tapPlayMothedView:(UITapGestureRecognizer *)tap
{
    self.is_showPlayMothed = NO;
}
#pragma mark - getterMothed
- (UIView *)headerView{
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width, 70)];
    }
    return _headerView;
}
- (UIView *)mainView{
    
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.frame.size.width, self.frame.size.height - CGRectGetHeight(self.headerView.frame) - CGRectGetHeight(self.footerView.frame))];
    }
    return _mainView;
}
- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:self.mainView.bounds];
    }
    return _bottomView;
}
- (UIView *)footerView{
    
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 70, self.frame.size.width, 70)];
    }
    return _footerView;
}
- (UIView *)playMothedView{
    
    if (!_playMothedView) {
        _playMothedView = [[UIView alloc] initWithFrame:self.bounds];
        _playMothedView.hidden = YES;
        //添加隐藏自身的手势
        UITapGestureRecognizer *tapPlayMothedView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPlayMothedView:)];
        [_playMothedView addGestureRecognizer:tapPlayMothedView];
    }
    return _playMothedView;
    
}
- (UIScrollView *)topScrollView{
    
    if (!_topScrollView) {
        _topScrollView = [[UIScrollView alloc] initWithFrame:self.mainView.bounds];
        _topScrollView.delegate = self;
        _topScrollView.showsVerticalScrollIndicator = NO;
        _topScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _topScrollView;
}
- (UIPanGestureRecognizer *)panGes{
    
    if (!_panGes) {
        _panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestrueRespone:)];
        _panGes.delegate = self;
        [_panGes setMinimumNumberOfTouches:1];
        [_panGes setMaximumNumberOfTouches:1];
        _panGes.enabled = NO;
    }
    return _panGes;
}
#pragma mark ------ 外部传入内部的展示View ------
#pragma mark - setterMothed
- (void)setIs_showBottomView:(BOOL)is_showBottomView{
    
    if (_is_showBottomView == is_showBottomView) return;
    _is_showBottomView = is_showBottomView;
    if (_is_showBottomView) {
        [self showBottomView];
    }else{
        [self hiddenBottomView];
    }
    self.bottomViewIsShowBlock ? self.bottomViewIsShowBlock(is_showBottomView) : nil;
}
- (void)setIs_showPlayMothed:(BOOL)is_showPlayMothed{
    
    if (_is_showPlayMothed == is_showPlayMothed) return;
    _is_showPlayMothed = is_showPlayMothed;
    self.playMothedView.hidden = !is_showPlayMothed;
    if (is_showPlayMothed) {
        [self bringSubviewToFront:self.playMothedView];
    }else{
        [self sendSubviewToBack:self.playMothedView];
    }
    self.playMothedViewIsShowBlock ? self.playMothedViewIsShowBlock(is_showPlayMothed) : nil;
}
- (void)setCustomHeaderView:(UIView *)customHeaderView{
    
    self.headerView.frame = __Rect(0, 0, self.frame.size.width, customHeaderView.frame.size.height);
    customHeaderView.frame = self.headerView.bounds;
    [self updateViewFrame];
    [self.headerView addSubview:customHeaderView];
}
- (void)setCustomBetView:(UIView *)customBetView{
    
    if (customBetView.frame.size.height <= self.topScrollView.frame.size.height) {
        customBetView.frame = __Rect(0, 0, CGRectGetWidth(self.topScrollView.frame), CGRectGetHeight(self.topScrollView.frame)+ 1.f);
    }else{
        customBetView.frame = __Rect(0, 0, CGRectGetWidth(self.topScrollView.frame), CGRectGetHeight(customBetView.frame));
    }
    self.topScrollView.backgroundColor = customBetView.backgroundColor;
    [self.topScrollView addSubview:customBetView];
    self.topScrollView.contentSize = customBetView.frame.size;
}
- (void)setCustomFooterView:(UIView *)customFooterView{
    
    self.footerView.frame = __Rect(0, CGRectGetHeight(self.frame) - customFooterView.frame.size.height, self.frame.size.width, customFooterView.frame.size.height);
    customFooterView.frame = self.footerView.bounds;
    [self updateViewFrame];
    [self.footerView addSubview:customFooterView];
}
- (void)setCustomAwardRecordView:(UIView *)customAwardRecordView{
    
    self.bottomView.frame = __Rect(0, 0, self.frame.size.width, customAwardRecordView.frame.size.height);
    customAwardRecordView.frame = self.bottomView.bounds;
    self.mainViewOffset = customAwardRecordView.frame.size.height;
    [self.bottomView addSubview:customAwardRecordView];
}
- (void)setCustomPlayMothedView:(UIView *)customPlayMothedView{
    
    customPlayMothedView.frame = __Rect(0, 0, customPlayMothedView.frame.size.width, customPlayMothedView.frame.size.height);
    [self.playMothedView addSubview:customPlayMothedView];
}

- (void)setMainViewShowStatus:(BOOL)mainViewShowStatus{
    if (mainViewShowStatus == NO) {
        self.topScrollView.hidden = YES;
        self.headerView.hidden = YES;
        self.mainView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.headerView.frame));
    }
}

@end
