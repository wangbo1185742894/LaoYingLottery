//
//  SLMatchHistoryView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//
#import "SLConfigMessage.h"
#import "SLMatchHistoryView.h"
#import "SLMatchHistoryModel.h"

@interface SLMatchHistoryView ()

/**
 历史战绩
 */
@property (nonatomic, strong) UILabel *historyTitle;

/**
 历史战绩详情
 */
@property (nonatomic, strong) UILabel *historyDetails;

/**
 近期战绩
 */
@property (nonatomic, strong) UILabel *recentTitle;

/**
 近期战绩详情
 */
@property (nonatomic, strong) UILabel *recentDetails;

/**
 详情比较按钮
 */
@property (nonatomic, strong) UILabel *compareLabel;
/**
 详情对比 > 图片
 */
@property (nonatomic, strong) UIImageView *compareImageView;

/**
 跳转战绩分析轻拍手势
 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) UIView *line1;

@property (nonatomic, strong) UIView *line2;

@end

@implementation SLMatchHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = SL_UIColorFromRGB(0xF6F1EB);

        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}


-(void)addSubviews
{
    [self addSubview:self.historyTitle];
    [self addSubview:self.historyDetails];
    [self addSubview:self.recentTitle];
    [self addSubview:self.recentDetails];
    [self addSubview:self.compareLabel];
    [self addSubview:self.compareImageView];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
}

- (void)addConstraints
{
    
    [self.historyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(SL__SCALE(26));
        make.top.equalTo(self.mas_top).offset(SL__SCALE(6));
        make.height.mas_equalTo(SL__SCALE(16));
        
    }];
    
    [self.historyDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.historyTitle.mas_right).offset(SL__SCALE(20));
        make.centerY.equalTo(self.historyTitle.mas_centerY);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.historyTitle.mas_bottom).offset(SL__SCALE(7));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.recentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line1.mas_bottom).offset(SL__SCALE(6));
        make.centerX.equalTo(self.historyTitle.mas_centerX);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.recentDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.historyDetails.mas_left);
        make.centerY.equalTo(self.recentTitle.mas_centerY);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.recentTitle.mas_bottom).offset(SL__SCALE(7));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.compareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line2.mas_bottom).offset(SL__SCALE(7));
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(SL__SCALE(-7));
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.compareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.compareLabel.mas_right).offset(3.f);
        make.centerY.equalTo(self.compareLabel);
    }];
}

//校验数据正确性
- (BOOL)checkDataforCorrect:(SLMatchHistoryModel *)model
{

    NSInteger number = model.win + model.draw + model.loss;
        
    return number > 0 ? YES : NO;
}

#pragma mark --- ButtonClick ---

- (void)tapClick{
    
    !self.onClickBlock ? : self.onClickBlock();
}


#pragma mark --- Set Method ---

- (void)setDetailsUrl:(NSString *)detailsUrl
{

    _detailsUrl = detailsUrl;
    
    if (detailsUrl && detailsUrl.length > 0) {
    
        self.compareLabel.text = @"战队详情战绩分析";
        
        self.tapGesture.enabled = YES;
        
        self.compareImageView.hidden = NO;
        
    }else{
    
        self.compareLabel.text = @"暂无战队详情战绩分析";
        
        self.tapGesture.enabled = NO;
        
        self.compareImageView.hidden = YES;
    }
}

- (void)setVsModel:(SLMatchHistoryModel *)vsModel
{
    
    _vsModel = vsModel;
    
    if (![self checkDataforCorrect:vsModel]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"暂无数据"];
        
        self.historyDetails.attributedText = attr;
        
        return;
    }
    
    NSInteger number = vsModel.win + vsModel.draw + vsModel.loss;
    NSString *str = [NSString stringWithFormat:@"近%ld场交战，%@",number,self.hostName];
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:str color:SL_UIColorFromRGB(0x999999) font:SL_FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithModel:vsModel];
    
    [attr appendAttributedString:spfAttr];
    
    self.historyDetails.attributedText = attr;
    
    
}

- (void)setHostModel:(SLMatchHistoryModel *)hostModel
{
    
    _hostModel = hostModel;
    
    if (![self checkDataforCorrect:hostModel]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"主队暂无数据"];
        
        self.recentDetails.attributedText = attr;
        
        return;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:@"主队" color:SL_UIColorFromRGB(0x999999) font:SL_FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithModel:hostModel];
    
    [attr appendAttributedString:spfAttr];
    
    self.recentDetails.attributedText = attr;
}

- (void)setAwayModel:(SLMatchHistoryModel *)awayModel
{
    
    _awayModel = awayModel;
    
    if (![self checkDataforCorrect:awayModel]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"，客队暂无数据"];
        
        NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.recentDetails.attributedText];
        
        [currentAttr appendAttributedString:attr];
        
        self.recentDetails.attributedText = currentAttr;
        
        return;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:@"，客队" color:SL_UIColorFromRGB(0x999999) font:SL_FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithModel:awayModel];
    
    [attr appendAttributedString:spfAttr];
    
    NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.recentDetails.attributedText];
    
    [currentAttr appendAttributedString:attr];
    
    self.recentDetails.attributedText = currentAttr;
    
}

//胜平负富文本
- (NSMutableAttributedString *)createSPFStringWithModel:(SLMatchHistoryModel *)model
{
    
    NSString *winStr = [NSString stringWithFormat:@"%ld胜",model.win];
    NSMutableAttributedString *attrWin = [self attributedStringWithStr:winStr color:SL_UIColorFromRGB(0xFC5548) font:SL_FONT_SCALE(12)];
    
    NSString *drawStr = [NSString stringWithFormat:@"%ld平",model.draw];
    NSMutableAttributedString *attrDraw = [self attributedStringWithStr:drawStr color:SL_UIColorFromRGB(0x45A2F7) font:SL_FONT_SCALE(12)];
    
    NSString *lossStr = [NSString stringWithFormat:@"%ld负",model.loss];
    NSMutableAttributedString *attrLoss = [self attributedStringWithStr:lossStr color:SL_UIColorFromRGB(0x2BC57C) font:SL_FONT_SCALE(12)];
    
    [attrWin appendAttributedString:attrDraw];
    [attrWin appendAttributedString:attrLoss];
    
    return attrWin;
}

//创建富文本
- (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str color:(UIColor *)color font:(UIFont *)font
{
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    [attr addAttribute:NSForegroundColorAttributeName value:color range:(NSMakeRange(0, attr.length))];
    [attr addAttribute:NSFontAttributeName value:font range:(NSMakeRange(0, attr.length))];
    
    return attr;
}

//没有数据时的富文本
- (NSMutableAttributedString *)attributedStringForNoDateWithStr:(NSString *)str
{
    NSMutableAttributedString *attr = [self attributedStringWithStr:str color:SL_UIColorFromRGB(0x999999) font:SL_FONT_SCALE(12)];
    
    return attr;
}


#pragma mark --- Get Method ---
- (UILabel *)historyTitle
{
    
    if (_historyTitle == nil) {
        
        _historyTitle = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _historyTitle.text = @"历史交锋";
        _historyTitle.textColor = SL_UIColorFromRGB(0x333333);
        _historyTitle.font = SL_FONT_SCALE(12);
        
    }
    return _historyTitle;
}

- (UILabel *)historyDetails
{
    
    if (_historyDetails == nil) {
        
        _historyDetails = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _historyDetails.text = @"近9次交战，墨尔本成6胜1平2负";
        _historyDetails.font = SL_FONT_SCALE(12);
    }
    
    return _historyDetails;
    
}

- (UILabel *)recentTitle
{
    
    if (_recentTitle == nil) {
        
        _recentTitle = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _recentTitle.text = @"近期战绩";
        _recentTitle.textColor = SL_UIColorFromRGB(0x333333);
        _recentTitle.font = SL_FONT_SCALE(12);
        
    }
    return _recentTitle;
}

- (UILabel *)recentDetails
{
    
    if (_recentDetails == nil) {
        
        _recentDetails = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _recentDetails.text = @"主队5胜2平负，客队2胜4平4负";
        _recentDetails.font = SL_FONT_SCALE(12);
        
    }
    
    return _recentDetails;
}

- (UILabel *)compareLabel
{
    
    if (_compareLabel == nil) {
        
        _compareLabel = [[UILabel alloc] init];
        _compareLabel.text = @"战队详情战绩分析";
        _compareLabel.textColor = SL_UIColorFromRGB(0x8F6E51);
        _compareLabel.font = SL_FONT_SCALE(12);
    }
    
    return _compareLabel;
}

- (UIImageView *)compareImageView{
    
    if (!_compareImageView) {
        _compareImageView = [[UIImageView alloc] init];
        _compareImageView.image = [UIImage imageNamed:@"play_compare"];
        
    }
    return _compareImageView;
}

- (UIView *)line1
{
    
    if (_line1 == nil) {
        
        _line1 = [[UIView alloc] initWithFrame:(CGRectZero)];
        _line1.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _line1;
}

- (UIView *)line2
{
    
    if (_line2 == nil) {
        
        _line2 = [[UIView alloc] initWithFrame:(CGRectZero)];
        _line2.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
    }
    
    return _line2;
}

- (UITapGestureRecognizer *)tapGesture
{

    if (_tapGesture == nil) {
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    }
    return _tapGesture;
}

- (NSString *)hostName
{

    if (_hostName.length == 0 && _hostName == nil) {
        
        _hostName = @"主队";
    }

    return _hostName;
}


@end
