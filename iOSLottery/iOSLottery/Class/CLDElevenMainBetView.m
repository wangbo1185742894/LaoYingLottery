
//
//  CLDElevenMainBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenMainBetView.h"
#import "CLDElevenConfigMessage.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLDEBonusInfo.h"
#import "CLLotteryDataManager.h"
//普通投注 任选
#import "CLDElevenAnySelectView.h"
#import "CLDEAnyBetTerm.h"
//两组投注 前二直选
#import "CLDElevenTwoGroupView.h"
#import "CLPreTwoDirectBetManager.h"
//前三组选
#import "CLDElevenThreeGroupView.h"
#import "CLDEPreThreeDirectBetManager.h"
//胆拖View
#import "CLDElevenDanTuoView.h"
#import "CLDEDTBetTerm.h"
#import "CLShowHUDManager.h"
@interface CLDElevenMainBetView ()
@property (nonatomic, strong) NSMutableArray *viewArray;//所有玩法View的数组
@property (nonatomic, strong) NSMutableDictionary *viewDictionary;//所有玩法View的字典

@property (nonatomic, assign) CLDElevenPlayMothedType currentPlayMothedType;//当前玩法
@property (nonatomic, strong) CLDEBonusInfo *bonusInfo;

@property (nonatomic, strong) CLDElevenAnySelectView *anyTwoView;//任选二
@property (nonatomic, strong) CLDElevenAnySelectView *anyThreeView;//任选三
@property (nonatomic, strong) CLDElevenAnySelectView *anyFourView;//任选四
@property (nonatomic, strong) CLDElevenAnySelectView *anyFiveView;//任选五
@property (nonatomic, strong) CLDElevenAnySelectView *anySixView;//任选六
@property (nonatomic, strong) CLDElevenAnySelectView *anySevenView;//任选七
@property (nonatomic, strong) CLDElevenAnySelectView *anyEightView;//任选八
@property (nonatomic, strong) CLDElevenAnySelectView *preOneView;//前一
@property (nonatomic, strong) CLDElevenAnySelectView *preTwoGroupView;//前二组选
@property (nonatomic, strong) CLDElevenAnySelectView *preThreeGroupView;//前三组选
@property (nonatomic, strong) CLDElevenTwoGroupView *preTwoDirectView;//前二直选
@property (nonatomic, strong) CLDElevenThreeGroupView *preThreeDirectView;//前三直选
@property (nonatomic, strong) CLDElevenDanTuoView *danAnyTwoView;//胆拖 任选二
@property (nonatomic, strong) CLDElevenDanTuoView *danAnyThreeView;//胆拖 任选三
@property (nonatomic, strong) CLDElevenDanTuoView *danAnyFourView;//胆拖 任选四
@property (nonatomic, strong) CLDElevenDanTuoView *danAnyFiveView;//胆拖 任选五
@property (nonatomic, strong) CLDElevenDanTuoView *danAnySixView;//胆拖 任选六
@property (nonatomic, strong) CLDElevenDanTuoView *danAnySevenView;//胆拖 任选七
@property (nonatomic, strong) CLDElevenDanTuoView *danAnyEightView;//胆拖 任选八
@property (nonatomic, strong) CLDElevenDanTuoView *danPreTwoView;//胆拖 前二组选
@property (nonatomic, strong) CLDElevenDanTuoView *danPreThreeView;//胆拖 前三组选

