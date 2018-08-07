//
//  SLMatchBetCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//
#import "SLConfigMessage.h"
#import "SLMatchBetCell.h"
#import "SLMatchTitleView.h"
#import "SLMatchInfoView.h"
#import "SLFootballMatchView.h"
#import "SLSPFPlayView.h"
#import "SLMatchHistoryView.h"
#import "SLMatchHistoryModel.h"
#import "SLMatchBetModel.h"
#import "SLBetInfoManager.h"
#import "UIImageView+WebCache.h"
#import "SLExternalService.h"

#import "UIImage+SLImage.h"
//#import <UIImageView+AFNetworking.h>
@interface SLMatchBetCell ()

/**
 置顶图片
 */
@property (nonatomic, strong) UIImageView *stickImageView;

/**
 比赛标题Label
 */
@property (nonatomic, strong) SLMatchTitleView *matchTitle;

/**
 比赛信息View
 */
@property (nonatomic, strong) SLMatchInfoView *matchInfoView;

/**
 玩法选项
 */
@property (nonatomic, strong) SLFootballMatchView *playMethod;

/**
 展开选项按钮
 */
@property (nonatomic, strong) UIButton *optionBtn;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;


/**
 隐藏部分 历史战绩
 */
@property (nonatomic, strong) SLMatchHistoryView *historyView;


@property (nonatomic, strong) UITableView *mainTableView;

@end

@implementation SLMatchBetCell

+ (SLMatchBetCell *)createBetCellWithTableView:(UITableView *)tableView;
{
    
    static NSString *idcell = @"SLMatchBetCell";
    SLMatchBetCell *cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    
    if (!cell) {
        cell = [[SLMatchBetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
    }
    return cell;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
    }

    return self;
}

-(void)addSubviews
{
    [self.contentView addSubview:self.stickImageView];
    
    [self.contentView addSubview:self.matchTitle];
    [self.contentView addSubview:self.matchInfoView];

    [self.contentView addSubview:self.playMethod];
    [self.contentView addSubview:self.optionBtn];

    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.historyView];

}

- (void)addConstraints
{

    [self.stickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.left.top.equalTo(self.contentView);
        make.width.mas_equalTo(SL__SCALE(60.f));
        make.height.mas_equalTo(SL__SCALE(20.f));

    }];
    
    [self.matchInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left);
        make.centerY.equalTo(self.playMethod);
    }];
    

    
    [self.matchTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(SL__SCALE(25.f));
        make.left.greaterThanOrEqualTo(self.playMethod.mas_left).offset(SL__SCALE(-38.f));
        make.right.lessThanOrEqualTo(self.playMethod.mas_right).offset(SL__SCALE(38.f));
        make.centerX.equalTo(self.playMethod.mas_centerX).offset(SL__SCALE(10.f));
    }];
    
    [self.playMethod mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.matchInfoView.mas_right);
        make.right.equalTo(self.optionBtn.mas_left);
        make.top.equalTo(self.matchTitle.mas_bottom).offset(SL__SCALE(15.f));
        make.height.mas_equalTo(SL__SCALE(70.f));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(SL__SCALE(-12.f));
    }];
    
    [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView.mas_right).offset(SL__SCALE(-10.f));
        make.width.mas_equalTo(SL__SCALE(35));
        make.height.mas_equalTo(SL__SCALE(70));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(SL__SCALE(-12.f));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(0.f));
    }];
}

- (void)selectPlayMothedItemNumber{
    
    
    NSInteger count = [SLBetInfoManager getSingleMatchSelectPlayMothedNumberWithMatchIssue:self.matchBetModel.match_issue];
    
    if (count > 0) {
        
        [_optionBtn setTitle:[NSString stringWithFormat:@"已\n选\n%zi\n项", count] forState:(UIControlStateNormal)];
         _optionBtn.selected = YES;
        
    }else{
        
        [_optionBtn setTitle:@"展\n开\n全\n部" forState:(UIControlStateNormal)];
        _optionBtn.selected = NO;
    }
    
    !self.reloadSelectMatchBlock ? : self.reloadSelectMatchBlock(self);
}

#pragma mark --- Button Click ---
- (void)optionBtnClick:(UIButton *)button
{

    if ([SLBetInfoManager judgeCurrentSelectIsValid:self.matchBetModel.match_issue]) {
        
        !self.unfoldAllOddsBlock ? : self.unfoldAllOddsBlock();
    }else{
        [SLExternalService showError:@"最多支持8场"];
    }
}

