//
//  CLAwardNumberNewView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAwardNumberNewView.h"
#import "Masonry.h"
#import "UIView+Ball.h"
#import "CLConfigMessage.h"

@implementation CLAwardNumberNewView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.space = __SCALE(20.f);
        self.ballWidthHeight = __SCALE(28.f);
    }
    return self;
}

- (void)setNumbers:(NSArray*)numbers {
    
    _numbers = numbers;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGFloat width = self.ballWidthHeight;
    
    __block UILabel* tempLabl;
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = width / 2.f;
        label.textColor = self.ballColor;
        label.layer.borderWidth = 0.5;
        label.layer.borderColor = self.ballColor.CGColor;
        label.text = [NSString stringWithFormat:@"%02lld",[obj longLongValue]];
        label.font = FONT_SCALE(16.f);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(width);
            if (idx == 0) {
                make.left.equalTo(self);
            } else {
                make.left.equalTo(tempLabl.mas_right).offset(self.space);
            }
        }];
        
        tempLabl = label;
        
    }];
    [tempLabl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self);
    }];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setCorner];
    }];
    
}

@end

