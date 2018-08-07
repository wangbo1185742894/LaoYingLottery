//
//  CLPaymentSelectedRedCell.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentSelectedRedCell.h"

#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CQViewQuickAllocDef.h"

#import "CLQuickRedPacketsModel.h"
#define CQUserRedPacketsListFont 13
#define CQUserRedPacketsListMargin 10.f
#define CQUserRedPacketsListCellWidth (SCREEN_WIDTH - 2 * CQUserRedPacketsListMargin) / 3
@interface CLPaymentSelectedRedCell()

@property (nonatomic, strong) UILabel *itemLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *selectedBankImage;
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation CLPaymentSelectedRedCell

+ (CGFloat)userPaymentSelectedRedPacketsListCellHeight
{
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.selectedBankImage];
        [self.contentView.layer insertSublayer:self.bottomLayer above:self.self.contentView.layer];
    }
    return self;
}

#pragma mark - assignMethod

- (void)assignPaymentSelectedUserRedPacketsListCellWithObj:(CLQuickRedPacketsModel *)model
{
    self.itemLabel.text = model.pay_name;
    self.descLabel.text = !model.noRedSelected?model.red_left_date:nil;
    
    if (model.red_left_date_color != nil && model.red_left_date_color.length > 0)
    {
        //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
        self.descLabel.textColor = UIColorFromRGB(strtoul([model.red_left_date_color UTF8String],0,16));
        self.itemLabel.textColor = UIColorFromRGB(0x333333);
    }
    else
    {
        self.itemLabel.textColor = self.descLabel.textColor = UIColorFromRGB(0x333333);
    }
    
    self.selectedBankImage.image = [UIImage imageNamed:model.isSelected ? @"accountSel_YES" : @"accountSel_NO"];
}

#pragma mark - gettingMethod

- (UIImageView *)selectedBankImage
{
    if (!_selectedBankImage) {
        _selectedBankImage = [[UIImageView alloc] initWithFrame:__Rect(0, 0, 20, 20)];
        _selectedBankImage.center = CGPointMake(SCREEN_WIDTH - 25.f, [CLPaymentSelectedRedCell userPaymentSelectedRedPacketsListCellHeight] * .5f);
    }
    return _selectedBankImage;
}

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"--", FONT_SCALE(CQUserRedPacketsListFont), NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect(CQUserRedPacketsListMargin, 0, CQUserRedPacketsListCellWidth, [CLPaymentSelectedRedCell userPaymentSelectedRedPacketsListCellHeight]));
        _itemLabel.numberOfLines = 0;
    }
    return _itemLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        AllocNormalLabel(_descLabel, @"--", FONT_SCALE(CQUserRedPacketsListFont), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(__Obj_XW_Value(self.itemLabel), __Obj_Frame_Y(self.itemLabel), CQUserRedPacketsListCellWidth, __Obj_Bounds_Height(self.itemLabel)));
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        AllocNormalLabel(_statusLabel, @"--", FONT_SCALE(CQUserRedPacketsListFont), NSTextAlignmentRight, UIColorFromRGB(0x333333), __Rect(__Obj_XW_Value(self.descLabel), __Obj_Frame_Y(self.descLabel), __Obj_Bounds_Width(self.itemLabel), __Obj_Bounds_Height(self.descLabel)));
        _statusLabel.numberOfLines = 0;
    }
    return _statusLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, [CLPaymentSelectedRedCell userPaymentSelectedRedPacketsListCellHeight] - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
