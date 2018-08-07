//
//  UINavigationItem+CLNavigationCustom.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UINavigationItem+CLNavigationCustom.h"

@implementation UINavigationItem (CLNavigationCustom)

- (void)setNotEdgeLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    [self setNotEdgeLeftBarButtonItems:@[leftBarButtonItem]];
}

- (void)setNotEdgeLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems
{
    NSMutableArray* barButtonItems = [NSMutableArray arrayWithArray:leftBarButtonItems];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -12;
    [barButtonItems insertObject:spaceButtonItem atIndex:0];
    [self setLeftBarButtonItems:barButtonItems];
    
}

- (void)setNotEdgeRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    [self setNotEdgeRightBarButtonItems:@[rightBarButtonItem]];
}

- (void)setNotEdgeRightBarButtonItems:(NSArray<UIBarButtonItem *> *)rightBarButtonItems
{
    NSMutableArray* barButtonItems = [NSMutableArray arrayWithArray:rightBarButtonItems];
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButtonItem.width = -12;
    [barButtonItems insertObject:spaceButtonItem atIndex:0];
    [self setRightBarButtonItems:barButtonItems];
    
}

@end
