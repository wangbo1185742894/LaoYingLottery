//
//  CLFTThreeDifferentBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeDifferentBetView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTBetButtonView.h"
#import "CLFTImageLabel.h"
#import "CLFTThreeDifferentBetInfo.h"
#import "CLFTThreeDifferentAllBetInfo.h"
#import "CLDiceAnimationView.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UILabel+CLAttributeLabel.h"
#import "UIImageView+CQWebImage.h"
@interface CLFTThreeDifferentBetView () <CLDiceAnimationProtocol>{
    
    NSInteger __firstDiceNumber;//随机骰子数
    NSInteger __secondDiceNumber;
    NSInteger __thirdDiceNumber;
    BOOL __allowAnimation; //是否允许动画
}
@property (nonatomic, strong) UIButton *shakeButton;//摇一摇按钮
@property (nonatomic, strong) CLTwoImageButton *activityButton;//活动按钮
@property (nonatomic, strong) CLFTImageLabel *threeDifferentLabel;//三不同号
@property (nonatomic, strong) UILabel *threeDifferentInfoLabel;//三不同号说明label

@property (nonatomic, strong) CLFTImageLabel *threeContinuousLabel;//三连号
@property (nonatomic, strong) UILabel *threeContinuousInfoLabel;//三连号说明label
@property (nonatomic, strong) CLFTBetButtonView *allSelectedBetView;//通选
@property (nonatomic, strong) NSMutableArray *betButtonArray;//按钮数组

@property (nonatomic, strong) CLDiceAnimationView *animationView;

@property (nonatomic, strong) NSMutableArray *omissionArray;

@property (nonatomic, strong) NSString *activityUrl;
@end

