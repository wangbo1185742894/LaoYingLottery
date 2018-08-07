//
//  CLFTImageLabel.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTImageLabel.h"
#import "CLConfigMessage.h"

@interface CLFTImageLabel ()
@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图
@property (nonatomic, strong) UILabel *contentLabel;//内容

@end
@implementation CLFTImageLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.contentLabel];
        [self configConstraint];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)configConstraint{
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(- 3.f);
        make.right.equalTo(self);
    }];
    
}
#pragma mark ------------ event Response ------------
- (void)tapSelf:(UITapGestureRecognizer *)tap{
    
    !self.onClickBlock ? : self.onClickBlock();
}
#pragma mark ------ setter Mothed ------
- (void)setBackImage:(UIImage *)backImage
{
    self.backgroundImageView.image = backImage;
}
- (void)setContentString:(NSString *)contentString{
    
    self.contentLabel.text = contentString;
}
- (void)setContentFont:(UIFont *)contentFont{
    
    self.contentLabel.font = contentFont;
}
- (void)setContentColor:(UIColor *)contentColor{
    
    self.contentLabel.textColor = contentColor;
}
#pragma mark ------ getter Mothed ------
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backgroundImageView.image = [UIImage imageNamed:@"ft_playMothedTag.png"];
    }
    return _backgroundImageView;
}
- (UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _contentLabel.text = @"三不同号";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = UIColorFromRGB(0xffffdd);
        _contentLabel.font = FONT_SCALE(14);
    }
    return _contentLabel;
}
@end
