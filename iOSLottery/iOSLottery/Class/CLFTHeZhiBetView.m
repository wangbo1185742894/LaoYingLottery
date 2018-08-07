//
//  CLFastThreeBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTHeZhiBetView.h"
#import "CLFTBetButtonView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTHeZhiBetInfo.h"
#import "CLTools.h"
#import "CLDiceAnimationView.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"
@interface CLFTHeZhiBetView ()<CLDiceAnimationProtocol>{
    
    NSInteger __firstDiceNumber;//随机骰子数
    NSInteger __secondDiceNumber;
    NSInteger __thirdDiceNumber;
    BOOL __allowAnimation;//是否允许 动画
}

@property (nonatomic, strong) UIButton *shakeButton;//摇一摇按钮
@property (nonatomic, strong) CLTwoImageButton *activityButton;//活动按钮
@property (nonatomic, strong) UILabel *quickBetLabel;//快速投注
@property (nonatomic, strong) UILabel *explainLabel;//猜相加的和
@property (nonatomic, strong) NSMutableArray *awardArray;//奖金
@property (nonatomic, strong) UIView *sizeView;//大小单双的底层View
@property (nonatomic, strong) UIButton *bigButton;//大
@property (nonatomic, strong) UIButton *littleButton;//小
@property (nonatomic, strong) UIButton *singleButton;//单
@property (nonatomic, strong) UIButton *doubleButton;//双
@property (nonatomic, strong) UIView *firstLineView;//第一根线
@property (nonatomic, strong) UIView *secondLineView;//第二根线
@property (nonatomic, strong) UIView *thirdLineView;//第三根线
@property (nonatomic, strong) NSMutableArray *buttonViewArray;//投注按钮的数组
@property (nonatomic, strong) NSMutableArray *omissionArray;//遗漏数组

@property (nonatomic, strong) NSArray *bigArray;//大
@property (nonatomic, strong) NSArray *littleArray;//小
@property (nonatomic, strong) NSArray *singleArray;//单
@property (nonatomic, strong) NSArray *doubleArray;//双

@property (nonatomic, strong) CLDiceAnimationView *animationView;//摇一摇动画

@property (nonatomic, strong) NSString *activityUrl;

@end

@implementation CLFTHeZhiBetView

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configRandomDice) name:shake_heZhi object:nil];
    }
    return self;
}

