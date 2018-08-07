
//
//  CLPlayMothedOptionView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPlayMothedOptionView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "Masonry.h"
@interface CLPlayMothedOptionView ()

@property (nonatomic, strong) UIView *cornerView;//基础View 为了让View有圆角 并且不影响左上角的加奖标志
@property (nonatomic, strong) UIImageView *addBonusImageView;//左上角的加奖

@property (nonatomic, strong) UIImageView *cornerMarkImageView;//角标
@property (nonatomic, strong) UILabel *playMothedNameLabel;//玩法名称
@property (nonatomic, strong) UILabel *awardBonusLabel; //奖金label
@property (nonatomic, strong) UIView *diceView;//骰子所在的View
@property (nonatomic, strong) UIImageView *firstImageView;//第一个骰子
@property (nonatomic, strong) UIImageView *secondImageView;//第二个骰子
@property (nonatomic, strong) UIImageView *thirdImageView;//第三个骰子
@property (nonatomic, strong) UILabel *firstPlusLabel;//第一个加号
@property (nonatomic, strong) UILabel *secondPlusLabel;//第二个加号
@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图片
@property (nonatomic, strong) NSMutableArray *labelArray;


@end
@implementation CLPlayMothedOptionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerView.layer.masksToBounds = YES;
        self.cornerView.layer.cornerRadius = 3.f;
        self.cornerView.layer.borderColor = UIColorFromRGB(0x71bb99).CGColor;
        self.cornerView.layer.borderWidth = 2.f;
        self.cornerView.backgroundColor = UIColorFromRGB(0x009955);
        [self addSubview:self.cornerView];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.playMothedNameLabel];
        [self addSubview:self.awardBonusLabel];
        [self addSubview:self.diceView];
        
        [self.diceView addSubview:self.firstImageView];
        [self.diceView addSubview:self.secondImageView];
        [self.diceView addSubview:self.thirdImageView];
        [self.diceView addSubview:self.firstPlusLabel];
        [self.diceView addSubview:self.secondPlusLabel];
        [self addSubview:self.cornerMarkImageView];
        [self addSubview:self.addBonusImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}
#pragma mark ------ event Respone ------
- (void)tapSelf:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(choosePlayMothedWithType:)]) {
        [self.delegate choosePlayMothedWithType:self.playMothedType];
    }
}
- (void)setImagesArray:(NSArray *)imagesArray{
    
    __block UIImageView *tempImageView = nil;

    [imagesArray enumerateObjectsUsingBlock:^(UIImage *  _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.diceView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (tempImageView) {
                make.left.equalTo(tempImageView.mas_right).offset(__SCALE(5.f));
            }else{
                make.left.equalTo(self.diceView);
            }
            make.height.width.mas_equalTo(__SCALE(20.f));
            make.top.bottom.equalTo(self.diceView);
        }];
        
        if (idx != imagesArray.count - 1) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.textColor = UIColorFromRGB(0xffffff);
            label.font = FONT_SCALE(10);
            label.textAlignment = NSTextAlignmentCenter;
            [self.diceView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(imageView.mas_right);
                make.centerY.equalTo(imageView);
                make.width.mas_equalTo(__SCALE(5.f));
            }];
            [self.labelArray addObject:label];
        }
        tempImageView = imageView;
        
    }];
    [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.diceView);
    }];
}