@implementation CLFTThreeDifferentBetView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        [self assginSubView];
        __allowAnimation = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRandomDice) name:shake_diffThree object:nil];
    }
    return self;
}
#pragma mark ------ 摇一摇动画delegate ------
- (void)diceAnimationDidStop{
    
    __allowAnimation = YES;
    self.animationView.hidden = YES;
    [self sendSubviewToBack:self.animationView];
    for (CLFTBetButtonView *betButton in self.betButtonArray) {
        if (betButton.tag == __firstDiceNumber) {
            betButton.is_Selected = YES;
        }
        if (betButton.tag == __secondDiceNumber) {
            betButton.is_Selected = YES;
        }
        if (betButton.tag == __thirdDiceNumber) {
            betButton.is_Selected = YES;
        }
    }
}
#pragma mark ------ delegate ------
- (void)assignUIWithData:(id)data{
    
    if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeThreeDifferent) {
        CLFTThreeDifferentBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.threeDifferentBetArray) {
            for (CLFTBetButtonView *betButton in self.betButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue]) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }else if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeThreeDifferentContinuous){
        CLFTThreeDifferentAllBetInfo *selectBetInfo = data;
        if (selectBetInfo.betNote > 0) {
            self.allSelectedBetView.is_Selected = YES;
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBetButton{
    
    for (CLFTBetButtonView *betView in self.betButtonArray) {
        betView.is_Selected = NO;
    }
    self.allSelectedBetView.is_Selected = NO;
}
#pragma mark - 刷新奖金
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo{
    
    self.threeDifferentInfoLabel.text = [NSString stringWithFormat:@"选3个不同号码，与开奖相同即中%zi元", bonusInfo.bonus_threeDiff];
    self.threeContinuousInfoLabel.text = [NSString stringWithFormat:@"123/234/345/456/任意开出即中%zi元", bonusInfo.bonus_threeDiffAll];
    self.betInfo.bonus = bonusInfo.bonus_threeDiff;
    self.allBetInfo.bonus = bonusInfo.bonus_threeDiffAll;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return ((self.betInfo.threeDifferentBetArray.count + self.allBetInfo.threeDifferentAllArray.count) > 0);
}
#pragma mark - 配置遗漏
- (void)setOmissionWithData:(NSArray *)omission{
    
    for (NSInteger i = 0; i < omission.count; i++) {
        
        UILabel *label = self.omissionArray[i];
        NSString *omissionStr = omission[i];
        if ([omissionStr rangeOfString:@"^"].location != NSNotFound) {
            
            label.text =  [omissionStr stringByReplacingOccurrencesOfString:@"^" withString:@""];
            label.textColor = UIColorFromRGB(0xffff00);
        }else{
            label.textColor = UIColorFromRGB(0x8eeacc);
            label.text = omissionStr;
        }
    }
}
#pragma mark - 配置默认遗漏
- (void)setDefaultOmission{
    
    for (UILabel *label in self.omissionArray) {
        label.text = @"-";
        label.textColor = UIColorFromRGB(0x8eeacc);
    }
}
#pragma mark - 配置活动链接
- (void)assignActicityLink:(id)data{
    
    CLLotteryActivitiesModel *model = data;
    if (model.activityImgUrl && model.activityImgUrl.length > 0) {
        
        if ([model.activityImgUrl hasPrefix:@"http"]) {
            
            [self.activityButton.mainImageView setImageWithURL:[NSURL URLWithString:model.activityImgUrl]];
            [self.activityButton setTitle:@"" forState:UIControlStateNormal];
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self).offset(__SCALE(0.f));
                make.right.equalTo(self);
                make.height.equalTo(self.activityButton.mas_width).multipliedBy(11.0 / 26);
                make.width.mas_equalTo(__SCALE(130.f));
            }];
            [self.activityButton assignMianImageViewHidden:NO];
        }else{
            [self.activityButton setTitle:model.activityImgUrl forState:UIControlStateNormal];
            
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(self.shakeButton);
                make.right.equalTo(self).offset(__SCALE(-20.f));
            }];
            [self.activityButton assignMianImageViewHidden:YES];
        }
        self.activityUrl = model.activityUrl;
        self.activityButton.hidden = NO;
    }else{
        self.activityButton.hidden = YES;
    }
    
}
#pragma mark - 配置奖金信息
- (void)assignBonusInfo:(NSArray *)bonusInfo{
    
    if (bonusInfo && bonusInfo.count == 25) {
        
        [self.threeDifferentInfoLabel attributeWithText:bonusInfo[20] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
        [self.threeContinuousInfoLabel attributeWithText:bonusInfo[21] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.animationView];
    [self addSubview:self.shakeButton];
    [self addSubview:self.threeDifferentLabel];
    [self addSubview:self.threeDifferentInfoLabel];
    [self addSubview:self.threeContinuousLabel];
    [self addSubview:self.threeContinuousInfoLabel];
    [self addSubview:self.allSelectedBetView];
    [self addSubview:self.activityButton];
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.shakeButton);
        make.right.equalTo(self).offset(__SCALE(-20.f));
    }];
    [self.threeDifferentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(20.f));
        make.width.mas_equalTo(__SCALE(70.f));
    }];
    [self.threeDifferentInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeDifferentLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.centerY.equalTo(self.threeDifferentLabel);
    }];
    [self.allSelectedBetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.threeContinuousLabel.mas_bottom).offset(__SCALE(20.f));
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.right.equalTo(self).offset(__SCALE(- 10.f));
    }];
    //添加 三不同号投注按钮
    [self addThreeDifferentNumberBetView];

}
- (void)addThreeDifferentNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    UILabel *lastLabel = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.betTerm = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.tag = i + 1;
        [self.betButtonArray addObject:betButton];
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf selectedBetButton:betButton];
        };
        [self addSubview:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.threeDifferentLabel.mas_bottom).offset(__SCALE(10.f));
            
            if (lastSizeBetButton) {
                make.left.equalTo(lastSizeBetButton.mas_right).offset(__SCALE(MAINBETBUTTONDISTANCE));
            }else{
                make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
            }
            
            if (lastSizeBetButton) {
                make.width.equalTo(lastSizeBetButton);
            }
            make.height.equalTo(betButton.mas_width).multipliedBy(0.84);
        }];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x8eeacc);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        if (i == 0) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"遗漏" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x8eeacc) forState:UIControlStateNormal];
            button.titleLabel.font = FONT_SCALE(11.f);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(showOmissionAlert) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(betButton);
                make.centerY.equalTo(label);
//                make.width.mas_equalTo(__SCALE(30.f));
            }];
            label.textAlignment = NSTextAlignmentLeft;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(button.mas_right).offset(3.f);
//                make.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom);
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }
        [self.omissionArray addObject:label];
        lastLabel = label;
        lastSizeBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastSizeBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
    }];
    //添加 三连号 约束
    [self.threeContinuousLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(45.f));
        make.left.equalTo(self);
        make.width.mas_equalTo(__SCALE(65));
    }];
    [self.threeContinuousInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeContinuousLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.centerY.equalTo(self.threeContinuousLabel);
    }];
    [self.allSelectedBetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(lastSizeBetButton);
    }];
    //创建遗漏lebal
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"-";
    label.font = FONT_SCALE(13);
    label.textColor = UIColorFromRGB(0x8eeacc);
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"遗漏" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x8eeacc) forState:UIControlStateNormal];
    button.titleLabel.font = FONT_SCALE(11.f);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [button addTarget:self action:@selector(showOmissionAlert) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.allSelectedBetView);
        make.centerY.equalTo(label);