#pragma mark ------ 配置默认选中项 delegate ------
- (void)assignUIWithData:(id)data{
    
    CLFTHeZhiBetInfo *selectBetInfo = data;
    for (NSString *betTerm in selectBetInfo.heZhiBetArray) {
        for (CLFTBetButtonView *betButton in self.buttonViewArray) {
            if (betButton.tag == [betTerm integerValue]) {
                betButton.is_Selected = YES;
            }
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBetButton{
    
    for (CLFTBetButtonView *betView in self.buttonViewArray) {
        betView.is_Selected = NO;
    }
}
#pragma mark - 刷新奖级
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo{
    
    [self.awardArray removeAllObjects];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_threeSameSingle]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumFour]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumFive]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumSix]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumSeven]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumEight]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumNine]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumTen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumEleven]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumTwelve]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumThirteen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumFourteen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumFifteen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumSixteen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_sumSeventeen]];
    [self.awardArray addObject:[NSString stringWithFormat:@"%zi", bonusInfo.bonus_threeSameSingle]];
    for (CLFTBetButtonView *betButton in self.buttonViewArray) {
        betButton.betAward = [NSString stringWithFormat:@"奖金%@元",self.awardArray[betButton.tag - 3]];
    }
    self.betInfo.bonusArray = self.awardArray;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return (self.betInfo.heZhiBetArray.count > 0);
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
    
        for (NSInteger i = 0; i < 16; i++) {
            ((CLFTBetButtonView *)self.buttonViewArray[i]).bonusInfo = bonusInfo[i];
        }
    }
}
#pragma mark ------ 摇色子的动画 delegate ------
- (void)diceAnimationDidStop{
    __allowAnimation = YES;
    self.animationView.hidden = YES;
    [self sendSubviewToBack:self.animationView];
    for (CLFTBetButtonView *betButton in self.buttonViewArray) {
        if (betButton.tag == (__firstDiceNumber + __secondDiceNumber + __thirdDiceNumber)) {
            betButton.is_Selected = YES;
        }
    }
}
- (void)hiddenOmission:(BOOL)hidden{
    
    for (UILabel *label in self.omissionArray) {
        label.hidden = hidden;
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
                
            make.height.mas_equalTo(hidden ? 0 : __SCALE(25));
        }];
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.animationView];
    [self addSubview:self.quickBetLabel];
    [self addSubview:self.shakeButton];
    [self addSubview:self.activityButton];
    [self addSubview:self.explainLabel];
    [self addSubview:self.sizeView];
    [self.sizeView addSubview:self.bigButton];
    [self.sizeView addSubview:self.littleButton];
    [self.sizeView addSubview:self.singleButton];
    [self.sizeView addSubview:self.doubleButton];
    [self.sizeView addSubview:self.firstLineView];
    [self.sizeView addSubview:self.secondLineView];
    [self.sizeView addSubview:self.thirdLineView];
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
    [self.quickBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
    }];
    [self.explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(15.f));
    }];
    //添加 投注按钮
    [self addNumberBetView];
    //添加 快速投注按钮
    [self addSizeBetView];
}
- (void)addNumberBetView{
    WS(_weakSelf)
    //添加 和值投注项
    CLFTBetButtonView *lastBetButtonY = nil;
    UILabel *lastLabel = nil;//记录上一行的label
    for (NSInteger j = 0; j < 4; j++) {
        //这是一行
        CLFTBetButtonView *lastBetButton = nil;
        UILabel *tempLabel = nil;
        for (NSInteger i = 0; i < 4; i++) {
            CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
            betButton.betNumber = [NSString stringWithFormat:@"%zi", (4 * j) + i + 3];
            betButton.betAward = [NSString stringWithFormat:@"奖金%@元",self.awardArray[((4 * j) + i)]];
            betButton.tag = (4 * j) + i + 3;
            betButton.betTerm = [NSString stringWithFormat:@"%zi", (4 * j) + i + 3];
            betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
                [_weakSelf clickBetButton:betButton];
            };
            betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
                [_weakSelf selectBetButton:betButton];
            };
            [self addSubview:betButton];
            [self.buttonViewArray addObject:betButton];
            [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (lastBetButtonY) {
                    make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(6.f));
                }else{
                    make.top.equalTo(self.explainLabel.mas_bottom).offset(__SCALE(12.f));
                }
                
                if (lastBetButton) {
                    make.left.equalTo(lastBetButton.mas_right).offset(__SCALE(MAINBETBUTTONDISTANCE));
                }else{
                    make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
                }
                
                if (lastBetButton) {
                    make.width.equalTo(lastBetButton);
                }
                make.height.equalTo(betButton.mas_width).multipliedBy(0.6);
            }];
            lastBetButton = betButton;
            
            //创建遗漏lebal
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
            label.text = @"-";
            label.font = FONT_SCALE(13);
            label.textColor = UIColorFromRGB(0x333333);
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
//                    make.width.mas_equalTo(__SCALE(25.f));
                }];
                label.textAlignment = NSTextAlignmentLeft;
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.equalTo(button.mas_right).offset(0.f);
//                    make.right.equalTo(betButton);
                    make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
                    make.height.mas_equalTo(__SCALE(20.f));
                }];
            }else{
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.right.equalTo(betButton);
                    make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
                    make.height.mas_equalTo(__SCALE(20.f));
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
    //给快速投注添加一条top 约束
    [self.quickBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(10.f));
    }];
}
- (void)addSizeBetView{
    
    [self.sizeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quickBetLabel.mas_bottom).offset(__SCALE(15.f));
        make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
        make.height.mas_equalTo(__SCALE(32));
    }];
    [self.bigButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.sizeView);
    }];
    [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigButton.mas_right);
        make.top.bottom.equalTo(self.sizeView);
        make.width.mas_equalTo(2.f);
    }];
    [self.littleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstLineView.mas_right);
        make.top.bottom.equalTo(self.sizeView);
        make.width.equalTo(self.bigButton);
    }];
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.littleButton.mas_right);
        make.top.bottom.equalTo(self.sizeView);
        make.width.equalTo(self.firstLineView);
    }];
    [self.singleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLineView.mas_right);
        make.top.bottom.equalTo(self.sizeView);
        make.width.equalTo(self.bigButton);
    }];
    [self.thirdLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.singleButton.mas_right);
        make.top.bottom.equalTo(self.sizeView);
        make.width.equalTo(self.firstLineView);
    }];
    [self.doubleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdLineView.mas_right);
        make.width.equalTo(self.bigButton);
        make.top.bottom.equalTo(self.sizeView);
        make.right.equalTo(self.sizeView);
    }];
}
#pragma mark - 获取两个数组中共有的元素
- (NSMutableArray *)screenSameObjectWithfirstArray:(NSArray *)firstArray secondArray:(NSArray *)secondArray{
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    [firstArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [secondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj integerValue] == [obj1 integerValue]) {
                [tmpArray addObject:obj];
            }
        }];
    }];
    return tmpArray;
}
#pragma mark - 点击了 大小单双 时，配置按钮的点击态
- (void)configBetButtonSelected{
    
    NSMutableArray *saveArray = [NSMutableArray arrayWithCapacity:0];
    
    if (self.bigButton.selected) {
        [saveArray addObject:self.bigArray];
    }
    if (self.littleButton.selected) {
        [saveArray addObject:self.littleArray];
    }
    if (self.singleButton.selected) {
        [saveArray addObject:self.singleArray];
    }
    if (self.doubleButton.selected) {
        [saveArray addObject:self.doubleArray];
    }
    
    NSMutableArray __block *tempArray = [NSMutableArray arrayWithCapacity:0];
    [saveArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            tempArray = saveArray[0];
        }else{
            tempArray = [self screenSameObjectWithfirstArray:tempArray secondArray:obj];
        }
    }];
    [self.buttonViewArray enumerateObjectsUsingBlock:^(CLFTBetButtonView * buttonView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([tempArray indexOfObject:[NSNumber numberWithInteger:buttonView.tag]] != NSNotFound) {
            buttonView.is_Selected = YES;
        }else{
            buttonView.is_Selected = NO;
        }
    }];
 }
