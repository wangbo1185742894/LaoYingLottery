//
//  CLRefreshFooterView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLRefreshFooterView.h"
#import "CLConfigMessage.h"
#import "CLRefreshHeaderCustomView.h"
@interface CLRefreshFooterView ()
{
    __unsafe_unretained UIImageView *_arrowView;
}

@property (nonatomic, strong) CLRefreshHeaderCustomView *refreshView;

@end

@implementation CLRefreshFooterView

#pragma mark - 懒加载子控件

- (CLRefreshHeaderCustomView *)refreshView
{
    if (!_refreshView) {
        CLRefreshHeaderCustomView *refreshView = [[CLRefreshHeaderCustomView alloc] init];
        
        refreshView.customViewStyle = CLRefreshCustomViewStyleGlay;
        [self addSubview:_refreshView = refreshView];
    }
    return _refreshView;
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    self.labelLeftInset = MJRefreshLabelLeftInset;
    // 监听label
    self.stateLabel.font = FONT(12.f);
    self.stateLabel.textColor = UIColorFromRGB(0x666666);
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
    
    [self setTitle:@"加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"数据已全部加载完成" forState:MJRefreshStateNoMoreData];
}

- (void)placeSubviews
{
    [super placeSubviews];
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5 - 40;
    //    if (!self.stateLabel.hidden) {
    //        CGFloat stateWidth = self.stateLabel.mj_textWith;
    //        arrowCenterX -= stateWidth / 2 + self.labelLeftInset;
    //    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.refreshView.constraints.count == 0) {
        self.refreshView.mj_size = self.refreshView.bounds.size;
        self.refreshView.center = arrowCenter;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            
        } else {
            //            [self beginRefreshing];
            [self.refreshView stopAnimating];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.refreshView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        
        [self.refreshView startAnimating];
    } else if (state == MJRefreshStateNoMoreData) {
        [self.refreshView stopAnimating];
    }
    self.refreshView.hidden = (state == MJRefreshStateNoMoreData);
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
//    NSLog(@"-------------------------");
    if (self.state != MJRefreshStateRefreshing) {
        [self.refreshView stopAnimating];
        self.refreshView.contentTransFormValue = CGAffineTransformMakeRotation(M_PI*2*pullingPercent);
    }
}

@end
