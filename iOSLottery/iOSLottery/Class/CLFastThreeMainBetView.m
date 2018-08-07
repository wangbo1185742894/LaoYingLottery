//
//  CLFastThreeMainBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFastThreeMainBetView.h"
#import "CLConfigMessage.h"
#import "CLShowHUDManager.h"
#import "CLFTBonusInfo.h"
#import "CLLotteryDataManager.h"
//和值
#import "CLFTHeZhiBetView.h"
#import "CLFTHeZhiBetInfo.h"
//三同号
#import "CLFTThreeSameBetView.h"
#import "CLFTThreeSameSingleBetInfo.h"
#import "CLFTThreeSameAllBetInfo.h"
//二同号
#import "CLFTTwoSameBetView.h"
#import "CLFTTwoSameSingleBetInfo.h"
#import "CLFTTwoSameDoubleBetInfo.h"
//三不同号
#import "CLFTThreeDifferentBetView.h"
#import "CLFTThreeDifferentAllBetInfo.h"
#import "CLFTThreeDifferentBetInfo.h"
//二不同号
#import "CLFTTwoDifferentBetView.h"
#import "CLFTTwoDifferentBetInfo.h"
//三不同号 胆拖
#import "CLFTThreeDiffererntDanBetView.h"
#import "CLFTDanThreeDifferentBetInfo.h"
//二不同号 胆拖
#import "CLFTTwoDifferentDanBetView.h"
#import "CLFTDanTwoDifferentBetInfo.h"

@interface CLFastThreeMainBetView ()

@property (nonatomic, strong) CLFTHeZhiBetView *heZhiBetView;//和值
@property (nonatomic, strong) CLFTThreeSameBetView *threeSameBetView;//三同号
@property (nonatomic, strong) CLFTTwoSameBetView *twoSameBetView;//二同号
@property (nonatomic, strong) CLFTThreeDifferentBetView *threeDifferentBetView;//三不同
@property (nonatomic, strong) CLFTTwoDifferentBetView *twoDifferentBetView;//二不同号
@property (nonatomic, strong) CLFTThreeDiffererntDanBetView *threeDifferentDanBetView;//三不同号胆拖
@property (nonatomic, strong) CLFTTwoDifferentDanBetView *twoDifferentDanBetView;//二不同号胆拖
@property (nonatomic, strong) UIImageView *backgroundImageView;
//奖级信息
@property (nonatomic, strong) CLFTBonusInfo *ft_bonusInfo;


@end

