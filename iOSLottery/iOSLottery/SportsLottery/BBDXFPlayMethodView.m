//
//  BBDXFPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBDXFPlayMethodView.h"

#import "SLConfigMessage.h"
#import "BBOddsItemButton.h"

#import "BBMatchModel.h"
#import "BBDXFModel.h"

#import "BBMatchInfoManager.h"

#import "BBSeletedGameModel.h"

#import "BBNoSaleLabel.h"

#import "BBBetDetailsInfoManager.h"

#import "SLExternalService.h"

@interface BBDXFPlayMethodView ()

@property (nonatomic, strong) UILabel *playNameLabel;

/**
 单关标签
 */
@property (nonatomic, strong) UIImageView *tagImageView;

@property (nonatomic, strong) BBOddsItemButton *bigScoreItem;

@property (nonatomic, strong) BBOddsItemButton *smallScoreItem;

@property (nonatomic, strong) BBNoSaleLabel *noSaleLabel;

@end

@implementation BBDXFPlayMethodView

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
    
    [self addSubview:self.tagImageView];

    [self addSubview:self.bigScoreItem];
    [self addSubview:self.smallScoreItem];
    
    [self addSubview:self.noSaleLabel];

    self.playNameLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(10.f), SL__SCALE(40.f), SL__SCALE(14.f));
    
    self.tagImageView.frame = CGRectMake(SL__SCALE(52.f), SL__SCALE(11.f), SL__SCALE(24.f),SL__SCALE(12.f));
    
    self.noSaleLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(320.f), SL__SCALE(40.f));
    
    self.bigScoreItem.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(160.f), SL__SCALE(40.f));
    
    self.smallScoreItem.frame = CGRectMake(CGRectGetMaxX(self.bigScoreItem.frame), CGRectGetMinY(self.bigScoreItem.frame), SL__SCALE(160.f), SL__SCALE(40.f));
    
}

- (void)oddsItemClick:(BBOddsItemButton *)item
{
    
    if (self.dxfInfo.isDanGuan == NO) {
        
        if ([BBBetDetailsInfoManager isShowToast]) {
            
            [SLExternalService showError:@"只有一场赛事，不能选择非单关玩法"];
            return;
        }
        
    }
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%02zi",item.tag];
    
    if (item.isSelected == YES) {
        
        [self.dxfInfo.selectPlayMothedArray addObject:selectTag];
        
    }else{
        
        [self.dxfInfo.selectPlayMothedArray removeObject:selectTag];
    }
}

- (void)setMatchModel:(BBMatchModel *)matchModel
{
    
    _matchModel = matchModel;
    
    self.tagImageView.hidden = !matchModel.dxf_danguan;
    
    if (matchModel.dxf_sale_status == 0) {
        
        self.noSaleLabel.hidden = NO;
        
        return;
    }
    
    NSString *smallScore = [NSString stringWithFormat:@"小于%@",matchModel.dxf.odds];
    NSString *bigScore = [NSString stringWithFormat:@"大于%@",matchModel.dxf.odds];
    
    [self.bigScoreItem setPlayName:bigScore];
    [self.bigScoreItem setOdds:matchModel.dxf.sp.big];
    
    [self.smallScoreItem setPlayName:smallScore];
    [self.smallScoreItem setOdds:matchModel.dxf.sp.small];
    
    BBSeletedGameModel *selectedInfo = [[BBMatchInfoManager shareManager] getSingleMatchSelectInfoWithMatchIssue:matchModel.match_issue];
    
    if (selectedInfo == nil) return;
    
    
    for (NSString *selectedStr in selectedInfo.dxfInfo.selectPlayMothedArray) {
        
        [self.dxfInfo.selectPlayMothedArray addObject:selectedStr];
    }
    
    if ([self.dxfInfo.selectPlayMothedArray containsObject:@"102"]) {
        
        self.bigScoreItem.selected = YES;
    }else{
        
        self.bigScoreItem.selected = NO;
    }
    
    if ([self.dxfInfo.selectPlayMothedArray containsObject:@"101"]) {
        
        self.smallScoreItem.selected = YES;
        
    }else{
        
        self.smallScoreItem.selected = NO;
    }
    
    self.dxfInfo.playMothed = @"dxf";
    self.dxfInfo.isDanGuan = self.matchModel.dxf_danguan;
    
}

- (UILabel *)playNameLabel
{
    if (_playNameLabel == nil) {
        
        _playNameLabel = [[UILabel alloc] init];
        _playNameLabel.text = @"大小分";
        _playNameLabel.textColor = SL_UIColorFromRGB(0x333333);
        _playNameLabel.font = SL_FONT_SCALE(12.f);
        _playNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _playNameLabel;
}

- (UIImageView *)tagImageView
{
    if (_tagImageView == nil) {
        
        _tagImageView = [[UIImageView alloc] init];
        
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
        _tagImageView.image = [UIImage imageNamed:@"allOddsDanGuan.png"];
    }
    
    return _tagImageView;
}

- (BBOddsItemButton *)bigScoreItem
{
    
    if (_bigScoreItem == nil) {
        
        _bigScoreItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_bigScoreItem setShowBottomLine:YES];
        
        _bigScoreItem.tag = 102;
        
        [_bigScoreItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _bigScoreItem;
}

- (BBOddsItemButton *)smallScoreItem
{
    
    if (_smallScoreItem == nil) {
        
        _smallScoreItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_smallScoreItem setShowRightLine:YES];
        [_smallScoreItem setShowBottomLine:YES];
        
        _smallScoreItem.tag = 101;
        
        [_smallScoreItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _smallScoreItem;
    
}

- (BBSelectPlayMethodInfo *)dxfInfo
{
    if (_dxfInfo == NO) {
        
        _dxfInfo = [[BBSelectPlayMethodInfo alloc] init];
        
        _dxfInfo.selectPlayMothedArray = [NSMutableArray new];
        
    }
    return _dxfInfo;
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
