//
//  CLFTBetButtonView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTBetButtonView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
#import "Masonry.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLFTBetButtonView ()

@property (nonatomic, strong) UILabel *titleLabel;//投注项 号码
@property (nonatomic, strong) UILabel *contentLabel;//投注项的奖金
@property (nonatomic, strong) UIImageView *backgroudImageView;//选中态的背景
@property (nonatomic, strong) UIView *baseView;//为了居中的基层View


@end

@implementation CLFTBetButtonView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x009955);
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = UIColorFromRGB(0x71bb99).CGColor;
        self.layer.borderWidth = 2.f;
        self.layer.masksToBounds = YES;
        [self addSubview:self.backgroudImageView];
        [self addSubview:self.baseView];
        [self.baseView addSubview:self.titleLabel];
        [self.baseView addSubview:self.contentLabel];
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelfOnClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark ------ event Respone ------
- (void)tapSelfOnClick:(UITapGestureRecognizer *)tap{
    
    self.is_Selected = !self.is_Selected;
    self.betButtonClickBlock ? self.betButtonClickBlock(self) : nil;
}


#pragma mark ------ private Mothed ------
- (void)configNumberConstraint{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView).offset(__SCALE(3.f));
        make.bottom.equalTo(self.baseView).offset(__SCALE(-3.f));
    }];
    [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
- (void)configAllSubContraint{
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(-1.f));
        make.left.right.equalTo(self.baseView);
        make.bottom.equalTo(self.baseView);
    }];
    [self.backgroudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}
#pragma mark ------ setter Mothed ------
- (void)setBetNumber:(NSString *)betNumber{
    
    self.titleLabel.text = betNumber;
    [self configNumberConstraint];
}
- (void)setBetAward:(NSString *)betAward{
    
    self.contentLabel.text = betAward;
    [self configAllSubContraint];
}
- (void)setIs_Selected:(BOOL)is_Selected{
    
    _is_Selected = is_Selected;
    if (is_Selected) {
        self.backgroundColor = UIColorFromRGB(0x2b835b);
        self.titleLabel.textColor = UIColorFromRGB(0xffff00);
        self.contentLabel.textColor = UIColorFromRGB(0xffff00);
        self.layer.borderColor = UIColorFromRGB(0xffff00).CGColor;
    }else{
        self.backgroundColor = UIColorFromRGB(0x009955);
        self.layer.borderColor = UIColorFromRGB(0x71bb99).CGColor;
        self.titleLabel.textColor = UIColorFromRGB(0xffffff);
        self.contentLabel.textColor = UIColorFromRGB(0xffffff);
        [self.contentLabel attributeWithText:self.bonusInfo beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
    }
    self.betButtonSelectedBlock ? self.betButtonSelectedBlock(self) : nil;
    
}
- (void)setBonusInfo:(NSString *)bonusInfo{
    
    _bonusInfo = bonusInfo;
    [self.contentLabel attributeWithText:bonusInfo beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
}
#pragma mark ------ getterMothed ------
- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"5";
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.font = [UIFont boldSystemFontOfSize:__SCALE_HALE(20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = UIColorFromRGB(0xffffff);
        _contentLabel.font = FONT_SCALE(11);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}
- (UIImageView *)backgroudImageView{
    
    if (!_backgroudImageView) {
        _backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroudImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroudImageView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
    }
    return _backgroudImageView;
}
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseView.backgroundColor = CLEARCOLOR;
    }
    return _baseView;
}

@end
