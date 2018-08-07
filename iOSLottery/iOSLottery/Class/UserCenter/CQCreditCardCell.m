//
//  CQCreditCardCell.m
//  caiqr
//
//  Created by 彩球 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQCreditCardCell.h"
#import "CLConfigMessage.h"
#import "UIImageView+CQWebImage.h"

#define CQCreidtCardWidth SCREEN_WIDTH - 2 * 10.f

@interface CQCreditCardCell ()

@property (nonatomic, strong) UIImageView* bankIconImgView;
@property (nonatomic, strong) UILabel* bankCardNoLbl;
@property (nonatomic, strong) UILabel* bankNameLbl;
@property (nonatomic, strong) UIImageView* selectImgView;
@property (nonatomic, strong) CALayer* underLineLayer;

@property (nonatomic, strong) UIView *cardListBackView;
@property (nonatomic, strong) UILabel *cardListCardLabel;

@property (nonatomic, strong) UILabel* bankCardUsuallyFlag;

@end


@implementation CQCreditCardCell

+ (CGFloat)heightOfCreditCardCell
{
    return __SCALE(60.f);
}

+ (CGFloat)heightOfCreditListCardCellHeight
{
    return __SCALE(90.f);
}

+ (CQCreditCardCell*)initWithTableView:(UITableView*)tableView mode:(creditCardMode)mode
{
    CQCreditCardCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CQCreditCardCellId"];
    if (!cell) {
        cell = [[CQCreditCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CQCreditCardCell"];
    }
    cell.mode = mode;
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = CLEARCOLOR;
        [self.contentView addSubview:self.cardListBackView];
        
    }
    return self;
}

#pragma mark - setter

- (void)setMode:(creditCardMode)mode
{
    _mode = mode;
    if (creditCardModeNormal == mode) {
        self.bankCardNoLbl.hidden = NO;
        self.cardListBackView.frame = __Rect(10, __SCALE(10.f), CQCreidtCardWidth, [CQCreditCardCell heightOfCreditCardCell] + __Obj_Bounds_Height(self.cardListCardLabel) + __SCALE(2));
        self.bankNameLbl.frame = __Rect(__Obj_Frame_X(self.bankCardNoLbl), __Obj_YH_Value(self.bankCardNoLbl), __Obj_Bounds_Width(self.bankCardNoLbl), __Obj_Bounds_Height(self.bankCardNoLbl));
        self.bankNameLbl.textColor = UIColorFromRGB(0x999999);
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cardListBackView.clipsToBounds = YES;
        self.cardListBackView.layer.cornerRadius = 5.f;
        self.cardListBackView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        self.cardListBackView.layer.borderWidth = .5f;
        self.selectImgView.hidden = YES;
        self.underLineLayer.hidden = YES;
        self.cardListCardLabel.hidden = NO;
    } else if (creditCardModeSelect == mode) {
        self.bankCardNoLbl.hidden = NO;
        self.cardListBackView.frame = __Rect(0, 0, SCREEN_WIDTH, [CQCreditCardCell heightOfCreditCardCell]);
        self.bankNameLbl.frame = __Rect(__Obj_Frame_X(self.bankCardNoLbl), __Obj_YH_Value(self.bankCardNoLbl), __Obj_Bounds_Width(self.bankCardNoLbl), __Obj_Bounds_Height(self.bankCardNoLbl));
        self.bankNameLbl.textColor = UIColorFromRGB(0xd80000);
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectImgView.hidden = NO;
        self.cardListCardLabel.hidden = YES;
        self.underLineLayer.hidden = NO;
    } else if (creditCardModeOnlyTextSelect == mode) {
        self.bankCardNoLbl.hidden = YES;
        self.cardListBackView.frame = __Rect(0, 0, SCREEN_WIDTH, [CQCreditCardCell heightOfCreditCardCell]);
        self.bankNameLbl.frame = __Rect(__Obj_Frame_X(self.bankCardNoLbl), 0, __Obj_Bounds_Width(self.bankCardNoLbl),[CQCreditCardCell heightOfCreditCardCell]);
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectImgView.hidden = NO;
        self.cardListCardLabel.hidden = YES;
        self.underLineLayer.hidden = NO;
    }
}

- (void)setCellSelectState:(BOOL)cellSelectState
{
    if (creditCardModeSelect == self.mode ||
        creditCardModeOnlyTextSelect == self.mode) {
        self.selectImgView.image = [UIImage imageNamed:cellSelectState?@"accountSel_YES":@"accountSel_NO"];
    }
}

- (void)setBankIconUrl:(NSString *)bankIconUrl
{
    [self.bankIconImgView setImageWithURL:[NSURL URLWithString:bankIconUrl]];
    
/*    if (![bankIconUrl isKindOfClass:[NSString class]] || bankIconUrl.length == 0) {
//        self.bankIconLayer.masksToBounds = NO;
        self.withdrawRedImage = [UIImage imageNamed:@"withdrawToRed"];
    }else{
//        self.bankIconLayer.masksToBounds = YES;
//        [self.bankIconLayer setImgUrl:bankIconUrl defaultImage:nil];
    }
  */
}

- (void)setBankCardCode:(NSString *)bankCardCode
{
    self.bankCardNoLbl.text = bankCardCode;
}

- (void)setBankName:(NSString *)bankName
{
    self.bankNameLbl.text = bankName;
}

- (void)setWithdrawRedImage:(UIImage *)withdrawRedImage
{
    self.bankIconImgView.image = withdrawRedImage;
}

- (void)setCardListCardCode:(NSString *)cardListCardCode
{
    self.cardListCardLabel.text = cardListCardCode;
}

- (void)setBankNameColor:(UIColor *)bankNameColor
{
    self.bankNameLbl.textColor = bankNameColor;
}

- (void)setShowUsuallyBankCard:(BOOL)showUsuallyBankCard
{
    self.bankCardUsuallyFlag.hidden = !showUsuallyBankCard;
}

#pragma mark - getter

- (UIView *)cardListBackView
{
    if (!_cardListBackView) {
        _cardListBackView = [[UIView alloc] init];
        _cardListBackView.backgroundColor = UIColorFromRGB(0xffffff);
        _cardListBackView.frame = __Rect(0, 0, CQCreidtCardWidth, [CQCreditCardCell heightOfCreditCardCell]);
        [_cardListBackView addSubview:self.bankIconImgView];
        [_cardListBackView addSubview:self.selectImgView];
        [_cardListBackView addSubview:self.bankCardUsuallyFlag];
        [_cardListBackView addSubview:self.bankCardNoLbl];
        [_cardListBackView addSubview:self.bankNameLbl];
        [_cardListBackView.layer addSublayer:self.underLineLayer];
        [_cardListBackView addSubview:self.cardListCardLabel];
    }
    return _cardListBackView;
}

- (UIImageView *)bankIconImgView
{
    if (!_bankIconImgView) {
        CGFloat height = [CQCreditCardCell heightOfCreditCardCell] / 3.f * 2.f;
        _bankIconImgView = [[UIImageView alloc] init];
        _bankIconImgView.frame =  __Rect(10.f, ([CQCreditCardCell heightOfCreditCardCell] - height) / 2.f, height, height);
        _bankIconImgView.backgroundColor = CLEARCOLOR;
    }
    return _bankIconImgView;
}

- (UIImageView *)selectImgView
{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:__Rect(SCREEN_WIDTH - 30.f, ([CQCreditCardCell heightOfCreditCardCell] - 20.f) / 2.f, 20.f, 20.f)];
    }
    return _selectImgView;
}