//        make.width.mas_equalTo(__SCALE(30.f));
    }];
    label.textAlignment = NSTextAlignmentLeft;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(button.mas_right).offset(0.f);
//        make.right.equalTo(self.allSelectedBetView);
        make.top.equalTo(self.allSelectedBetView.mas_bottom).offset(__SCALE(0.f));
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.omissionArray addObject:label];
}
#pragma mark - 返回投注项的注数 奖金
- (void)callBackNoteAndBetBonus{
    
    NSInteger note = self.betInfo.betNote + self.allBetInfo.betNote;
    //最小奖金
    NSInteger minBonus = 0;
    if (self.allBetInfo.minBetBonus > 0) {
        minBonus = self.allBetInfo.minBetBonus;
    }else{
        minBonus = self.betInfo.minBetBonus;
    }
    if (self.betInfo.threeDifferentBetArray.count == 6) {
        minBonus = 40;
    }
    //最大奖金
    NSInteger maxBonus = 0;
    //判断 单选投注项是否是连号  如果是连号则 单选中 则三连号必中  如果不是连号 则单选和 三连号不会同时中
    if ([self hasContinuousNumber]) {
        maxBonus = self.betInfo.MaxBetBonus + self.allBetInfo.MaxBetBonus;
    }else{
        maxBonus = MAX(self.betInfo.MaxBetBonus, self.allBetInfo.MaxBetBonus);
    }
    self.threeDifferentBetBonusAndNotesBlock ? self.threeDifferentBetBonusAndNotesBlock(note, minBonus, maxBonus) : nil;
}
- (BOOL)hasContinuousNumber{
    
    //123  234  345  456
    
    if ([self.betInfo.threeDifferentBetArray containsObject:@"1"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"2"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"3"]) {
        return YES;
    }
    
    if ([self.betInfo.threeDifferentBetArray containsObject:@"2"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"3"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"4"]) {
        return YES;
    }
    
    if ([self.betInfo.threeDifferentBetArray containsObject:@"3"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"4"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"5"]) {
        return YES;
    }
    
    if ([self.betInfo.threeDifferentBetArray containsObject:@"4"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"5"] &&
        [self.betInfo.threeDifferentBetArray containsObject:@"6"]) {
        return YES;
    }
    
    return NO;
}
#pragma mark - 配置随机色子动画
- (void)configRandomDice{
    
    if (__allowAnimation) {
        __allowAnimation = NO;
        self.animationView.hidden = NO;
        [self bringSubviewToFront:self.animationView];
        __firstDiceNumber = arc4random() % 6 + 1;
        for (NSInteger i = 0; i < 100; i++) {
            __secondDiceNumber = arc4random() % 6 + 1;
            if (__firstDiceNumber != __secondDiceNumber) {
                break;
            }
        }
        for (NSInteger i = 0; i < 100; i++) {
            __thirdDiceNumber = arc4random() % 6 + 1;
            if ((__firstDiceNumber != __thirdDiceNumber) && (__thirdDiceNumber != __secondDiceNumber)) {
                break;
            }
        }
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            if (betButton.tag == __firstDiceNumber) {
                [pointArray addObject:[NSValue valueWithCGPoint:betButton.center]];
            }
        }
        [self clearAllBetButton];
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            
            if (betButton.tag == __secondDiceNumber) {
                [pointArray addObject:[NSValue valueWithCGPoint:betButton.center]];
            }
        }
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            
            if (betButton.tag == __thirdDiceNumber) {
                [pointArray addObject:[NSValue valueWithCGPoint:betButton.center]];
            }
        }
        [numberArray addObjectsFromArray:@[[NSString stringWithFormat:@"%zi", __firstDiceNumber], [NSString stringWithFormat:@"%zi", __secondDiceNumber], [NSString stringWithFormat:@"%zi", __thirdDiceNumber]]];
        self.animationView.diceFinishPointArray = pointArray;
        self.animationView.diceNumberArray = numberArray;
        [self.animationView startShakeDiceAnimation];
    }
}
#pragma mark ------ event Response ------
#pragma mark - 点击了摇一摇
- (void)shakeButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了摇一摇");
    [self configRandomDice];
}
#pragma mark - 投注按钮的选中态改变
- (void)selectedBetButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.betInfo addBetTerm:betButton.betTerm];
    }else{
        [self.betInfo removeBetTerm:betButton.betTerm];
    }
    [self callBackNoteAndBetBonus];
}
- (void)selectedAllBetButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.allBetInfo addBetTerm:betButton.betTerm];
    }else{
        [self.allBetInfo removeBetTerm:betButton.betTerm];
    }
    [self callBackNoteAndBetBonus];
}
- (void)showOmissionAlert{
    
    [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeKuaiSan];
}

- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    
    //如果当前显示的是和值 则需要向外传递 奖金 来更改底部视图的奖金
    if (!hidden) {
        //获取投注项的金额
        [self callBackNoteAndBetBonus];
    }
}
#pragma mark ------ getter Mothed ------
- (UIButton *)shakeButton{
    
    if (!_shakeButton) {
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"ft_shakeImages.png"] forState:UIControlStateNormal];
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shakeButton;
}
- (CLTwoImageButton *)activityButton{
    
    if (!_activityButton) {
        _activityButton = [[CLTwoImageButton alloc] init];
        _activityButton.hidden = YES;
//        [_activityButton setTitle:@"史无前例大加奖" forState:UIControlStateNormal];
        [_activityButton setTitleColor:UIColorFromRGB(0xa4e800) forState:UIControlStateNormal];
        _activityButton.titleLabel.font = FONT_SCALE(14);
        _activityButton.leftImage = [UIImage imageNamed:@"ft_star.png"];
        _activityButton.rightImage = [UIImage imageNamed:@"ft_arrow.png"];
        [_activityButton addTarget:self action:@selector(activityButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _activityButton;
}
- (CLFTImageLabel *)threeDifferentLabel{
    
    if (!_threeDifferentLabel) {
        _threeDifferentLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _threeDifferentLabel.contentString = @"三不同号";
        _threeDifferentLabel.backImage = [UIImage imageNamed:@"ft_playMothedTagLong.png"];
    }
    return _threeDifferentLabel;
}
- (UILabel *)threeDifferentInfoLabel{
    
    if (!_threeDifferentInfoLabel) {
        _threeDifferentInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _threeDifferentInfoLabel.text = @"选3个不同号码，与开奖相同即中40元";
        _threeDifferentInfoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _threeDifferentInfoLabel.font = FONT_SCALE(13);
        _threeDifferentInfoLabel.numberOfLines = 0;
    }
    
    return _threeDifferentInfoLabel;
}
- (CLFTImageLabel *)threeContinuousLabel{
    
    if (!_threeContinuousLabel) {
        _threeContinuousLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _threeContinuousLabel.contentString = @"三连号";
        _threeContinuousLabel.backImage = [UIImage imageNamed:@"ft_playMothedTagLong.png"];
    }
    return _threeContinuousLabel;
}
- (UILabel *)threeContinuousInfoLabel{
    
    if (!_threeContinuousInfoLabel) {
        _threeContinuousInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _threeContinuousInfoLabel.text = @"123/234/345/456/任意开出即中10元";
        _threeContinuousInfoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _threeContinuousInfoLabel.font = FONT_SCALE(13);
        _threeContinuousInfoLabel.numberOfLines = 0;
    }
    return _threeContinuousInfoLabel;
}
- (CLFTBetButtonView *)allSelectedBetView{
    WS(_weakSelf)
    if (!_allSelectedBetView) {
        _allSelectedBetView = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        _allSelectedBetView.betNumber = @"三连号通选";
        _allSelectedBetView.betTerm = @"三连号通选";
        _allSelectedBetView.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf selectedAllBetButton:betButton];
        };
    }
    return _allSelectedBetView;
}
- (NSMutableArray *)betButtonArray{
    
    if (!_betButtonArray) {
        _betButtonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _betButtonArray;
}
- (NSMutableArray *)omissionArray{
    
    if (!_omissionArray) {
        _omissionArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _omissionArray;
}
- (CLFTThreeDifferentBetInfo *)betInfo{
    
    if (!_betInfo) {
        _betInfo = [[CLFTThreeDifferentBetInfo alloc] init];
    }
    return _betInfo;
}
- (CLFTThreeDifferentAllBetInfo *)allBetInfo{
    
    if (!_allBetInfo) {
        _allBetInfo = [[CLFTThreeDifferentAllBetInfo alloc] init];
    }
    return _allBetInfo;
}
- (CLDiceAnimationView *)animationView{
    
    if (!_animationView) {
        _animationView = [[CLDiceAnimationView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT)];
        _animationView.delegate = self;
        _animationView.hidden = YES;
    }
    return _animationView;
}
@end
