//
//  CLFTThreeSameBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeSameBetView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTBetButtonView.h"
#import "CLFTThreeSameSingleBetInfo.h"
#import "CLFTThreeSameAllBetInfo.h"
#import "CLDiceAnimationView.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"
#define ALLSELECTBTNTAG 99

@interface CLFTThreeSameBetView () <CLDiceAnimationProtocol>{
    
    NSInteger __randomNumber;//随机选号
    BOOL __allowAnimation;//是否允许动画
}

@property (nonatomic, strong) UIButton *shakeButton;//摇一摇按钮
@property (nonatomic, strong) CLTwoImageButton *activityButton;//活动按钮
@property (nonatomic, strong) UILabel *infoBetLabel;//猜豹子号
@property (nonatomic, strong) CLFTBetButtonView *allSelectedBetView;//通选
@property (nonatomic, strong) NSMutableArray *betButtonArray;//投注按钮数组
@property (nonatomic, strong) CLDiceAnimationView *animationView;//摇色子动画

@property (nonatomic, strong) NSMutableArray *omissionArray;//遗漏
@property (nonatomic, strong) NSString *activityUrl;

@end
@implementation CLFTThreeSameBetView

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRandomDice) name:shake_sameThree object:nil];
    }
    return self;
}
#pragma mark ------ delegate ------
- (void)assignUIWithData:(id)data{
    
    if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeThreeSameSingle) {
        CLFTThreeSameSingleBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.threeSameSingleBetArray) {
            for (CLFTBetButtonView *betButton in self.betButtonArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue]) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }else if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeThreeSameAll){
        CLFTThreeSameAllBetInfo *selectBetInfo = data;
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
    
    for (CLFTBetButtonView *betButton in self.betButtonArray) {
        betButton.betAward = [NSString stringWithFormat:@"奖金%zi元", bonusInfo.bonus_threeSameSingle];
    }
    self.allSelectedBetView.betAward = [NSString stringWithFormat:@"任意一个豹子开出即中%zi元", bonusInfo.bonus_threeSameAll];
    self.singleBetInfo.bonus = bonusInfo.bonus_threeSameSingle;
    self.allBetInfo.bonus = bonusInfo.bonus_threeSameAll;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return ((self.allBetInfo.threeSameAllBetArray.count + self.singleBetInfo.threeSameSingleBetArray.count) > 0);
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
#pragma mark - 配置奖金信息
- (void)assignBonusInfo:(NSArray *)bonusInfo{
    
    if (bonusInfo && bonusInfo.count == 25) {
        
        for (CLFTBetButtonView *betView in self.betButtonArray) {
            betView.bonusInfo = bonusInfo[16];
        }
        self.allSelectedBetView.bonusInfo = bonusInfo[17];
    }
}
#pragma mark ------ 动画 delegate ------
- (void)diceAnimationDidStop{
    __allowAnimation = YES;
    self.animationView.hidden = YES;
    [self sendSubviewToBack:self.animationView];
    for (CLFTBetButtonView *betButton in self.betButtonArray) {
        if (betButton.tag == __randomNumber) {
            betButton.is_Selected = YES;
        }
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.animationView];
    [self addSubview:self.shakeButton];
    [self addSubview:self.activityButton];
    [self addSubview:self.infoBetLabel];
    [self addSubview:self.allSelectedBetView];
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
    //添加 投注按钮
    [self addNumberBetView];
}
- (void)addNumberBetView{
    WS(_weakSelf)
    //添加 投注项
    CLFTBetButtonView *lastBetButtonY = nil;
    UILabel *lastLabel = nil;
    for (NSInteger j = 0; j < 2; j++) {
        //这是一行
        CLFTBetButtonView *lastBetButton = nil;
        UILabel *tempLabel = nil;
        for (NSInteger i = 0; i < 3; i++) {
            CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
            betButton.betNumber = [NSString stringWithFormat:@"%zi%zi%zi", ((3 * j) + i + 1), ((3 * j) + i + 1), ((3 * j) + i + 1)];
            betButton.betAward = @"奖金240";
            betButton.numberFont = FONT_SCALE(16);
            betButton.tag = (3 * j) + i + 1;
            betButton.betTerm = [NSString stringWithFormat:@"%zi%zi%zi", ((3 * j) + i + 1), ((3 * j) + i + 1), ((3 * j) + i + 1)];
            [self addSubview:betButton];
            betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
                [_weakSelf clickBetButton:betButton];
            };
            betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
                [_weakSelf selectBetButton:betButton];
            };
            [self.betButtonArray addObject:betButton];
            [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (lastBetButtonY) {
                    make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(10.f));
                }else{
                    make.top.equalTo(self.infoBetLabel.mas_bottom).offset(__SCALE(15.f));
                }
                
                if (lastBetButton) {
                    make.left.equalTo(lastBetButton.mas_right).offset(__SCALE(15.f));
                }else{
                    make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
                }
                
                if (lastBetButton) {
                    make.width.equalTo(lastBetButton);
                }
                make.height.equalTo(betButton.mas_width).multipliedBy(0.5);
            }];
            lastBetButton = betButton;
            
            //创建遗漏lebal
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"-";
            label.font = FONT_SCALE(13);
            label.textColor = UIColorFromRGB(0x8eeacc);
            label.textAlignment = NSTextAlignmentCenter;
            
            [self addSubview:label];
            if (i == 0 && j == 0) {
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
//                    make.width.mas_equalTo(__SCALE(30.f));
                }];
                label.textAlignment = NSTextAlignmentLeft;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(button.mas_right).offset(0.f);
