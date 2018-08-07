//
//  CLNoNetFloatView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLNoNetFloatView.h"
#import "Masonry.h"
#import "CLConfigMessage.h"
#import "CLAllJumpManager.h"
@interface CLNoNetFloatView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, weak) UIViewController *selfWeakViewController;

@end

@implementation CLNoNetFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        [self addsubViews];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInterfaceMethod:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:ges];

    }
    return self;
}

- (void)addsubViews{
    if (!_rightImageView && !_textLabel) {
        [self addSubview:self.textLabel];
        [self addSubview:self.rightImageView];
        [self addConstraint];
    }
    
}
- (void)addConstraint{
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(10.f);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-10.f);
        make.centerY.mas_equalTo(self);
        make.height.width.mas_equalTo(__SCALE(13));
        
    }];
}
#pragma 点击进入详情
- (void)userInterfaceMethod:(id)sender{

    [[CLAllJumpManager shareAllJumpManager] open:@"CLNoNetSettingViewController_push"];
}

#pragma mark - GetMethod
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.preferredMaxLayoutWidth = 280;
        [_textLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:[UIScreen mainScreen].bounds.size.width/320.0*12.f];
        _textLabel.text = @"无网络连接，您的设备未启用WiFi网络或移动网络";
        
        _textLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInterfaceMethod:)];
        ges.numberOfTapsRequired = 1;
        ges.numberOfTouchesRequired = 1;
        [_textLabel addGestureRecognizer:ges];
    }
    return _textLabel;
}


- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.backgroundColor = CLEARCOLOR;
        _rightImageView.image = [UIImage imageNamed:@"noNetNext.png"];
    }
    return _rightImageView;
}

@end
