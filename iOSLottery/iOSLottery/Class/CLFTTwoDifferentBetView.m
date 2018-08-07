//
//  CLFTTwoDifferentBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTTwoDifferentBetView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTBetButtonView.h"
#import "CLFTImageLabel.h"
#import "CLFTTwoDifferentBetInfo.h"
#import "CLDiceAnimationView.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UILabel+CLAttributeLabel.h"
#import "UIImageView+CQWebImage.h"
@interface CLFTTwoDifferentBetView ()<CLDiceAnimationProtocol>{
    
    NSInteger __firstDiceNumber;//随机骰子数
    NSInteger __secondDiceNumber;
    BOOL __allowAnimation; //是否允许动画
}
@property (nonatomic, strong) UIButton *shakeButton;//摇一摇按钮
@property (nonatomic, strong) UILabel *infoLabel;//二不同号说明label
@property (nonatomic, strong) NSMutableArray *betButtonArray;//按钮数组
@property (nonatomic, strong) CLDiceAnimationView *animationView;//色子动画
@property (nonatomic, strong) NSMutableArray *omissionArray;
@property (nonatomic, strong) CLTwoImageButton *activityButton;//活动按钮
@property (nonatomic, strong) NSString *activityUrl;

@end
@implementation CLFTTwoDifferentBetView

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRandomDice) name:shake_diffTwo object:nil];
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
    }
}
#pragma mark ------ delegate ------
- (void)assignUIWithData:(id)data{
    
    if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeTwoDifferent) {
        CLFTTwoDifferentBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.twoDifferentBetArray) {
            for (CLFTBetButtonView *betButton in self.betButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue]) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBetButton{
    
    for (CLFTBetButtonView *betView in self.betButtonArray) {
        betView.is_Selected = NO;
    }
}
#pragma mark - 刷新奖金
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo{
    
    self.infoLabel.text = [NSString stringWithFormat:@"选2个不同号码，猜中开奖的任意2位即中%zi元", bonusInfo.bonus_twoDiff];
    self.betInfo.bonus = bonusInfo.bonus_twoDiff;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return ((self.betInfo.twoDifferentBetArray.count) > 0);
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
        
        [self.infoLabel attributeWithText:bonusInfo[22] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.animationView];
    [self addSubview:self.shakeButton];
    [self addSubview:self.infoLabel];
    [self addSubview:self.activityButton];
    
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.shakeButton);
        make.right.equalTo(self).offset(__SCALE(-20.f));
    }];
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.right.equalTo(self).offset(__SCALE(-10.f));
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(15.f));
    }];
    //添加 二不同号投注按钮
    [self addTwoDifferentNumberBetView];
    
}
- (void)addTwoDifferentNumberBetView{
    
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.betTerm = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.tag = i + 1;
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            [_weakSelf selectedBetButton:betButton];
        };
        [self addSubview:betButton];
        [self.betButtonArray addObject:betButton];
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(20.f));
            
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
        __firstDiceNumber = arc4random() % 6 + 1;
        for (NSInteger i = 0; i < 100; i++) {
            __secondDiceNumber = arc4random() % 6 + 1;
            if (__firstDiceNumber != __secondDiceNumber) {
                break;
            }
        }
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            if (betButton.tag == __firstDiceNumber) {
                [pointArray addObject:[NSValue valueWithCGPoint:betButton.center]];
            }
            betButton.is_Selected = NO;
        }
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            
            if (betButton.tag == __secondDiceNumber) {
                [pointArray addObject:[NSValue valueWithCGPoint:betButton.center]];
            }
        }
        [numberArray addObjectsFromArray:@[[NSString stringWithFormat:@"%zi", __firstDiceNumber], [NSString stringWithFormat:@"%zi", __secondDiceNumber]]];
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
- (void)selectedBetButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.betInfo addBetTerm:betButton.betTerm];
    }else{
        [self.betInfo removeBetTerm:betButton.betTerm];
    }
    self.twoDifferentBetBonusAndNotesBlock ? self.twoDifferentBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
    
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
        self.twoDifferentBetBonusAndNotesBlock ? self.twoDifferentBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
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
- (UILabel *)infoLabel{
    
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.text = @"选2个不同号码，猜中开奖的任意2位即中8元";
        _infoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _infoLabel.font = FONT_SCALE(13);
        _infoLabel.numberOfLines = 0;
    }
    
    return _infoLabel;
}
- (CLFTTwoDifferentBetInfo *)betInfo{
    
    if (!_betInfo) {
        _betInfo = [[CLFTTwoDifferentBetInfo alloc] init];
    }
    return _betInfo;
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
- (CLDiceAnimationView *)animationView{
    
    if (!_animationView) {
        _animationView = [[CLDiceAnimationView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT)];
        _animationView.delegate = self;
        _animationView.hidden = YES;
    }
    return _animationView;
}

@end
