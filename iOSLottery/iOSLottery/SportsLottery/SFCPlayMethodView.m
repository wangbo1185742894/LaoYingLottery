//
//  SFCPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SFCPlayMethodView.h"
#import "SLConfigMessage.h"

#import "BBMatchTitleView.h"

#import "BBOddsItemButton.h"
#import "SLBottomBtnView.h"

#import "BBMatchModel.h"
#import "BBSFCModel.h"

#import "BBMatchInfoManager.h"

#import "BBSeletedGameModel.h"

@interface SFCPlayMethodView ()
/**
 背景View
 */
@property (nonatomic, strong) UIView *backView;

/**
 所有内容的基层View
 */
@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) BBMatchTitleView *matchTitleView;

/**
 上部分割线
 */
@property (nonatomic, strong) UIView *topLineView;

/**
 玩法名Label
 */
@property (nonatomic, strong) UILabel *playNameLabel;

/**
 单关标签image
 */
@property (nonatomic, strong) UIImageView *danGuanImageView;

/**
 客胜标签Label
 */
@property (nonatomic, strong) UILabel *awayWinLabel;

/**
 主胜标签Label
 */
@property (nonatomic, strong) UILabel *hostWinLabel;

@property (nonatomic, strong) SLBottomBtnView *bottomView;

/**
 玩法标记数组
 */
@property (nonatomic, strong) NSArray *playMethodArray;

/**
 玩法项数组
 */
@property (nonatomic, strong) NSMutableArray *oddsItemArray;

@property (nonatomic, strong) BBSelectPlayMethodInfo *sfcInfo;


@end

@implementation SFCPlayMethodView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
      
        [self addSubviews];
        [self addConstraints];

    }
    return self;
}

- (void)addSubviews
{
    [self addSubview:self.backView];
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.matchTitleView];
    [self.baseView addSubview:self.topLineView];
    [self.baseView addSubview:self.playNameLabel];
    [self.baseView addSubview:self.duanGuanImageView];
    [self.baseView addSubview:self.bottomView];

    [self createContent];
}

- (void)addConstraints
{
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(SL__SCALE(18.f));
        make.top.equalTo(self).offset(SL__SCALE(176.f));
        make.bottom.equalTo(self).offset(SL__SCALE(-176.f));
        make.right.equalTo(self).offset(SL__SCALE(-18.f));
    }];
    
    [self.matchTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.baseView);
        make.height.mas_equalTo(SL__SCALE(44.f));
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.baseView);
        make.top.equalTo(self.matchTitleView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.baseView);
        make.height.mas_equalTo(SL__SCALE(60));
        
    }];
    
}


- (void)createContent
{
    self.playNameLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(55.f), SL__SCALE(40.f), SL__SCALE(14.f));
    
    self.danGuanImageView.frame = CGRectMake(SL__SCALE(52.f), SL__SCALE(56.f), SL__SCALE(24.f),SL__SCALE(12.f));

    self.awayWinLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(75.f), SL__SCALE(20.f), SL__SCALE(80.f));

    [self.baseView addSubview:self.awayWinLabel];
    
    self.hostWinLabel.frame = CGRectMake(CGRectGetMinX(self.awayWinLabel.frame), CGRectGetMaxY(self.awayWinLabel.frame), SL__SCALE(20.f), SL__SCALE(80.f));
    
    [self.baseView addSubview:self.hostWinLabel];
    
    
    CGFloat itemWidth = SL__SCALE(100.f);
    CGFloat itemHeight = SL__SCALE(40.f);
    
    int row,col = 0;
    
    for (int i = 0; i < 12; i ++) {
       
        row = i / 3;
        col = i % 3;
        
        BBOddsItemButton *oddsItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectMake(SL__SCALE(30.f) + col * itemWidth, SL__SCALE(75.f) + row * itemHeight, itemWidth, itemHeight))];
        
        [oddsItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [oddsItem setShowRightLine:i == 2 || i == 5 || i == 8 || i == 11];
        
        [oddsItem setShowBottomLine:i == 9 || i == 10 || i == 11];

        
        [self.baseView addSubview:oddsItem];
        
        [self.oddsItemArray addObject:oddsItem];
    }
    
    [self.oddsItemArray enumerateObjectsUsingBlock:^(BBOddsItemButton *item, NSUInteger idx, BOOL * _Nonnull stop) {
       
        item.tag = [self.playMethodArray[idx] integerValue];
        
    }];
}


