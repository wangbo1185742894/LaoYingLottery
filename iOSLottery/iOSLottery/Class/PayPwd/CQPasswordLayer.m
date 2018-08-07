//
//  CQPasswordLayer.m
//  caiqr
//
//  Created by 彩球 on 16/4/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQPasswordLayer.h"
#import <UIKit/UIKit.h>



@interface CQPasswordLayer ()

@property (nonatomic, strong) CALayer* dotLayer;

@end

@implementation CQPasswordLayer

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    self.dotLayer.hidden = !_showDot;
}

- (CALayer *)dotLayer
{
    if (!_dotLayer) {
        _dotLayer = [CALayer layer];
        CGFloat width = (MIN(self.bounds.size.width, self.bounds.size.height) / 5.f * 2.f);
        CGFloat leftEdge = (self.bounds.size.width - width) / 2.f;
        CGFloat topEdge = (self.bounds.size.height - width) / 2.f;
        _dotLayer.frame = CGRectMake(leftEdge, topEdge, width, width);
        _dotLayer.cornerRadius = width / 2.f;
        _dotLayer.hidden = YES;
        _dotLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self addSublayer:_dotLayer];
    }
    return _dotLayer;
}

@end