#pragma mark - 修改快速投注的选中态
- (void)selectedQucikButton{
    
    //遍历所有按钮，判断选中态, 选中存入数组， 比较数组，判断是否满足大小单双
    NSMutableArray *selectedArray = [NSMutableArray arrayWithCapacity:0];
    for (CLFTBetButtonView *buttonView in self.buttonViewArray) {
        if (buttonView.is_Selected) {
            [selectedArray addObject:@(buttonView.tag)];
        }
    }
    if ([selectedArray isEqualToArray:self.bigArray]) {
        self.bigButton.selected = YES;
        return;
    }else{
        self.bigButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:self.littleArray]) {
        self.littleButton.selected = YES;
        return;
    }else{
        self.littleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:self.singleArray]) {
        self.singleButton.selected = YES;
        return;
    }else{
        self.singleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:self.doubleArray]) {
        self.doubleButton.selected = YES;
        return;
    }else{
        self.doubleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:[self screenSameObjectWithfirstArray:self.bigArray secondArray:self.singleArray]]) {
        self.bigButton.selected = YES;
        self.singleButton.selected = YES;
        return;
    }else{
        self.bigButton.selected = NO;
        self.singleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:[self screenSameObjectWithfirstArray:self.bigArray secondArray:self.doubleArray]]) {
        self.bigButton.selected = YES;
        self.doubleButton.selected = YES;
        return;
    }else{
        self.bigButton.selected = NO;
        self.doubleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:[self screenSameObjectWithfirstArray:self.littleArray secondArray:self.singleArray]]) {
        self.littleButton.selected = YES;
        self.singleButton.selected = YES;
        return;
    }else{
        self.littleButton.selected = NO;
        self.singleButton.selected = NO;
    }
    if ([selectedArray isEqualToArray:[self screenSameObjectWithfirstArray:self.littleArray secondArray:self.doubleArray]]) {
        self.littleButton.selected = YES;
        self.doubleButton.selected = YES;
        return;
    }else{
        self.littleButton.selected = NO;
        self.doubleButton.selected = NO;
    }
}
#pragma mark - 配置随机色子动画
- (void)configRandomDice{
    
    if (__allowAnimation) {
        __allowAnimation = NO;
        self.animationView.hidden = NO;
        [self bringSubviewToFront:self.animationView];
        //模拟色子 的 随机数
        __firstDiceNumber = arc4random() % 6 + 1;
        __secondDiceNumber = arc4random() % 6 + 1;
        __thirdDiceNumber = arc4random() % 6 + 1;
        
        NSInteger randomNumber = __firstDiceNumber + __secondDiceNumber + __thirdDiceNumber;
        CGPoint point = CGPointZero;
        for (CLFTBetButtonView *betButton in self.buttonViewArray) {
            if (betButton.tag == randomNumber) {
                point = betButton.center;
            }
            betButton.is_Selected = NO;
        }
        NSMutableArray *pointArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *numberArray = [NSMutableArray arrayWithCapacity:0];
        [pointArray addObjectsFromArray:@[[NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:point], [NSValue valueWithCGPoint:point]]];
        [numberArray addObjectsFromArray:@[[NSString stringWithFormat:@"%zi", __firstDiceNumber], [NSString stringWithFormat:@"%zi", __secondDiceNumber], [NSString stringWithFormat:@"%zi", __thirdDiceNumber]]];
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
- (void)bigButtonOnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) self.littleButton.selected = !btn.selected;
    [self configBetButtonSelected];
}
- (void)littleButtonOnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) self.bigButton.selected = !btn.selected;
    [self configBetButtonSelected];
}
- (void)singleButtonOnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) self.doubleButton.selected = !btn.selected;
    [self configBetButtonSelected];
}
- (void)doubleButtonOnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    if (btn.selected) self.singleButton.selected = !btn.selected;
    [self configBetButtonSelected];
}
- (void)showOmissionAlert{
    
    [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeKuaiSan];
}
- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark - 点击了选中按钮
- (void)clickBetButton:(CLFTBetButtonView *)betButtonView{
    
}
#pragma mark - 修改投注按钮的选中态
- (void)selectBetButton:(CLFTBetButtonView *)betButtonView{
    
    //点击了投注项 判断大小单双 按钮是否需要选中
    [self selectedQucikButton];
    //存储投注项
    if (betButtonView.is_Selected) {
        [self.betInfo addBetTerm:betButtonView.betTerm];
    }else{
        [self.betInfo removeBetTerm:betButtonView.betTerm];
    }
    //获取投注项的金额
    self.heZhiBetBonusAndNotesBlock ? self.heZhiBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    
    //如果当前显示的是和值 则需要向外传递 奖金 来更改底部视图的奖金
    if (!hidden) {
        //获取投注项的金额
        self.heZhiBetBonusAndNotesBlock ? self.heZhiBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
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
- (UILabel *)quickBetLabel{
    
    if (!_quickBetLabel) {
        _quickBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _quickBetLabel.text = @"快速投注";
        _quickBetLabel.textColor = UIColorFromRGB(0xffffff);
        _quickBetLabel.font = FONT_SCALE(15);
    }
    return _quickBetLabel;
}
- (UILabel *)explainLabel{
    
    if (!_explainLabel) {
        _explainLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _explainLabel.text = @"猜开奖号码相加的和";
        _explainLabel.textColor = UIColorFromRGB(0xffffff);
        _explainLabel.font = FONT_SCALE(15);
    }
    return _explainLabel;
}
- (UIView *)sizeView{
    
    if (!_sizeView) {
        _sizeView = [[UIView alloc] initWithFrame:CGRectZero];
        _sizeView.layer.cornerRadius = 2.f;
        _sizeView.layer.borderColor = UIColorFromRGB(0x71bb99).CGColor;
        _sizeView.layer.borderWidth = 2.f;
        _sizeView.layer.masksToBounds = YES;
    }
    return _sizeView;
}
- (UIButton *)bigButton{
    
    if (!_bigButton) {
        _bigButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_bigButton setTitle:@"大" forState:UIControlStateNormal];
        _bigButton.titleLabel.font = FONT_BOLD(17.f);
        [_bigButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_bigButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        [_bigButton setBackgroundImage:[UIImage imageNamed:@"ft_backgroundVeinImage.png"] forState:UIControlStateNormal];
        [_bigButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0x2b7055)] forState:UIControlStateSelected];
        [_bigButton setBackgroundColor:UIColorFromRGB(0x009955)];
        _bigButton.adjustsImageWhenHighlighted = NO;
        [_bigButton addTarget:self action:@selector(bigButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bigButton;
}
- (UIButton *)littleButton{
    
    if (!_littleButton) {
        _littleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_littleButton setTitle:@"小" forState:UIControlStateNormal];
        _littleButton.titleLabel.font = FONT_BOLD(17.f);
        [_littleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_littleButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        [_littleButton setBackgroundImage:[UIImage imageNamed:@"ft_backgroundVeinImage.png"] forState:UIControlStateNormal];
        [_littleButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0x2b7055)] forState:UIControlStateSelected];
        [_littleButton setBackgroundColor:UIColorFromRGB(0x009955)];
        _littleButton.adjustsImageWhenHighlighted = NO;
        [_littleButton addTarget:self action:@selector(littleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _littleButton;
}
- (UIButton *)singleButton{
    
    if (!_singleButton) {
        _singleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_singleButton setTitle:@"单" forState:UIControlStateNormal];
        _singleButton.titleLabel.font = FONT_BOLD(17.f);
        [_singleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_singleButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        [_singleButton setBackgroundImage:[UIImage imageNamed:@"ft_backgroundVeinImage.png"] forState:UIControlStateNormal];
        [_singleButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0x2b7055)] forState:UIControlStateSelected];
        [_singleButton setBackgroundColor:UIColorFromRGB(0x009955)];
        _singleButton.adjustsImageWhenHighlighted = NO;
        [_singleButton addTarget:self action:@selector(singleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleButton;
}
- (UIButton *)doubleButton{
    
    if (!_doubleButton) {
        _doubleButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_doubleButton setTitle:@"双" forState:UIControlStateNormal];
        _doubleButton.titleLabel.font = FONT_BOLD(17.f);
        [_doubleButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_doubleButton setTitleColor:UIColorFromRGB(0xffff00) forState:UIControlStateSelected];
        [_doubleButton setBackgroundImage:[UIImage imageNamed:@"ft_backgroundVeinImage.png"] forState:UIControlStateNormal];
        [_doubleButton setBackgroundImage:[CLTools createImageWithColor:UIColorFromRGB(0x2b7055)] forState:UIControlStateSelected];
        [_doubleButton setBackgroundColor:UIColorFromRGB(0x009955)];
        _doubleButton.adjustsImageWhenHighlighted = NO;
        [_doubleButton addTarget:self action:@selector(doubleButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doubleButton;
}
- (UIView *)firstLineView{
    
    if (!_firstLineView) {
        _firstLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _firstLineView.backgroundColor = UIColorFromRGB(0x71bb99);
    }
    return _firstLineView;
}
- (UIView *)secondLineView{
    
    if (!_secondLineView) {
        _secondLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _secondLineView.backgroundColor = UIColorFromRGB(0x71bb99);
    }
    return _secondLineView;
}
- (UIView *)thirdLineView{
    
    if (!_thirdLineView) {
        _thirdLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _thirdLineView.backgroundColor = UIColorFromRGB(0x71bb99);
    }
    return _thirdLineView;
}
- (NSMutableArray *)awardArray{
    
    if (!_awardArray) {
        _awardArray = [NSMutableArray arrayWithCapacity:0];
        [_awardArray addObjectsFromArray:@[@"240",
                                          @"80",
                                          @"40",
                                          @"25",
                                          @"16",
                                          @"12",
                                          @"10",
                                          @"9",
                                          @"9",
                                          @"10",
                                          @"12",
                                          @"16",
                                          @"25",
                                          @"40",
                                          @"80",
                                          @"240"]];
    }
    return _awardArray;
}
- (NSMutableArray *)buttonViewArray{
    
    if (!_buttonViewArray) {
        _buttonViewArray = [[NSMutableArray alloc] init];
    }
    return _buttonViewArray;
}
- (NSMutableArray *)omissionArray{
    
    if (!_omissionArray) {
        _omissionArray = [[NSMutableArray alloc] init];
    }
    return _omissionArray;
}
- (NSArray *)bigArray{
    
    return @[@(11),
             @(12),
             @(13),
             @(14),
             @(15),
             @(16),
             @(17),
             @(18)];
}
- (NSArray *)littleArray{
    
    return @[@(3),
             @(4),
             @(5),
             @(6),
             @(7),
             @(8),
             @(9),
             @(10)];
}
- (NSArray *)singleArray{
    
    return @[@(3),
             @(5),
             @(7),
             @(9),
             @(11),
             @(13),
             @(15),
             @(17)];
}
- (NSArray *)doubleArray{
    
    return @[@(4),
             @(6),
             @(8),
             @(10),
             @(12),
             @(14),
             @(16),
             @(18)];
}
- (CLFTHeZhiBetInfo *)betInfo{
    
    if (!_betInfo) {
        _betInfo = [[CLFTHeZhiBetInfo alloc] init];
    }
    return _betInfo;
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
