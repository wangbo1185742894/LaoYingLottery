//
//  CQUserBalanceHeaderView.m
//  caiqr
//
//  Created by 小铭 on 16/3/31.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUserBalanceHeaderView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"

#import "CQViewQuickAllocDef.h"
#import "CLAccountInfoModel.h"
//#import "CQUserInfoView.h"
//#import "CQUserCashBalanceInfo.h"
//#import "UILabel+CQAttributeLabel.h"
//#import "CQTools.h"
/**
 *  账户余额Strin
 */
NSString * const UserBalanceAmountText = @"账户余额:";
/**
 *  用户账户列表余额描述文案
 */
NSString * const UserBalanceDesLabelText = @"可用于消费或提现";
/**
 *   用户账户列表HeaderView按钮的title字体大小
 */
CGFloat const UserBalanceHeaderViewButtonTextFont = 14;

/**
 *  用户账户headerView
 */
@interface CQUserBalanceHeaderView()

@property (nonatomic, strong) UILabel *userBalanceLabel;    //用户余额摘要

@property (nonatomic, strong) UILabel *userBalanceDesLabel; //用户余额描述

@property (nonatomic, strong) CALayer *cutOffLayer; //分割线

@property (nonatomic, strong) CALayer *btnCutOffLayer;  //按钮分割线

@property (nonatomic, strong) CALayer *btnCutDOffLayer; //按钮分割线2

@property (nonatomic, strong) UIButton *depositButton;  //用户充值按钮

@property (nonatomic, strong) UIButton *withdrawButton; // 用户提现按钮

@property (nonatomic, strong) UIButton *conversionButton;   //兑换红包按钮

//@property (nonatomic, strong) CALayer *bottomLayer; //底部分割线

@end

@implementation CQUserBalanceHeaderView {
    
    CGFloat __viewScale;
}

+ (instancetype)createUserBalanceHeaderView:(id)userAccount actionBlock:(userBalanceHeaderViewActionBlock)actionBlock
{
    CQUserBalanceHeaderView *userBalanceHeaderView = [[CQUserBalanceHeaderView alloc] init];
    userBalanceHeaderView.clickActionBlock = actionBlock;
    [userBalanceHeaderView assignDataWithObject:userAccount];
    return userBalanceHeaderView;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        __viewScale = [UIScreen mainScreen].scale;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.userBalanceLabel];
        [self addSubview:self.userBalanceDesLabel];
        [self.layer addSublayer:self.cutOffLayer];
        [self addSubview:self.depositButton];
        [self.layer addSublayer:self.btnCutOffLayer];
        [self addSubview:self.withdrawButton];
        [self.layer addSublayer:self.btnCutDOffLayer];
        [self addSubview:self.conversionButton];
//        [self.layer addSublayer:self.bottomLayer];
        self.frame = CGRectMake(0, 0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.depositButton.bounds) + self.depositButton.frame.origin.y);
    }
    return self;
}

- (void)assignDataWithObject:(id)object
{
    CLAccountInfoModel *userCashInfo = (CLAccountInfoModel *)object;
    NSString *balanceInfoString = [NSString stringWithFormat:@"%@%@%@",UserBalanceAmountText, [self stringFromCash:userCashInfo.balance],userCashInfo.unit];
    [self.userBalanceLabel attributeWithText:balanceInfoString controParams:@[[AttributedTextParams attributeRange:[balanceInfoString rangeOfString:[self stringFromCash:userCashInfo.balance]] Color:THEME_COLOR Font:FONT_SCALE(22)],[AttributedTextParams attributeRange:[balanceInfoString rangeOfString:userCashInfo.unit] Color:UIColorFromRGB(0x333333) Font:FONT_SCALE(11)]]];
//    [CQTools cq_setImageSetWith:self.conversionButton.adImgView Url:[NSURL URLWithString:userCashInfo.img_url] placeholder:nil];
}

- (void)userBalanceHeaderViewActionClickWithStyle:(UIButton *)sender
{
    if (!self.clickActionBlock) return;
    if (sender == self.depositButton)
    {
//        NSLog(@"点击了充值按钮");
        self.clickActionBlock(userBalanceHeaderViewDepositClick);
    }
    else if (sender == self.withdrawButton)
    {
//        NSLog(@"点击了提现按钮");
        self.clickActionBlock(userBalanceHeaderViewWithdrawClick);
    }
    else if (sender == self.conversionButton)
    {
//        NSLog(@"点击了红包兑换按钮");
        self.clickActionBlock(userBalanceHeaderViewConversionClick);
    }
}

#pragma mark - cash to String

