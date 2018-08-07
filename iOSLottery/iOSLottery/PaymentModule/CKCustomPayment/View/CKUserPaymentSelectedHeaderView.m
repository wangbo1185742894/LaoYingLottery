//
//  CKUserPaymentSelectedHeaderView.m
//  caiqr
//
//  Created by 小铭 on 2017/9/21.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKUserPaymentSelectedHeaderView.h"
#import "CKDefinition.h"

#define CKUserRedPacketsListFont 13
#define CKUserRedPacketsListMargin __SCALE(10.f)
#define CKUserRedPacketsListCellWidth (SCREEN_WIDTH - 2 * CKUserRedPacketsListMargin) / 3

@interface CKUserPaymentSelectedHeaderView()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) CALayer *bottomLayer;
@end


@implementation CKUserPaymentSelectedHeaderView

+ (instancetype)userPaymentSelectedHeaderView
{
    CKUserPaymentSelectedHeaderView *headerView = [[CKUserPaymentSelectedHeaderView alloc] init];
    
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
        self.frame = __Rect(0, 5.f, SCREEN_WIDTH, __SCALE(40.f));
    }
    return self;
}

#pragma mark - gettingMethod
- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] initWithFrame:__Rect(CKUserRedPacketsListMargin, 0, CKUserRedPacketsListCellWidth, __SCALE(40.f))];
        _itemLabel.text = @"可用金额";
        _itemLabel.textColor = UIColorFromRGB(0x666666);
        _itemLabel.font = FONT_SCALE(13.f);
        _itemLabel.numberOfLines = 0;
        _itemLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _itemLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:__Rect(__Obj_XW_Value(self.itemLabel), __Obj_Frame_Y(self.itemLabel), CKUserRedPacketsListCellWidth, __Obj_Bounds_Height(self.itemLabel))];
        _descLabel.text = @"有效期";
        _descLabel.textColor = UIColorFromRGB(0x666666);
        _descLabel.font = FONT_SCALE(13.f);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:__Rect(__Obj_XW_Value(self.descLabel), __Obj_Frame_Y(self.descLabel), __Obj_Bounds_Width(self.itemLabel), __Obj_Bounds_Height(self.descLabel))];
        _statusLabel.text = @"使用";
        _statusLabel.textColor = UIColorFromRGB(0x666666);
        _statusLabel.font = FONT_SCALE(13.f);
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, __SCALE(40.f) - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

@end
