//
//  CLQuickBetHomeTableViewCell.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  

#import "CLQuickBetHomeTableViewCell.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "UIImageView+CQWebImage.h"
#define CQQuickBetHomeCellLeftMargin __SCALE(10.f)
#define CQQuickBetHomeCellWidth SCREEN_WIDTH - 2 * 30
@interface CLQuickBetHomeTableViewCell()
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CLQuickBetHomeTableViewCell

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
        [self.contentView addSubview:self.bottomLineView];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(CQQuickBetHomeCellLeftMargin);
            make.width.height.mas_equalTo([CLQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight] - 2 * CQQuickBetHomeCellLeftMargin);
        }];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImage.mas_right).offset(CQQuickBetHomeCellLeftMargin);
            make.height.mas_equalTo([CLQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight]);
            make.top.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
        }];
        [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.contentView).offset(- 1.f);
            make.height.mas_equalTo(.5f);
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
        self.iconImage.image = [UIImage imageNamed:@"userCenterredPacketRecode.png"];
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
        AllocNormalLabel(_itemLabel, @"", FONT_SCALE(13), NSTextAlignmentLeft, UIColorFromRGB(0x333333), CGRectZero);
    }
    return _itemLabel;
}

- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _bottomLineView;
}

@end

