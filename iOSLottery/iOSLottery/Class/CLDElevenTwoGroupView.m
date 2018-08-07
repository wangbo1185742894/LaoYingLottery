//
//  CLDElevenTwoGroupView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/1.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenTwoGroupView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLDEOneGroupBetNmuberView.h"
#import "CLDEBetButton.h"
#import "CLFTImageLabel.h"
#import "CLPreTwoDirectBetManager.h"
#import "CLDETwoGroupBetTerm.h"
#import "AppDelegate.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"

@interface CLDElevenTwoGroupView (){
    
    NSInteger __randomAnimationIndex;
}
@property (nonatomic, strong) UILabel *firstAwardInfoLabel;//第一组 中奖奖金 说明label
@property (nonatomic, strong) UIButton *shakeButton;//摇一摇动画
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) CLDEOneGroupBetNmuberView *oneGroupBetButton;//一组按钮
@property (nonatomic, strong) CLDEOneGroupBetNmuberView *secondGroupBetButton;//第二组按钮
@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;//自身所代表的玩法
@property (nonatomic, strong) NSMutableArray *betButtonArray;//投注按钮的数组
@property (nonatomic, strong) NSMutableArray *randomAnimationArray;//执行随机动画的数组
@property (nonatomic, strong) CLFTImageLabel *firstTagLabel;//第一位
@property (nonatomic, strong) CLFTImageLabel *secondTagLabel;//第二位
//@property (nonatomic, strong) UIView *lineView;//中间线
@property (nonatomic, strong) CLFTImageLabel *firstOmissionLabel;//第一位
@property (nonatomic, strong) CLFTImageLabel *secondOmissionLabel;//第二位
@property (nonatomic, strong) NSString *activityUrl;
@end
@implementation CLDElevenTwoGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
        [self addSubview:self.shakeButton];
        [self addSubview:self.activityButton];
        [self addSubview:self.firstAwardInfoLabel];
        [self addSubview:self.firstTagLabel];
        [self addSubview:self.secondTagLabel];
        [self addSubview:self.firstOmissionLabel];
        [self addSubview:self.secondOmissionLabel];
