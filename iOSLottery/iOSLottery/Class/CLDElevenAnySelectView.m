//
//  CLDElevenAnySelectView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenAnySelectView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLDEOneGroupBetNmuberView.h"
#import "CLDEBetButton.h"
#import "CLFTImageLabel.h"
#import "CLDEAnyBetTerm.h"
#import "AppDelegate.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"

@interface CLDElevenAnySelectView (){
    
    NSInteger __randomAnimationIndex;
}
@property (nonatomic, strong) UILabel *awardInfoLabel;//中奖奖金 说明label
@property (nonatomic, strong) UIButton *shakeButton;//摇一摇动画
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) CLDEOneGroupBetNmuberView *oneGroupBetButton;//一组按钮
@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;//自身所代表的玩法
@property (nonatomic, strong) NSMutableArray *randomAnimationArray;//执行随机动画的数组
@property (nonatomic, strong) CLFTImageLabel *selectNumber;//选号 标签
@property (nonatomic, strong) CLFTImageLabel *omissionTag;
@property (nonatomic, strong) NSString *activityUrl;

@end
@implementation CLDElevenAnySelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
        [self addSubview:self.shakeButton];
        [self addSubview:self.activityButton];
        [self addSubview:self.awardInfoLabel];
        [self addSubview:self.selectNumber];
        [self addSubview:self.oneGroupBetButton];
        [self addSubview:self.omissionTag];
        [self configConstraint];

    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDEAnyBetTerm *)betTerm{
    
    for (NSString *tagStr in betTerm.betTermArray) {
        [self.oneGroupBetButton selectBetButtonWithTag:[tagStr integerValue]];
    }
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(14.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(__SCALE(- 20.f));
        make.centerY.equalTo(self.shakeButton);
    }];
    
    [self.awardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(15.f));
    }];
    [self.selectNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.width.mas_equalTo(__SCALE(40.f));
        make.centerY.equalTo(self.oneGroupBetButton.mas_top).offset(__SCALE(17.f));
    }];
    [self.oneGroupBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectNumber.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self);
        make.top.equalTo(self.awardInfoLabel.mas_bottom).offset(__SCALE(10));
    }];
    
    [self.omissionTag mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.selectNumber);
        make.centerY.equalTo(self.oneGroupBetButton.mas_top).offset(__SCALE((34.f + 12.5f)));
    }];
}
#pragma mark - 摇一摇 随机选号
- (void)randomSelectedNumber{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            [self randomAnyTwoNumber];
            break;
        case CLDElevenPlayMothedTypeThree:
            [self randomAnyThreeNumber];
            break;
        case CLDElevenPlayMothedTypeFour:
            [self randomAnyFourNumber];
            break;
        case CLDElevenPlayMothedTypeFive:
            [self randomAnyFiveNumber];
            break;
        case CLDElevenPlayMothedTypeSix:
            [self randomAnySixNumber];
            break;
        case CLDElevenPlayMothedTypeSeven:
            [self randomAnySevenNumber];
            break;
        case CLDElevenPlayMothedTypeEight:
            [self randomAnyEightNumber];
            break;
        case CLDElevenPlayMothedTypePreOne:
            [self randomPreOneNumber];
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            [self randomAnyTwoNumber];
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            [self randomAnyThreeNumber];
            break;
        default:
            break;
    }
}
#pragma mark - 执行随机动画
- (void)startRandomAnimation{
    WS(_weakSelf)
    for (CLDEBetButton *betBtn in self.randomAnimationArray) {
        betBtn.animationStopBlock = ^(){
            
            [_weakSelf preBetViewAnimationStop];
        };
    }
    __randomAnimationIndex = 0;
    if (self.randomAnimationArray.count > __randomAnimationIndex) {
        //关闭屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = NO;
        
        ((CLDEBetButton *)self.randomAnimationArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomAnimationArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }
}
#pragma mark - 上一次动画执行结束
- (void)preBetViewAnimationStop{
    
    if (self.randomAnimationArray.count > __randomAnimationIndex) {
        ((CLDEBetButton *)self.randomAnimationArray[__randomAnimationIndex]).randomAnimation = YES;
        ((CLDEBetButton *)self.randomAnimationArray[__randomAnimationIndex]).selected = YES;
        __randomAnimationIndex++;
    }else{
        //打开屏幕点击事件触发
        ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.userInteractionEnabled = YES;
    }
}
#pragma mark - 任选二 的随机动画
- (void)randomAnyTwoNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:2]]];
    [self startRandomAnimation];
}
#pragma mark - 任选三 的随机动画
- (void)randomAnyThreeNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:3]]];
    [self startRandomAnimation];
}
#pragma mark - 任选四 的随机动画
- (void)randomAnyFourNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:4]]];
    [self startRandomAnimation];
}
#pragma mark - 任选五 的随机动画
- (void)randomAnyFiveNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:5]]];
    [self startRandomAnimation];
}
#pragma mark - 任选六 的随机动画
- (void)randomAnySixNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:6]]];
    [self startRandomAnimation];
}
#pragma mark - 任选七 的随机动画
- (void)randomAnySevenNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:7]]];
    [self startRandomAnimation];
}
#pragma mark - 任选八 的随机动画
- (void)randomAnyEightNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:8]]];
    [self startRandomAnimation];
}
#pragma mark - 前一 的随机动画
- (void)randomPreOneNumber{
    
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:[self randomArrayWithCount:1]]];
    [self startRandomAnimation];
}
#pragma mark - 生成不重复的随机数
-(NSArray *)randomArrayWithCount:(NSInteger)count
{
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i < MAXFLOAT; i++) {
        NSInteger randomNumber = arc4random() % 11 + 1;
        BOOL isStore = YES;
        for (NSNumber *number in resultArray) {
            if ([number integerValue] == randomNumber) {
                isStore = NO;
            }
        }
        if (isStore) {
            [resultArray addObject:@(randomNumber)];
        }
        if (resultArray.count == count) {
            break;
        }
    }
    return resultArray;
}
- (void)de_setOmissionData:(NSArray *)omission{
    
    if (omission && omission.count == 11) {
        
        [self.oneGroupBetButton setOmissionData:omission];
    }else{
        [self.oneGroupBetButton setDefaultOmission];
    }
}
#pragma mark ------------ event Response ------------
#pragma mark - 摇一摇
- (void)shakeButtonOnClick:(UIButton *)btn{
    
    [self randomSelectedNumber];
}
#pragma mark - 按钮选中状态发生改变
- (void)selectStateChange:(CLDEBetButton *)betButton{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", betButton.tag];
    if (betButton.selected) {
        
        if ([self.anyBetTerm.betTermArray indexOfObject:betStr] == NSNotFound) {
            [self.anyBetTerm.betTermArray addObject:betStr];
        }
    }else{
        
        if ([self.anyBetTerm.betTermArray indexOfObject:betStr] != NSNotFound) {
            [self.anyBetTerm.betTermArray removeObject:betStr];
        }
    }
    
    self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.anyBetTerm.betNote, self.anyBetTerm.minBetBonus, self.anyBetTerm.MaxBetBonus) : nil;
    
}
- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------所有投注页面的共同属性 delegate ------------
- (void)setPlayMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    self.currentPlayMothedType = playMothedType;
    self.anyBetTerm.playMothedType = playMothedType;
}
- (CLDElevenPlayMothedType)playMothedType{
    
    return self.currentPlayMothedType;
}
- (BOOL)de_hasSelectedBetButton{
    
    return self.anyBetTerm.betTermArray.count > 0;
}
- (void)clearAllBetButton{
    
    [self.oneGroupBetButton clearAllBet];
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
- (void)assignBonusInfo:(NSString *)bonusInfo{
        
    [self.awardInfoLabel attributeWithText:bonusInfo beginTag:@"^" endTag:@"&" color:THEME_COLOR];
}
#pragma mark - 配置奖级
- (void)assignAward:(CLDEBonusInfo *)awardInfo{
    
    self.anyBetTerm.bonusInfo = awardInfo;
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    //当前该页面显示的时候 刷新底部视图的奖金信息
    if (!hidden) {
        self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.anyBetTerm.betNote, self.anyBetTerm.minBetBonus, self.anyBetTerm.MaxBetBonus) : nil;
    }
}
#pragma mark ------------ getter Mothed ------------
- (UIButton *)shakeButton{
    
    if (!_shakeButton) {
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"DE_shakeImage.png"] forState:UIControlStateNormal];
    }
    return _shakeButton;
}
- (CLTwoImageButton *)activityButton{
    
    if (!_activityButton) {
        _activityButton = [[CLTwoImageButton alloc] init];
        _activityButton.hidden = YES;
//        [_activityButton setTitle:@"史无前例大加奖" forState:UIControlStateNormal];
        [_activityButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _activityButton.titleLabel.font = FONT_SCALE(14);
        _activityButton.leftImage = [UIImage imageNamed:@"de_star.png"];
        _activityButton.rightImage = [UIImage imageNamed:@"de_arrow.png"];
        [_activityButton addTarget:self action:@selector(activityButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _activityButton;
}
- (UILabel *)awardInfoLabel{
    
    if (!_awardInfoLabel) {
        _awardInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _awardInfoLabel.textColor = UIColorFromRGB(0x333333);
        _awardInfoLabel.font = FONT_SCALE(14);
        _awardInfoLabel.numberOfLines = 0;
        NSString *text = @"至少选2个号， 猜对任意2个开奖号即中6元";
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(text.length - 2, 1) Color:UIColorFromRGB(0xd90000)];
        [_awardInfoLabel attributeWithText:text controParams:@[params]];
        //_awardInfoLabel.backgroundColor = [UIColor redColor];
    }
    return _awardInfoLabel;
}
- (CLFTImageLabel *)selectNumber{
    
    if (!_selectNumber) {
        _selectNumber = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _selectNumber.contentString = @"选号";
        _selectNumber.contentFont = FONT_SCALE(13);
        _selectNumber.contentColor = UIColorFromRGB(0x333333);
        _selectNumber.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _selectNumber;
}
- (CLFTImageLabel *)omissionTag{
    
    if (!_omissionTag) {
        _omissionTag = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _omissionTag.contentString = @"遗漏";
        _omissionTag.contentFont = FONT_SCALE(13);
        _omissionTag.contentColor = UIColorFromRGB(0x988366);
        _omissionTag.backImage = [UIImage imageNamed:@""];
        _omissionTag.onClickBlock = ^(){
            
            NSLog(@"展示遗漏弹窗");
            [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeD11];
        };
    }
    return _omissionTag;
}
- (CLDEOneGroupBetNmuberView *)oneGroupBetButton{
    
    WS(_weakSelf)
    if (!_oneGroupBetButton) {
        _oneGroupBetButton = [[CLDEOneGroupBetNmuberView alloc] initWithFrame:CGRectZero];
        _oneGroupBetButton.selectStateChangeBlock = ^(CLDEBetButton *betButton){
            
            [_weakSelf selectStateChange:betButton];
        };
    }
    return _oneGroupBetButton;
}
- (NSMutableArray *)randomAnimationArray{
    
    if (!_randomAnimationArray) {
        _randomAnimationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _randomAnimationArray;
}
- (CLDEAnyBetTerm *)anyBetTerm{
    
    if (!_anyBetTerm) {
        _anyBetTerm = [[CLDEAnyBetTerm alloc] init];
    }
    return _anyBetTerm;
}
@end
