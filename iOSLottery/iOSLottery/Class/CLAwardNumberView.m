//
//  CLAwardNumberView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardNumberView.h"
#import "Masonry.h"
#import "UIView+Ball.h"
#import "CLConfigMessage.h"
@interface CLAwardNumberView ()


@end

@implementation CLAwardNumberView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.space = __SCALE(20.f);
        self.ballWidthHeight = __SCALE(30.f);
        
        self.showTwoPlaces = YES;
    }
    return self;
}

- (void)setNumbers:(NSArray*)numbers {
    
    _numbers = numbers;

    //清空子视图
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = self.ballWidthHeight;
    
    __block UILabel* tempLabl;
    
    [numbers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        
        label.backgroundColor = self.onlyShowText ? [UIColor clearColor] : self.ballColor;
        
        label.textColor = self.onlyShowText ? self.ballColor : [UIColor whiteColor];
        
        
//        if (self.onlyShowText == YES) {
//            
//            label.backgroundColor = [UIColor clearColor];
//            label.textColor = UIColorFromRGB(0xD21100);
//            
//            
//        }else{
//        
//            label.backgroundColor = self.ballColor;
//            label.textColor = [UIColor whiteColor];
//        }
        
        if (self.showTwoPlaces == YES) {
           
            label.text = [NSString stringWithFormat:@"%02lld",[obj longLongValue]];
            
        }else{
        
           label.text = [NSString stringWithFormat:@"%lld",[obj longLongValue]]; 
        }
        
        label.layer.cornerRadius = width / 2.f;

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
