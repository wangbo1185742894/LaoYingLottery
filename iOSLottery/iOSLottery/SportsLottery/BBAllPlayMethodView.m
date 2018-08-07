//
//  BBAllPlayMethodView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBAllPlayMethodView.h"

#import "SLConfigMessage.h"

#import "BBMatchTitleView.h"

#import "SLBottomBtnView.h"

#import "BBOddsItemButton.h"

#import "BBSFPlayMethodView.h"
#import "BBRFSFPlayMethodView.h"
#import "BBDXFPlayMethodView.h"
#import "BBSFCPlayMethodView.h"

#import "BBSeletedGameModel.h"
#import "BBMatchModel.h"

#import "BBMatchInfoManager.h"

@interface BBAllPlayMethodView ()

@property (nonatomic, strong) BBMatchTitleView *matchTitleView;

@property (nonatomic, strong) SLBottomBtnView *bottomView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) BBSFPlayMethodView *sf_playMethodView;

@property (nonatomic, strong) BBRFSFPlayMethodView *rfsf_playMethodView;

@property (nonatomic, strong) BBDXFPlayMethodView *dxf_playMethodView;

@property (nonatomic, strong) BBSFCPlayMethodView *sfc_playMethodView;

@end

@implementation BBAllPlayMethodView

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
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.matchTitleView];
    
    
    [self.contentView addSubview:self.sf_playMethodView];
    [self.contentView addSubview:self.rfsf_playMethodView];
    [self.contentView addSubview:self.dxf_playMethodView];
    [self.contentView addSubview:self.sfc_playMethodView];
    
    
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.topLineView];


}

- (void)addConstraints
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(SL__SCALE(18.f));
        make.top.equalTo(self).offset(SL__SCALE(72.f));
        make.bottom.equalTo(self).offset(SL__SCALE(-71.f));
        make.right.equalTo(self).offset(SL__SCALE(-17.f));
    }];
    
    [self.matchTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(44.f));
    }];
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.matchTitleView.mas_bottom);
        make.height.mas_equalTo(0.5f);
        
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        

        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(60));
        
    }];

}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.sf_playMethodView.frame = CGRectMake(0, SL__SCALE(44.f), self.contentView.frame.size.width, SL__SCALE(70.f));
    
    self.rfsf_playMethodView.frame = CGRectMake(0, CGRectGetMaxY(self.sf_playMethodView.frame), self.contentView.frame.size.width, SL__SCALE(70.f));
    
    self.dxf_playMethodView.frame = CGRectMake(0, CGRectGetMaxY(self.rfsf_playMethodView.frame), self.contentView.frame.size.width, SL__SCALE(70.f));
    
    self.sfc_playMethodView.frame = CGRectMake(0, CGRectGetMaxY(self.dxf_playMethodView.frame), self.contentView.frame.size.width, SL__SCALE(190.f));
}



- (void)showInWindow
{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}

//底部确定按钮点击事件
- (void)confimButtonOnClick
{
    
    if (self.sf_playMethodView.sfInfo.selectPlayMothedArray.count == 0 && self.rfsf_playMethodView.rfsfInfo.selectPlayMothedArray.count == 0 && self.dxf_playMethodView.dxfInfo.selectPlayMothedArray.count == 0 && self.sfc_playMethodView.sfcInfo.selectPlayMothedArray.count == 0) {
        
        self.sureClearMatchBlock ? self.sureClearMatchBlock() : nil;
        
        return;
    }
    
 
    BBSeletedGameModel *gameInfo = [[BBSeletedGameModel alloc] init];
    
    gameInfo.matchIssue = self.currentMatchInfo.match_issue;
    
    gameInfo.sfInfo = self.sf_playMethodView.sfInfo;
    gameInfo.rfsfInfo = self.rfsf_playMethodView.rfsfInfo;
    gameInfo.dxfInfo = self.dxf_playMethodView.dxfInfo;
    gameInfo.sfcInfo = self.sfc_playMethodView.sfcInfo;
    
    [[BBMatchInfoManager shareManager] saveOneMatchSelectInfo:gameInfo];
    
    !self.reloadSelectDataBlock ? : self.reloadSelectDataBlock(self.selectIndexPath);
    
    [self removeFromSuperview];
}

- (void)setCurrentMatchInfo:(BBMatchModel *)currentMatchInfo
{

    _currentMatchInfo = currentMatchInfo;
    
    self.matchTitleView.titleModel = currentMatchInfo;
    
    self.sf_playMethodView.matchModel = currentMatchInfo;
    
    self.rfsf_playMethodView.matchModel = currentMatchInfo;
    
    self.dxf_playMethodView.matchModel = currentMatchInfo;
    
    self.sfc_playMethodView.matchModel = currentMatchInfo;
}

#pragma mark ------------ getter Mothed ------------
- (UIView *)backView
{
    
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7);
    }
    return _backView;
}

- (UIView *)contentView
{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        _contentView.layer.cornerRadius = 5.f;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (BBMatchTitleView *)matchTitleView
{
    
    if (!_matchTitleView) {
        _matchTitleView = [[BBMatchTitleView alloc] initWithFrame:CGRectZero];
        
        [_matchTitleView setShowRank:NO];
    }
    return _matchTitleView;
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
- (UIView *)topLineView{
    
    if (!_topLineView) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _topLineView;
}

- (BBSFPlayMethodView *)sf_playMethodView
{

    if (_sf_playMethodView == nil) {
        
        _sf_playMethodView = [[BBSFPlayMethodView alloc] init];
    }
    return _sf_playMethodView;
}

- (BBRFSFPlayMethodView *)rfsf_playMethodView
{

    if (_rfsf_playMethodView == nil) {
        
        _rfsf_playMethodView = [[BBRFSFPlayMethodView alloc] init];
    }
    return _rfsf_playMethodView;
}

- (BBDXFPlayMethodView *)dxf_playMethodView
{

    if (_dxf_playMethodView == nil) {
        
        _dxf_playMethodView = [[BBDXFPlayMethodView alloc] init];
    }
    return _dxf_playMethodView;
}

- (BBSFCPlayMethodView *)sfc_playMethodView
{

    if (_sfc_playMethodView == nil) {
        
        _sfc_playMethodView = [[BBSFCPlayMethodView alloc] init];
    }
    return _sfc_playMethodView;
}

@end