- (UILabel *)bankCardUsuallyFlag
{
    if (!_bankCardUsuallyFlag) {
        AllocNormalLabel(_bankCardUsuallyFlag, @"常用", FONT_FIX(12), NSTextAlignmentRight, UIColorFromRGB(0x999999), __Rect(__Obj_Frame_X(self.selectImgView) - __SCALE(60.f) - 5.f, __Obj_Frame_Y(self.selectImgView), __SCALE(60.f), 20.f))
        _bankCardUsuallyFlag.hidden = YES;
    }
    return _bankCardUsuallyFlag;
}

- (UILabel *)bankCardNoLbl
{
    if (!_bankCardNoLbl) {
        AllocNormalLabel(_bankCardNoLbl, @"", FONT_SCALE(14.f), NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect(__Obj_XW_Value(self.bankIconImgView) + 10.f, 10.f, __Obj_Frame_X(self.selectImgView) - __Obj_XW_Value(self.bankIconImgView) - 10.f, ([CQCreditCardCell heightOfCreditCardCell] - 20.f) / 2.f))
    }
    return _bankCardNoLbl;
}

- (UILabel *)bankNameLbl
{
    if (!_bankNameLbl) {
        AllocNormalLabel(_bankNameLbl, @"", FONT_SCALE(13.f), self.bankCardNoLbl.textAlignment, self.bankCardNoLbl.textColor, __Rect(__Obj_Frame_X(self.bankCardNoLbl), __Obj_YH_Value(self.bankCardNoLbl), __Obj_Bounds_Width(self.bankCardNoLbl), __Obj_Bounds_Height(self.bankCardNoLbl)))
    }
    return _bankNameLbl;
}

- (UILabel *)cardListCardLabel
{
    if (!_cardListCardLabel) {
        
        AllocNormalLabel(_cardListCardLabel, @"", [UIFont boldSystemFontOfSize:__SCALE_HALE(17)], NSTextAlignmentRight, UIColorFromRGB(0x333333), __Rect(__Obj_Frame_X(self.bankCardNoLbl), __Obj_YH_Value(self.bankNameLbl) + __SCALE(2.f), __Obj_Bounds_Width(self.bankNameLbl), __SCALE(18)));
    }
    return _cardListCardLabel;
}

- (CALayer *)underLineLayer
{
    if (!_underLineLayer) {
        _underLineLayer = [CALayer layer];
        _underLineLayer.frame = __Rect(0, [CQCreditCardCell heightOfCreditCardCell] - .5f, SCREEN_WIDTH, .5f);
        _underLineLayer.backgroundColor = UIColorFromRGB(0xeeeeee).CGColor;
    }
    return _underLineLayer;
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
