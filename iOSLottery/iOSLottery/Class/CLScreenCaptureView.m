//
//  SLScreenCaptureView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLScreenCaptureView.h"
#import "CLConfigMessage.h"

@interface CLScreenCaptureView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *captureImageView;


@end

@implementation CLScreenCaptureView


- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 134.f);
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = UIColorFromRGB(0xFAF9F6);
        
    }
    
    return self;
}

- (void)addSubviews
{

    [self addSubview:self.titleLabel];
    
    [self addSubview:self.captureImageView];

}

- (void)addConstraints
{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.mas_equalTo(__SCALE(65.f * 0.85));
        make.height.mas_equalTo(__SCALE(16.f * 0.85));
    }];
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
}

- (void)setTopTitle:(NSString *)topTitle
{

    _topTitle = topTitle;
    
    if (topTitle && topTitle.length > 0) {
       
        self.titleLabel.text = topTitle;
    }
}

- (void)setCaptureImage:(UIImage *)captureImage
{

    _captureImage = captureImage;
    
    _captureImageView.image = captureImage;
    
    [self.captureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(20.f * 0.85));
        make.left.equalTo(self.mas_left).offset(__SCALE(62.f * 0.85));
        make.right.equalTo(self.mas_right).offset(__SCALE(-62.f * 0.85));
        make.height.equalTo(self.captureImageView.mas_width).multipliedBy(captureImage.size.height / captureImage.size.width);
        //make.bottom.lessThanOrEqualTo(self.mas_bottom).offset(__SCALE(-10.f * 0.85));
    }];
    

    
    //[self updateConstraints];
}

#pragma mark --- Get Method ---
- (UILabel *)titleLabel
{

    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _titleLabel.text = @"是否要将此订单分享给好友?";
        _titleLabel.textColor = UIColorFromRGB(0x363636);
        _titleLabel.font = FONT_SCALE(14.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIImageView *)captureImageView
{
    
    if (_captureImageView == nil) {
        
        _captureImageView = [[UIImageView alloc] initWithFrame:(CGRectZero)];

        _captureImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        //_captureImageView.clipsToBounds = YES;
        
        _captureImageView.layer.shadowColor = UIColorFromRGB(0X9F8269).CGColor;
        
        _captureImageView.layer.shadowOffset = CGSizeMake(0, 0);
        
        _captureImageView.layer.shadowOpacity = 0.3;
        
        _captureImageView.layer.shadowRadius = 5;
    }
    
    return _captureImageView;
}



@end
