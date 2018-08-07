//
//  CLPaymentInfoShowCell.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentInfoShowCell.h"
#import "CQDefinition.h"
#import "CQViewQuickAllocDef.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLUserPayAccountInfo.h"
#import "CLQuickRedPacketsModel.h"
#define CQUserCashBankNameFont FONT_SCALE(13)


@interface CLPaymentInfoShowCell()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *itemDescLabel;
@property (nonatomic, strong) CALayer *botttomLayer;

@end

@implementation CLPaymentInfoShowCell

+ (CGFloat)payMentInfoShowHeight
{
    return 50.f;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.itemDescLabel];
        [self.itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5.f);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo([CLPaymentInfoShowCell payMentInfoShowHeight]);
        }];
        [self.itemDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5.f);
            make.centerY.mas_equalTo(self.contentView);
            make.height.mas_equalTo([CLPaymentInfoShowCell payMentInfoShowHeight]);
            make.left.mas_equalTo(self.itemLabel.mas_right);
        }];
        [self.contentView.layer insertSublayer:self.botttomLayer atIndex:0];
    }
    return self;
}

- (void)assignUserCashDepositCellWithObj:(id)obj
{
    if ([obj isKindOfClass:[CLUserPayAccountInfo class]])
    {
        self.cellShowStyle = defaultPaymentShowStyle;
        //** 用户支付信息cell */
        CLUserPayAccountInfo *info = (CLUserPayAccountInfo *)obj;
        UIColor *amountColor;
        if (info.isMarkednessRed) {
            amountColor = UIColorFromRGB(0xd80000);
        }else{
            amountColor = UIColorFromRGB(0x333333);
        }
        NSString *amountString = [NSString stringWithFormat:@"%@%@",[self dealWithMoneyDotString:(double)info.amount/100],@"元"];
        NSString *totalAmountString = [NSString stringWithFormat:@"%@ : %@",info.payAmountItemString,amountString];
        [self.itemLabel attributeWithText:totalAmountString controParams:@[[AttributedTextParams attributeRange:[totalAmountString rangeOfString:amountString] Color:amountColor]]];
    }
    else if ([obj isKindOfClass:[CLQuickRedPacketsModel class]])
    {
        self.cellShowStyle = noIconAndNoSelectedButtonDepositStyle;
        //** 红包样式 */
        CLQuickRedPacketsModel *model = (CLQuickRedPacketsModel *)obj;
        if (model.noRedSelected) {
            self.itemLabel.text = @"不使用红包";
        }else{
            self.itemLabel.text = [NSString stringWithFormat:@"红包抵扣 : %@",model.show_name];
        }
    }
}

- (void)setCellShowStyle:(CLPaymentInfoShowCellStyle)cellShowStyle
{
    _cellShowStyle = cellShowStyle;
    /** 分Style处理 */
    if (cellShowStyle == defaultPaymentShowStyle) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (cellShowStyle == noIconAndNoSelectedButtonDepositStyle){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}

- (NSString*)dealWithMoneyDotString:(double)accountMoney
{
    NSString* account = [NSString stringWithFormat:@"%.2f",accountMoney];
    NSRange dotRange = [account rangeOfString:@"."];
    NSMutableString* realAccount = [[account substringToIndex:dotRange.location] mutableCopy];
    NSMutableString* money = [[account substringFromIndex:dotRange.location + 1] mutableCopy];
    NSString* first_M = [money substringWithRange:NSMakeRange(0, 1)];
    NSString* scound_M = [money substringWithRange:NSMakeRange(1, 1)];
    if ([scound_M integerValue] == 0) {
        [money deleteCharactersInRange:NSMakeRange(1, 1)];
        if ([first_M integerValue] == 0) {
            [money deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    if (money.length > 0){
        [realAccount appendString:@"."];
    }
    [realAccount appendString:money];
    return realAccount;
}

#pragma mark - gettingMethod

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"", CQUserCashBankNameFont, NSTextAlignmentLeft, UIColorFromRGB(0x333333), CGRectZero);
    }
    return _itemLabel;
}

- (UILabel *)itemDescLabel
{
    if (!_itemDescLabel) {
        AllocNormalLabel(_itemDescLabel, @"", FONT_SCALE(11), NSTextAlignmentLeft, UIColorFromRGB(0x999999), CGRectZero);
        _itemDescLabel.numberOfLines = 0;
    }
    return _itemDescLabel;
}

- (CALayer *)botttomLayer
{
    if (!_botttomLayer) {
        _botttomLayer = [[CALayer alloc] init];
        _botttomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _botttomLayer.frame = __Rect(0, [CLPaymentInfoShowCell payMentInfoShowHeight] - .5f, SCREEN_WIDTH, .5f);
    }
    return _botttomLayer;
}

@end
