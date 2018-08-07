//
//  CLWithdrawHeaderView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawHeaderView.h"
#import "CLConfigMessage.h"

@interface CLWithdrawHeaderView ()

@end
@implementation CLWithdrawHeaderView

+ (CGFloat) headerHeight {
    
    return __SCALE(25);
}

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.timeLbl = [[UILabel alloc] init];
        self.timeLbl.backgroundColor = [UIColor clearColor];
        self.timeLbl.font = FONT_SCALE(12);
        self.timeLbl.textColor = UIColorFromRGB(0x333333);
        
        [self.contentView addSubview:self.timeLbl];
        
        [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
