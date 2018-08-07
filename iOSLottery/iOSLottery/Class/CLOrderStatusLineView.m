//
//  CLOrderStatusLineView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderStatusLineView.h"
#import "CLOrderStatusViewModel.h"
#import "CLConfigMessage.h"


@implementation CLOrderStatusLineView


- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    if (!self.dotParams && (self.dotParams.count == 0)) {
        return;
    }
    
    if (self.dotParams.count != (self.lineParams.count + 1)) {
        return;
    }
    
    CGFloat __width = self.frame.size.width;
    CGFloat __height = self.frame.size.height;
    CGFloat __radius = __SCALE(10.f);
    
    CGFloat __dotCenterYMultiple = 0.3f;
    //根据 lineParams元素设置点
    
//    1-1-1
//     1-1
//      1
    NSMutableArray* __dots = [NSMutableArray arrayWithCapacity:0];
    if (self.lineParams.count == 0) {
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 2.f, __height * __dotCenterYMultiple)]];
    } else if (self.lineParams.count == 1) {
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 4.f, __height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 4.f * 3.f, __height * __dotCenterYMultiple)]];
    } else if (self.lineParams.count == 2) {
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 4.f - 2. * __radius, __height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 2.f,__height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 4.f * 3.f + 2.f * __radius, __height * __dotCenterYMultiple)]];
    } else if (self.lineParams.count == 3) {
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 5.f, __height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 5.f * 2.f,__height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 5.f * 3.f, __height * __dotCenterYMultiple)]];
        [__dots addObject:[NSValue valueWithCGPoint:CGPointMake( __width / 5.f * 4.f, __height * __dotCenterYMultiple)]];
    }
    
    
    UIColor* __selectColor = UIColorFromRGB(0xFC5548);
    UIColor* __unSelectColor = UIColorFromRGB(0xcccccc);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //首先绘制线段
    
    if (__dots.count > 1) {
        
        for (int i = 0; i < (__dots.count - 1); i++) {
            CGPoint aPoints[2];//坐标点
            aPoints[0] = [__dots[i] CGPointValue];
            aPoints[1] = [__dots[i + 1] CGPointValue];
            
            CLOrderStatusViewModel* lineParam = self.lineParams[i];
            UIColor *lineColor = lineParam.lineLight?__selectColor:__unSelectColor;
            
            CGContextSetLineWidth(context, 4.f);
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            CGContextAddLines(context, aPoints, 2);//添加线
            CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径

        }
    }
    
    for (int i = 0 ; i < __dots.count; i++) {
        CLOrderStatusViewModel* dotParam = self.dotParams[i];
        CGPoint point = [__dots[i] CGPointValue];
        
        if (dotParam.dotType == CLOrderStatusDotTypeSuccess ||
            dotParam.dotType == CLOrderStatusDotTypeFail) {
            
            
            UIColor *color = __selectColor;
            CGContextSetFillColorWithColor(context,color.CGColor);
            CGContextAddArc(context, point.x , point.y , __radius, 0, 2 * M_PI, 0);
            CGContextDrawPath(context, kCGPathFill);
            
            [[UIImage imageNamed:(dotParam.dotType == CLOrderStatusDotTypeSuccess)?@"testYES":@"testNO"] drawInRect:CGRectMake(point.x - __SCALE(8), point.y - __SCALE(8), 2.f * __SCALE(8), 2.f * __SCALE(8))];
            
            
        } else if (dotParam.dotType == CLOrderStatusDotTypeLight ||
                   dotParam.dotType == CLOrderStatusDotTypeDark) {
            
            UIColor *color = (dotParam.dotType == CLOrderStatusDotTypeLight)?__selectColor:__unSelectColor;
            CGContextSetFillColorWithColor(context,color.CGColor);
            CGContextAddArc(context, point.x , point.y , __radius, 0, 2 * M_PI, 0);
            CGContextDrawPath(context, kCGPathFill);

            
            
            if (dotParam.dotText && dotParam.dotText.length > 0) {
                NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.alignment = NSTextAlignmentCenter;
                paragraph.lineBreakMode = NSLineBreakByCharWrapping;
                
                NSDictionary* dict = @{NSFontAttributeName : FONT_BOLD(14),NSParagraphStyleAttributeName:paragraph,
                                       NSForegroundColorAttributeName:[UIColor whiteColor]};
                CGFloat height = [dotParam.dotText boundingRectWithSize:CGSizeMake(50.f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
                [dotParam.dotText drawInRect:CGRectMake(point.x - __radius, point.y - (height / 2.f), 2.f * __radius, height) withAttributes:dict];
            }
        }
        
        
        if (dotParam.dotTitle && dotParam.dotTitle.length > 0) {
            UIColor* color = (dotParam.dotType == CLOrderStatusDotTypeLight || dotParam.dotType == CLOrderStatusDotTypeSuccess || dotParam.dotType == CLOrderStatusDotTypeFail)?__selectColor:__unSelectColor;
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.alignment = NSTextAlignmentCenter;
            paragraph.lineBreakMode = NSLineBreakByCharWrapping;
            NSDictionary* dict = @{NSFontAttributeName : FONT_SCALE(13),NSParagraphStyleAttributeName:paragraph,
                                   NSForegroundColorAttributeName:color};
            
            CGFloat height = [dotParam.dotTitle boundingRectWithSize:CGSizeMake(__SCALE(65.f), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
            [dotParam.dotTitle drawInRect:CGRectMake(point.x - __SCALE(65.f / 2), (__height - (__height / 2.f) - height ) /2.f + (__height / 2.f), __SCALE(65.f), height) withAttributes:dict];
        }
        
    }
}
@end

