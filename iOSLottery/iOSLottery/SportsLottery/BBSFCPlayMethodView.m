//
//  BBSFCPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBSFCPlayMethodView.h"

#import "SLConfigMessage.h"

#import "BBOddsItemButton.h"

#import "BBMatchModel.h"
#import "BBSFCModel.h"

#import "BBMatchInfoManager.h"

#import "BBSeletedGameModel.h"
#import "BBNoSaleLabel.h"

#import "BBBetDetailsInfoManager.h"

#import "SLExternalService.h"

@interface BBSFCPlayMethodView ()

/**
 玩法名Label
 */
@property (nonatomic, strong) UILabel *playNameLabel;

/**
 单关标签image
 */
@property (nonatomic, strong) UIImageView *tagImageView;

/**
 客胜标签Label
 */
@property (nonatomic, strong) UILabel *awayWinLabel;

/**
 主胜标签Label
 */
@property (nonatomic, strong) UILabel *hostWinLabel;

@property (nonatomic, strong) BBNoSaleLabel *noSaleLabel;

@property (nonatomic, strong) UILabel *backView;

@property (nonatomic, strong) NSMutableArray *oddsItemArray;

@property (nonatomic, strong) NSArray *playMethodArray;

@end

@implementation BBSFCPlayMethodView

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
    
    self.playNameLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(10.f), SL__SCALE(40.f), SL__SCALE(14.f));
    
    self.tagImageView.frame = CGRectMake(SL__SCALE(52.f), SL__SCALE(11.f), SL__SCALE(24.f),SL__SCALE(12.f));
    
    self.awayWinLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(20.f), SL__SCALE(80.f));
    
    [self addSubview:self.awayWinLabel];
    
    self.hostWinLabel.frame = CGRectMake(CGRectGetMinX(self.awayWinLabel.frame), CGRectGetMaxY(self.awayWinLabel.frame), SL__SCALE(20.f), SL__SCALE(80.f));
    
    [self addSubview:self.hostWinLabel];
    
    CGFloat itemWidth = SL__SCALE(100.f);
    CGFloat itemHeight = SL__SCALE(40.f);
    
    int row,col = 0;
    
    for (int i = 0; i < 12; i ++) {
        
        row = i / 3;
        col = i % 3;
        
        BBOddsItemButton *oddsItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectMake(SL__SCALE(30.f) + col * itemWidth, SL__SCALE(30.f) + row * itemHeight, itemWidth, itemHeight))];
        
        [oddsItem setShowRightLine:i == 2 || i == 5 || i == 8 || i == 11];
        
        [oddsItem setShowBottomLine:i == 9 || i == 10 || i == 11];
        
        [oddsItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:oddsItem];
        
        [self.oddsItemArray addObject:oddsItem];
    }
    
    [self.oddsItemArray enumerateObjectsUsingBlock:^(BBOddsItemButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        item.tag = [self.playMethodArray[idx] integerValue];
        
    }];
    
    [self addSubview:self.noSaleLabel];
    
    self.noSaleLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(320.f), SL__SCALE(40.f));
}

- (void)oddsItemClick:(BBOddsItemButton *)item
{
    
    if (self.sfcInfo.isDanGuan == NO) {
        
        if ([BBBetDetailsInfoManager isShowToast]) {
            
            [SLExternalService showError:@"只有一场赛事，不能选择非单关玩法"];
            
            NSLog(@"不能选了，老铁！");
            
            return;
        }
        
    }
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%02zi",item.tag];
    
    
    if (item.isSelected == YES) {
        
        [self.sfcInfo.selectPlayMothedArray addObject:selectTag];
        
    }else{
        
        [self.sfcInfo.selectPlayMothedArray removeObject:selectTag];
    }
    
    self.sfcInfo.playMothed = @"sfc";
    self.sfcInfo.isDanGuan = self.matchModel.sfc_danguan;
}



