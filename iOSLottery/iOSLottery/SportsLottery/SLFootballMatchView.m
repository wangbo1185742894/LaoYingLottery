//
//  SLFootballMatchView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLSPFPlayView.h"
#import "SLFootballMatchView.h"
#import "SLConfigMessage.h"
#import "SLMatchBetModel.h"
#import "SLBetInfoManager.h"
#import "SLBetSelectInfo.h"
#import "SLSPFModel.h"
@interface SLFootballMatchView ()

@property (nonatomic, strong) SLSPFPlayView *normalPlay;

@property (nonatomic, strong) SLSPFPlayView *singlePassPlay;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation SLFootballMatchView

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
    [self addSubview:self.normalPlay];
    [self addSubview:self.singlePassPlay];
    
    [self addSubview:self.leftLine];
    [self addSubview:self.topLine];
    [self addSubview:self.bottomLine];
    [self addSubview:self.rightLine];
    [self bringSubviewToFront:self.bottomLine];
}

- (void)addConstraints
{

    [self.normalPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self);
    }];
    
    [self.singlePassPlay mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.normalPlay.mas_bottom);
        make.left.right.bottom.equalTo(self);
        
    }];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.26);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(0.26);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.singlePassPlay);
        make.height.mas_equalTo(0.26);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.right.bottom.equalTo(self);
        make.width.mas_equalTo(0.26);
    }];
}

#pragma mark --- Set Method ---

- (void)setPlayModel:(SLMatchBetModel *)playModel
{

    _playModel = playModel;
    
    self.normalPlay.matchIssue = playModel.match_issue;
    
    self.singlePassPlay.matchIssue = playModel.match_issue;
    
    self.normalPlay.spfModel = playModel.spf;
    
    self.singlePassPlay.spfModel = playModel.rqspf;

}

- (void)setLeftLineShow:(BOOL)leftLineShow
{

    _leftLineShow = leftLineShow;
    
    self.leftLine.hidden = !leftLineShow;

}

- (void)setRightLineShow:(BOOL)rightLineShow
{

    _rightLineShow = rightLineShow;
    
    self.rightLine.hidden = !rightLineShow;

}

- (void)setTopLineShow:(BOOL)topLineShow
{

    _topLineShow = topLineShow;
    
    self.topLine.hidden = !topLineShow;
}

- (void)setBottomLineShow:(BOOL)bottomLineShow
{

    _bottomLineShow = bottomLineShow;
    
    self.bottomLine.hidden = !bottomLineShow;
}

- (void)setSelectedInfo:(SLBetSelectSingleGameInfo *)selectedInfo{
    
    self.normalPlay.hostWinBtn.selected = NO;
    self.normalPlay.dogfallBtn.selected = NO;
    self.normalPlay.guestWinBtn.selected = NO;
    self.singlePassPlay.hostWinBtn.selected = NO;
    self.singlePassPlay.dogfallBtn.selected = NO;
    self.singlePassPlay.guestWinBtn.selected = NO;
    
    for (SLBetSelectPlayMothedInfo *playMothedInfo in selectedInfo.singleBetSelectArray) {
        if ([playMothedInfo.playMothed isEqualToString:SPF]) {
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"3"]) {
                self.normalPlay.hostWinBtn.selected = YES;
            }else{
                self.normalPlay.hostWinBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"1"]) {
                self.normalPlay.dogfallBtn.selected = YES;
            }else{
                self.normalPlay.dogfallBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"0"]) {
                self.normalPlay.guestWinBtn.selected = YES;
            }else{
                self.normalPlay.guestWinBtn.selected = NO;
            }
        }
        if ([playMothedInfo.playMothed isEqualToString:RQSPF]) {
            
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10003"]) {
                self.singlePassPlay.hostWinBtn.selected = YES;
            }else{
                self.singlePassPlay.hostWinBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10001"]) {
                self.singlePassPlay.dogfallBtn.selected = YES;
            }else{
                self.singlePassPlay.dogfallBtn.selected = NO;
            }
            if ([playMothedInfo.selectPlayMothedArray containsObject:@"10000"]) {
                self.singlePassPlay.guestWinBtn.selected = YES;
            }else{
                self.singlePassPlay.guestWinBtn.selected = NO;
            }
        }
    }
    
}

#pragma mark --- Get Method ---
- (SLSPFPlayView *)normalPlay
{

    if (_normalPlay == nil) {
        WS_SL(_weakSelf)
        _normalPlay = [[SLSPFPlayView alloc] initWithFrame:(CGRectZero)];
        _normalPlay.clickButtonBlock = ^(BOOL isSelect, NSInteger selectNumber) {
            
            if (isSelect) {
                [SLBetInfoManager saveSelectBetInfoWithMatchIssue:_weakSelf.playModel.match_issue palyMothed:SPF selectItem:@[[NSString stringWithFormat:@"%zi", selectNumber]] isDanGuan:(_weakSelf.playModel.spf.danguan == 1)];
            }else{
                [SLBetInfoManager removeSelectBetInfoWithMatchIssue:_weakSelf.playModel.match_issue palyMothed:SPF selectItem:@[[NSString stringWithFormat:@"%zi", selectNumber]]];
            }
            !_weakSelf.reloadSelectNumberBlock ? : _weakSelf.reloadSelectNumberBlock();
        };
    }

    return _normalPlay;
}

- (SLSPFPlayView *)singlePassPlay
{

    if (_singlePassPlay == nil) {
        WS_SL(_weakSelf)
        _singlePassPlay = [[SLSPFPlayView alloc] initWithFrame:(CGRectZero)];
        _singlePassPlay.clickButtonBlock = ^(BOOL isSelect, NSInteger selectNumber) {
           
            if (isSelect) {
                [SLBetInfoManager saveSelectBetInfoWithMatchIssue:_weakSelf.playModel.match_issue palyMothed:RQSPF selectItem:@[[NSString stringWithFormat:@"1000%zi", selectNumber ]] isDanGuan:(_weakSelf.playModel.rqspf.danguan == 1) rangQiuCount:_weakSelf.playModel.rqspf.handicap];
            }else{
                [SLBetInfoManager removeSelectBetInfoWithMatchIssue:_weakSelf.playModel.match_issue palyMothed:RQSPF selectItem:@[[NSString stringWithFormat:@"1000%zi", selectNumber]]];
            }
            !_weakSelf.reloadSelectNumberBlock ? : _weakSelf.reloadSelectNumberBlock();
        };
    }
    
    return _singlePassPlay;
}

- (UIView *)leftLine
{

    if (_leftLine == nil) {
        
        _leftLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _leftLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }

    return _leftLine;
}

- (UIView *)rightLine
{
    if (_rightLine == nil) {
        
        _rightLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _rightLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _rightLine;
}

- (UIView *)topLine
{
    if (_topLine == nil) {
        
        _topLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _topLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _topLine;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _bottomLine;
}

@end
