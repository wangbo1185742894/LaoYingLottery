//
//  CLRefreshHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLRefreshHeaderView.h"
#import "CLConfigMessage.h"
#import "CLRefreshHeaderCustomView.h"
@interface CLRefreshHeaderView ()
{
    __unsafe_unretained UIImageView *_arrowView;
}

@property (nonatomic, strong) CLRefreshHeaderCustomView *refreshView;
@end
@implementation CLRefreshHeaderView

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

#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    self.lastUpdatedTimeLabel.hidden = YES;
    self.labelLeftInset = 20.f;
    self.stateLabel.font = FONT(12.f);
    self.stateLabel.textColor = UIColorFromRGB(0x666666);
    
    [self setTitle:@"下拉刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5 - 40;
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
            [self.refreshView stopAnimating];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.refreshView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.refreshView startAnimating];
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    if (self.state != MJRefreshStateRefreshing) {
        [self.refreshView stopAnimating];
        self.refreshView.contentTransFormValue = CGAffineTransformMakeRotation(M_PI*2*pullingPercent);
    }
}

@end