- (void)setMatchModel:(BBMatchModel *)matchModel
{
    
    _matchModel = matchModel;
    
    self.tagImageView.hidden = !matchModel.sfc_danguan;
    
    if (matchModel.sfc_sale_status == 0) {
        
        [self.oddsItemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [obj setHidden:YES];
        }];
        
        self.awayWinLabel.hidden = YES;
        self.hostWinLabel.hidden = YES;
        
        self.noSaleLabel.hidden = NO;
        
        return;
    }
    
    NSArray *playNameArray = @[@"1-5",@"6-10",@"11-15",
                               @"16-20",@"21-25",@"26+",
                               @"1-5",@"6-10",@"11-15",
                               @"16-20",@"21-25",@"26+"];
    
    NSArray *oddsArray = @[matchModel.sfc.sp.away_1_5,
                           matchModel.sfc.sp.away_6_10,
                           matchModel.sfc.sp.away_11_15,
                           matchModel.sfc.sp.away_16_20,
                           matchModel.sfc.sp.away_21_25,
                           matchModel.sfc.sp.away_26,
                           matchModel.sfc.sp.host_1_5,
                           matchModel.sfc.sp.host_6_10,
                           matchModel.sfc.sp.host_11_15,
                           matchModel.sfc.sp.host_16_20,
                           matchModel.sfc.sp.host_21_25,
                           matchModel.sfc.sp.host_26];
    
    
    if (playNameArray.count != oddsArray.count) return;
    
    [self.oddsItemArray enumerateObjectsUsingBlock:^(BBOddsItemButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [item setPlayName:playNameArray[idx]];
        [item setOdds:oddsArray[idx]];
        
    }];
    
    
    BBSeletedGameModel *selectedInfo = [[BBMatchInfoManager shareManager] getSingleMatchSelectInfoWithMatchIssue:matchModel.match_issue];
    
    if (selectedInfo == nil) return;
    
    for (NSString *selectedStr in selectedInfo.sfcInfo.selectPlayMothedArray) {
        
        [self.sfcInfo.selectPlayMothedArray addObject:selectedStr];
    }
    
    for (BBOddsItemButton *item in self.oddsItemArray) {
        
        item.selected = [selectedInfo.sfcInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%02zi", item.tag]];
    }
    
    self.sfcInfo.playMothed = @"sfc";
    self.sfcInfo.isDanGuan = self.matchModel.sfc_danguan;
}


- (UILabel *)playNameLabel
{
    
    if (_playNameLabel == nil) {
        
        _playNameLabel = [[UILabel alloc] init];
        _playNameLabel.text = @"胜分差";
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

- (UILabel *)awayWinLabel
{
    
    if (_awayWinLabel == nil) {
        
        _awayWinLabel = [[UILabel alloc] init];
        _awayWinLabel.text = @"客\n胜";
        _awayWinLabel.textColor = SL_UIColorFromRGB(0x2BC57C);
        _awayWinLabel.font = SL_FONT_SCALE(10.f);
        
        _awayWinLabel.textAlignment = NSTextAlignmentCenter;
        
        _awayWinLabel.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        
        _awayWinLabel.numberOfLines = 0;
        
        _awayWinLabel.clipsToBounds = YES;
        
        UIView *topLine = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(20.f), 0.51))];
        topLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        [_awayWinLabel addSubview:topLine];
        
        UIView *leftLine = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0.51, SL__SCALE(80.f)))];
        leftLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        [_awayWinLabel addSubview:leftLine];

    }
    return _awayWinLabel;
}

- (UILabel *)hostWinLabel
{
    if (_hostWinLabel == nil) {
        
        _hostWinLabel = [[UILabel alloc] init];
        _hostWinLabel.text = @"主\n胜";
        _hostWinLabel.textColor = SL_UIColorFromRGB(0xFC5548);
        _hostWinLabel.font = SL_FONT_SCALE(10.f);
        
        _hostWinLabel.textAlignment = NSTextAlignmentCenter;
        
        _hostWinLabel.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        
        _hostWinLabel.numberOfLines = 0;
        
        _hostWinLabel.clipsToBounds = YES;
        
        UIView *topLine = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, SL__SCALE(20.f), 0.51))];
        topLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        [_hostWinLabel addSubview:topLine];
        
        UIView *leftLine = [[UIView alloc] initWithFrame:(CGRectMake(0, 0, 0.51, SL__SCALE(80.f)))];
        leftLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        [_hostWinLabel addSubview:leftLine];
        
        UIView *buttomLine = [[UIView alloc] initWithFrame:(CGRectMake(0, SL__SCALE(80.f) - 0.51, SL__SCALE(20.f), 0.51))];
        buttomLine.backgroundColor = SL_UIColorFromRGB(0xece5dd);
        
        [_hostWinLabel addSubview:buttomLine];
    }
    return _hostWinLabel;
}

- (BBNoSaleLabel *)noSaleLabel
{
    
    if (_noSaleLabel == nil) {
        
        _noSaleLabel = [[BBNoSaleLabel alloc] init];
        
        _noSaleLabel.hidden = YES;
    }
    return _noSaleLabel;
}

- (NSArray *)playMethodArray
{
    
    if (_playMethodArray == nil) {
        
        _playMethodArray = @[@"01",@"02",@"03",@"04",@"05",@"06",
                             @"31",@"32",@"33",@"34",@"35",@"36"];
    }
    return _playMethodArray;
}

- (BBSelectPlayMethodInfo *)sfcInfo
{
    if (_sfcInfo == NO) {
        
        _sfcInfo = [[BBSelectPlayMethodInfo alloc] init];
        
        _sfcInfo.selectPlayMothedArray = [NSMutableArray new];
        
    }
    return _sfcInfo;
}

- (NSMutableArray *)oddsItemArray
{
    
    if (_oddsItemArray == nil) {
        
        _oddsItemArray = [NSMutableArray new];
    }
    return _oddsItemArray;
}

@end
