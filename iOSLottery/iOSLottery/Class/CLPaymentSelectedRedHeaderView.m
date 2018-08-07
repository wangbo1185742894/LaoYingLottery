//
//  CLPaymentSelectedRedHeaderView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentSelectedRedHeaderView.h"
#import "CLConfigMessage.h"
#import "CQDefinition.h"
@interface CLPaymentSelectedRedHeaderView()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *bottomLayer;
@end


@implementation CLPaymentSelectedRedHeaderView

+ (instancetype)userPaymentSelectedHeaderView
{
    CLPaymentSelectedRedHeaderView *headerView = [[CLPaymentSelectedRedHeaderView alloc] init];
    
    return headerView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.itemLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.statusLabel];
        [self.layer addSublayer:self.bottomLayer];
        self.frame = __Rect(0, 5.f, SCREEN_WIDTH, 10.f);
    }
    return self;
}

#pragma mark - gettingMethod
- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        
        AllocNormalLabel(_itemLabel, @"可用金额", FONT_SCALE(13), NSTextAlignmentLeft, UIColorFromRGB(0x666666),CGRectZero);
        _itemLabel.numberOfLines = 0;
    }
    return _itemLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        AllocNormalLabel(_descLabel, @"有效期", FONT_SCALE(13), NSTextAlignmentCenter, UIColorFromRGB(0x666666), CGRectZero);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        AllocNormalLabel(_statusLabel, @"使用", FONT_SCALE(13), NSTextAlignmentRight, UIColorFromRGB(0x666666), CGRectZero);
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, 10 - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

@end
