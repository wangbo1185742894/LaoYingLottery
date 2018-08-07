//
//  CLDElevenDanTuoView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenDanTuoView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLDEOneGroupBetNmuberView.h"
#import "CLDEBetButton.h"
#import "CLFTImageLabel.h"
#import "CLDEDTBetTerm.h"
#import "CLShowHUDManager.h"
#import "CLAllJumpManager.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"

#import "CLLotteryOmissionView.h"

typedef NS_ENUM(NSInteger, CLDElevenDTType) {
    
    CLDElevenDTTypeDan,
    CLDElevenDTTypeTuo
};

@interface CLDElevenDanTuoView (){
    
    NSInteger __randomAnimationIndex;
}

/**
 中奖奖金 说明label
 */
@property (nonatomic, strong) UILabel *awardInfoLabel;
@property (nonatomic, strong) UIButton *danTuoInfoButton;//什么是胆拖?
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) CLDEOneGroupBetNmuberView *danGroupBetButton;//胆 组按钮
@property (nonatomic, strong) CLDEOneGroupBetNmuberView *tuoGroupBetButton;//拖 组按钮
@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;//自身所代表的玩法
@property (nonatomic, strong) NSMutableArray *betButtonArray;//投注按钮的数组
@property (nonatomic, strong) NSMutableArray *randomAnimationArray;//执行随机动画的数组
@property (nonatomic, strong) CLFTImageLabel *danTagLabel;//拖码
@property (nonatomic, strong) CLFTImageLabel *tuoTagLabel;//胆码
@property (nonatomic, strong) UILabel *mustOutLabel;//必出的label
@property (nonatomic, strong) UILabel *possibilityOutLabel;//可能出的label
@property (nonatomic, strong) CLFTImageLabel *danOmissionLabel;//拖码
@property (nonatomic, strong) CLFTImageLabel *tuoOmissionLabel;//胆码
@property (nonatomic, strong) NSString *activityUrl;

@end

