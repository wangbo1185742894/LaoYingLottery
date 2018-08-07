//
//  CLQuickPaySelectedCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/26.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLQuickPaySelectedCell.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CLQuickRedPacketsModel.h"
#import "CLAccountInfoModel.h"
#import "CaiqrWebImage.h"


#define CQQuickBetHomeCellLeftMargin __SCALE(10.f)
#define CQQuickBetHomeCellWidth ((SCREEN_WIDTH - 2 * __SCALE(20.f)))
#define CQQuickBetPayMentFont FONT_SCALE(14)
#define CQQuickBetNoBalanceString @"余额不足"

@interface CLQuickPaySelectedCell ()

@property (nonatomic, strong) CALayer *iconLayer;
@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *subStatusLabel;

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) CALayer *bottomLayer;
@property (nonatomic, readwrite) BOOL paymentSelected;

@end

@implementation CLQuickPaySelectedCell

+ (CGFloat)quickBetPaySelectedTableViewCellHeight
{
    return __SCALE(40.f);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView.layer addSublayer:self.iconLayer];
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.statusLabel];
        [self.contentView addSubview:self.subStatusLabel];
        [self.contentView.layer addSublayer:self.bottomLayer];
    }
    return self;
}

- (void)assignQuickBetCellWithMethod:(id)method
{
    self.showStyle = CLQuickPaymentDefaultStyle;
    
    if ([method isKindOfClass:[CLQuickRedPacketsModel class]]) {
        /** 红包样式 */
        self.iconLayer.hidden = YES;
        self.itemLabel.frame = __Rect(CQQuickBetHomeCellLeftMargin, 0, CQQuickBetHomeCellWidth - 2 * CQQuickBetHomeCellLeftMargin, [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight]);
        CLQuickRedPacketsModel *model = (CLQuickRedPacketsModel *)method;
        self.iconLayer.contents = (id)[UIImage imageNamed:@"userCenterredPacketRecode.png"].CGImage;
        self.itemLabel.text = model.pay_name;
        self.paymentSelected = model.isSelected;
        self.itemLabel.textColor = UIColorFromRGB(0x333333);
        self.itemLabel.frame = __Rect([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], 0, CQQuickBetHomeCellWidth - 2 * CQQuickBetHomeCellLeftMargin - [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight]);
    }else if([method isKindOfClass:[CLAccountInfoModel class]]){
        /** 支付方式 */
        CLAccountInfoModel *model = (CLAccountInfoModel *)method;
        self.iconLayer.hidden = NO;
        [CaiqrWebImage downloadImageUrl:model.img_url progress:nil completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
            if (image != nil)
            {
               self.iconLayer.contents = (id)image.CGImage;
            }
        }];
        
        self.itemLabel.frame = __Rect([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], model.memo?5:0, CQQuickBetHomeCellWidth - 2 * CQQuickBetHomeCellLeftMargin - [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], model.memo ? ([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] * .5 - 5.f): [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight]);
        if (model.account_type_id == 1)
        {
            /** 账户余额不足 */
            if (!model.useStatus) self.showStyle = CLQuickPaymentNotSelectedStyle;
            //** 账户余额 */
            self.itemLabel.text = [NSString stringWithFormat:@"%@：%.2f%@",model.account_type_nm,model.maxLimit / 100.f,@"元"];
        }
        else if (model.account_type_id == 999)
        {
            //客服
            self.statusLabel.hidden = NO;
            self.statusLabel.textColor = THEME_COLOR;
            self.statusLabel.text = @"400-689-2227";
            self.statusLabel.adjustsFontSizeToFitWidth = YES;
            self.itemLabel.text = model.account_type_nm;
            
        }
        else
        {
            self.itemLabel.text = model.account_type_nm;
            self.rightImageView.hidden = NO;
            self.subStatusLabel.hidden = !(model.memo && model.memo.length);
            self.subStatusLabel.text = model.memo;
            self.subStatusLabel.frame = __Rect(CGRectGetMinX(self.itemLabel.frame),CGRectGetMaxY(self.itemLabel.frame),CGRectGetWidth(self.itemLabel.frame), CGRectGetHeight(self.itemLabel.frame));
        }
        /** 配置选择状态 */
        self.paymentSelected = model.selectedStatus;
        
    }
}

