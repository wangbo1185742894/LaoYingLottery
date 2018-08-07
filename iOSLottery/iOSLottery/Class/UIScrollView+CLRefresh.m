//
//  UIScrollView+CLRefresh.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UIScrollView+CLRefresh.h"
#import "MJRefresh.h"
#import "CLRefreshHeaderView.h"
#import "CLRefreshFooterView.h"
@implementation UIScrollView (CLRefresh)

- (void)showsRefresh:(BOOL)shows{
    
    self.mj_header.hidden = !shows;
}

- (void)showsLoading:(BOOL)shows{
    
    self.mj_footer.hidden = !shows;
}

- (void)startRefreshAnimating
{
    [self.mj_header beginRefreshing];
}

- (void)stopRefreshAnimating
{
    [self.mj_header endRefreshing];
}

- (void)startLoadingAnimating
{
    [self.mj_footer beginRefreshing];
}
- (void)stopLoadingAnimating
{
    [self.mj_footer endRefreshing];
}
- (void)stopLoadingAnimatingWithNoMoreData{
    
    [self.mj_footer endRefreshingWithNoMoreData];
}
- (void)resetNoMoreData{
    
    [self.mj_footer resetNoMoreData];
}
- (void)addRefresh:(void (^)(void))refreshAction{
    
    self.mj_header = [CLRefreshHeaderView headerWithRefreshingBlock:refreshAction];
}

- (void)addLoading:(void (^)(void))loadingAction{
    
    self.mj_footer = [CLRefreshFooterView footerWithRefreshingBlock:loadingAction];
}

@end
