//
//  CLSFCHistoryView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCHistoryView.h"

#import "CLConfigMessage.h"

#import "CLSFCBetModel.h"
#import "UIResponder+CLRouter.h"

@interface CLSFCHistoryView ()

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
 赔率
 */
@property (nonatomic, strong) UILabel *oddsLabel;

/**
 胜
 */
@property (nonatomic, strong) UILabel *winOddsLabel;

/**
 平
 */
@property (nonatomic, strong) UILabel *drawOddsLabel;

/**
 负
 */
@property (nonatomic, strong) UILabel *awayOddsLabel;

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

@property (nonatomic, strong) UIView *line3;

@end

@implementation CLSFCHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = UIColorFromRGB(0xF6F1EB);
        
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
    
    [self addSubview:self.oddsLabel];
    
    [self addSubview:self.winOddsLabel];
    [self addSubview:self.drawOddsLabel];
    [self addSubview:self.awayOddsLabel];
    
    [self addSubview:self.compareLabel];
    [self addSubview:self.compareImageView];
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.line3];
}

- (void)addConstraints
{
    
    [self.historyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(CL__SCALE(26));
        make.top.equalTo(self.mas_top).offset(CL__SCALE(6));
        make.height.mas_equalTo(CL__SCALE(16));
    }];
    
    [self.historyDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.historyTitle.mas_right).offset(CL__SCALE(20));
        make.centerY.equalTo(self.historyTitle.mas_centerY);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.historyTitle.mas_bottom).offset(CL__SCALE(7));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.recentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line1.mas_bottom).offset(CL__SCALE(6));
        make.centerX.equalTo(self.historyTitle.mas_centerX);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.recentDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.historyDetails.mas_left);
        make.centerY.equalTo(self.recentTitle.mas_centerY);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.recentTitle.mas_bottom).offset(CL__SCALE(7));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.oddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.line2.mas_bottom).offset(CL__SCALE(6));
        make.centerX.equalTo(self.historyTitle.mas_centerX);
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.winOddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.oddsLabel);
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(135.f));
    }];
    
    [self.drawOddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.oddsLabel);
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(225.f));
    }];
    
    [self.awayOddsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.oddsLabel);
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(315.f));
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.oddsLabel.mas_bottom).offset(CL__SCALE(7));
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    [self.compareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.line3.mas_bottom).offset(CL__SCALE(7));
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(CL__SCALE(-7));
        make.height.equalTo(self.historyTitle.mas_height);
    }];
    
    [self.compareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.compareLabel.mas_right).offset(3.f);
        make.centerY.equalTo(self.compareLabel);
    }];
}

//校验数据正确性
- (BOOL)checkDataforCorrect:(NSString *)data
{
    NSArray *array = [data componentsSeparatedByString:@","];
    
    if (array.count == 3) return YES;
    
        return NO;
}

#pragma mark --- ButtonClick ---

- (void)tapClick{
    
    //!self.onClickBlock ? : self.onClickBlock();
    
    [self routerWithEventName:@"SFCHistoryViewReloadView" userInfo:@{@"url":self.historyModel.sfcBottomPageUrl}];
}


#pragma mark --- Set Method ---

- (void)setHistoryModel:(CLSFCBetModel *)historyModel
{

    _historyModel = historyModel;
    
    [self setDetailsUrl:historyModel.sfcBottomPageUrl];
    
    [self setVsData:historyModel.historyRecentRecord];
    [self setHostData:historyModel.hostRecentRecord];
    [self setAwayData:historyModel.awayRecentRecord];
    
    NSArray *oddsArray = [self.historyModel.odds componentsSeparatedByString:@","];
    
    if (oddsArray.count < 3) return;
    
    self.winOddsLabel.text = [NSString stringWithFormat:@"主胜%@",oddsArray[0]];
    self.drawOddsLabel.text = [NSString stringWithFormat:@"平局%@",oddsArray[1]];
    self.awayOddsLabel.text = [NSString stringWithFormat:@"主负%@",oddsArray[2]];
}

- (void)setDetailsUrl:(NSString *)detailsUrl
{
    
//    _detailsUrl = detailsUrl;
    
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

- (void)setVsData:(NSString *)data
{
    
    if (![self checkDataforCorrect:data]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"暂无数据"];
        
        self.historyDetails.attributedText = attr;
        
        return;
    }
    
    NSArray *dataArray = [data componentsSeparatedByString:@","];
    
    NSInteger number = [dataArray[0] integerValue] + [dataArray[1] integerValue] + [dataArray[2] integerValue];
    
    NSString *str = [NSString stringWithFormat:@"近%ld场交战，主队",number];
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:str color:UIColorFromRGB(0x999999) font:FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithData:self.historyModel.historyRecentRecord];
    
    [attr appendAttributedString:spfAttr];
    
    self.historyDetails.attributedText = attr;
    
    
}

- (void)setHostData:(NSString *)data
{
    
    if (![self checkDataforCorrect:data]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"主队暂无数据"];
        
        self.recentDetails.attributedText = attr;
        
        return;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:@"主队" color:UIColorFromRGB(0x999999) font:FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithData:self.historyModel.hostRecentRecord];
    
    [attr appendAttributedString:spfAttr];
    
    self.recentDetails.attributedText = attr;
}

