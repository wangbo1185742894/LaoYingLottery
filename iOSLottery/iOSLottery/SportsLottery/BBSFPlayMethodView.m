//
//  BBSFPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBSFPlayMethodView.h"
#import "SLConfigMessage.h"

#import "BBOddsItemButton.h"

#import "BBSeletedGameModel.h"
#import "BBMatchModel.h"
#import "BBSFModel.h"

#import "BBNoSaleLabel.h"

#import "BBMatchInfoManager.h"

#import "BBBetDetailsInfoManager.h"

#import "SLExternalService.h"

@interface BBSFPlayMethodView ()

@property (nonatomic, strong) UILabel *playNameLabel;

@property (nonatomic, strong) BBOddsItemButton *awayWinItem;

@property (nonatomic, strong) BBOddsItemButton *hostWinItem;

@property (nonatomic, strong) BBNoSaleLabel *noSaleLabel;

@end


@implementation BBSFPlayMethodView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        
    }
    return self;
}

- (void)addSubviews
{

    [self addSubview:self.playNameLabel];
    [self addSubview:self.awayWinItem];
    [self addSubview:self.hostWinItem];
    [self addSubview:self.noSaleLabel];
    
    self.noSaleLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(320.f), SL__SCALE(40.f));
    
    self.playNameLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(9.f), SL__SCALE(40.f), SL__SCALE(14.f));
    
    self.awayWinItem.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(160.f), SL__SCALE(40.f));
    
    self.hostWinItem.frame = CGRectMake(CGRectGetMaxX(self.awayWinItem.frame), CGRectGetMinY(self.awayWinItem.frame), SL__SCALE(160.f), SL__SCALE(40.f));
    
}

- (void)buttonClick:(BBOddsItemButton *)item
{

    if (self.sfInfo.isDanGuan == NO) {
        
        if ([BBBetDetailsInfoManager isShowToast]) {
            
            [SLExternalService showError:@"只有一场赛事，不能选择非单关玩法"];
            
            return;
        }
        
    }
    
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%zi",item.tag];
    
    if (item.isSelected == YES) {
        
        [self.sfInfo.selectPlayMothedArray addObject:selectTag];
        
    }else{
        
        [self.sfInfo.selectPlayMothedArray removeObject:selectTag];
    }
    
}


- (void)setMatchModel:(BBMatchModel *)matchModel
{

    _matchModel = matchModel;
    
    if (matchModel.sf_sale_status == 0) {
        
        self.noSaleLabel.hidden = NO;
        
        return;
    }

    
    
    [self.awayWinItem setPlayName:@"主负"];
    [self.awayWinItem setOdds:matchModel.sf.sp.loss];
    
    [self.hostWinItem setPlayName:@"主胜"];
    [self.hostWinItem setOdds:matchModel.sf.sp.win];
    
    BBSeletedGameModel *selectedInfo = [[BBMatchInfoManager shareManager] getSingleMatchSelectInfoWithMatchIssue:matchModel.match_issue];
        
    if (selectedInfo == nil) return;
    
    
    for (NSString *selectedStr in selectedInfo.sfInfo.selectPlayMothedArray) {
        
        [self.sfInfo.selectPlayMothedArray addObject:selectedStr];
    }
    
    if ([self.sfInfo.selectPlayMothedArray containsObject:@"0"]) {
        
        self.awayWinItem.selected = YES;
    }else{
    
        self.awayWinItem.selected = NO;
    }
    
    if ([self.sfInfo.selectPlayMothedArray containsObject:@"3"]) {
        
        self.hostWinItem.selected = YES;
        
    }else{
    
        self.hostWinItem.selected = NO;
    }
    
    self.sfInfo.playMothed = @"sf";
    self.sfInfo.isDanGuan = self.matchModel.sf_danguan;
    
}


- (UILabel *)playNameLabel
{
    if (_playNameLabel == nil) {
        
        _playNameLabel = [[UILabel alloc] init];
        _playNameLabel.text = @"胜负";
        _playNameLabel.textColor = SL_UIColorFromRGB(0x333333);
        _playNameLabel.font = SL_FONT_SCALE(12.f);
        _playNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _playNameLabel;
}

- (BBOddsItemButton *)awayWinItem
{

    if (_awayWinItem == nil) {
        
        _awayWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_awayWinItem setShowBottomLine:YES];
        
        [_awayWinItem addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _awayWinItem.tag = 0;
    }
    return _awayWinItem;
}

- (BBOddsItemButton *)hostWinItem
{

    if (_hostWinItem == nil) {
        
        _hostWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_hostWinItem setShowRightLine:YES];
        [_hostWinItem setShowBottomLine:YES];
        
        [_hostWinItem addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        _hostWinItem.tag = 3;
    }
    return _hostWinItem;
}

- (BBSelectPlayMethodInfo *)sfInfo
{
    if (_sfInfo == NO) {
        
        _sfInfo = [[BBSelectPlayMethodInfo alloc] init];
        
        _sfInfo.selectPlayMothedArray = [NSMutableArray new];
    }
    return _sfInfo;
}

- (BBNoSaleLabel *)noSaleLabel
{

    if (_noSaleLabel == nil) {
        
        _noSaleLabel = [[BBNoSaleLabel alloc] init];
        
        _noSaleLabel.hidden = YES;
    }
    return _noSaleLabel;
}

@end