//                    make.right.equalTo(betButton);
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
            tempLabel = label;
        }
        //再给最后一个加一个约束 距离右边界
        [lastBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
        }];
        lastBetButtonY = lastBetButton;
        lastLabel = tempLabel;
    }
    [self.allSelectedBetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
        make.top.equalTo(lastBetButtonY.mas_bottom).offset(__SCALE(30.f));
        make.height.equalTo(lastBetButtonY);
    }];
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
#pragma mark - 返回投注的注数和金额
- (void)callBackNoteAndBetBonus{
    
    //获取投注项的金额
    NSInteger note = self.singleBetInfo.betNote + self.allBetInfo.betNote;
    NSInteger minBetBonus = 0;
    NSInteger maxBetBonus = 0;
    if (self.singleBetInfo.threeSameSingleBetArray.count == 6) {
        minBetBonus = self.singleBetInfo.minBetBonus + self.allBetInfo.minBetBonus;
        maxBetBonus = self.singleBetInfo.MaxBetBonus + self.allBetInfo.MaxBetBonus;
    }else{
        minBetBonus = self.allBetInfo.minBetBonus > 0 ? self.allBetInfo.minBetBonus : self.singleBetInfo.minBetBonus;
        maxBetBonus = self.singleBetInfo.MaxBetBonus + self.allBetInfo.MaxBetBonus;
    }
    
    self.threeSameBetBonusAndNotesBlock ? self.threeSameBetBonusAndNotesBlock(note, minBetBonus, maxBetBonus) : nil;
}
#pragma mark - 配置随机色子动画
- (void)configRandomDice{
    
    if (__allowAnimation) {
        __allowAnimation = NO;
        self.animationView.hidden = NO;
        [self bringSubviewToFront:self.animationView];
        __randomNumber = arc4random() % 6 + 1;
        CGPoint point = CGPointZero;
        for (CLFTBetButtonView *betButton in self.betButtonArray) {
            if (betButton.tag == __randomNumber) {
                point = betButton.center;
            }
        }
        [self clearAllBetButton];
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        [pointArray addObjectsFromArray:@[[NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:point]]];
        [numberArray addObjectsFromArray:@[[NSString stringWithFormat:@"%zi", __randomNumber], [NSString stringWithFormat:@"%zi", __randomNumber], [NSString stringWithFormat:@"%zi", __randomNumber]]];
        self.animationView.diceFinishPointArray = pointArray;
        self.animationView.diceNumberArray = numberArray;
        [self.animationView startShakeDiceAnimation];
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
#pragma mark ------ event Response ------
- (void)shakeButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了摇一摇");
    [self configRandomDice];
}
- (void)clickBetButton:(CLFTBetButtonView *)betButtonView{
    
}
- (void)clickAllSelectBetButton:(CLFTBetButtonView *)betButtonView{
    
}
- (void)selectBetButton:(CLFTBetButtonView *)betButtonView{
    
    //存储投注项
    if (betButtonView.is_Selected) {
        [self.singleBetInfo addBetTerm:betButtonView.betTerm];
    }else{
        [self.singleBetInfo removeBetTerm:betButtonView.betTerm];
    }
    //获取投注项的金额 奖金
    [self callBackNoteAndBetBonus];
}
- (void)selectAllSelectBetButton:(CLFTBetButtonView *)betButtonView{
    
    //存储投注项
    if (betButtonView.is_Selected) {
        [self.allBetInfo addBetTerm:betButtonView.betTerm];
    }else{
        [self.allBetInfo removeBetTerm:betButtonView.betTerm];
    }
    //获取投注项的金额 奖金
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
- (UILabel *)infoBetLabel{
    
    if (!_infoBetLabel) {
        _infoBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoBetLabel.text = @"猜豹子号（3个号相同）";
        _infoBetLabel.textColor = UIColorFromRGB(0xffffff);
        _infoBetLabel.font = FONT_SCALE(15);
    }
    return _infoBetLabel;
}
- (CLFTBetButtonView *)allSelectedBetView{
    WS(_weakSelf)
    if (!_allSelectedBetView) {
        _allSelectedBetView = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        _allSelectedBetView.betNumber = @"三同号通选";
        _allSelectedBetView.betAward = @"任意一个豹子开出即中40元";
        _allSelectedBetView.betTerm = @"三同号通选";
        _allSelectedBetView.tag = ALLSELECTBTNTAG;
        _allSelectedBetView.numberFont = FONT_SCALE(15);
        _allSelectedBetView.betButtonClickBlock = ^(CLFTBetButtonView *betView){
            [_weakSelf clickAllSelectBetButton:betView];
        };
        _allSelectedBetView.betButtonSelectedBlock = ^(CLFTBetButtonView *betView){
            [_weakSelf selectAllSelectBetButton:betView];
        };
    }
    return _allSelectedBetView;
}
- (CLFTThreeSameSingleBetInfo *)singleBetInfo{
    
    if (!_singleBetInfo) {
        _singleBetInfo = [[CLFTThreeSameSingleBetInfo alloc] init];
    }
    return _singleBetInfo;
}
- (CLFTThreeSameAllBetInfo *)allBetInfo{
    
    if (!_allBetInfo) {
        _allBetInfo = [[CLFTThreeSameAllBetInfo alloc] init];
    }
    return _allBetInfo;
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