- (void)setAwayData:(NSString *)data
{
    
    if (![self checkDataforCorrect:data]) {
        
        NSMutableAttributedString *attr = [self attributedStringForNoDateWithStr:@"，客队暂无数据"];
        
        NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.recentDetails.attributedText];
        
        [currentAttr appendAttributedString:attr];
        
        self.recentDetails.attributedText = currentAttr;
        
        return;
    }
    
    NSMutableAttributedString *attr = [self attributedStringWithStr:@"，客队" color:UIColorFromRGB(0x999999) font:FONT_SCALE(12)];
    
    NSMutableAttributedString *spfAttr = [self createSPFStringWithData:self.historyModel.awayRecentRecord];
    
    [attr appendAttributedString:spfAttr];
    
    NSMutableAttributedString *currentAttr = [[NSMutableAttributedString alloc] initWithAttributedString:self.recentDetails.attributedText];
    
    [currentAttr appendAttributedString:attr];
    
    self.recentDetails.attributedText = currentAttr;
    
}

//胜平负富文本
- (NSMutableAttributedString *)createSPFStringWithData:(NSString *)data
{
    
    NSArray *dataArray = [data componentsSeparatedByString:@","];
    
    NSString *winStr = [NSString stringWithFormat:@"%ld胜",[dataArray[0] integerValue]];
    NSMutableAttributedString *attrWin = [self attributedStringWithStr:winStr color:UIColorFromRGB(0xFC5548) font:FONT_SCALE(12)];
    
    NSString *drawStr = [NSString stringWithFormat:@"%ld平",[dataArray[1] integerValue]];
    NSMutableAttributedString *attrDraw = [self attributedStringWithStr:drawStr color:UIColorFromRGB(0x45A2F7) font:FONT_SCALE(12)];
    
    NSString *lossStr = [NSString stringWithFormat:@"%ld负",[dataArray[2] integerValue]];
    NSMutableAttributedString *attrLoss = [self attributedStringWithStr:lossStr color:UIColorFromRGB(0x2BC57C) font:FONT_SCALE(12)];
    
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
    NSMutableAttributedString *attr = [self attributedStringWithStr:str color:UIColorFromRGB(0x999999) font:FONT_SCALE(12)];
    
    return attr;
}


#pragma mark --- Get Method ---
- (UILabel *)historyTitle
{
    if (_historyTitle == nil) {
        
        _historyTitle = [self p_createLabelText:@"历史交锋" Color:UIColorFromRGB(0x333333)];
    }
    return _historyTitle;
}

- (UILabel *)historyDetails
{
    
    if (_historyDetails == nil) {
        
        _historyDetails = [self p_createLabelText:@"主队5胜2平负，客队2胜4平4负" Color:UIColorFromRGB(0x999999)];
    }
    return _historyDetails;
}

- (UILabel *)recentTitle
{
    if (_recentTitle == nil) {
        
        _recentTitle = [self p_createLabelText:@"近期战绩" Color:UIColorFromRGB(0x333333)];
    }
    return _recentTitle;
}

- (UILabel *)recentDetails
{
    if (_recentDetails == nil) {
        
        _recentDetails = [self p_createLabelText:@"主队5胜2平负，客队2胜4平4负" Color:UIColorFromRGB(0x999999)];
    }
    return _recentDetails;
}

- (UILabel *)oddsLabel
{

    if (_oddsLabel == nil) {
        
        _oddsLabel = [self p_createLabelText:@"赔率" Color:UIColorFromRGB(0x333333)];
    }
    return _oddsLabel;
}

- (UILabel *)winOddsLabel
{

    if (_winOddsLabel == nil) {
        
        _winOddsLabel = [self p_createLabelText:@"主胜" Color:UIColorFromRGB(0x999999)];
    }
    return _winOddsLabel;
}

- (UILabel *)drawOddsLabel
{
    
    if (_drawOddsLabel == nil) {
        
        _drawOddsLabel = [self p_createLabelText:@"主胜" Color:UIColorFromRGB(0x999999)];
    }
    return _drawOddsLabel;
}


- (UILabel *)awayOddsLabel
{
    
    if (_awayOddsLabel == nil) {
        
        _awayOddsLabel = [self p_createLabelText:@"主胜" Color:UIColorFromRGB(0x999999)];
    }
    return _awayOddsLabel;
}


- (UILabel *)p_createLabelText:(NSString *)text Color:(UIColor *)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.text = text;
    label.textColor = color;
    label.font = FONT_SCALE(12);
    
    return label;
}
- (UILabel *)compareLabel
{
    
    if (_compareLabel == nil) {
        
        _compareLabel = [[UILabel alloc] init];
        _compareLabel.text = @"战队详情战绩分析";
        _compareLabel.textColor = UIColorFromRGB(0x8F6E51);
        _compareLabel.font = FONT_SCALE(12);
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
    
        _line1 = [self createLine];
    }
    return _line1;
}

- (UIView *)line2
{
    
    if (_line2 == nil) {
        
        _line2 = [self createLine];
    }
    return _line2;
}

- (UIView *)line3
{
    
    if (_line3 == nil) {
        
        _line3 = [self createLine];
    }
    return _line3;
}

- (UIView *)createLine
{
    UIView *view = [[UIView alloc] initWithFrame:(CGRectZero)];
    view.backgroundColor = UIColorFromRGB(0xECE5DD);
    
    return view;
}

- (UITapGestureRecognizer *)tapGesture
{
    
    if (_tapGesture == nil) {
        
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    }
    return _tapGesture;
}
@end