@end
@implementation CLDElevenMainBetView
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
        self.currentPlayMothedType = CLDElevenPlayMothedTypeTwo;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeNotification) name:dElevenShakeNotification object:nil];
    }
    return self;
}
#pragma mark ------------ private Mothed ------------
#pragma mark - 获取任选View的投注项
- (NSArray *)getAnyBetTermWithView:(CLDElevenAnySelectView *)anyView leastNumber:(NSInteger)leastNumber{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (anyView.anyBetTerm.betNote > 0) {
        [array addObject:anyView.anyBetTerm];
    }else{
        if (anyView.anyBetTerm.betTermArray.count > 0) {
            [CLShowHUDManager showHUDWithView:self text:[NSString stringWithFormat:@"请至少选择%zi个号码", leastNumber] type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else{
            [anyView randomSelectedNumber];
        }
    }
    return array;
}
#pragma mark - 获取前一投注项
- (NSArray *)getPreOneBetTerm{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.preOneView.anyBetTerm.betNote > 0) {
        [array addObject:self.preOneView.anyBetTerm];
    }else{
        [self.preOneView randomSelectedNumber];
    }
    return array;
}
#pragma mark - 获取前二直选 投注项
- (NSArray *)getPreTwoDirectBetTerm{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.preTwoDirectView.betManager.betNote > 0) {
        [array addObjectsFromArray:self.preTwoDirectView.betManager.betTermArray];
    }else{
        if (self.preTwoDirectView.betManager.firstBetTermArray.count == 0 && self.preTwoDirectView.betManager.secondBetTermArray.count == 0) {
            [self.preTwoDirectView randomSelectedNumber];
        }else{
            [CLShowHUDManager showHUDWithView:self text:@"每位至少选1个不同的号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }
    }
    return array;
}
#pragma mark - 获取前三直选 投注项
- (NSArray *)getPreThreeDirectBetTerm{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.preThreeDirectView.betManager.betNote > 0) {
        [array addObjectsFromArray:self.preThreeDirectView.betManager.betTermArray];
    }else{
        if (self.preThreeDirectView.betManager.firstBetTermArray.count == 0 &&
            self.preThreeDirectView.betManager.secondBetTermArray.count == 0 &&
            self.preThreeDirectView.betManager.thirdBetTermArray.count == 0) {
            [self.preThreeDirectView randomSelectedNumber];
        }else{
            [CLShowHUDManager showHUDWithView:self text:@"每位至少选1个不同的号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }
    }
    return array;
}
#pragma mark - 获取任选View的投注项
- (NSArray *)getDTAnyBetTermWithView:(CLDElevenDanTuoView *)anyView leastNumber:(NSInteger)leastNumber playMothedTitle:(NSString *)title{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (anyView.dt_BetTerm.betNote > 0) {
        [array addObject:anyView.dt_BetTerm];
    }else{
        if (anyView.dt_BetTerm.danBetTermArray.count == 0) {
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else if (anyView.dt_BetTerm.tuoBetTermArray.count == 0){
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else if (anyView.dt_BetTerm.danBetTermArray.count + anyView.dt_BetTerm.tuoBetTermArray.count < leastNumber){
            [CLShowHUDManager showHUDWithView:self text:[NSString stringWithFormat:@"%@胆码加拖码至少选择%zi个拖码", title, leastNumber] type:CLShowHUDTypeOnlyText delayTime:1.f];
        }
    }
    return array;
}
#pragma mark ------------ public Mothed ------------
- (void)reloadDataWithPlayMothed:(CLDElevenPlayMothedType)playMothedType{
    
    self.currentPlayMothedType = playMothedType;
    
    if (playMothedType == CLDElevenPlayMothedTypePreThreeDirect) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(550));
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(400));
    }
    
    if (self.viewArray.count == 21) {
        for (UIView<CLDElevenMainBetDelegate> *anySelectedView in self.viewArray) {
            if (anySelectedView.playMothedType == playMothedType) {
                anySelectedView.hidden = NO;
                [self bringSubviewToFront:anySelectedView];
            }else{
                anySelectedView.hidden = YES;
                [self sendSubviewToBack:anySelectedView];
            }
        }
    }else{
        for (CLDElevenAnySelectView *anySelectedView in self.viewArray) {
            anySelectedView.hidden = YES;
        }
        switch (self.currentPlayMothedType) {
            case CLDElevenPlayMothedTypeTwo:
                self.anyTwoView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeThree:
                self.anyThreeView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeFour:
                self.anyFourView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeFive:
                self.anyFiveView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeSix:
                self.anySixView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeSeven:
                self.anySevenView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeEight:
                self.anyEightView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypePreOne:
                self.preOneView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypePreTwoDirect:
                self.preTwoDirectView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypePreTwoGroup:
                self.preTwoGroupView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypePreThreeDirect:
                self.preThreeDirectView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypePreThreeGroup:
                self.preThreeGroupView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTTwo:
                self.danAnyTwoView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTThree:
                self.danAnyThreeView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTFour:
                self.danAnyFourView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTFive:
                self.danAnyFiveView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTSix:
                self.danAnySixView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTSeven:
                self.danAnySevenView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTEight:
                self.danAnyEightView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTPreTwoGroup:
                self.danPreTwoView.hidden = NO;
                break;
            case CLDElevenPlayMothedTypeDTPreThreeGroup:
                self.danPreThreeView.hidden = NO;
                break;
            default:
                break;
        }
    }
}
#pragma mark - 摇一摇随机动画
- (void)shakeNotification{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:
            [self.anyTwoView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeThree:
            [self.anyThreeView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeFour:
            [self.anyFourView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeFive:
            [self.anyFiveView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeSix:
            [self.anySixView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeSeven:
            [self.anySevenView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypeEight:
            [self.anyEightView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypePreOne:
            [self.preOneView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:
            [self.preTwoDirectView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            [self.preTwoGroupView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:
            [self.preThreeDirectView randomSelectedNumber];
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            [self.preThreeGroupView randomSelectedNumber];
            break;
        default:
            break;
    }
    
}
#pragma mark - 获取投注项
- (NSArray *)getBetTermInfoWithPlayMothed:(CLDElevenPlayMothedType)playMothed{
    
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            return [self getAnyBetTermWithView:self.anyTwoView leastNumber:2];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            return [self getAnyBetTermWithView:self.anyThreeView leastNumber:3];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            return [self getAnyBetTermWithView:self.anyFourView leastNumber:4];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            return [self getAnyBetTermWithView:self.anyFiveView leastNumber:5];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            return [self getAnyBetTermWithView:self.anySixView leastNumber:6];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            return [self getAnyBetTermWithView:self.anySevenView leastNumber:7];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            return [self getAnyBetTermWithView:self.anyEightView leastNumber:8];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            return [self getPreOneBetTerm];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            return [self getPreTwoDirectBetTerm];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            return [self getAnyBetTermWithView:self.preTwoGroupView leastNumber:2];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            return [self getPreThreeDirectBetTerm];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            return [self getAnyBetTermWithView:self.preThreeGroupView leastNumber:3];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            return [self getDTAnyBetTermWithView:self.danAnyTwoView leastNumber:2 playMothedTitle:@"任选二"];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            return [self getDTAnyBetTermWithView:self.danAnyThreeView leastNumber:3 playMothedTitle:@"任选三"];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            return [self getDTAnyBetTermWithView:self.danAnyFourView leastNumber:4 playMothedTitle:@"任选四"];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            return [self getDTAnyBetTermWithView:self.danAnyFiveView leastNumber:5 playMothedTitle:@"任选五"];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            return [self getDTAnyBetTermWithView:self.danAnySixView leastNumber:6 playMothedTitle:@"任选六"];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            return [self getDTAnyBetTermWithView:self.danAnySevenView leastNumber:7 playMothedTitle:@"任选七"];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            return [self getDTAnyBetTermWithView:self.danAnyEightView leastNumber:8 playMothedTitle:@"任选八"];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            return [self getDTAnyBetTermWithView:self.danPreTwoView leastNumber:2 playMothedTitle:@"前二组选"];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            return [self getDTAnyBetTermWithView:self.danPreThreeView leastNumber:3 playMothedTitle:@"前三组选"];
        }
            break;
        default:
            break;
    }
    return nil;
}
- (void)assginDataWithSelectedData:(id)betInfo playMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self.anyTwoView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self.anyThreeView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self.anyFourView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self.anyFiveView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self.anySixView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self.anySevenView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self.anyEightView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self.preOneView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self.preTwoDirectView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self.preTwoGroupView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self.preThreeDirectView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self.preThreeGroupView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self.danAnyTwoView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self.danAnyThreeView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self.danAnyFourView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self.danAnyFiveView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self.danAnySixView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self.danAnySevenView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self.danAnyEightView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self.danPreTwoView assignSelectBetButtonWithData:betInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self.danPreThreeView assignSelectBetButtonWithData:betInfo];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 清空选项
- (void)clearAllSelectedBetButtonWithPlayMothed:(CLDElevenPlayMothedType)playMothed{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self.anyTwoView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self.anyThreeView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self.anyFourView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self.anyFiveView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self.anySixView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self.anySevenView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self.anyEightView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self.preOneView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self.preTwoDirectView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self.preTwoGroupView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self.preThreeDirectView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self.preThreeGroupView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self.danAnyTwoView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self.danAnyThreeView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self.danAnyFourView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self.danAnyFiveView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self.danAnySixView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self.danAnySevenView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self.danAnyEightView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self.danPreTwoView clearAllBetButton];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self.danPreThreeView clearAllBetButton];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 刷新后台请求数据
- (void)reloadDataForMainBetViewWithPlayMothedType:(CLDElevenPlayMothedType)type{
    
    //刷新奖级
    NSDictionary *awardDic = [CLLotteryDataManager getBonusInfoWithGameEn:self.gameEn];
    [self.bonusInfo setBonusInfoData:awardDic];
    
    [self refreshEveryBonusInfoWithPlayMothedType:type];
    [self de_omissionData:[CLLotteryDataManager getOmissionDataGameEn:self.gameEn] playMothedType:type];
    [self de_activityData:type];
}
#pragma mark - 刷新奖金
- (void)de_RefreshBonusInfo{
    
    for (UIView<CLDElevenMainBetDelegate> *betView in self.viewArray) {
        
        [self refreshEveryBonusInfoWithPlayMothedType:betView.playMothedType];
    }
}

#pragma mark - 刷新每一个View奖金
- (void)refreshEveryBonusInfoWithPlayMothedType:(CLDElevenPlayMothedType)playMothedType{
    
    NSArray *bonusArray = [CLLotteryDataManager getShowBonusInfoGameEn:self.gameEn];
    
    switch (playMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self.anyTwoView assignBonusInfo:bonusArray[playMothedType]];
            [self.anyTwoView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self.anyThreeView assignBonusInfo:bonusArray[playMothedType]];
            [self.anyThreeView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self.anyFourView assignBonusInfo:bonusArray[playMothedType]];
            [self.anyFourView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self.anyFiveView assignBonusInfo:bonusArray[playMothedType]];
            [self.anyFiveView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self.anySixView assignBonusInfo:bonusArray[playMothedType]];
            [self.anySixView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self.anySevenView assignBonusInfo:bonusArray[playMothedType]];
            [self.anySevenView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self.anyEightView assignBonusInfo:bonusArray[playMothedType]];
            [self.anyEightView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self.preOneView assignBonusInfo:bonusArray[playMothedType]];
            [self.preOneView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self.preTwoDirectView assignBonusInfo:bonusArray[playMothedType]];
            [self.preTwoDirectView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self.preTwoGroupView assignBonusInfo:bonusArray[playMothedType]];
            [self.preTwoGroupView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self.preThreeDirectView assignBonusInfo:bonusArray[playMothedType]];
            [self.preThreeDirectView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self.preThreeGroupView assignBonusInfo:bonusArray[playMothedType]];
            [self.preThreeGroupView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self.danAnyTwoView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnyTwoView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self.danAnyThreeView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnyThreeView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self.danAnyFourView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnyFourView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self.danAnyFiveView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnyFiveView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self.danAnySixView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnySixView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self.danAnySevenView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnySevenView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self.danAnyEightView assignBonusInfo:bonusArray[playMothedType]];
            [self.danAnyEightView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self.danPreTwoView assignBonusInfo:bonusArray[playMothedType]];
            [self.danPreTwoView assignAward:self.bonusInfo];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self.danPreThreeView assignBonusInfo:bonusArray[playMothedType]];
            [self.danPreThreeView assignAward:self.bonusInfo];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 配置遗漏
- (void)de_omissionData:(NSDictionary *)omissionDic playMothedType:(CLDElevenPlayMothedType)type{
    
    switch (self.currentPlayMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self.anyTwoView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self.anyThreeView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self.anyFourView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self.anyFiveView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self.anySixView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self.anySevenView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self.anyEightView de_setOmissionData:omissionDic[@"REN8"]];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self.preOneView de_setOmissionData:omissionDic[@"QIAN_1"]];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self.preTwoDirectView de_setOmissionData:omissionDic[@"QIAN_2_ZHIXUAN"]];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self.preTwoGroupView de_setOmissionData:omissionDic[@"QIAN_2_ZUXUAN"]];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self.preThreeDirectView de_setOmissionData:omissionDic[@"QIAN_3_ZHIXUAN"]];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self.preThreeGroupView de_setOmissionData:omissionDic[@"QIAN_3_ZUXUAN"]];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self.danAnyTwoView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self.danAnyThreeView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self.danAnyFourView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self.danAnyFiveView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self.danAnySixView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self.danAnySevenView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self.danAnyEightView de_setOmissionData:[self getCompound:omissionDic[@"REN8"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self.danPreTwoView de_setOmissionData:[self getCompound:omissionDic[@"QIAN_2_ZUXUAN"]]];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self.danPreThreeView de_setOmissionData:[self getCompound:omissionDic[@"QIAN_3_ZUXUAN"]]];
        }
            break;
        default:
            break;
    }
}
- (void)de_activityData:(CLDElevenPlayMothedType)playMothedType{
    
    
    switch (playMothedType) {
        case CLDElevenPlayMothedTypeTwo:{
            [self.anyTwoView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeThree:{
            [self.anyThreeView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeFour:{
            [self.anyFourView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeFive:{
            [self.anyFiveView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeSix:{
            [self.anySixView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeSeven:{
            [self.anySevenView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeEight:{
            [self.anyEightView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypePreOne:{
            [self.preOneView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:{
            [self.preTwoDirectView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:{
            [self.preTwoGroupView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:{
            [self.preThreeDirectView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:{
            [self.preThreeGroupView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTTwo:{
            [self.danAnyTwoView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTThree:{
            [self.danAnyThreeView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTFour:{
            [self.danAnyFourView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTFive:{
            [self.danAnyFiveView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTSix:{
            [self.danAnySixView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTSeven:{
            [self.danAnySevenView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTEight:{
            [self.danAnyEightView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:{
            [self.danPreTwoView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:{
            [self.danPreThreeView assignActicityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
        }
            break;
        default:
            break;
    }
}
- (NSArray *)getCompound:(NSArray *)array{
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    if (array && array.count == 11) {
        [temp addObjectsFromArray:array];
        [temp addObjectsFromArray:array];
    }
    return temp;
}
#pragma mark ------------ getter Mothed ------------
- (CLDEBonusInfo *)bonusInfo{
    
    if (!_bonusInfo) {
        _bonusInfo = [[CLDEBonusInfo alloc] init];
    }
    return _bonusInfo;
}
- (CLDElevenAnySelectView *)anyTwoView{
    
    WS(_weakSelf)
    if (!_anyTwoView) {
        _anyTwoView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anyTwoView.playMothedType = CLDElevenPlayMothedTypeTwo;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeTwo];
        _anyTwoView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anyTwoView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anyTwoView];
        _anyTwoView.hidden = YES;
        [self.viewArray addObject:_anyTwoView];
        [self.viewDictionary setObject:_anyTwoView forKey:@"0"];
    }
    return _anyTwoView;
}
- (CLDElevenAnySelectView *)anyThreeView{
    
    WS(_weakSelf)
    if (!_anyThreeView) {
        _anyThreeView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anyThreeView.playMothedType = CLDElevenPlayMothedTypeThree;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeThree];
        _anyThreeView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anyThreeView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anyThreeView];
        _anyThreeView.hidden = YES;
        [self.viewArray addObject:_anyThreeView];
        [self.viewDictionary setObject:_anyThreeView forKey:@"1"];
    }
    return _anyThreeView;
}
- (CLDElevenAnySelectView *)anyFourView{
    
    WS(_weakSelf)
    if (!_anyFourView) {
        _anyFourView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anyFourView.playMothedType = CLDElevenPlayMothedTypeFour;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeFour];
        _anyFourView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anyFourView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anyFourView];
        _anyFourView.hidden = YES;
        [self.viewArray addObject:_anyFourView];
        [self.viewDictionary setObject:_anyFourView forKey:@"2"];
    }
    return _anyFourView;
}
- (CLDElevenAnySelectView *)anyFiveView{
    
    WS(_weakSelf)
    if (!_anyFiveView) {
        _anyFiveView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anyFiveView.playMothedType = CLDElevenPlayMothedTypeFive;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeFive];
        _anyFiveView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anyFiveView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anyFiveView];
        _anyFiveView.hidden = YES;
        [self.viewArray addObject:_anyFiveView];
        [self.viewDictionary setObject:_anyFiveView forKey:@"3"];
    }
    return _anyFiveView;
}
- (CLDElevenAnySelectView *)anySixView{
    
    WS(_weakSelf)
    if (!_anySixView) {
        _anySixView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anySixView.playMothedType = CLDElevenPlayMothedTypeSix;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeSix];
        _anySixView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anySixView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anySixView];
        _anySixView.hidden = YES;
        [self.viewArray addObject:_anySixView];
        [self.viewDictionary setObject:_anySixView forKey:@"4"];
    }
    return _anySixView;
}
- (CLDElevenAnySelectView *)anySevenView{
    
    WS(_weakSelf)
    if (!_anySevenView) {
        _anySevenView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anySevenView.playMothedType = CLDElevenPlayMothedTypeSeven;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeSeven];
        _anySevenView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anySevenView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anySevenView];
        _anySevenView.hidden = YES;
        [self.viewArray addObject:_anySevenView];
        [self.viewDictionary setObject:_anySevenView forKey:@"5"];
    }
    return _anySevenView;
}
- (CLDElevenAnySelectView *)anyEightView{
    
    WS(_weakSelf)
    if (!_anyEightView) {
        _anyEightView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _anyEightView.playMothedType = CLDElevenPlayMothedTypeEight;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeEight];
        _anyEightView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.anyEightView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_anyEightView];
        _anyEightView.hidden = YES;
        [self.viewArray addObject:_anyEightView];
        [self.viewDictionary setObject:_anyEightView forKey:@"6"];
    }
    return _anyEightView;
}
- (CLDElevenAnySelectView *)preOneView{
    
    WS(_weakSelf)
    if (!_preOneView) {
        _preOneView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _preOneView.playMothedType = CLDElevenPlayMothedTypePreOne;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypePreOne];
        _preOneView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.preOneView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_preOneView];
        _preOneView.hidden = YES;
        [self.viewArray addObject:_preOneView];
        [self.viewDictionary setObject:_preOneView forKey:@"7"];
    }
    return _preOneView;
}
- (CLDElevenAnySelectView *)preTwoGroupView{
    
    WS(_weakSelf)
    if (!_preTwoGroupView) {
        _preTwoGroupView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _preTwoGroupView.playMothedType = CLDElevenPlayMothedTypePreTwoGroup;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypePreTwoGroup];
        _preTwoGroupView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.preTwoGroupView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_preTwoGroupView];
        _preTwoGroupView.hidden = YES;
        [self.viewArray addObject:_preTwoGroupView];
        [self.viewDictionary setObject:_preTwoGroupView forKey:@"8"];
    }
    return _preTwoGroupView;
}
- (CLDElevenAnySelectView *)preThreeGroupView{
    
    WS(_weakSelf)
    if (!_preThreeGroupView) {
        _preThreeGroupView = [[CLDElevenAnySelectView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(300))];
        _preThreeGroupView.playMothedType = CLDElevenPlayMothedTypePreThreeGroup;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypePreThreeGroup];
        _preThreeGroupView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.preThreeGroupView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_preThreeGroupView];
        _preThreeGroupView.hidden = YES;
        [self.viewArray addObject:_preThreeGroupView];
        [self.viewDictionary setObject:_preThreeGroupView forKey:@"9"];
    }
    return _preThreeGroupView;
}
- (CLDElevenTwoGroupView *)preTwoDirectView{
    
    WS(_weakSelf)
    if (!_preTwoDirectView) {
        _preTwoDirectView = [[CLDElevenTwoGroupView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(400))];
        _preTwoDirectView.playMothedType = CLDElevenPlayMothedTypePreTwoDirect;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypePreTwoDirect];
        _preTwoDirectView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.preTwoDirectView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_preTwoDirectView];
        _preTwoDirectView.hidden = YES;
        [self.viewArray addObject:_preTwoDirectView];
        [self.viewDictionary setObject:_preTwoDirectView forKey:@"10"];
    }
    return _preTwoDirectView;
}
- (CLDElevenThreeGroupView *)preThreeDirectView{
    
    WS(_weakSelf)
    if (!_preThreeDirectView) {
        _preThreeDirectView = [[CLDElevenThreeGroupView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(550))];
        _preThreeDirectView.playMothedType = CLDElevenPlayMothedTypePreThreeDirect;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypePreThreeDirect];
        [self addSubview:_preThreeDirectView];
        _preThreeDirectView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.preThreeDirectView de_hasSelectedBetButton]) : nil;
        };
        _preThreeDirectView.hidden = YES;
        [self.viewArray addObject:_preThreeDirectView];
        [self.viewDictionary setObject:_preThreeDirectView forKey:@"11"];
    }
    return _preThreeDirectView;
}
- (CLDElevenDanTuoView *)danAnyTwoView{
    
    WS(_weakSelf)
    if (!_danAnyTwoView) {
        _danAnyTwoView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnyTwoView.playMothedType = CLDElevenPlayMothedTypeDTTwo;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTTwo];
        _danAnyTwoView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnyTwoView de_hasSelectedBetButton]) : nil;
        };
        _danAnyTwoView.explainInfoLabel.text = @"请选1个";
        _danAnyTwoView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self addSubview:_danAnyTwoView];
        _danAnyTwoView.hidden = YES;
        [self.viewArray addObject:_danAnyTwoView];
        [self.viewDictionary setObject:_danAnyTwoView forKey:@"12"];
    }
    return _danAnyTwoView;
}
- (CLDElevenDanTuoView *)danAnyThreeView{
    
    WS(_weakSelf)
    if (!_danAnyThreeView) {
        _danAnyThreeView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnyThreeView.playMothedType = CLDElevenPlayMothedTypeDTThree;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTThree];
        _danAnyThreeView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnyThreeView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnyThreeView];
        _danAnyThreeView.hidden = YES;
        _danAnyThreeView.explainInfoLabel.text = @"至少选1个，最多2个";
        _danAnyThreeView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnyThreeView];
        [self.viewDictionary setObject:_danAnyThreeView forKey:@"13"];
    }
    return _danAnyThreeView;
}
- (CLDElevenDanTuoView *)danAnyFourView{
    
    WS(_weakSelf)
    if (!_danAnyFourView) {
        _danAnyFourView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnyFourView.playMothedType = CLDElevenPlayMothedTypeDTFour;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTFour];
        _danAnyFourView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnyFourView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnyFourView];
        _danAnyFourView.hidden = YES;
        _danAnyFourView.explainInfoLabel.text = @"至少选1个，最多3个";
        _danAnyFourView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnyFourView];
        [self.viewDictionary setObject:_danAnyFourView forKey:@"14"];
    }
    return _danAnyFourView;
}
- (CLDElevenDanTuoView *)danAnyFiveView{
    
    WS(_weakSelf)
    if (!_danAnyFiveView) {
        _danAnyFiveView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnyFiveView.playMothedType = CLDElevenPlayMothedTypeDTFive;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTFive];
        _danAnyFiveView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnyFiveView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnyFiveView];
        _danAnyFiveView.hidden = YES;
        _danAnyFiveView.explainInfoLabel.text = @"至少选1个，最多4个";
        _danAnyFiveView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnyFiveView];
        [self.viewDictionary setObject:_danAnyFiveView forKey:@"15"];
    }
    return _danAnyFiveView;
}
- (CLDElevenDanTuoView *)danAnySixView{
    
    WS(_weakSelf)
    if (!_danAnySixView) {
        _danAnySixView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnySixView.playMothedType = CLDElevenPlayMothedTypeDTSix;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTSix];
        _danAnySixView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnySixView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnySixView];
        _danAnySixView.hidden = YES;
        _danAnySixView.explainInfoLabel.text = @"至少选1个，最多5个";
        _danAnySixView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnySixView];
        [self.viewDictionary setObject:_danAnySixView forKey:@"16"];
    }
    return _danAnySixView;
}
- (CLDElevenDanTuoView *)danAnySevenView{
    
    WS(_weakSelf)
    if (!_danAnySevenView) {
        _danAnySevenView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnySevenView.playMothedType = CLDElevenPlayMothedTypeDTSeven;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTSeven];
        _danAnySevenView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnySevenView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnySevenView];
        _danAnySevenView.hidden = YES;
        _danAnySevenView.explainInfoLabel.text = @"至少选1个，最多6个";
        _danAnySevenView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnySevenView];
        [self.viewDictionary setObject:_danAnySevenView forKey:@"17"];
    }
    return _danAnySevenView;
}
- (CLDElevenDanTuoView *)danAnyEightView{
    
    WS(_weakSelf)
    if (!_danAnyEightView) {
        _danAnyEightView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danAnyEightView.playMothedType = CLDElevenPlayMothedTypeDTEight;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTEight];
        _danAnyEightView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danAnyEightView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danAnyEightView];
        _danAnyEightView.hidden = YES;
        _danAnyEightView.explainInfoLabel.text = @"至少选1个，最多7个";
        _danAnyEightView.tuoExplainInfoLabel.text = @"至少选1个，最多选10个";
        [self.viewArray addObject:_danAnyEightView];
        [self.viewDictionary setObject:_danAnyEightView forKey:@"18"];
    }
    return _danAnyEightView;
}
- (CLDElevenDanTuoView *)danPreTwoView{
    
    WS(_weakSelf)
    if (!_danPreTwoView) {
        _danPreTwoView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danPreTwoView.playMothedType = CLDElevenPlayMothedTypeDTPreTwoGroup;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTPreTwoGroup];
        _danPreTwoView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danPreTwoView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danPreTwoView];
        _danPreTwoView.hidden = YES;
        [self.viewArray addObject:_danPreTwoView];
        [self.viewDictionary setObject:_danPreTwoView forKey:@"19"];
    }
    return _danPreTwoView;
}
- (CLDElevenDanTuoView *)danPreThreeView{
    
    WS(_weakSelf)
    if (!_danPreThreeView) {
        _danPreThreeView = [[CLDElevenDanTuoView alloc] initWithFrame:__Rect(0, 0, CGRectGetWidth(self.frame), __SCALE(450))];
        _danPreThreeView.playMothedType = CLDElevenPlayMothedTypeDTPreThreeGroup;
        [self refreshEveryBonusInfoWithPlayMothedType:CLDElevenPlayMothedTypeDTPreThreeGroup];
        _danPreThreeView.callBackNoteBonusBlock = ^(NSInteger betNote, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.selectedChangeBlock ? _weakSelf.selectedChangeBlock(betNote, minBonus, maxBonus, [_weakSelf.danPreThreeView de_hasSelectedBetButton]) : nil;
        };
        [self addSubview:_danPreThreeView];
        _danPreThreeView.hidden = YES;
        _danPreThreeView.explainInfoLabel.text = @"至少选1个，最多2个";
        [self.viewArray addObject:_danPreThreeView];
        [self.viewDictionary setObject:_danPreThreeView forKey:@"20"];
    }
    return _danPreThreeView;
}

- (NSMutableArray *)viewArray{
    
    if (!_viewArray) {
        _viewArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _viewArray;
}
- (NSMutableDictionary *)viewDictionary{
    
    if (!_viewDictionary) {
        _viewDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _viewDictionary;
}
@end
