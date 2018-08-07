//
//  BBPlayMethodTagView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBPlayMethodTagView.h"
#import "SLConfigMessage.h"

@interface BBPlayMethodTagView ()

/**
 标签文字
 */
@property (nonatomic, strong) NSString *tagString;

/**
 标签文字颜色
 */
@property (nonatomic, strong) UIColor *tagColor;

/**
 是否显示标签
 */
@property (nonatomic, assign) BOOL isShowTag;

@end

@implementation BBPlayMethodTagView

- (void)setTagText:(NSString *)text
{

    self.tagString = text;
}

- (void)setTagTextColor:(UIColor *)textColor
{

    self.tagColor = textColor;
}

- (void)setShowTag:(BOOL)show
{
    self.isShowTag = show;
}

- (void)drawRect:(CGRect)rect
{
    
    //填充背景色
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);
    
    if (self.isShowTag == YES) {
        
        UIImage *tag = [UIImage imageNamed:@"play_danguan"];
        
        [tag drawInRect:(CGRectMake(0, 0, SL__SCALE(20.f), SL__SCALE(20.f)))];
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    //设置水平居中
    style.alignment = NSTextAlignmentCenter;

    UIFont *font = [UIFont systemFontOfSize:SL__SCALE(10.f)];
    
    NSDictionary *attrbutes = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : style};
    
    //计算文字大小
    CGSize strSize = [self.tagString sizeWithAttributes:attrbutes];
    
    CGFloat marginTop = (rect.size.height - strSize.height + 1) / 2;
    
    CGRect strRect = CGRectMake(0, marginTop, rect.size.width, strSize.height);
    
    //绘制文字
    [self.tagString drawInRect:strRect withAttributes:attrbutes];
    
    //画边线
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    path.lineWidth = 0.251;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    UIColor *color = SL_UIColorFromRGB(0xECE5DD);
    [color set];
    
    [path stroke];
}

@end
