//
//  UIBarButtonItem+SLBarButtonItem.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SLBarButtonItem)

@property (nonatomic, strong) UIButton *contentButton;

+ (UIBarButtonItem *)sl_itemWithImage:(NSString *)str target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)sl_spaceItemWithWidth:(NSInteger)width;

+ (UIBarButtonItem *)sl_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

- (void)sl_setItemHidden:(BOOL)hidden;

@end