- (NSString*)stringFromCash:(double)cash {
    
    NSString* account = [NSString stringWithFormat:@"%.2f",cash];
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

#pragma mark - getter

- (UILabel *)userBalanceLabel
{
    if (!_userBalanceLabel) {
        _userBalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, __SCALE(10), SCREEN_WIDTH - 20.f,__SCALE(20))];
        _userBalanceLabel.font = FONT_SCALE(UserBalanceHeaderViewButtonTextFont);
        _userBalanceLabel.textColor = UIColorFromRGB(0x333333);
        _userBalanceLabel.backgroundColor = [UIColor clearColor];
    }
    return _userBalanceLabel;
}

- (UILabel *)userBalanceDesLabel
{
    if (!_userBalanceDesLabel) {
        _userBalanceDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.userBalanceLabel.frame.origin.x, self.userBalanceLabel.frame.origin.y + CGRectGetHeight(self.userBalanceLabel.bounds) + __SCALE(10), CGRectGetWidth(self.userBalanceLabel.bounds), CGRectGetHeight(self.userBalanceLabel.bounds))];
        _userBalanceDesLabel.text = UserBalanceDesLabelText;
        _userBalanceDesLabel.font = FONT_SCALE(11);
        _userBalanceDesLabel.textColor = UIColorFromRGB(0x999999);
        _userBalanceDesLabel.backgroundColor = [UIColor clearColor];
    }
    return _userBalanceDesLabel;
}

- (CALayer *)cutOffLayer
{
    if (!_cutOffLayer) {
        _cutOffLayer = [[CALayer alloc] init];
        _cutOffLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _cutOffLayer.frame = __Rect(0, __Obj_YH_Value(self.userBalanceDesLabel) + __SCALE(10), SCREEN_WIDTH, .5f);
    }
    return _cutOffLayer;
}

- (UIButton *)depositButton
{
    if (!_depositButton) {
        _depositButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _depositButton.frame = __Rect(0, __Obj_YH_Value(self.cutOffLayer), (SCREEN_WIDTH - 1 * 2) / 3, 40.f);
        [_depositButton setTitle:@"充值" forState:UIControlStateNormal];
        [_depositButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _depositButton.titleLabel.font = FONT_SCALE(UserBalanceHeaderViewButtonTextFont);
        [_depositButton addTarget:self action:@selector(userBalanceHeaderViewActionClickWithStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _depositButton;
}

- (CALayer *)btnCutOffLayer
{
    if (!_btnCutOffLayer) {
        _btnCutOffLayer = [[CALayer alloc] init];
        _btnCutOffLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _btnCutOffLayer.frame = __Rect(__Obj_XW_Value(self.depositButton), __Obj_Frame_Y(self.depositButton) + __Obj_Bounds_Height(_depositButton) / 4, 1.f, __Obj_Bounds_Height(self.depositButton) * .5f);
    }
    return _btnCutOffLayer;
}

- (UIButton *)withdrawButton
{
    if (!_withdrawButton) {
        _withdrawButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _withdrawButton.frame = __Rect(__Obj_XW_Value(self.btnCutOffLayer), __Obj_Frame_Y(self.depositButton), __Obj_Bounds_Width(self.depositButton), __Obj_Bounds_Height(self.depositButton));
        [_withdrawButton setTitle:@"提现" forState:UIControlStateNormal];
        [_withdrawButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        _withdrawButton.titleLabel.font = FONT_SCALE(UserBalanceHeaderViewButtonTextFont);
        [_withdrawButton addTarget:self action:@selector(userBalanceHeaderViewActionClickWithStyle:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _withdrawButton;
}

- (CALayer *)btnCutDOffLayer
{
    if (!_btnCutDOffLayer) {
        _btnCutDOffLayer = [[CALayer alloc] init];
        _btnCutDOffLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _btnCutDOffLayer.frame = __Rect(__Obj_XW_Value(self.withdrawButton), __Obj_Frame_Y(self.depositButton) + __Obj_Bounds_Height(_depositButton) / 4, 1.f, __Obj_Bounds_Height(self.depositButton) * .5f);
    }
    return _btnCutDOffLayer;
}

- (UIButton *)conversionButton
{
    if (!_conversionButton) {
        _conversionButton = [[UIButton alloc] initWithFrame:__Rect(__Obj_XW_Value(self.btnCutDOffLayer), __Obj_Frame_Y(self.depositButton), __Obj_Bounds_Width(self.depositButton), __Obj_Bounds_Height(self.depositButton))];
        [_conversionButton setTitle:@"购买红包" forState:UIControlStateNormal];
        _conversionButton.titleLabel.font = FONT_SCALE(UserBalanceHeaderViewButtonTextFont);
        [_conversionButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_conversionButton addTarget:self action:@selector(userBalanceHeaderViewActionClickWithStyle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conversionButton;
}
//
//- (CALayer *)bottomLayer
//{
//    if (!_bottomLayer) {
//        _bottomLayer = [[CALayer alloc] init];
//        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
//        _bottomLayer.frame = __Rect(0, __Obj_YH_Value(self.withdrawButton), SCREEN_WIDTH, .5f);
//    }
//    return _bottomLayer;
//}




@end