//        [self addSubview:self.lineView];
        [self addSubview:self.oneGroupBetButton];
        [self addSubview:self.secondGroupBetButton];
        [self configConstraint];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDETwoGroupBetTerm *)betTerm{
    
    for (NSString *tagStr in betTerm.firstBetTermArray) {
        [self.oneGroupBetButton selectBetButtonWithTag:[tagStr integerValue]];
    }
    for (NSString *tagStr in betTerm.secondBetTermArray) {
        [self.secondGroupBetButton selectBetButtonWithTag:[tagStr integerValue]];
    }
}
#pragma mark - 配置遗漏
- (void)de_setOmissionData:(NSArray *)omission{
    
    if (omission && omission.count == 22) {
        
        [self.oneGroupBetButton setOmissionData:[omission subarrayWithRange:NSMakeRange(0, 11)]];
        [self.secondGroupBetButton setOmissionData:[omission subarrayWithRange:NSMakeRange(11, 11)]];
    }else{
        [self.oneGroupBetButton setDefaultOmission];
        [self.secondGroupBetButton setDefaultOmission];
    }
}
#pragma mark - 配置奖级
- (void)assignAward:(CLDEBonusInfo *)awardInfo{
    
    self.betManager.bonusInfo = awardInfo;
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.shakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(101));
        make.height.mas_equalTo(__SCALE(30));
    }];
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(__SCALE(- 20.f));
        make.centerY.equalTo(self.shakeButton);
    }];
    [self.firstAwardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.top.equalTo(self.shakeButton.mas_bottom).offset(__SCALE(20.f));
    }];
    [self.firstTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.width.mas_equalTo(__SCALE(50.f));
        make.centerY.equalTo(self.oneGroupBetButton.mas_top).offset(__SCALE(17.f));
    }];
    [self.secondTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.width.mas_equalTo(__SCALE(50.f));
        make.centerY.equalTo(self.secondGroupBetButton.mas_top).offset(__SCALE(17.f));
    }];
    
    [self.firstOmissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.firstTagLabel);
        make.centerY.equalTo(self.oneGroupBetButton.mas_top).offset(__SCALE((34.f + 12.5f)));
    }];
    [self.secondOmissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.firstTagLabel);
        make.centerY.equalTo(self.secondGroupBetButton.mas_top).offset(__SCALE((34.f + 12.5f)));
    }];
    
    [self.oneGroupBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstTagLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self);
        make.top.equalTo(self.firstAwardInfoLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    [self.secondGroupBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondTagLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self.oneGroupBetButton);
        make.top.equalTo(self.oneGroupBetButton.mas_bottom).offset(__SCALE(20.f));
    }];
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.oneGroupBetButton.mas_bottom).offset(__SCALE(15.f));
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(1.f);
//    }];
}
#pragma mark - 开启随机选号
- (void)randomSelectedNumber{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypePreTwoDirect:
            [self randomPreTwoGroupNumber];
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
#pragma mark - 前二组选 的随机动画
- (void)randomPreTwoGroupNumber{
    
    NSArray *randomArray = [self randomArrayWithCount:2];
    [self.randomAnimationArray removeAllObjects];
    [self.randomAnimationArray addObjectsFromArray:[self.oneGroupBetButton randomSelectNumberWithArray:@[randomArray[0]]]];
    [self.randomAnimationArray addObjectsFromArray:[self.secondGroupBetButton randomSelectNumberWithArray:@[randomArray[1]]]];
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
#pragma mark ------------ event Response ------------
#pragma mark - 摇一摇按钮事件
- (void)shakeButtonOnClick:(UIButton *)btn{
    
    [self randomSelectedNumber];
}
#pragma mark - 第一组按钮选中状态改变
- (void)firstBetButtonSelectStateChange:(CLDEBetButton *)betButton{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", betButton.tag];
    if (betButton.selected) {
        if ([self.betManager.firstBetTermArray indexOfObject:betStr] == NSNotFound) {
            [self.betManager.firstBetTermArray addObject:betStr];
        }
    }else{
        if ([self.betManager.firstBetTermArray indexOfObject:betStr] != NSNotFound) {
            [self.betManager.firstBetTermArray removeObject:betStr];
        }
    }
    self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.betManager.betNote, self.betManager.minBetBonus, self.betManager.MaxBetBonus) : nil;
}
#pragma mark - 第二组按钮选中状态改变
- (void)secondBetButtonSelectStateChange:(CLDEBetButton *)betButton{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", betButton.tag];
    if (betButton.selected) {
        if ([self.betManager.secondBetTermArray indexOfObject:betStr] == NSNotFound) {
            [self.betManager.secondBetTermArray addObject:betStr];
        }
    }else{
        if ([self.betManager.secondBetTermArray indexOfObject:betStr] != NSNotFound) {
            [self.betManager.secondBetTermArray removeObject:betStr];
        }
    }
    self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.betManager.betNote, self.betManager.minBetBonus, self.betManager.MaxBetBonus) : nil;
}
- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------所有投注页面的共同属性 delegate ------------
- (void)setPlayMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    self.currentPlayMothedType = playMothedType;
}
- (CLDElevenPlayMothedType)playMothedType{
    
    return self.currentPlayMothedType;
}
- (BOOL)de_hasSelectedBetButton{
    
    return (self.betManager.firstBetTermArray.count + self.betManager.secondBetTermArray.count) > 0;
}
- (void)clearAllBetButton{
    
    [self.oneGroupBetButton clearAllBet];
    [self.secondGroupBetButton clearAllBet];
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
    
    [self.firstAwardInfoLabel attributeWithText:bonusInfo beginTag:@"^" endTag:@"&" color:THEME_COLOR];
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    //当前该页面显示的时候 刷新底部视图的奖金信息
    if (!hidden) {
        self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.betManager.betNote, self.betManager.minBetBonus, self.betManager.MaxBetBonus) : nil;
    }
}
#pragma mark ------------ getter Mothed ------------
- (UIButton *)shakeButton{
    
    if (!_shakeButton) {
        _shakeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shakeButton setBackgroundImage:[UIImage imageNamed:@"DE_shakeImage.png"] forState:UIControlStateNormal];
        [_shakeButton addTarget:self action:@selector(shakeButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
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
- (UILabel *)firstAwardInfoLabel{
    
    if (!_firstAwardInfoLabel) {
        _firstAwardInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _firstAwardInfoLabel.textColor = UIColorFromRGB(0x333333);
        _firstAwardInfoLabel.font = FONT_SCALE(14);
        _firstAwardInfoLabel.numberOfLines = 0;
        NSString *text = @"每位至少选1个号，按位猜对前2个开奖号即中130元";
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(text.length - 4, 3) Color:UIColorFromRGB(0xd90000)];
        [_firstAwardInfoLabel attributeWithText:text controParams:@[params]];
    }
    return _firstAwardInfoLabel;
}
- (CLFTImageLabel *)firstTagLabel{
    
    if (!_firstTagLabel) {
        _firstTagLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _firstTagLabel.contentString = @"第一位";
        _firstTagLabel.contentFont = FONT_SCALE(13);
        _firstTagLabel.contentColor = UIColorFromRGB(0x333333);
        _firstTagLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _firstTagLabel;
}
- (CLFTImageLabel *)secondTagLabel{
    
    if (!_secondTagLabel) {
        _secondTagLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _secondTagLabel.contentString = @"第二位";
        _secondTagLabel.contentFont = FONT_SCALE(13);
        _secondTagLabel.contentColor = UIColorFromRGB(0x333333);
        _secondTagLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _secondTagLabel;
}

- (CLFTImageLabel *)firstOmissionLabel{
    
    if (!_firstOmissionLabel) {
        _firstOmissionLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _firstOmissionLabel.contentString = @"遗漏";
        _firstOmissionLabel.contentFont = FONT_SCALE(13);
        _firstOmissionLabel.contentColor = UIColorFromRGB(0x988366);
        _firstOmissionLabel.backImage = [UIImage imageNamed:@""];
        _firstOmissionLabel.onClickBlock = ^(){
            
            NSLog(@"点击了遗漏");
        };
    }
    return _firstOmissionLabel;
}
- (CLFTImageLabel *)secondOmissionLabel{
    
    if (!_secondOmissionLabel) {
        _secondOmissionLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _secondOmissionLabel.contentString = @"遗漏";
        _secondOmissionLabel.contentFont = FONT_SCALE(13);
        _secondOmissionLabel.contentColor = UIColorFromRGB(0x988366);
        _secondOmissionLabel.backImage = [UIImage imageNamed:@""];
        _secondOmissionLabel.onClickBlock = ^(){
           
            NSLog(@"点击了遗漏");
        };
    }
    return _secondOmissionLabel;
}
- (CLDEOneGroupBetNmuberView *)oneGroupBetButton{
    
    WS(_weakSelf)
    if (!_oneGroupBetButton) {
        _oneGroupBetButton = [[CLDEOneGroupBetNmuberView alloc] initWithFrame:CGRectZero];
        _oneGroupBetButton.selectStateChangeBlock = ^(CLDEBetButton *betButton){
            
            [_weakSelf firstBetButtonSelectStateChange:betButton];
        };
    }
    return _oneGroupBetButton;
}
- (CLDEOneGroupBetNmuberView *)secondGroupBetButton{
    
    WS(_weakSelf)
    if (!_secondGroupBetButton) {
        _secondGroupBetButton = [[CLDEOneGroupBetNmuberView alloc] initWithFrame:CGRectZero];
        _secondGroupBetButton.selectStateChangeBlock = ^(CLDEBetButton *betButton){
            
            [_weakSelf secondBetButtonSelectStateChange:betButton];
        };
    }
    return _secondGroupBetButton;
}

- (NSMutableArray *)betButtonArray{
    
    if (!_betButtonArray) {
        _betButtonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _betButtonArray;
}
- (NSMutableArray *)randomAnimationArray{
    
    if (!_randomAnimationArray) {
        _randomAnimationArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _randomAnimationArray;
}
- (CLPreTwoDirectBetManager *)betManager{
    
    if (!_betManager) {
        _betManager = [[CLPreTwoDirectBetManager alloc] init];
    }
    return _betManager;
}
@end
