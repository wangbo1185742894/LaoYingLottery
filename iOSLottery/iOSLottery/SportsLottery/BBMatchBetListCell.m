//
//  BBMatchBetListCell.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBMatchBetListCell.h"

#import "SLConfigMessage.h"

#import "BBMatchTitleView.h"

#import "SLMatchInfoView.h"
#import "BBMatchInfoView.h"


#import "SFCPlayMethodView.h"
#import "BBMatchHistoryView.h"

#import "BBMatchModel.h"


#import "BBSeletedGameModel.h"

#import "BBMatchNewPlayMethodView.h"
#import "BBNoSaleLabel.h"

#import "BBPlayMethodModel.h"
#import "BBPlayMethodTagLabel.h"

#import "BBSFModel.h"
#import "BBRFSFModel.h"
#import "BBDXFModel.h"

#import "SLMatchHistoryModel.h"

#import "UIImage+SLImage.h"
#import "UIImageView+WebCache.h"

#import "BBMatchInfoManager.h"

#import "SLExternalService.h"

@interface BBMatchBetListCell ()

/**
 赛事标签imageView;
 */
@property (nonatomic, strong) UIImageView *tagImageView;

/**
 赛事标题View
 */
@property (nonatomic, strong) BBMatchTitleView *mtachTitleView;

/**
 赛事信息
 */
@property (nonatomic, strong) BBMatchInfoView *matchInfoView;


@property (nonatomic, strong) BBPlayMethodTagLabel *sfcTagLabel;

@property (nonatomic, strong) UIButton *showSFCButton;

@property (nonatomic, strong) SFCPlayMethodView *sfcPlayMethodView;

/**
 历史对战View
 */
@property (nonatomic, strong) BBMatchHistoryView *historyView;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) BBMatchNewPlayMethodView *sf_PlayMethodVeiw;

@property (nonatomic, strong) BBMatchNewPlayMethodView *rfsf_PlayMethodVeiw;

@property (nonatomic, strong) BBMatchNewPlayMethodView *dxf_PlayMethodVeiw;

@property (nonatomic, strong) BBMatchNewPlayMethodView *sfc_PlayMethodVeiw;

@property (nonatomic, strong) BBNoSaleLabel *sfcNoSaleLabel;

@property (nonatomic, strong) NSDictionary *betStringDic;

@property (nonatomic, weak) UITableView *contentTableView;

@end

@implementation BBMatchBetListCell

+ (instancetype)createMatchBetListCellWithTableView:(UITableView *)tableView
{
    
    static NSString *idCell = @"BBMatchBetListCell";
    
    BBMatchBetListCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if (!cell) {
        cell = [[BBMatchBetListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xFAF8F6);
        [self addSubviews];
        [self addConstraints];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}

- (void)addSubviews
{

    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.mtachTitleView];
    [self.contentView addSubview:self.matchInfo];
    [self.contentView addSubview:self.historyView];
    
    
    [self.contentView addSubview:self.sf_PlayMethodVeiw];
    [self.contentView addSubview:self.rfsf_PlayMethodVeiw];
    [self.contentView addSubview:self.dxf_PlayMethodVeiw];
    
    [self.contentView addSubview:self.sfcTagLabel];
    [self.contentView addSubview:self.showSFCButton];
    
    [self.contentView addSubview:self.sfcNoSaleLabel];
    
    [self.contentView addSubview:self.bottomLine];

}

- (void)addConstraints
{

    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.contentView);
        make.width.mas_equalTo(SL__SCALE(60.f));
        make.height.mas_equalTo(SL__SCALE(20.f));
        
    }];
    
    [self.matchInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(SL__SCALE(101.f));
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(SL__SCALE(75.f));
    }];
    

    [self.mtachTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(SL__SCALE(0.f));
        make.left.greaterThanOrEqualTo(self.sf_PlayMethodVeiw.mas_left).offset(SL__SCALE(-5.f));
        make.right.lessThanOrEqualTo(self.sf_PlayMethodVeiw.mas_right).offset(SL__SCALE(5.f));
        make.centerX.equalTo(self.sf_PlayMethodVeiw.mas_centerX);
    }];
    
    
    [self.showSFCButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).offset(SL__SCALE(170.f));
        make.width.mas_equalTo(SL__SCALE(250.f));
        make.height.mas_equalTo(SL__SCALE(40.f));
        make.right.equalTo(self.contentView).offset(SL__SCALE(-10.f));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(SL__SCALE(-9.5f));
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(.51f);
    }];
    
    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomLine.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(0.f));
    }];
    
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    self.sf_PlayMethodVeiw.frame = CGRectMake(SL__SCALE(75.f), SL__SCALE(50.f), SL__SCALE(290.f), SL__SCALE(40.f));
    
    self.rfsf_PlayMethodVeiw.frame = CGRectMake(SL__SCALE(75.f), SL__SCALE(90.f), SL__SCALE(290.f), SL__SCALE(40.f));
    
    self.dxf_PlayMethodVeiw.frame = CGRectMake(SL__SCALE(75.f), SL__SCALE(130.f), SL__SCALE(290.f), SL__SCALE(40.f));
    
    self.sfcTagLabel.frame = CGRectMake(SL__SCALE(75.f), SL__SCALE(170.f), SL__SCALE(40.f), SL__SCALE(40.f));
    
    self.sfcNoSaleLabel.frame = CGRectMake(SL__SCALE(115.f), SL__SCALE(170.f), SL__SCALE(250.f), SL__SCALE(40.f));
}