@implementation CLDElevenDanTuoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
        
        [self addSubview:self.danTuoInfoButton];
        [self addSubview:self.activityButton];
        [self addSubview:self.awardInfoLabel];
        [self addSubview:self.danTagLabel];
        [self addSubview:self.tuoTagLabel];
        [self addSubview:self.danOmissionLabel];
        [self addSubview:self.tuoOmissionLabel];
        [self addSubview:self.mustOutLabel];
        [self addSubview:self.possibilityOutLabel];
        [self addSubview:self.explainInfoLabel];
        [self addSubview:self.tuoExplainInfoLabel];
        [self addSubview:self.danGroupBetButton];
        [self addSubview:self.tuoGroupBetButton];
        
        [self configConstraint];
    }
    return self;
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认选中项
- (void)assignSelectBetButtonWithData:(CLDEDTBetTerm *)betTerm{
    
    for (NSString *tagStr in betTerm.danBetTermArray) {
        [self.danGroupBetButton selectBetButtonWithTag:[tagStr integerValue]];
    }
    for (NSString *tagStr in betTerm.tuoBetTermArray) {
        [self.tuoGroupBetButton selectBetButtonWithTag:[tagStr integerValue]];
    }
}
#pragma mark - 配置遗漏
- (void)de_setOmissionData:(NSArray *)omission{
    
    if (omission && omission.count == 22) {
        
        [self.danGroupBetButton setOmissionData:[omission subarrayWithRange:NSMakeRange(0, 11)]];
        [self.tuoGroupBetButton setOmissionData:[omission subarrayWithRange:NSMakeRange(11, 11)]];
    }else{
        [self.danGroupBetButton setDefaultOmission];
        [self.tuoGroupBetButton setDefaultOmission];
    }
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 配置约束
- (void)configConstraint{
    
    [self.danTuoInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self).offset(__SCALE(12.f));
    }];
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(__SCALE(-20.f));
        make.centerY.equalTo(self.danTuoInfoButton);
    }];
    
    [self.awardInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danTuoInfoButton);
        make.right.equalTo(self).offset(__SCALE(-5.f));
        make.top.equalTo(self.danTuoInfoButton.mas_bottom).offset(__SCALE(5.f));
    }];
    [self.danTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.width.mas_equalTo(__SCALE(40.f));
        make.top.equalTo(self.awardInfoLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    [self.mustOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danGroupBetButton.mas_left).offset(__SCALE(5.f));
        make.centerY.equalTo(self.danTagLabel);
    }];
    [self.explainInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mustOutLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.mustOutLabel);
    }];
    [self.danGroupBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danTagLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self);
        make.top.equalTo(self.danTagLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    
    [self.tuoTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.width.equalTo(self.danTagLabel);
        make.top.equalTo(self.danGroupBetButton.mas_bottom).offset(__SCALE(20.f));
    }];
    [self.possibilityOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tuoGroupBetButton).offset(__SCALE(5.f));
        make.centerY.equalTo(self.tuoTagLabel);
    }];
    
    [self.danOmissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.danTagLabel);
        make.centerY.equalTo(self.danGroupBetButton.mas_top).offset(__SCALE((34.f + 12.5f)));
    }];
    
    [self.tuoOmissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.danTagLabel);
        make.centerY.equalTo(self.tuoGroupBetButton.mas_top).offset(__SCALE((34.f + 12.5f)));
    }];
    
    [self.tuoExplainInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.possibilityOutLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.possibilityOutLabel);
    }];
    
    [self.tuoGroupBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tuoTagLabel.mas_right).offset(__SCALE(5.f));
        make.right.equalTo(self.danGroupBetButton);
        make.top.equalTo(self.possibilityOutLabel.mas_bottom).offset(__SCALE(10.f));
    }];
}
#pragma mark - 配置胆拖互斥关系 （参数：当前选中betButton的tag值 需要互斥的类型）
- (void)configMutualExclusionWithTag:(CLDEBetButton *)betButton type:(CLDElevenDTType)dElevenType{
    
    if (dElevenType == CLDElevenDTTypeDan) {
        
        if (betButton.selected) {
            [self.danGroupBetButton changeMutualExclusionBetButton:betButton.tag];
        }
    }else if (dElevenType == CLDElevenDTTypeTuo){
        
        if (betButton.selected) {
            [self.tuoGroupBetButton changeMutualExclusionBetButton:betButton.tag];
        }
    }
     
}
#pragma mark - 按钮选中状态改变
- (void)danSelectStateChange:(CLDEBetButton *)betButton{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", betButton.tag];
    if (betButton.selected) {
        if ([self.dt_BetTerm.danBetTermArray indexOfObject:betStr] == NSNotFound) {
            [self.dt_BetTerm.danBetTermArray addObject:betStr];
        }
    }else{
        if ([self.dt_BetTerm.danBetTermArray indexOfObject:betStr] != NSNotFound) {
            [self.dt_BetTerm.danBetTermArray removeObject:betStr];
        }
    }
    self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.dt_BetTerm.betNote, self.dt_BetTerm.minBetBonus, self.dt_BetTerm.MaxBetBonus) : nil;
}
- (void)tuoSelectStateChange:(CLDEBetButton *)betButton{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", betButton.tag];
    if (betButton.selected) {
        if ([self.dt_BetTerm.tuoBetTermArray indexOfObject:betStr] == NSNotFound) {
            [self.dt_BetTerm.tuoBetTermArray addObject:betStr];
        }
    }else{
        if ([self.dt_BetTerm.tuoBetTermArray indexOfObject:betStr] != NSNotFound) {
            [self.dt_BetTerm.tuoBetTermArray removeObject:betStr];
        }
    }
    self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.dt_BetTerm.betNote, self.dt_BetTerm.minBetBonus, self.dt_BetTerm.MaxBetBonus) : nil;
}
#pragma mark - 配置胆码最大个数 和 胆拖 最大选择个数的弹窗提醒
- (void)configDTMaxSelectCount{
    
    WS(_weakSelf)
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeDTTwo:{
            self.danGroupBetButton.maxSelectedCount = 1;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选二最多选择1个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选二最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            self.danGroupBetButton.maxSelectedCount = 2;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选三最多选择2个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选三最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            self.danGroupBetButton.maxSelectedCount = 3;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选四最多选择3个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选四最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            self.danGroupBetButton.maxSelectedCount = 4;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选五最多选择4个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选五最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            self.danGroupBetButton.maxSelectedCount = 5;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选六最多选择5个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选六最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            self.danGroupBetButton.maxSelectedCount = 6;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选七最多选择6个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选七最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            self.danGroupBetButton.maxSelectedCount = 7;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选八最多选择7个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"任选八最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            self.danGroupBetButton.maxSelectedCount = 1;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"前二组选最多选择1个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"前二组选最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            self.danGroupBetButton.maxSelectedCount = 2;
            self.danGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"前三组选最多选择2个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
            self.tuoGroupBetButton.needShowHUDBlock = ^(){
                [CLShowHUDManager showHUDWithView:_weakSelf text:@"前三组选最多选择10个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            };
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark ------------ event Response ------------
#pragma mark - 什么是胆拖
- (void)danTuoInfoButtonOnClick:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:@"http://m.caiqr.com/help/courageStatment.html"];
}

- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------所有投注页面的共同属性 delegate ------------
- (void)setPlayMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    self.currentPlayMothedType = playMothedType;
    self.dt_BetTerm.playMothedType = playMothedType;
    [self configDTMaxSelectCount];
    
}
- (CLDElevenPlayMothedType)playMothedType{
    
    return self.currentPlayMothedType;
}
- (BOOL)de_hasSelectedBetButton{
    
    return (self.dt_BetTerm.danBetTermArray.count + self.dt_BetTerm.tuoBetTermArray.count) > 0;
}
- (void)clearAllBetButton{
    
    [self.danGroupBetButton clearAllBet];
    [self.tuoGroupBetButton clearAllBet];
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
                
                make.centerY.equalTo(self.danTuoInfoButton);
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
    
    self.dt_BetTerm.bonusInfo = awardInfo;
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    //当前该页面显示的时候 刷新底部视图的奖金信息
    if (!hidden) {
        self.callBackNoteBonusBlock ? self.callBackNoteBonusBlock(self.dt_BetTerm.betNote, self.dt_BetTerm.minBetBonus, self.dt_BetTerm.MaxBetBonus) : nil;
    }
}

#pragma mark ------------ getter Mothed ------------
- (UIButton *)danTuoInfoButton{
    
    if (!_danTuoInfoButton) {
        _danTuoInfoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_danTuoInfoButton setTitle:@"什么是胆拖？" forState:UIControlStateNormal];
        [_danTuoInfoButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _danTuoInfoButton.titleLabel.font = FONT_SCALE(14);
        [_danTuoInfoButton addTarget:self action:@selector(danTuoInfoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danTuoInfoButton;
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
        NSString *text = @"猜对任意2个开奖号即中6元";
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(text.length - 2, 1) Color:UIColorFromRGB(0xd90000)];
        [_awardInfoLabel attributeWithText:text controParams:@[params]];
    }
    return _awardInfoLabel;
}
- (CLFTImageLabel *)danTagLabel{
    
    if (!_danTagLabel) {
        _danTagLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _danTagLabel.contentString = @"胆码";
        _danTagLabel.contentFont = FONT_SCALE(13.f);
        _danTagLabel.contentColor = UIColorFromRGB(0x333333);
        _danTagLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _danTagLabel;
}
- (CLFTImageLabel *)tuoTagLabel{
    
    if (!_tuoTagLabel) {
        _tuoTagLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tuoTagLabel.contentString = @"拖码";
        _tuoTagLabel.contentColor = UIColorFromRGB(0x333333);
        _tuoTagLabel.contentFont = FONT_SCALE(13.f);
        _tuoTagLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _tuoTagLabel;
}
- (CLFTImageLabel *)danOmissionLabel{
    
    if (!_danOmissionLabel) {
        _danOmissionLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _danOmissionLabel.contentString = @"遗漏";
        _danOmissionLabel.contentFont = FONT_SCALE(13.f);
        _danOmissionLabel.contentColor = UIColorFromRGB(0x988366);
        _danOmissionLabel.backImage = [UIImage imageNamed:@""];
        _danOmissionLabel.onClickBlock = ^(){
            
            NSLog(@"点击了遗漏");
            [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeD11];
        };
    }
    return _danOmissionLabel;
}
- (CLFTImageLabel *)tuoOmissionLabel{
    
    if (!_tuoOmissionLabel) {
        _tuoOmissionLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tuoOmissionLabel.contentString = @"遗漏";
        _tuoOmissionLabel.contentColor = UIColorFromRGB(0x988366);
        _tuoOmissionLabel.contentFont = FONT_SCALE(13.f);
        _tuoOmissionLabel.backImage = [UIImage imageNamed:@""];
        _tuoOmissionLabel.onClickBlock = ^(){
            
            NSLog(@"点击了遗漏");
            [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeD11];
        };
    }
    return _tuoOmissionLabel;
}
- (CLDEOneGroupBetNmuberView *)danGroupBetButton{
    
    WS(_weakSelf)
    if (!_danGroupBetButton) {
        _danGroupBetButton = [[CLDEOneGroupBetNmuberView alloc] initWithFrame:CGRectZero];
        _danGroupBetButton.selectStateChangeBlock = ^(CLDEBetButton *betButton){
            [_weakSelf configMutualExclusionWithTag:betButton type:CLDElevenDTTypeTuo];
            [_weakSelf danSelectStateChange:betButton];
        };
    }
    return _danGroupBetButton;
}
- (CLDEOneGroupBetNmuberView *)tuoGroupBetButton{
    
    WS(_weakSelf)
    if (!_tuoGroupBetButton) {
        _tuoGroupBetButton = [[CLDEOneGroupBetNmuberView alloc] initWithFrame:CGRectZero];
        _tuoGroupBetButton.maxSelectedCount = 10;
        _tuoGroupBetButton.selectStateChangeBlock = ^(CLDEBetButton *betButton){
            [_weakSelf configMutualExclusionWithTag:betButton type:CLDElevenDTTypeDan];
            [_weakSelf tuoSelectStateChange:betButton];
        };
    }
    return _tuoGroupBetButton;
}
- (UILabel *)mustOutLabel{
    
    if (!_mustOutLabel) {
        _mustOutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _mustOutLabel.text = @"我认为必出的号码";
        _mustOutLabel.font = FONT_SCALE(13);
        _mustOutLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _mustOutLabel;
}
- (UILabel *)possibilityOutLabel{
    
    if (!_possibilityOutLabel) {
        _possibilityOutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _possibilityOutLabel.text = @"我认为可能出的号码";
        _possibilityOutLabel.font = FONT_SCALE(13);
        _possibilityOutLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _possibilityOutLabel;
}
- (UILabel *)explainInfoLabel{
    
    if (!_explainInfoLabel) {
        _explainInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _explainInfoLabel.text = @"请选1个";
        _explainInfoLabel.font = FONT_SCALE(13);
        _explainInfoLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _explainInfoLabel;
}
- (UILabel *)tuoExplainInfoLabel{
    
    if (!_tuoExplainInfoLabel) {
        _tuoExplainInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        _tuoExplainInfoLabel.font = FONT_SCALE(13);
        _tuoExplainInfoLabel.textColor = UIColorFromRGB(0x666666);
    }
    return _tuoExplainInfoLabel;
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
- (CLDEDTBetTerm *)dt_BetTerm{
    
    if (!_dt_BetTerm) {
        _dt_BetTerm = [[CLDEDTBetTerm alloc] init];
    }
    return _dt_BetTerm;
}

@end
