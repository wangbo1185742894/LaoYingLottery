//
//  CLSSQAwardHeaderView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/3.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQAwardHeaderView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLSSQAwardHeaderView ()

@property (nonatomic, strong) UILabel *bonusLabel;
@property (nonatomic, strong) UILabel *multipleLabel;

@end
@implementation CLSSQAwardHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bonusLabel];
        [self addSubview:self.multipleLabel];
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    
    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.centerY.equalTo(self);
    }];
    
    [self.multipleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.bonusLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self);
    }];
}
- (void)assignBonus:(NSString *)bonus multiple:(NSString *)multiple{
    
    self.multipleLabel.text = multiple;
    
    NSInteger loc = [bonus rangeOfString:@":"].location;
    AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(loc + 1, bonus.length - loc - 1) Color:THEME_COLOR];
    [self.bonusLabel attributeWithText:bonus controParams:@[params]];
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)bonusLabel{
    
    if (!_bonusLabel) {
        _bonusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bonusLabel.text = @"";
        _bonusLabel.textColor = UIColorFromRGB(0x333333);
        _bonusLabel.font = FONT_SCALE(11);
        _bonusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bonusLabel;
}

- (UILabel *)multipleLabel{
    
    if (!_multipleLabel) {
        _multipleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _multipleLabel.text = @"";
        _multipleLabel.textColor = UIColorFromRGB(0x333333);
        _multipleLabel.font = FONT_SCALE(11);
        _multipleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _multipleLabel;
}
@end