- (void)setMatchModel:(BBMatchModel *)matchModel
{
    _matchModel = matchModel;
    
    self.mtachTitleView.titleModel = matchModel;
    if (matchModel.top_image && matchModel.top_image.length) {
        [self.tagImageView setImageWithURL:[NSURL URLWithString:matchModel.top_image]];
    }else{
        self.tagImageView.image = nil;
    }
    [self.matchInfoView setMatchLeagueName:matchModel.season_pre];
    [self.matchInfoView setMatchNumber:[NSString stringWithFormat:@"%@%@",matchModel.match_week,matchModel.match_sn]];
    [self.matchInfoView setCutOffTime:matchModel.issue_time_desc];
    //[self.matchInfoView setShowHistory:matchModel.isShowHistory];
    
    self.matchInfoView.infoModel = matchModel;
    
    if (self.historyView.hidden == matchModel.isShowHistory) {
        self.historyView.hidden = !matchModel.isShowHistory;
        
        [self setUpHistoryViewConstrainsWithIsShow:matchModel.isShowHistory];
        
    }
    

    
    /*** 胜负模型  ***/
    
    BBPlayMethodModel *sf_Model = [[BBPlayMethodModel alloc] init];
    sf_Model.matchIssuse = matchModel.match_issue;
    sf_Model.playMethodName = @"sf";
    sf_Model.playMethodTag = @[@"0",@"3"];
    sf_Model.itemNameArray = @[@"主负",@"主胜"];
    sf_Model.oddsArray = @[matchModel.sf.sp.loss ? matchModel.sf.sp.loss : @"1.00",
                           matchModel.sf.sp.win ? matchModel.sf.sp.win : @"1.00"];
    sf_Model.isSale = matchModel.sf_sale_status;
    sf_Model.isDanGuan = matchModel.sf_danguan == 1;
    
    self.sf_PlayMethodVeiw.playMethodModel = sf_Model;
    
    /*** 让分胜负模型 ***/
    
    BBPlayMethodModel *rfsf_Model = [[BBPlayMethodModel alloc] init];
    rfsf_Model.matchIssuse = matchModel.match_issue;
    rfsf_Model.playMethodName = @"rfsf";
    rfsf_Model.playMethodTag = @[@"1000",@"1003"];
    
    NSString *rangFenStr = [NSString stringWithFormat:@"让主胜_%@",matchModel.rfsf.odds];
    
    rfsf_Model.itemNameArray = @[@"让主负",rangFenStr];
    rfsf_Model.oddsArray = @[matchModel.rfsf.sp.loss ? matchModel.rfsf.sp.loss : @"1.00",
                           matchModel.rfsf.sp.win ? matchModel.rfsf.sp.win : @"1.00"];
    rfsf_Model.isSale = matchModel.rfsf_sale_status;
    rfsf_Model.isDanGuan = matchModel.rfsf_danguan == 1;
    rfsf_Model.rangFenNumber = matchModel.rfsf.odds;
    rfsf_Model.isRangFen = YES;
    
    self.rfsf_PlayMethodVeiw.playMethodModel = rfsf_Model;

    
    /*** 大小分模型  ***/
    
    BBPlayMethodModel *dxf_Model = [[BBPlayMethodModel alloc] init];
    dxf_Model.matchIssuse = matchModel.match_issue;
    dxf_Model.playMethodName = @"dxf";
    dxf_Model.playMethodTag = @[@"102",@"101"];
    
    NSString *smallScore = [NSString stringWithFormat:@"小于%@",matchModel.dxf.odds];
    NSString *bigScore = [NSString stringWithFormat:@"大于%@",matchModel.dxf.odds];
    
    dxf_Model.itemNameArray = @[bigScore,smallScore];
    dxf_Model.oddsArray = @[matchModel.dxf.sp.big ? matchModel.dxf.sp.big : @"1.00",
                           matchModel.dxf.sp.small ? matchModel.dxf.sp.small : @"1.00"];
    dxf_Model.isSale = matchModel.dxf_sale_status;
    dxf_Model.isDanGuan = matchModel.dxf_danguan == 1;
    
    self.dxf_PlayMethodVeiw.playMethodModel = dxf_Model;

    [self.sfcTagLabel setShowTag:matchModel.sfc_danguan == 1];
    
    
    //设置sfc玩法未开售label
    self.sfcNoSaleLabel.hidden = !(matchModel.sfc_sale_status == 0);
    
    self.historyView.vsModel = matchModel.vs;
    
    self.historyView.awayModel = matchModel.away;
    self.historyView.hostModel = matchModel.host;
    self.historyView.detailsUrl = matchModel.bottom_url;
    
    WS_SL(weakSelf);
    _historyView.onClickBlock = ^{
        if (weakSelf.historyClickBlock) weakSelf.historyClickBlock(matchModel.bottom_url);
    };
}