#pragma mark ------ private Mothed ------
///只有玩法名称时的约束
- (void)configNameLabelConstaint{
    
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.addBonusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(__SCALE(-5.f));
        make.left.equalTo(self).offset(__SCALE(-5.f));
        make.width.mas_equalTo(__SCALE(33.f));
        make.height.mas_equalTo(__SCALE(15.f));
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.playMothedNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.bottom.equalTo(self).offset(__SCALE(- 10.f));
    }];
    
    [self.cornerMarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.equalTo(self);
        make.height.width.mas_equalTo(__SCALE(17.f));
    }];
}
//奖金和骰子都有的时候的约束
- (void)configAllConstraint{
    
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.addBonusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(__SCALE(-5.f));
        make.left.equalTo(self).offset(__SCALE(-5.f));
        make.width.mas_equalTo(__SCALE(33.f));
        make.height.mas_equalTo(__SCALE(15.f));
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.playMothedNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(__SCALE(10.f));
    }];
    [self.awardBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playMothedNameLabel.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self.playMothedNameLabel);
    }];
    [self.diceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.awardBonusLabel.mas_bottom).offset(__SCALE(5.f));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(__SCALE(-5.f));
    }];
}
#pragma mark ------ setter Mothed ------
- (void)setPlayMothedName:(NSString *)playMothedName{
    self.playMothedNameLabel.text = playMothedName;
    [self configNameLabelConstaint];
    
}
- (void)setAwardBonus:(NSString *)awardBonus{
    self.awardBonusLabel.text = awardBonus;
    [self configAllConstraint];
}
- (void)setIsShowPlus:(BOOL )isShowPlus{
    
    if (isShowPlus) {
        for (UILabel *label in self.labelArray) {
            label.text = @"+";
            label.hidden = NO;
        }
    }else{
        for (UILabel *label in self.labelArray) {
            label.text = @"";
            label.hidden = YES;
        }
    }
}
- (void)setIs_selected:(BOOL)is_selected{
    
    _is_selected = is_selected;
    if (is_selected) {
        self.cornerView.backgroundColor = UIColorFromRGB(0x2b835b);
        self.cornerView.layer.borderColor = UIColorFromRGB(0xffff00).CGColor;
        self.cornerMarkImageView.hidden = NO;
    }else{
        self.cornerView.backgroundColor = UIColorFromRGB(0x009955);
        self.cornerView.layer.borderColor = UIColorFromRGB(0x71bb99).CGColor;
        self.cornerMarkImageView.hidden = YES;
    }
}
- (void)setBonusType:(CLFTPlayMothedBonusType)bonusType{
    
    if (bonusType == CLFTPlayMothedBonusTypeNormal) {
        self.addBonusImageView.image = nil;
    }else if (bonusType == CLFTPlayMothedBonusTypeAddBonus){
        self.addBonusImageView.image = [UIImage imageNamed:@"addBonus.png"];
    }else if (bonusType == CLFTPlayMothedBonusTypeBonusToBonus){
        self.addBonusImageView.image = [UIImage imageNamed:@"bonusToBonus.png"];
    }
}
#pragma mark ------ getter Mothed ------
- (UIView *)cornerView{
    
    if (!_cornerView) {
        _cornerView = [[UIView alloc] init];
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
- (UIImageView *)cornerMarkImageView{
    
    if (!_cornerMarkImageView) {
        _cornerMarkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _cornerMarkImageView.contentMode = UIViewContentModeScaleAspectFit;
        _cornerMarkImageView.image = [UIImage imageNamed:@"ft_playMothedCornerMark.png"];
        _cornerMarkImageView.hidden = YES;
    }
    return _cornerMarkImageView;
}
- (UILabel *)playMothedNameLabel{
    
    if (!_playMothedNameLabel) {
        _playMothedNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _playMothedNameLabel.text = @"和值";
        _playMothedNameLabel.textAlignment = NSTextAlignmentCenter;
        _playMothedNameLabel.textColor = UIColorFromRGB(0xffffff);
        _playMothedNameLabel.font = [UIFont boldSystemFontOfSize:__SCALE_HALE(16)];
    }
    return _playMothedNameLabel;
}
- (UILabel *)awardBonusLabel{
    
    if (!_awardBonusLabel) {
        _awardBonusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardBonusLabel.text = @"";
        _awardBonusLabel.textAlignment = NSTextAlignmentCenter;
        _awardBonusLabel.textColor = UIColorFromRGB(0x71bb99);
        _awardBonusLabel.font = FONT_SCALE(12);
    }
    return _awardBonusLabel;
}
- (UIView *)diceView{
    
    if (!_diceView) {
        _diceView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _diceView;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}
- (NSMutableArray *)labelArray{
    
    if (!_labelArray) {
        _labelArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _labelArray;
}
@end