@implementation CLFastThreeMainBetView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x339966);
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.heZhiBetView];
        [self addSubview:self.threeSameBetView];
        [self addSubview:self.twoSameBetView];
        [self addSubview:self.threeDifferentBetView];
        [self addSubview:self.twoDifferentBetView];
        [self addSubview:self.threeDifferentDanBetView];
        [self addSubview:self.twoDifferentDanBetView];
        
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(SCREEN_HEIGHT + 100);
        }];
    }
    return self;
}
#pragma mark ------ public Mothed ------
#pragma mark - 刷新展示页面
- (void)refreshShowWithPlayMothed:(CLFastThreePlayMothedType)playMothed{
    //先将所有的View 都隐藏
    self.heZhiBetView.hidden = YES;
    self.threeSameBetView.hidden = YES;
    self.twoSameBetView.hidden = YES;
    self.threeDifferentBetView.hidden = YES;
    self.twoDifferentBetView.hidden = YES;
    self.threeDifferentDanBetView.hidden = YES;
    self.twoDifferentDanBetView.hidden = YES;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(400.f));
    switch (playMothed) {
        case CLFastThreePlayMothedTypeHeZhi:
            self.heZhiBetView.hidden = NO;
            [self bringSubviewToFront:self.heZhiBetView];
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(500.f));
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            self.threeSameBetView.hidden = NO;
            [self bringSubviewToFront:self.threeSameBetView];
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            self.twoSameBetView.hidden = NO;
            [self bringSubviewToFront:self.twoSameBetView];
            self.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(500.f));
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            self.threeDifferentBetView.hidden = NO;
            [self bringSubviewToFront:self.threeDifferentBetView];
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            self.twoDifferentBetView.hidden = NO;
            [self bringSubviewToFront:self.twoDifferentBetView];
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            self.threeDifferentDanBetView.hidden = NO;
            [self bringSubviewToFront:self.threeDifferentDanBetView];
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            self.twoDifferentDanBetView.hidden = NO;
            [self bringSubviewToFront:self.twoDifferentDanBetView];
            break;
        default:
            break;
    }
}
#pragma mark - 获取投注项
- (NSArray *)getBetTermInfoWithPlayMothed:(CLFastThreePlayMothedType)playMothed{
    
    switch (playMothed) {
        case CLFastThreePlayMothedTypeHeZhi:
            return [self getHeZhiBetInfo];
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            return [self getThreeSameBetInfo];
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            return [self getTwoSameBetInfo];
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            return [self getThreeDifferentBetInfo];
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            return [self getTwoDifferentBetInfo];
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            return [self getDanThreeDifferentBetInfo];
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            return [self getDanTwoDifferentBetInfo];
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark - 根据选中的投注信息 配置相应的UI
- (void)assginDataWithSelectedData:(id)betInfo playMothedType:(CLFastThreePlayMothedType)playMothedType{
    
    switch (playMothedType) {
        case CLFastThreePlayMothedTypeHeZhi:
            if([self.heZhiBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.heZhiBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            if([self.threeSameBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.threeSameBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            if([self.twoSameBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.twoSameBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            if([self.threeDifferentBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.threeDifferentBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            if([self.twoDifferentBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.twoDifferentBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            if([self.threeDifferentDanBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.threeDifferentDanBetView assignUIWithData:betInfo];
            }
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            if([self.twoDifferentDanBetView respondsToSelector:@selector(assignUIWithData:)]){
                [self.twoDifferentDanBetView assignUIWithData:betInfo];
            }
            break;
        default:
            break;
    }
    
}
#pragma mark - 清空选中的按钮
- (void)clearAllSelectedBetButtonWithPlayMothed:(CLFastThreePlayMothedType)playMothed{
    
    switch (playMothed) {
        case CLFastThreePlayMothedTypeHeZhi:
            if([self.heZhiBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.heZhiBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            if([self.threeSameBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.threeSameBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            if([self.twoSameBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.twoSameBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            if([self.threeDifferentBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.threeDifferentBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            if([self.twoDifferentBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.twoDifferentBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            if([self.threeDifferentDanBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.threeDifferentDanBetView clearAllBetButton];
            }
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            if([self.twoDifferentDanBetView respondsToSelector:@selector(clearAllBetButton)]){
                [self.twoDifferentDanBetView clearAllBetButton];
            }
            break;
        default:
            break;
    }
}
#pragma mark - 刷新网络请求后的数据
- (void)reloadDataForFTMainBetView{
    
    [self refreshFTBonus];
    [self assignOmissionData:[CLLotteryDataManager getOmissionDataGameEn:self.gameEn]];
    [self assignActivityLink:[CLLotteryDataManager getActivityLink:self.gameEn]];
    [self assignBonusInfo:[CLLotteryDataManager getShowBonusInfoGameEn:self.gameEn]];
}


#pragma mark ------ private Mothed ------
#pragma mark - 刷新奖级
- (void)refreshFTBonus{
    
    [self.ft_bonusInfo setBonusInfoWithData:[CLLotteryDataManager getBonusInfoWithGameEn:self.gameEn]];
    [self.heZhiBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.threeSameBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.twoSameBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.threeDifferentBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.twoDifferentBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.threeDifferentDanBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
    [self.twoDifferentDanBetView ft_RefreshBonusInfo:self.ft_bonusInfo];
}
#pragma mark - 配置遗漏
- (void)assignOmissionData:(NSDictionary *)omissionData{
    
    NSArray *hezhi = omissionData[@"HEZHI"];
    NSArray *ABC_3_ALL = omissionData[@"ABC_3_ALL"];
    NSArray *DIFF_2 = omissionData[@"DIFF_2"];
    NSArray *DIFF_3 = omissionData[@"DIFF_3"];
    NSArray *SAME_2_ALL = omissionData[@"SAME_2_ALL"];
    NSArray *SAME_2_SINGLE = omissionData[@"SAME_2_SINGLE"];
    NSArray *SAME_3_ALL = omissionData[@"SAME_3_ALL"];
    NSArray *SAME_3_SINGLE = omissionData[@"SAME_3_SINGLE"];
    
    if (hezhi && hezhi.count == 16) {
        [self.heZhiBetView setOmissionWithData:omissionData[@"HEZHI"]];
    }else{
        [self.heZhiBetView setDefaultOmission];
    }
    if (SAME_3_ALL && SAME_3_ALL.count > 0 && SAME_3_SINGLE && SAME_3_SINGLE.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:SAME_3_SINGLE];
        [temp addObjectsFromArray:SAME_3_ALL];
        [self.threeSameBetView setOmissionWithData:temp];
    }else{
        [self.threeSameBetView setDefaultOmission];
    }
    if (SAME_2_SINGLE && SAME_2_SINGLE.count > 0 && SAME_2_ALL && SAME_2_ALL.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:SAME_2_SINGLE];
        [temp addObjectsFromArray:SAME_2_ALL];
        [self.twoSameBetView setOmissionWithData:temp];
    }else{
        [self.twoSameBetView setDefaultOmission];
    }
    if (DIFF_3 && DIFF_3.count > 0 && ABC_3_ALL && ABC_3_ALL.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:DIFF_3];
        [temp addObjectsFromArray:ABC_3_ALL];
        [self.threeDifferentBetView setOmissionWithData:temp];
        [temp removeAllObjects];
        [temp addObjectsFromArray:DIFF_3];
        [temp addObjectsFromArray:DIFF_3];
        [self.threeDifferentDanBetView setOmissionWithData:temp];
    }else{
        [self.threeDifferentBetView setDefaultOmission];
        [self.threeDifferentDanBetView setDefaultOmission];
    }
    if (DIFF_2 && DIFF_2.count > 0) {
        [self.twoDifferentBetView setOmissionWithData:DIFF_2];
        
        NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
        [temp addObjectsFromArray:DIFF_3];
        [temp addObjectsFromArray:DIFF_3];
        [self.twoDifferentDanBetView setOmissionWithData:temp];
    }else{
        [self.twoDifferentBetView setDefaultOmission];
        [self.twoDifferentDanBetView setDefaultOmission];
    }
}
#pragma mark - 配置活动链接
- (void)assignActivityLink:(id)data{
    
    [self.heZhiBetView assignActicityLink:data];
    [self.threeSameBetView assignActicityLink:data];
    [self.twoSameBetView assignActicityLink:data];
    [self.threeDifferentBetView assignActicityLink:data];
    [self.twoDifferentBetView assignActicityLink:data];
    [self.threeDifferentDanBetView assignActicityLink:data];
    [self.twoDifferentDanBetView assignActicityLink:data];
}
#pragma mark - 配置奖金信息
- (void)assignBonusInfo:(NSArray *)bonusInfo{
    
    [self.heZhiBetView assignBonusInfo:bonusInfo];
    [self.threeSameBetView assignBonusInfo:bonusInfo];
    [self.twoSameBetView assignBonusInfo:bonusInfo];
    [self.threeDifferentBetView assignBonusInfo:bonusInfo];
    [self.twoDifferentBetView assignBonusInfo:bonusInfo];
    [self.threeDifferentDanBetView assignBonusInfo:bonusInfo];
    [self.twoDifferentDanBetView assignBonusInfo:bonusInfo];
}

#pragma mark - 和值投注项
- (NSArray *)getHeZhiBetInfo{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.heZhiBetView.betInfo.betNote > 0) {
        [array addObject:self.heZhiBetView.betInfo];
    }else{
        [self.heZhiBetView configRandomDice];
    }
    return array;
}
#pragma mark - 三同号的投注项
- (NSArray *)getThreeSameBetInfo{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.threeSameBetView.allBetInfo.betNote > 0) {
        [array addObject:self.threeSameBetView.allBetInfo];
    }
    if (self.threeSameBetView.singleBetInfo.betNote > 0) {
        [array addObject:self.threeSameBetView.singleBetInfo];
    }
    if (array.count == 0) {
        [self.threeSameBetView configRandomDice];
    }
    return array;
}
#pragma mark - 二同号的投注项
- (NSArray *)getTwoSameBetInfo{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    if (self.twoSameBetView.doubleBetInfo.betNote > 0) {
        [array addObject:self.twoSameBetView.doubleBetInfo];
    }
    if (self.twoSameBetView.singleBetInfo.betNote > 0) {
        [array addObject:self.twoSameBetView.singleBetInfo];
    }else{
        if (self.twoSameBetView.singleBetInfo.sameNumberBetArray.count > 0) {
            [CLShowHUDManager showHUDWithView:self text:@"二同号单选请至少选一个不同号" type:CLShowHUDTypeOnlyText delayTime:1.f];
            return nil;
        }else if (self.twoSameBetView.singleBetInfo.singleBetArray.count > 0){
            [CLShowHUDManager showHUDWithView:self text:@"二同号单选请至少选一个同号" type:CLShowHUDTypeOnlyText delayTime:1.f];
            return nil;
        }else if (array.count == 0){
            [self.twoSameBetView configRandomDice];
            return nil;
        }
    }
    return array;
}
#pragma mark - 三不同号投注项
- (NSArray *)getThreeDifferentBetInfo{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.threeDifferentBetView.allBetInfo.betNote > 0) {
        [array addObject:self.threeDifferentBetView.allBetInfo];
    }
    if (self.threeDifferentBetView.betInfo.betNote > 0) {
        [array addObject:self.threeDifferentBetView.betInfo];
    }else{
        if (self.threeDifferentBetView.betInfo.threeDifferentBetArray.count > 0) {
            [CLShowHUDManager showHUDWithView:self text:@"三不同号请至少选3个号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
            return nil;
        }else if (array.count == 0){
            [self.threeDifferentBetView configRandomDice];
            return nil;
        }
    }
    return array;
}
#pragma mark - 二不同号投注项
- (NSArray *)getTwoDifferentBetInfo{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.twoDifferentBetView.betInfo.betNote > 0) {
        [array addObject:self.twoDifferentBetView.betInfo];
    }else{
        if (self.twoDifferentBetView.betInfo.twoDifferentBetArray.count > 0) {
            [CLShowHUDManager showHUDWithView:self text:@"请至少选2个号码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else{
            [self.twoDifferentBetView configRandomDice];
        }
    }
    return array;
}
#pragma mark - 胆拖三不同号投注项
- (NSArray *)getDanThreeDifferentBetInfo{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.threeDifferentDanBetView.betInfo.betNote > 0) {
        [array addObject:self.threeDifferentDanBetView.betInfo];
    }else{
        
        if (self.threeDifferentDanBetView.betInfo.danThreeDifferentBetArray.count == 0) {
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else if (self.threeDifferentDanBetView.betInfo.tuoThreeDifferentBetArray.count == 0){
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else{
            [CLShowHUDManager showHUDWithView:self text:@"三不同号胆码加拖码至少要选3个" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }
    }
    return array;
}
#pragma mark - 胆拖二不同号投注项
- (NSArray *)getDanTwoDifferentBetInfo{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    if (self.twoDifferentDanBetView.betInfo.betNote > 0) {
        [array addObject:self.twoDifferentDanBetView.betInfo];
    }else{
        
        if (self.twoDifferentDanBetView.betInfo.danTwoDifferentBetArray.count == 0) {
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个胆码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }else if (self.twoDifferentDanBetView.betInfo.tuoTwoDifferentBetArray.count == 0){
            [CLShowHUDManager showHUDWithView:self text:@"请至少选择1个拖码" type:CLShowHUDTypeOnlyText delayTime:1.f];
        }
    }
    return array;
}
#pragma mark ------ getter Mothed ------
- (CLFTBonusInfo *)ft_bonusInfo{
    
    if (!_ft_bonusInfo) {
        _ft_bonusInfo = [[CLFTBonusInfo alloc] init];
    }
    return _ft_bonusInfo;
}
- (UIImageView *)backgroundImageView{
    
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
    }
    return _backgroundImageView;
}
- (CLFTHeZhiBetView *)heZhiBetView{
    WS(_weakSelf)
    if (!_heZhiBetView) {
        _heZhiBetView = [[CLFTHeZhiBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(500))];
        _heZhiBetView.hidden = YES;
        _heZhiBetView.heZhiBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.heZhiBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _heZhiBetView;
}
- (CLFTThreeSameBetView *)threeSameBetView{
    WS(_weakSelf)
    if (!_threeSameBetView) {
        _threeSameBetView = [[CLFTThreeSameBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(400))];
        _threeSameBetView.hidden = YES;
        _threeSameBetView.threeSameBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus , [_weakSelf.threeSameBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _threeSameBetView;
}
- (CLFTTwoSameBetView *)twoSameBetView{
    WS(_weakSelf)
    if (!_twoSameBetView) {
        _twoSameBetView = [[CLFTTwoSameBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(500))];
        _twoSameBetView.hidden = YES;
        _twoSameBetView.twoSameBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.twoSameBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _twoSameBetView;
}
- (CLFTThreeDifferentBetView *)threeDifferentBetView{
    
    WS(_weakSelf)
    if (!_threeDifferentBetView) {
        _threeDifferentBetView = [[CLFTThreeDifferentBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(400))];
        _threeDifferentBetView.hidden = YES;
        _threeDifferentBetView.threeDifferentBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.threeDifferentBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _threeDifferentBetView;
}
- (CLFTTwoDifferentBetView *)twoDifferentBetView{
    
    WS(_weakSelf)
    if (!_twoDifferentBetView) {
        _twoDifferentBetView = [[CLFTTwoDifferentBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(400))];
        _twoDifferentBetView.hidden = YES;
        _twoDifferentBetView.twoDifferentBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.twoDifferentBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _twoDifferentBetView;
}
- (CLFTThreeDiffererntDanBetView *)threeDifferentDanBetView{
    
    WS(_weakSelf)
    if (!_threeDifferentDanBetView) {
        _threeDifferentDanBetView = [[CLFTThreeDiffererntDanBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(400))];
        _threeDifferentDanBetView.hidden = YES;
        _threeDifferentDanBetView.danThreeDifferentBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.threeDifferentDanBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _threeDifferentDanBetView;
}
- (CLFTTwoDifferentDanBetView *)twoDifferentDanBetView{
    
    WS(_weakSelf)
    if (!_twoDifferentDanBetView) {
        _twoDifferentDanBetView = [[CLFTTwoDifferentDanBetView alloc] initWithFrame:__Rect(0, 0, self.frame.size.width, __SCALE(400))];
        _twoDifferentDanBetView.hidden = YES;
        _twoDifferentDanBetView.danTwoDifferentBetBonusAndNotesBlock = ^(NSInteger note, NSInteger minBonus, NSInteger maxBonus){
            _weakSelf.betBonusAndNotesBlock ? _weakSelf.betBonusAndNotesBlock(note, minBonus, maxBonus, [_weakSelf.twoDifferentDanBetView ft_hasSelectBetButton]) : nil;
        };
    }
    return _twoDifferentDanBetView;
}
@end
