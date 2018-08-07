//
//  CLRedSelectedHeaderView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedSelectedHeaderView.h"
#import "CLConfigMessage.h"

#define CLUserRedPacketsListMargin 10.f
#define CLUserRedPacketsListCellWidth (SCREEN_WIDTH - 2 * CLUserRedPacketsListMargin) / 3
@interface CLRedSelectedHeaderView()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *bottomLayer;
@end


@implementation CLRedSelectedHeaderView

+ (instancetype)userRedSelectedHeaderView
{
    CLRedSelectedHeaderView *headerView = [[CLRedSelectedHeaderView alloc] init];
    
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
        self.frame = __Rect(0, 5.f, SCREEN_WIDTH, 50.f);
    }
    return self;
}

#pragma mark - gettingMethod
- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"可用金额", FONT_SCALE(13), NSTextAlignmentLeft, UIColorFromRGB(0x666666), __Rect(CLUserRedPacketsListMargin, 0, CLUserRedPacketsListCellWidth, 50.f));
        _itemLabel.numberOfLines = 0;
    }
    return _itemLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        AllocNormalLabel(_descLabel, @"有效期", FONT_SCALE(13), NSTextAlignmentCenter, UIColorFromRGB(0x666666), __Rect(__Obj_XW_Value(self.itemLabel), __Obj_Frame_Y(self.itemLabel), CLUserRedPacketsListCellWidth, __Obj_Bounds_Height(self.itemLabel)));
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        AllocNormalLabel(_statusLabel, @"使用", FONT_SCALE(13), NSTextAlignmentRight, UIColorFromRGB(0x666666), __Rect(__Obj_XW_Value(self.descLabel), __Obj_Frame_Y(self.descLabel), __Obj_Bounds_Width(self.itemLabel), __Obj_Bounds_Height(self.descLabel)));
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, 50.f - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

@end
