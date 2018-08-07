//
//  BBRFSFPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBRFSFPlayMethodView.h"

#import "SLConfigMessage.h"

#import "BBOddsItemButton.h"

#import "BBMatchModel.h"
#import "BBRFSFModel.h"

#import "BBMatchInfoManager.h"

#import "BBBetDetailsInfoManager.h"

#import "SLExternalService.h"

#import "BBSeletedGameModel.h"

#import "BBNoSaleLabel.h"

#import "UILabel+SLAttributeLabel.h"
@interface BBRFSFPlayMethodView ()

@property (nonatomic, strong) UILabel *playNameLabel;

@property (nonatomic, strong) UIImageView *tagImageView;


@property (nonatomic, strong) BBOddsItemButton *awayWinItem;

@property (nonatomic, strong) BBOddsItemButton *hostWinItem;

@property (nonatomic, strong) BBNoSaleLabel *noSaleLabel;

@end

@implementation BBRFSFPlayMethodView

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
    
    [self addSubview:self.awayWinItem];
    [self addSubview:self.hostWinItem];
    
    [self addSubview:self.noSaleLabel];
    
    self.noSaleLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(320.f), SL__SCALE(40.f));
    
    self.playNameLabel.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(9.f), SL__SCALE(30.f), SL__SCALE(14.f));
    
    self.tagImageView.frame = CGRectMake(SL__SCALE(40.f), SL__SCALE(56.f), SL__SCALE(24.f),SL__SCALE(12.f));

    self.awayWinItem.frame = CGRectMake(SL__SCALE(10.f), SL__SCALE(30.f), SL__SCALE(160.f), SL__SCALE(40.f));
    
    self.hostWinItem.frame = CGRectMake(CGRectGetMaxX(self.awayWinItem.frame), CGRectGetMinY(self.awayWinItem.frame), SL__SCALE(160.f), SL__SCALE(40.f));
    
}


- (void)oddsItemClick:(BBOddsItemButton *)item
{
    
    if (self.rfsfInfo.isDanGuan == NO) {
        
        if ([BBBetDetailsInfoManager isShowToast]) {
            
            [SLExternalService showError:@"只有一场赛事，不能选择非单关玩法"];
            
            return;
        }
        
    }
    
    item.selected = ! item.isSelected;
    
    NSString *selectTag = [NSString stringWithFormat:@"%02zi",item.tag];
    
    
    if (item.isSelected == YES) {
        
        [self.rfsfInfo.selectPlayMothedArray addObject:selectTag];
        
    }else{
        
        [self.rfsfInfo.selectPlayMothedArray removeObject:selectTag];
    }
}


- (void)setMatchModel:(BBMatchModel *)matchModel
{
    
    _matchModel = matchModel;
    
    self.tagImageView.hidden = !matchModel.rfsf_danguan;
    
    if (matchModel.rfsf_sale_status == 0) {
        
        self.noSaleLabel.hidden = NO;
        
        return;
    }

    
    [self.awayWinItem setPlayName:@"让主负"];
    [self.awayWinItem setOdds:matchModel.rfsf.sp.loss];
    
    NSString *rangFenStr = [NSString stringWithFormat:@"让主胜_%@",matchModel.rfsf.odds];
    /** 兼容让分胜负玩法 */
    NSArray *itemNameArr = [rangFenStr componentsSeparatedByString:@"_"];
    NSString *itemStrig = [itemNameArr componentsJoinedByString:@""];
    UIColor *tagColor;
    if ([itemStrig rangeOfString:@"+"].length) {
        tagColor = SL_UIColorFromRGB(0xFC5548);
        // #00251E
    }else if([itemStrig rangeOfString:@"-"].length){
        // #2BC57C
        tagColor = SL_UIColorFromRGB(0x2bc57c);
    }
    
    [self.hostWinItem setAttributePlayName:itemStrig attributeArr:@[[SLAttributedTextParams attributeRange:[itemStrig rangeOfString:itemNameArr.lastObject] Color:tagColor]]];
    
    
    [self.hostWinItem setOdds:matchModel.rfsf.sp.win];
    
    BBSeletedGameModel *selectedInfo = [[BBMatchInfoManager shareManager] getSingleMatchSelectInfoWithMatchIssue:matchModel.match_issue];
        
    if (selectedInfo == nil) return;
    
    
    for (NSString *selectedStr in selectedInfo.rfsfInfo.selectPlayMothedArray) {
        
        [self.rfsfInfo.selectPlayMothedArray addObject:selectedStr];
    }
    
    if ([self.rfsfInfo.selectPlayMothedArray containsObject:@"1000"]) {
        
        self.awayWinItem.selected = YES;
    }else{
        
        self.awayWinItem.selected = NO;
    }
    
    if ([self.rfsfInfo.selectPlayMothedArray containsObject:@"1003"]) {
        
        self.hostWinItem.selected = YES;
        
    }else{
        
        self.hostWinItem.selected = NO;
    }
    
    self.rfsfInfo.playMothed = @"rfsf";
    self.rfsfInfo.isDanGuan = self.matchModel.rfsf_danguan;
    self.rfsfInfo.rangFenCount = self.matchModel.rfsf.odds;
}



- (UILabel *)playNameLabel
{
    if (_playNameLabel == nil) {
        
        _playNameLabel = [[UILabel alloc] init];
        _playNameLabel.text = @"让分";
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

- (BBOddsItemButton *)awayWinItem
{
    
    if (_awayWinItem == nil) {
        
        _awayWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_awayWinItem setShowBottomLine:YES];
        
        _awayWinItem.tag = 1000;
        
        [_awayWinItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _awayWinItem;
}

- (BBOddsItemButton *)hostWinItem
{
    
    if (_hostWinItem == nil) {
        
        _hostWinItem = [[BBOddsItemButton alloc] initWithFrame:(CGRectZero)];
        
        [_hostWinItem setShowRightLine:YES];
        [_hostWinItem setShowBottomLine:YES];
        
        _hostWinItem.tag = 1003;
        
        [_hostWinItem addTarget:self action:@selector(oddsItemClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hostWinItem;
    
}

- (BBSelectPlayMethodInfo *)rfsfInfo
{
    if (_rfsfInfo == NO) {
        
        _rfsfInfo = [[BBSelectPlayMethodInfo alloc] init];
        
        _rfsfInfo.selectPlayMothedArray = [NSMutableArray new];
    }
    return _rfsfInfo;
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