- (void)oddsItemClick:(BBOddsItemButton *)item
{
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%02zi",item.tag];
    
//    if (item.isSelected == YES) {
//        
//        [[BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.matchModel.match_issue palyMothed:@"sfc" selectItem:@[selectTag] isDanGuan:YES];
//        
//    }else{
//        
//        [[BBMatchInfoManager shareManager] removeSelectBetInfoWithMatchIssue:self.matchModel.match_issue palyMothed:@"sfc" selectItem:@[selectTag]];
//    }
    
    if (item.isSelected == YES) {
        
        [self.sfcInfo.selectPlayMothedArray addObject:selectTag];
        
    }else{
    
        [self.sfcInfo.selectPlayMothedArray removeObject:selectTag];
    }

    
}

- (void)confimButtonOnClick
{
    
    
    [[BBMatchInfoManager shareManager] saveSelectBetInfoWithMatchIssue:self.matchModel.match_issue palyMothed:@"sfc" selectItem:self.sfcInfo.selectPlayMothedArray isDanGuan:self.matchModel.sfc_danguan];
    
    self.reloadUIBlock ? self.reloadUIBlock() : nil;
    
    [self removeFromSuperview];
}


- (void)show
{

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
}

- (void)setMatchModel:(BBMatchModel *)matchModel
{

    _matchModel = matchModel;
    
    self.matchTitleView.titleModel = matchModel;
    
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
    
    [self.sfcInfo.selectPlayMothedArray removeAllObjects];
        
    for (BBOddsItemButton *item in self.oddsItemArray) {
        
        item.selected = NO;
    }
    
    if (selectedInfo == nil) return;

    for (NSString *selectedStr in selectedInfo.sfcInfo.selectPlayMothedArray) {
        
        [self.sfcInfo.selectPlayMothedArray addObject:selectedStr];
    }
    
    for (BBOddsItemButton *item in self.oddsItemArray) {
        
        item.selected = [selectedInfo.sfcInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%02zi", item.tag]];
    }
    
}

//- (void)setSelectedInfo:(BBSeletedGameModel *)selectedInfo
//{
//
//    _selectedInfo = selectedInfo;
//    
//    for (NSString *selectedStr in selectedInfo.sfcInfo.selectPlayMothedArray) {
//        
//        [self.sfcInfo.selectPlayMothedArray addObject:selectedStr];
//    }
//    
//    for (BBOddsItemButton *item in self.oddsItemArray) {
//        
//        item.selected = [selectedInfo.sfcInfo.selectPlayMothedArray containsObject:[NSString stringWithFormat:@"%02zi", item.tag]];
//    }
//}

#pragma mark ------------ getter Mothed ------------
- (UIView *)backView{
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7);
    }
    return _backView;
}

- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        _baseView.layer.cornerRadius = 5.f;
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}

- (BBMatchTitleView *)matchTitleView
{

    if (_matchTitleView == nil) {
        
        _matchTitleView = [[BBMatchTitleView alloc] initWithFrame:(CGRectZero)];
        
        [_matchTitleView setShowRank:NO];
    }
    return _matchTitleView;
}

- (UIView *)topLineView
{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
}

- (SLBottomBtnView *)bottomView{
    
    if (!_bottomView) {
        WS_SL(_weakSelf)
        _bottomView = [[SLBottomBtnView alloc] initWithFrame:CGRectZero];
        [_bottomView returnSureClick:^{
            
            [_weakSelf confimButtonOnClick];
        }];
        
        [_bottomView returnCancelClick:^{
            
            [_weakSelf removeFromSuperview];
        }];
    }
    return _bottomView;
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

- (UIImageView *)duanGuanImageView
{

    if (_danGuanImageView == nil) {
    
        _danGuanImageView = [[UIImageView alloc] init];
        _danGuanImageView.contentMode = UIViewContentModeScaleAspectFit;
        _danGuanImageView.image = [UIImage imageNamed:@"allOddsDanGuan.png"];
    }
    return _danGuanImageView;
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

- (NSArray *)playMethodArray
{

    if (_playMethodArray == nil) {
        
        _playMethodArray = @[@"01",@"02",@"03",@"04",@"05",@"06",
                             @"31",@"32",@"33",@"34",@"35",@"36"];
    }
    return _playMethodArray;
}

- (NSMutableArray *)oddsItemArray
{

    if (_oddsItemArray == nil) {
        
        _oddsItemArray = [NSMutableArray new];
    }
    return _oddsItemArray;
}

- (BBSelectPlayMethodInfo *)sfcInfo
{

    if (_sfcInfo == nil) {
        
        _sfcInfo = [[BBSelectPlayMethodInfo alloc] init];
        
        _sfcInfo.selectPlayMothedArray = [NSMutableArray new];
        
    }
    return _sfcInfo;
}

@end
