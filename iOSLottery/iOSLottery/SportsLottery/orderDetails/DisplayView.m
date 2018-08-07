//
//  DisplayView.m
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "DisplayView.h"
#import "CoreTextImageData.h"
#import "SLConfigMessage.h"

@implementation DisplayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.isOffset ? self.bounds.size.height + SL__SCALE(5.f) : self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    if (self.data) {
        
        CTFrameDraw(self.data.ctFrame, context);
        
        
        
        if (self.data.imageArray.count > 0) {
            
            for (CoreTextImageData* imgData in self.data.imageArray) {
                CGContextDrawImage(context, imgData.imagePosition, [UIImage imageNamed:imgData.imgName].CGImage);
            }
            
            
        }
    }
    
}

@end
