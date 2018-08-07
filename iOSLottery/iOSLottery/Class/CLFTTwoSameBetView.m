//
//  CLFTTwoSameBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTTwoSameBetView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTBetButtonView.h"
#import "CLFTImageLabel.h"
#import "CLFTTwoSameSingleBetInfo.h"
#import "CLFTTwoSameDoubleBetInfo.h"
#import "CLDiceAnimationView.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UILabel+CLAttributeLabel.h"
#import "UIImageView+CQWebImage.h"
#define SAMENUMBETVIEWTAG 10 //同号tag
#define DOUBLEBETVIEWTAG 100// 复选tag

@interface CLFTTwoSameBetView ()<CLDiceAnimationProtocol>{
    
    NSInteger __SameNumber ;//同号
    NSInteger __SingleNumber; //单号
    BOOL __allowAnimation;//是否允许动画
}

@property (nonatomic, strong) UIButton *shakeButton;//摇一摇按钮
@property (nonatomic, strong) UILabel *infoBetLabel;//猜对子号
@property (nonatomic, strong) CLFTImageLabel *singleLabel;//单选
@property (nonatomic, strong) UILabel *singleInfoLabel;//单选说明label

@property (nonatomic, strong) UILabel *sameNumberLabel;//同号
@property (nonatomic, strong) UILabel *differentNumberLabel;//不同号

@property (nonatomic, strong) CLFTImageLabel *doubleLabel;//复选
@property (nonatomic, strong) UILabel *doubleInfoLabel;//复选说明label

@property (nonatomic, strong) NSMutableArray *betViewButtonArray;//所有选项的数组
@property (nonatomic, strong) CLDiceAnimationView *animationView;//摇一摇动画

@property (nonatomic, strong) NSMutableArray *omissionArray;

@property (nonatomic, strong) CLTwoImageButton *activityButton;//活动按钮

@property (nonatomic, strong) NSString *activityUrl;

@end

@implementation CLFTTwoSameBetView

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRandomDice) name:shake_sameTwo object:nil];
    }
    return self;
}

