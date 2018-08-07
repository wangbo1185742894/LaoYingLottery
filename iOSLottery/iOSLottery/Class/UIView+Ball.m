//
//  UIView+Ball.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "UIView+Ball.h"

@implementation UIView (Ball)

- (void)setCorner {
    
    self.layer.cornerRadius = self.bounds.size.width / 2.f;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

@end
