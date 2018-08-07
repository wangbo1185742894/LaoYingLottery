//
//  CKQuickBetHomeTableViewCell.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  

#import "CKQuickBetHomeTableViewCell.h"
#import "CKDefinition.h"
#import "Masonry.h"
#import "UIImageView+CKWebImage.h"
#define CKQuickBetHomeCellLeftMargin __SCALE(10.f)
#define CKQuickBetHomeCellWidth SCREEN_WIDTH - 2 * 30
@interface CKQuickBetHomeTableViewCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView *bottomLayer;

@end

@implementation CKQuickBetHomeTableViewCell

+ (CGFloat)quickBetHomeTableViewCellHeight
{
    return __SCALE(40.f);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self.contentView addSubview:self.iconImage];
        [self.contentView addSubview:self.itemLabel];
        [self addSubview:self.bottomLayer];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(CKQuickBetHomeCellLeftMargin);
            make.width.height.mas_equalTo([CKQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight] - 2 * CKQuickBetHomeCellLeftMargin);
        }];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(CKQuickBetHomeCellLeftMargin);
            make.height.mas_equalTo([CKQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight]);
            make.top.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setItemString:(NSString *)itemString
{
    self.itemLabel.text = itemString;
}

- (void)setIconString:(NSString *)iconString
{
    if (iconString && iconString.length > 0) {
        [self.iconImage setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:nil];
    }else{
        self.iconImage.image = [UIImage imageNamed:@"ck_userCenterredPacketRecode.png"];
    }
}

#pragma mark - gettingMethod

- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLabel.backgroundColor = [UIColor clearColor];
        _itemLabel.textAlignment = NSTextAlignmentLeft;
        _itemLabel.font = FONT_SCALE(13);
        _itemLabel.text = @"";
        _itemLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _itemLabel;
}

- (UIView *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[UIView alloc] init];
        _bottomLayer.frame = __Rect(0, [CKQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight] - .5f, SCREEN_WIDTH, .5f);
        _bottomLayer.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _bottomLayer;
}

@end

