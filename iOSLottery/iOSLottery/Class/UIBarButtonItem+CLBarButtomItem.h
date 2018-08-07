//
//  UIBarButtonItem+CLBarButtomItem.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/11/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CLBarButtonItemType){
    
    CLBarButtonItemTypeLeft,
    CLBarButtonItemTypeRight
};

@interface UIBarButtonItem (CLBarButtomItem)

@property (nonatomic, strong) UIButton *contentButton;

+ (UIBarButtonItem *)cl_itemWithType:(CLBarButtonItemType)type Image:(NSString *)str target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)cl_spaceItemWithWidth:(NSInteger)width;

+ (UIBarButtonItem *)cl_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

- (void)cl_setItemHidden:(BOOL)hidden;

@end
