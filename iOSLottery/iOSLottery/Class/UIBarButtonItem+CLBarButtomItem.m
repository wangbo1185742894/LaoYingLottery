//
//  UIBarButtonItem+CLBarButtomItem.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/11/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UIBarButtonItem+CLBarButtomItem.h"
#import <objc/runtime.h>

static char *contentBottonKey = "contentBotton";

@implementation UIBarButtonItem (CLBarButtomItem)

+ (UIBarButtonItem *)cl_itemWithType:(CLBarButtonItemType)type Image:(NSString *)str target:(id)target action:(SEL)action{
    
    UIImage *image = [UIImage imageNamed:str];
    //设置渲染模式
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    //设置大小，设置位置没有用
    btn.frame = CGRectMake(0, 0, 28, 28);
    
    [btn setImage:image forState:(UIControlStateNormal)];
    
    [btn setAdjustsImageWhenHighlighted:NO];
    
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    

//    if (@available(iOS 11.0, *)) {
//
//        if (type == CLBarButtonItemTypeLeft) {
//            
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//            
//        }else{
//            
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
//        }
//    }

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    item.contentButton = btn;
    return item;
}


+ (UIBarButtonItem *)cl_spaceItemWithWidth:(NSInteger)width
{
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = width;
    
    return space;
}

+ (UIBarButtonItem *)cl_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    
    [btn setTitle:title forState:(UIControlStateNormal)];
    
    [btn setTitleColor:color forState:(UIControlStateNormal)];
    
    [btn setAdjustsImageWhenHighlighted:NO];
    
    btn.titleLabel.font = font;
    
    [btn addTarget:target action:action forControlEvents:(UIControlEventTouchUpInside)];
    
    [btn sizeToFit];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    item.contentButton = btn;
    
    return item;
}

- (void)cl_setItemHidden:(BOOL)hidden
{
    
    self.contentButton.hidden = hidden;
}

- (void)setContentButton:(UIButton *)contentButton
{
    objc_setAssociatedObject(self, &contentBottonKey, contentButton, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)contentButton
{
    
    return objc_getAssociatedObject(self, &contentBottonKey);
}

@end