//设置历史详情约束
- (void)setUpHistoryViewConstrainsWithIsShow:(BOOL)isShow
{
    
    [self.historyView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(isShow ? 90.f : 0);
        
    }];
    
    [self updateConstraintsIfNeeded];
}

- (void)setSeletedModel:(BBSeletedGameModel *)seletedModel
{

    _seletedModel = seletedModel;
    
    self.sf_PlayMethodVeiw.selectedArray = seletedModel.sfInfo.selectPlayMothedArray;
    
    self.rfsf_PlayMethodVeiw.selectedArray = seletedModel.rfsfInfo.selectPlayMothedArray;
    
    self.dxf_PlayMethodVeiw.selectedArray = seletedModel.dxfInfo.selectPlayMothedArray;
    
    if (seletedModel.sfcInfo.selectPlayMothedArray && seletedModel.sfcInfo.selectPlayMothedArray.count) {
        NSMutableString *betString = [NSMutableString string];
        
        [[seletedModel.sfcInfo.selectPlayMothedArray sortedArrayUsingSelector:@selector(compare:)] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [betString appendString:[NSString stringWithFormat:@"%@ ",self.betStringDic[obj]]];
        }];

        self.showSFCButton.selected = YES;
        [self.showSFCButton setTitle:[betString substringToIndex:betString.length - 1] forState:UIControlStateSelected];
        
    }else{
        
        self.showSFCButton.selected = NO;
        [self.showSFCButton setTitle:@"展开胜分差玩法" forState:UIControlStateNormal];
    }
    
}


#pragma mark ---- Button Click ----
- (void)showSFCPlayMethodView
{

    if ([[BBMatchInfoManager shareManager] isCanSaveSelectBetInfoWithMatchIssue:self.matchModel.match_issue] == NO) {
        
        [SLExternalService showError:@"最多支持8场"];
        
        return;
        
    }
    
    self.sfcPlayMethodView.matchModel = self.matchModel;
    
    [self.sfcPlayMethodView show];
}

#pragma mark ---- lazyLoad ----

- (UIImageView *)tagImageView
{
    if (_tagImageView == nil) {
        _tagImageView = [[UIImageView alloc] init];
        _tagImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _tagImageView;
}

- (BBMatchTitleView *)mtachTitleView
{

    if (_mtachTitleView == nil) {
        
        _mtachTitleView = [[BBMatchTitleView alloc] initWithFrame:(CGRectZero)];
    }
    return _mtachTitleView;
}

- (BBMatchInfoView *)matchInfo
{

    if (_matchInfoView == nil) {
        
        _matchInfoView = [[BBMatchInfoView alloc] initWithFrame:(CGRectZero)];
        
        WS_SL(ws);
        
        _matchInfoView.infoBlock = ^{
            
            !ws.showHistoryBlock ? : ws.showHistoryBlock();
        };
    }
    return _matchInfoView;
}


- (UIView *)bottomLine
{
    
    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xDDDDDD);
    }
    
    return _bottomLine;
}

- (BBMatchHistoryView *)historyView
{

    if (_historyView == nil) {
        
        _historyView = [[BBMatchHistoryView alloc] initWithFrame:(CGRectZero)];
        _historyView.backgroundColor = SL_UIColorFromRGB(0xF5F0EB);
        _historyView.hidden = YES;
    }
    return _historyView;
}

- (BBPlayMethodTagLabel *)sfcTagLabel
{

    if (_sfcTagLabel == nil) {
        
        _sfcTagLabel = [[BBPlayMethodTagLabel alloc] init];
        [_sfcTagLabel setTagText:@"胜分差"];
        [_sfcTagLabel setShowButtomLine:YES];
    }
    return _sfcTagLabel;
}