#pragma mark ------ 摇一摇动画 delegete ------
- (void)diceAnimationDidStop{
    
    __allowAnimation = YES;
    self.animationView.hidden = YES;
    [self sendSubviewToBack:self.animationView];
    for (CLFTBetButtonView *betButton in self.betViewButtonArray) {
        if (betButton.tag == __SameNumber + SAMENUMBETVIEWTAG) {
            betButton.is_Selected = YES;
        }
        if (betButton.tag == __SingleNumber) {
            betButton.is_Selected = YES;
        }
    }
}
#pragma mark ------ delegate ------
#pragma mark - 清空所有选项
- (void)clearAllBetButton{
    
    for (CLFTBetButtonView *betView in self.betViewButtonArray) {
        betView.is_Selected = NO;
    }
}
- (void)assignUIWithData:(id)data{
    
    if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeTwoSameSingle) {
        CLFTTwoSameSingleBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.sameNumberBetArray) {
            for (CLFTBetButtonView *betButton in self.betViewButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue] + SAMENUMBETVIEWTAG) {
                    betButton.is_Selected = YES;
                }
            }
        }
        for (NSString *betTerm in selectBetInfo.singleBetArray) {
            for (CLFTBetButtonView *betButton in self.betViewButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue]) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }else if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeTwoSameDouble){
        CLFTTwoSameDoubleBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.twoSameDoubleBetArray) {
            for (CLFTBetButtonView *betButton in self.betViewButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue] + DOUBLEBETVIEWTAG) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }
}
#pragma mark - 刷新奖金
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo{
    
    self.singleInfoLabel.text = [NSString stringWithFormat:@"选择同号和不同号的组合，奖金%zi元", bonusInfo.bonus_twoSameSingle];
    self.doubleInfoLabel.text = [NSString stringWithFormat:@"猜开奖中2个指定的相同号码，奖金%zi元", bonusInfo.bonus_twoSameDouble];
    self.singleBetInfo.bonus = bonusInfo.bonus_twoSameSingle;
    self.doubleBetInfo.bonus = bonusInfo.bonus_twoSameDouble;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return ((self.singleBetInfo.singleBetArray.count + self.singleBetInfo.sameNumberBetArray.count + self.doubleBetInfo.twoSameDoubleBetArray.count) > 0);
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
        
        [self.singleInfoLabel attributeWithText:bonusInfo[18] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
        [self.doubleInfoLabel attributeWithText:bonusInfo[19] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.animationView];
    [self addSubview:self.shakeButton];
    [self addSubview:self.infoBetLabel];
    [self addSubview:self.singleLabel];
    [self addSubview:self.singleInfoLabel];
    [self addSubview:self.sameNumberLabel];
    [self addSubview:self.differentNumberLabel];
    [self addSubview:self.doubleLabel];
    [self addSubview:self.doubleInfoLabel];
    [self addSubview:self.activityButton];
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(0));
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.shakeButton);
        make.right.equalTo(self).offset(__SCALE(-20.f));
    }];
    
    [self.infoBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(15.f));
    }];
    [self.singleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.infoBetLabel.mas_bottom).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(50));
    }];
    [self.singleInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.singleLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.centerY.equalTo(self.singleLabel);
    }];
    [self.sameNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.singleLabel.mas_bottom).offset(__SCALE(12.f));
        make.centerX.equalTo(self);
    }];
    //添加 同号投注按钮
    [self addSameNumberBetView];
    //添加 不同号 投注按钮
    [self addDifferentNumberBetView];
    //添加 复选投注按钮
    [self addDoubleNumberBetView];
}
- (void)addSameNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    UILabel *lastLabel = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi%zi", i + 1, i + 1];
        betButton.tag = (i + 1) + SAMENUMBETVIEWTAG;
        betButton.betTerm = [NSString stringWithFormat:@"%zi%zi", i + 1, i + 1];
        betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf betButtonOnClick:betButton];
        };
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf selectSingleBetButton:betButton];
        };
        [self.betViewButtonArray addObject:betButton];
        [self addSubview:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.sameNumberLabel.mas_bottom).offset(__SCALE(10.f));
            
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
                
                make.left.equalTo(button.mas_right).offset(0.f);
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
    //添加 不同号label约束
    [self.differentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(12.f));
        make.centerX.equalTo(self);
    }];
    
    
}
- (void)addDifferentNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    UILabel *lastLabel = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.tag = i + 1;
        betButton.betTerm = [NSString stringWithFormat:@"%zi", i + 1];
        [self addSubview:betButton];
        betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf betButtonOnClick:betButton];
        };
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf selectSingleBetButton:betButton];
        };
        [self.betViewButtonArray addObject:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.differentNumberLabel.mas_bottom).offset(__SCALE(10.f));
            
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
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(betButton);
            make.top.equalTo(betButton.mas_bottom);
            make.height.mas_equalTo(__SCALE(25.f));
        }];
        [self.omissionArray addObject:label];
        lastLabel = label;
        lastSizeBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastSizeBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
    }];
    //复选label 约束
    [self.doubleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(15.f));
        make.width.equalTo(self.singleLabel.mas_width);
    }];
    [self.doubleInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.doubleLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.centerY.equalTo(self.doubleLabel);
    }];
}
- (void)addDoubleNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi%zi*", i + 1, i + 1];
        betButton.tag = (i + 1) + DOUBLEBETVIEWTAG;
        betButton.betTerm = [NSString stringWithFormat:@"%zi%zi*", i + 1, i + 1];
        [self addSubview:betButton];
        [self.betViewButtonArray addObject:betButton];
        betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf betButtonOnClick:betButton];
        };
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf selectDoubleBetButton:betButton];
        };
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.doubleLabel.mas_bottom).offset(__SCALE(20.f));
            
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
                
                make.left.equalTo(button.mas_right).offset(0.f);
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
        lastSizeBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastSizeBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
    }];
    
}
#pragma mark - 配置随机色子动画
- (void)configRandomDice{
    
    if (__allowAnimation) {
        __allowAnimation = NO;
        self.animationView.hidden = NO;
        [self bringSubviewToFront:self.animationView];
        __SameNumber = arc4random() % 6 + 1;
        for (NSInteger i = 0; i < 100; i++) {
            __SingleNumber = arc4random() % 6 + 1;
            if (__SingleNumber != __SameNumber) {
                break;
            }
        }
        CGPoint sameNumberPoint = CGPointZero;
        CGPoint singleNumberPoint = CGPointZero;
        for (CLFTBetButtonView *betButton in self.betViewButtonArray) {
            if (betButton.tag == __SameNumber + SAMENUMBETVIEWTAG) {
                sameNumberPoint = betButton.center;
            }
            if (betButton.tag == __SingleNumber) {
                singleNumberPoint = betButton.center;
            }
            betButton.is_Selected = NO;
        }
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        [pointArray addObjectsFromArray:@[[NSValue valueWithCGPoint:sameNumberPoint], [NSValue valueWithCGPoint:sameNumberPoint], [NSValue valueWithCGPoint:singleNumberPoint]]];
        [numberArray addObjectsFromArray:@[[NSString stringWithFormat:@"%zi", __SameNumber], [NSString stringWithFormat:@"%zi", __SameNumber], [NSString stringWithFormat:@"%zi", __SingleNumber]]];
        self.animationView.diceFinishPointArray = pointArray;
        self.animationView.diceNumberArray = numberArray;
        [self.animationView startShakeDiceAnimation];
    }
}
#pragma mark ------ event Response ------
- (void)shakeButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了摇一摇");
    [self configRandomDice];
}
- (void)betButtonOnClick:(CLFTBetButtonView *)betButton{
    
    for (CLFTBetButtonView *betButtonView in self.betViewButtonArray) {
        
        if ((betButtonView.tag == betButton.tag - SAMENUMBETVIEWTAG) || (betButtonView.tag == betButton.tag + SAMENUMBETVIEWTAG)) {
            betButtonView.is_Selected = NO;
        }
    }
}
- (void)selectSingleBetButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.singleBetInfo addBetTerm:betButton.betTerm];
    }else{
        [self.singleBetInfo removeBetTerm:betButton.betTerm];
    }
    [self callBackNoteAndBetBonus];
    
}
- (void)selectDoubleBetButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.doubleBetInfo addBetTerm:betButton.betTerm];
    }else{
        [self.doubleBetInfo removeBetTerm:betButton.betTerm];
    }
    [self callBackNoteAndBetBonus];
}
- (void)showOmissionAlert{
    
    [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeKuaiSan];
}
#pragma mark - 返回投注的注数和金额
- (void)callBackNoteAndBetBonus{

    //获取投注项的金额
    NSInteger note = self.singleBetInfo.betNote + self.doubleBetInfo.betNote;//注数
    NSInteger minBetBonus = 0;//最小奖金
    NSInteger maxBetBonus = MAX(self.singleBetInfo.MaxBetBonus, self.doubleBetInfo.MaxBetBonus);//最大金额
    //最小奖金 第一种情况 95  即 同号 22#1 3 4 5 6   22*  其他情况下是15  或  80
    //最小奖金 其他情况
    if (self.doubleBetInfo.minBetBonus > 0) {
        //如果有15的就是15  没有就是self.singleBetInfo.minBetBonus 要么0  要么80
        minBetBonus = self.doubleBetInfo.minBetBonus;
    }else{
        minBetBonus = self.singleBetInfo.minBetBonus;
    }
    //最大奖金 如果同号 和 通选 有一样的最大金额就为95 否则就为两者中大的
    for (NSString *singleStr in self.singleBetInfo.sameNumberBetArray) {
        for (NSString *doubleStr in self.doubleBetInfo.twoSameDoubleBetArray) {
            if ([singleStr isEqualToString:[doubleStr substringWithRange:NSMakeRange(0, 2)]]) {
                maxBetBonus = 95;
            }
        }
    }
    
    if (self.singleBetInfo.sameNumberBetArray.count == 1 && self.doubleBetInfo.twoSameDoubleBetArray.count == 1) {
        if ([self.singleBetInfo.sameNumberBetArray[0] isEqualToString:[self.doubleBetInfo.twoSameDoubleBetArray[0] substringWithRange:NSMakeRange(0, 2)]]) {
            if (self.singleBetInfo.singleBetArray.count == 5) {
                minBetBonus = 95;
                maxBetBonus = 95;
            }
        }
    }
    self.twoSameBetBonusAndNotesBlock ? self.twoSameBetBonusAndNotesBlock(note, minBetBonus, maxBetBonus) : nil;
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
- (UILabel *)infoBetLabel{
    
    if (!_infoBetLabel) {
        _infoBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoBetLabel.text = @"猜对子号（有2个号相同）";
        _infoBetLabel.textColor = UIColorFromRGB(0xffffff);
        _infoBetLabel.font = FONT_SCALE(15);
    }
    return _infoBetLabel;
}
- (CLFTImageLabel *)singleLabel{
    
    if (!_singleLabel) {
        _singleLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _singleLabel.contentString = @"单选";
    }
    return _singleLabel;
}
- (UILabel *)singleInfoLabel{
    
    if (!_singleInfoLabel) {
        _singleInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _singleInfoLabel.text = @"选择同号和不同号的组合，奖金80元";
        _singleInfoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _singleInfoLabel.font = FONT_SCALE(13);
        _singleInfoLabel.numberOfLines = 0;
    }
    
    return _singleInfoLabel;
}
- (UILabel *)sameNumberLabel{
    
    if (!_sameNumberLabel) {
        _sameNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sameNumberLabel.text = @"同号";
        _sameNumberLabel.textColor = UIColorFromRGB(0xffffff);
        _sameNumberLabel.font = FONT_SCALE(16);
    }
    return _sameNumberLabel;
}
- (UILabel *)differentNumberLabel{
    
    if (!_differentNumberLabel) {
        _differentNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _differentNumberLabel.text = @"不同号";
        _differentNumberLabel.textColor = UIColorFromRGB(0xffffff);
        _differentNumberLabel.font = FONT_SCALE(16);
    }
    return _differentNumberLabel;
}
- (CLFTImageLabel *)doubleLabel{
    
    if (!_doubleLabel) {
        _doubleLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _doubleLabel.contentString = @"复选";
    }
    return _doubleLabel;
}
- (UILabel *)doubleInfoLabel{
    
    if (!_doubleInfoLabel) {
        _doubleInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _doubleInfoLabel.text = @"猜开奖中2个指定的相同号码，奖金15元";
        _doubleInfoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _doubleInfoLabel.font = FONT_SCALE(13);
        _doubleInfoLabel.numberOfLines = 0;
    }
    return _doubleInfoLabel;
}
- (NSMutableArray *)betViewButtonArray{
    
    if (!_betViewButtonArray) {
        _betViewButtonArray = [[NSMutableArray alloc] init];
    }
    return _betViewButtonArray;
}
- (NSMutableArray *)omissionArray{
    
    if (!_omissionArray) {
        _omissionArray = [[NSMutableArray alloc] init];
    }
    return _omissionArray;
}
- (CLFTTwoSameSingleBetInfo *)singleBetInfo{
    
    if (!_singleBetInfo) {
        _singleBetInfo = [[CLFTTwoSameSingleBetInfo alloc] init];
    }
    return _singleBetInfo;
}
- (CLFTTwoSameDoubleBetInfo *)doubleBetInfo{
    
    if (!_doubleBetInfo) {
        _doubleBetInfo = [[CLFTTwoSameDoubleBetInfo alloc] init];
    }
    return _doubleBetInfo;
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