#pragma mark --- Set Method ---
- (void)setMatchBetModel:(SLMatchBetModel *)matchBetModel
{

    _matchBetModel = matchBetModel;
    
    self.stickImageView.image = nil;
    if (self.matchBetModel.top_type > 0) {
        
        if (self.matchBetModel.top_image && self.matchBetModel.top_image.length > 0) {
            [self.stickImageView sd_setImageWithURL:[NSURL URLWithString:self.matchBetModel.top_image] placeholderImage:[UIImage imageNamed:@"testAAA"]];
        }
    }

    self.matchTitle.titleModel = matchBetModel;
    self.matchInfoView.infoModel = matchBetModel;
    
    self.historyView.vsModel = matchBetModel.vs;
    self.historyView.hostModel = matchBetModel.host;
    self.historyView.awayModel = matchBetModel.away;
    self.historyView.detailsUrl = matchBetModel.bottom_url;
    
    
    self.playMethod.playModel = matchBetModel;

    //校验
    if (self.historyView.hidden == matchBetModel.isShowHistory) {
        self.historyView.hidden = !matchBetModel.isShowHistory;
        
        [self setUpHistoryViewConstrainsWithIsShow:matchBetModel.isShowHistory];
        
    }
}

//设置历史详情约束
- (void)setUpHistoryViewConstrainsWithIsShow:(BOOL)isShow
{

    [self.historyView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(isShow ? 90.f : 0);
        
    }];
    
    [self updateConstraintsIfNeeded];
}


- (void)setSelectInfoModel:(SLBetSelectSingleGameInfo *)selectInfoModel{
    
    _selectInfoModel = selectInfoModel;
    self.playMethod.selectedInfo = selectInfoModel;
}
#pragma mark --- Get Method ---

- (SLMatchTitleView *)matchTitle
{

    if (_matchTitle == nil) {
        
        _matchTitle = [[SLMatchTitleView alloc] initWithFrame:CGRectZero];
    }
    return _matchTitle;
}

- (SLMatchInfoView *)matchInfoView
{

    if (_matchInfoView == nil) {
        
        _matchInfoView = [[SLMatchInfoView alloc] initWithFrame:(CGRectZero)];
        
        WS_SL(ws)
        [_matchInfoView returnShowHistoryClick:^{
           
            !ws.showHistoryBlock ? : ws.showHistoryBlock(ws);
        }];
    }
    
    return _matchInfoView;
}



- (SLFootballMatchView *)playMethod
{

    if (_playMethod == nil) {
        WS_SL(ws)
        _playMethod = [[SLFootballMatchView alloc] initWithFrame:CGRectZero];
        _playMethod.backgroundColor = [UIColor clearColor];
        _playMethod.leftLineShow = NO;
        _playMethod.rightLineShow = NO;
        _playMethod.reloadSelectNumberBlock = ^{
           
            [ws selectPlayMothedItemNumber];
        };
    }

    return _playMethod;
}


- (UIButton *)optionBtn
{

    if (_optionBtn == nil) {
        
        _optionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_optionBtn setTitle:@"展\n开\n全\n部" forState:(UIControlStateNormal)];
        _optionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [_optionBtn setTitleColor:SL_UIColorFromRGB(0x8F6E51) forState:(UIControlStateNormal)];
        
        [_optionBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xFFFFFF)] forState:(UIControlStateNormal)];
        
        [_optionBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xECE5DD)] forState:(UIControlStateSelected)];
        
        _optionBtn.titleLabel.font = SL_FONT_SCALE(12);
        _optionBtn.titleLabel.numberOfLines = 0;
        _optionBtn.layer.borderWidth = 0.5;
        _optionBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        [_optionBtn addTarget:self action:@selector(optionBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [_optionBtn setAdjustsImageWhenHighlighted:NO];
    
    }
    return _optionBtn;
}


- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xDDDDDD);
    }

    return _bottomLine;
}

- (UIImageView *)stickImageView{
    
    if (!_stickImageView) {
        _stickImageView = [[UIImageView alloc] init];
        _stickImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _stickImageView;
}

- (SLMatchHistoryView *)historyView{
    
    if (!_historyView) {
        _historyView = [[SLMatchHistoryView alloc] initWithFrame:CGRectZero];
        _historyView.hidden = YES;
        WS_SL(_weakSelf)
        _historyView.onClickBlock = ^(){
            
            !_weakSelf.historyOnClickBlock ? : _weakSelf.historyOnClickBlock(_weakSelf.matchBetModel.bottom_url);
        };
    }
    return _historyView;
}
@end