- (void)setPaymentSelected:(BOOL)paymentSelected
{
    _paymentSelected = paymentSelected;
    self.rightImageView.image = [UIImage imageNamed:paymentSelected?@"accountSel_YES":@"accountSel_NO"];
}

- (void)setShowStyle:(CLQuickPaymentShowStyle)showStyle
{
    _showStyle = showStyle;
    if (showStyle == CLQuickPaymentDefaultStyle) {
        self.subStatusLabel.hidden = YES;
        self.statusLabel.hidden = YES;
        self.statusLabel.adjustsFontSizeToFitWidth = NO;
        self.rightImageView.hidden = NO;
        self.itemLabel.textColor = UIColorFromRGB(0x333333);
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if (showStyle == CLQuickPaymentNotSelectedStyle){
        self.statusLabel.hidden = NO;
        self.subStatusLabel.hidden = YES;
        self.statusLabel.adjustsFontSizeToFitWidth = NO;
        self.rightImageView.hidden = YES;
        self.itemLabel.textColor = UIColorFromRGB(0x999999);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

#pragma mark gettingMethod

- (CALayer *)iconLayer
{
    if (!_iconLayer) {
        _iconLayer = [[CALayer alloc] init];
        CGFloat iconLayerWH = [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] - 2 * CQQuickBetHomeCellLeftMargin;
        _iconLayer.frame = __Rect(CQQuickBetHomeCellLeftMargin, CQQuickBetHomeCellLeftMargin, iconLayerWH, iconLayerWH);
    }
    return _iconLayer;
}

- (UIImageView *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:__Rect(0, 0, __SCALE(19.f), __SCALE(19.f))];
        _rightImageView.center = CGPointMake(CQQuickBetHomeCellWidth - __SCALE(20.f), [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] * .5f);
        _rightImageView.image = [UIImage imageNamed:@"accountSel_NO"];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"", CQQuickBetPayMentFont, NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect([CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], 0, CQQuickBetHomeCellWidth - 2 * CQQuickBetHomeCellLeftMargin - [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight], [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight]));
        _itemLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _itemLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        //        CGFloat statusStringW = ceilf([@"400-689-2227" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) Font:CQQuickBetPayMentFont].size.width);
        AllocNormalLabel(_statusLabel, CQQuickBetNoBalanceString, CQQuickBetPayMentFont, NSTextAlignmentRight, UIColorFromRGB(0x999999), __Rect(CQQuickBetHomeCellWidth - CQQuickBetHomeCellLeftMargin, 0,0, [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight]));
        _statusLabel.hidden = YES;
        //        _statusLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _statusLabel;
}

- (UILabel *)subStatusLabel
{
    if (!_subStatusLabel) {
        AllocNormalLabel(_subStatusLabel, CQQuickBetNoBalanceString, FONT_SCALE(12), NSTextAlignmentLeft, UIColorFromRGB(0x999999), __Rect(CGRectGetMinX(self.itemLabel.frame),CGRectGetMaxY(self.itemLabel.frame),CGRectGetWidth(self.itemLabel.frame), CGRectGetHeight(self.itemLabel.frame)));
    }
    return _subStatusLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.frame = __Rect(0, [CLQuickPaySelectedCell quickBetPaySelectedTableViewCellHeight] - .5f, CQQuickBetHomeCellWidth, .5f);
        _bottomLayer.backgroundColor = UIColorFromRGB(0xeeeeee).CGColor;
    }
    return _bottomLayer;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
