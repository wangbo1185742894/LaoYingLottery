//
//  UITableView+CLScreenCapture.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "UITableView+CLScreenCapture.h"
#import "CLConfigMessage.h"

@implementation UITableView (CLScreenCapture)

- (UIImage *)cl_captureImageOfContentSize;
{

    UIImage* image = nil;
    
    /**
     第一个参数表示区域大小
     第二个参数表示是否是非透明的
     如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度
     */
    //初始化画板
    
    CGSize contextSize = CGSizeMake(self.contentSize.width, self.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(contextSize, YES, [UIScreen mainScreen].scale);
    
    //保存截屏之前tableView的contentOffset
    CGPoint savedContentOffset = self.contentOffset;
    
    //保存截屏之前tableView的frame
    CGRect savedFrame = self.frame;
    
    //设置contentOffset置0
    self.contentOffset = CGPointZero;
    
    //设置tableView的frame为内容的大小
    self.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    //把这个frame变大的tableView绘制到画板上
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //从画板上获取图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //下面这两步就将tableView恢复到截屏之前的状态
    self.contentOffset = savedContentOffset;
    self.frame = savedFrame;
    
    //关闭画板
    UIGraphicsEndImageContext();
    
    return image;


}

- (UIImage *)cl_captureImageOfFrame;
{

    UIImage* image = nil;

    //初始化画板
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, [UIScreen mainScreen].scale);
    
    //设置contentOffset置0
    self.contentOffset = CGPointZero;
    
    //把这个frame变大的tableView绘制到画板上
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    //从画板上获取图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭画板
    UIGraphicsEndImageContext();
    
    return image;

}

- (UIImage *)cl_captureShareImageOfContentAndAppIcon:(UIImage *)icon;
{

    UIImage *longImage = [self cl_captureImageOfContentSize];
    
    CGSize contextSize = CGSizeMake(longImage.size.width, longImage.size.height + __SCALE(100.f * 0.85));
    
    UIGraphicsBeginImageContextWithOptions(contextSize, YES, [UIScreen mainScreen].scale);
    

    [longImage drawInRect:(CGRectMake(0, __SCALE(100.f * 0.85), longImage.size.width, longImage.size.height))];
    
    //拼接分享出去后顶部app介绍
    
    if (icon == nil) {
        
        icon = [UIImage imageNamed:@"share_add"];
    }
 
    [icon drawInRect:(CGRectMake(0, 0, longImage.size.width, __SCALE(100.f * 0.85)))];
    
    longImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭画板
    UIGraphicsEndImageContext();
    
    return longImage;
    
}

- (void)scrollToAllShowArea:(NSIndexPath *)indexPath
{
    if (CGRectGetMaxY([self rectForRowAtIndexPath:indexPath]) > self.contentOffset.y + self.bounds.size.height) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    if (CGRectGetMinY([self rectForRowAtIndexPath:indexPath]) < self.contentOffset.y) {
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
