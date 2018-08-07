//
//  CLEmptyButton.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLEmptyButton.h"

@implementation CLEmptyButton

- (instancetype)initWithFrame:(CGRect)frame withtitle:(NSString *)titleString withBackgroundColor:(UIColor *)backGroundColor{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitle:titleString forState:UIControlStateNormal];
        [self setBackgroundColor:backGroundColor];
        [self addTarget:self action:@selector(selfselected:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 2.0f;
    }
    
    return self;
    
}

- (void)selfselected:(id)sender{
    
    if (_btnselected) {
        _btnselected();
    }
}

@end