- (UIButton *)showSFCButton
{

    if (_showSFCButton == nil) {
        
        _showSFCButton = [UIButton buttonWithType:(UIButtonTypeCustom)];

        _showSFCButton.titleLabel.lineBreakMode  = NSLineBreakByTruncatingMiddle;
        [_showSFCButton setTitle:@"展开胜分差玩法" forState:(UIControlStateNormal)];
        
        [_showSFCButton setBackgroundImage:[UIImage sl_imageWithColor:[UIColor colorWithWhite:0 alpha:0.1]] forState:(UIControlStateHighlighted)];
        
        [_showSFCButton setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xffffff)] forState:UIControlStateNormal];
        [_showSFCButton setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xe63222)] forState:UIControlStateSelected];
        
        [_showSFCButton setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_showSFCButton setTitleColor:SL_UIColorFromRGB(0xffffff) forState:(UIControlStateSelected)];
        
        _showSFCButton.titleLabel.font = SL_FONT_SCALE(14.f);
        
        _showSFCButton.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        _showSFCButton.layer.borderWidth = 0.5;
        
        [_showSFCButton addTarget:self action:@selector(showSFCPlayMethodView) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _showSFCButton;
}

- (BBNoSaleLabel *)sfcNoSaleLabel
{

    if (_sfcNoSaleLabel == nil) {
        
        _sfcNoSaleLabel = [[BBNoSaleLabel alloc] init];
        
        _sfcNoSaleLabel.hidden = YES;
    }
    return _sfcNoSaleLabel;
}


- (BBMatchNewPlayMethodView *)sf_PlayMethodVeiw
{

    if (_sf_PlayMethodVeiw == nil) {
        
        _sf_PlayMethodVeiw = [[BBMatchNewPlayMethodView alloc] init];
       
        WS_SL(weakSelf);
        
        _sf_PlayMethodVeiw.reloadUIBlock = ^{
            
            weakSelf.reloadButtomViewBlock ? weakSelf.reloadButtomViewBlock() : nil;
        };
    }
    return _sf_PlayMethodVeiw;
}

- (BBMatchNewPlayMethodView *)rfsf_PlayMethodVeiw
{
    
    if (_rfsf_PlayMethodVeiw == nil) {
        
        WS_SL(weakSelf);
        
        _rfsf_PlayMethodVeiw = [[BBMatchNewPlayMethodView alloc] init];
        
        _rfsf_PlayMethodVeiw.reloadUIBlock = ^{
            
        weakSelf.reloadButtomViewBlock ? weakSelf.reloadButtomViewBlock() : nil;
        };
    }
    return _rfsf_PlayMethodVeiw;
}


- (BBMatchNewPlayMethodView *)dxf_PlayMethodVeiw
{
    
    if (_dxf_PlayMethodVeiw == nil) {
        
        
        WS_SL(weakSelf);
        
        _dxf_PlayMethodVeiw = [[BBMatchNewPlayMethodView alloc] init];
        
        _dxf_PlayMethodVeiw.reloadUIBlock = ^{
            
            weakSelf.reloadButtomViewBlock ? weakSelf.reloadButtomViewBlock() : nil;
        };
    }
    return _dxf_PlayMethodVeiw;
}



- (SFCPlayMethodView *)sfcPlayMethodView
{

    if (_sfcPlayMethodView == nil) {
        
        WS_SL(weakSelf);
        
        _sfcPlayMethodView = [[SFCPlayMethodView alloc] initWithFrame:(CGRectZero)];
        
        _sfcPlayMethodView.reloadUIBlock = ^{
            
            weakSelf.reloadButtomViewBlock ? weakSelf.reloadButtomViewBlock() : nil;
        };
    
    }
    return _sfcPlayMethodView;
}



/** 
 31:"主胜1-5"
 32:"主胜6-10"
 33:"主胜11-15"
 34:"主胜16-20"
 35:"主胜21-25"
 36:"主胜26+"
 01:"客胜1-5"
 02:"客胜6-10"
 03:"客胜11-15"
 04:"客胜16-20"
 05:"客胜21-25"
 06:"客胜26+"
 */

- (NSDictionary *)betStringDic
{
    if (!_betStringDic) {
        _betStringDic = @{@"31":@"主胜1-5",
                          @"32":@"主胜6-10",
                          @"33":@"主胜11-15",
                          @"34":@"主胜16-20",
                          @"35":@"主胜21-25",
                          @"36":@"主胜26+",
                          @"01":@"主负1-5",
                          @"02":@"主负6-10",
                          @"03":@"主负11-15",
                          @"04":@"主负16-20",
                          @"05":@"主负21-25",
                          @"06":@"主负26+"
                          };
    }
    return _betStringDic;
}

@end
