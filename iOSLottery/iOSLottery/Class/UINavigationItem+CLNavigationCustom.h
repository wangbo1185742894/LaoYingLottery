//
//  UINavigationItem+CLNavigationCustom.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (CLNavigationCustom)

- (void)setNotEdgeLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
- (void)setNotEdgeLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems;
- (void)setNotEdgeRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
- (void)setNotEdgeRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems;
@end
