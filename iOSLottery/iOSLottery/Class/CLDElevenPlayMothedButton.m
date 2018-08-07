//
//  CLDElevenPlayMothedButton.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenPlayMothedButton.h"
#import "CLConfigMessage.h"
@interface CLDElevenPlayMothedButton ()

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *cornerView;//圆角View
@property (nonatomic, strong) UIImageView *addBonusImageView;//加奖图标

@end

@implementation CLDElevenPlayMothedButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cornerView];
        [self addSubview:self.rightImageView];
        [self addSubview:self.addBonusImageView];
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.equalTo(self);
            make.height.width.mas_equalTo(__SCALE(17.f));
        }];
        [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
        }];
        [self.addBonusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(__SCALE(-5.f));
            make.top.equalTo(self).offset(__SCALE(-5.f));
            make.width.mas_equalTo(__SCALE(33.f));
            make.height.mas_equalTo(__SCALE(15.f));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    self.rightImageView.hidden = !selected;
    self.cornerView.layer.borderColor = selected ? THEME_COLOR.CGColor : UIColorFromRGB(0xcbbdaa).CGColor;
}
#pragma mark ------------ setter Mothed ------------
- (void)setBonusType:(CLDEAddBonusType)bonusType{
    
    if (bonusType == CLDEAddBonusTypeNormal) {
        self.addBonusImageView.image = nil;
    }else if (bonusType == CLDEAddBonusTypeAddBonus){
        self.addBonusImageView.image = [UIImage imageNamed:@"addBonus.png"];
    }else if (bonusType == CLDEAddBonusTypeBonusToBonus){
        self.addBonusImageView.image = [UIImage imageNamed:@"bonusToBonus.png"];
    }
}
#pragma mark ------------ getter Mothed ------------
- (UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.image = [UIImage imageNamed:@"de_playMothedCornerMark"];
        _rightImageView.hidden = YES;
    }
    return _rightImageView;
}
- (UIView *)cornerView{
    
    if(!_cornerView){
        
        _cornerView = [[UIView alloc] init];
        _cornerView.layer.cornerRadius = 2.f;
        _cornerView.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
        _cornerView.layer.borderWidth = .5f;
        _cornerView.userInteractionEnabled = NO;
    }
    return _cornerView;
}
- (UIImageView *)addBonusImageView{
    
    if (!_addBonusImageView) {
        _addBonusImageView = [[UIImageView alloc] init];
        _addBonusImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _addBonusImageView;
}
@end
