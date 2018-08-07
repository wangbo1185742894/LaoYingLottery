//
//  CLSLAwardNoticeCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSLDrawNoticeCell.h"
#import "CLConfigMessage.h"
#import "CLAwardVoModel.h"
#import "CLBSLAwardNoticeResult.h"
@interface CLSLDrawNoticeCell ()

/**
 玩法名Label
 */
@property (nonatomic, strong) UILabel *playName;

/**
 联赛名Label
 */
@property (nonatomic, strong) UILabel *leagueName;

/**
 比赛编号Label
 */
@property (nonatomic, strong) UILabel *matchNumber;

/**
 开始时间Label
 */
@property (nonatomic, strong) UILabel *startTime;

/**
 比赛赛果Label
 */
@property (nonatomic, strong) CLSLAwardNoticeResult *matchResult;

@property (nonatomic, strong) CLBSLAwardNoticeResult *basMatchResult;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation CLSLDrawNoticeCell

+ (CLSLDrawNoticeCell *)createSLDrawNoticeCellWithTableView:(UITableView *)tableView;
{
    static NSString *ID = @"CLSLDrawNoticeCell";
    
    CLSLDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[CLSLDrawNoticeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)addSubviews
{

    [self.contentView addSubview:self.leagueName];
    [self.contentView addSubview:self.playName];
    [self.contentView addSubview:self.matchNumber];
    [self.contentView addSubview:self.startTime];
    [self.contentView addSubview:self.matchResult];
    [self.contentView addSubview:self.basMatchResult];
    [self.contentView addSubview:self.bottomLine];
}

- (void)addConstraints
{
    
    
    [self.playName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView.mas_left).offset(__SCALE(11.f* 0.85));
        make.top.equalTo(self.contentView.mas_top).offset(__SCALE(18.f* 0.85));
        make.height.mas_equalTo(__SCALE(19.f* 0.85));
        
    }];
    
    [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.playName.mas_right).offset(__SCALE(5.f* 0.85));
        make.top.equalTo(self.playName.mas_top).offset(__SCALE(1.2f* 0.85));
        make.height.mas_equalTo(__SCALE(16.f* 0.85));
    }];
    
    [self.matchNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leagueName.mas_right).offset(__SCALE(5.f* 0.85));
        make.top.equalTo(self.leagueName.mas_top);
        make.height.mas_equalTo(__SCALE(16.f* 0.85));
    }];
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.matchNumber.mas_right).offset(__SCALE(5.f* 0.85));
        make.top.equalTo(self.leagueName.mas_top);
        make.height.mas_equalTo(__SCALE(16.f* 0.85));
    }];
    
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    [self.matchResult mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.playName.mas_left);
        make.width.mas_equalTo(__SCALE(320.f * 0.85));
        make.height.mas_equalTo(__SCALE(36.f* 0.85));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(__SCALE(-16.f * 0.85));
    }];
    [self.basMatchResult mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playName.mas_left);
        make.width.mas_equalTo(__SCALE(320.f * 0.85));
        make.height.mas_equalTo(__SCALE(36.f* 0.85));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(__SCALE(-16.f * 0.85));
    }];
}

- (void)setDrawNoticeModel:(CLAwardVoModel *)drawNoticeModel
{

    _drawNoticeModel = drawNoticeModel;
    
    _playName.text = drawNoticeModel.gameName;
    
    NSArray *array = [drawNoticeModel.periodId componentsSeparatedByString:@"_"];
    
    if (array.count != 2) return;
    
    _leagueName.text = array[0];
    
    _matchNumber.text = array[1];
    
    _startTime.text = drawNoticeModel.awardTime;
    if ([drawNoticeModel.gameEn hasSuffix:@"jczq_mix_p"]) {
        _matchResult.isCancel = drawNoticeModel.isCancel;
        [_matchResult setDateWithString:drawNoticeModel.winningNumbers];
        _matchResult.hidden = NO;
        _basMatchResult.hidden = YES;
    }else if ([drawNoticeModel.gameEn hasSuffix:@"jclq_mix_p"]){
        _basMatchResult.isCancel = drawNoticeModel.isCancel;
        [_basMatchResult setDateWithString:drawNoticeModel.winningNumbers];
        _matchResult.hidden = YES;
        _basMatchResult.hidden =NO;
    }

}


#pragma mark --- Get Method ---

-(UILabel *)playName
{

    if (_playName == nil) {
        
        _playName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _playName.text = @"竞猜足球";
        _playName.textColor = UIColorFromRGB(0x333333);
        _playName.font = FONT_SCALE(15.f);
    }
    
    return _playName;

}

-(UILabel *)leagueName
{
    
    if (_leagueName == nil) {
        
        _leagueName = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leagueName.text = @"英超";
        _leagueName.textColor = UIColorFromRGB(0x9A9A9A);
        _leagueName.font = FONT_SCALE(12.f);
    }
    
    return _leagueName;
    
}

-(UILabel *)matchNumber
{
    
    if (_matchNumber == nil) {
        
        _matchNumber = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _matchNumber.text = @"周六001";
        _matchNumber.textColor = UIColorFromRGB(0x9A9A9A);
        _matchNumber.font = FONT_SCALE(12.f);
    }
    
    return _matchNumber;
    
}

-(UILabel *)startTime
{
    
    if (_startTime == nil) {
        
        _startTime = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _startTime.text = @"2017-03-27 15:00";
        _startTime.textColor = UIColorFromRGB(0x9A9A9A);
        _startTime.font = FONT_SCALE(12.f);
    }
    
    return _startTime;
    
}


- (CLSLAwardNoticeResult *)matchResult
{

    if (_matchResult == nil) {
        
        _matchResult = [[CLSLAwardNoticeResult alloc] initWithFrame:(CGRectZero)];
        
    }
    return _matchResult;
}

- (CLBSLAwardNoticeResult *)basMatchResult
{
    if (!_basMatchResult) {
        _basMatchResult = [[CLBSLAwardNoticeResult alloc] initWithFrame:(CGRectZero)];
    }
    return _basMatchResult;
}

- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        _bottomLine.backgroundColor = UIColorFromRGB(0xD8D8D8);
    }
    
    return _bottomLine;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end

@interface CLSLAwardNoticeResult ()

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, strong) UILabel *leftlabel;

@property (nonatomic, strong) UILabel *scoreLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *letScoreLabel;

@end

@implementation CLSLAwardNoticeResult

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.backgroundColor = UIColorFromRGB(0x3FA974);
        self.layer.cornerRadius = __SCALE(18 * 0.85);
    }
    
    return self;

}

- (void)addSubviews
{
 
    [self addSubview:self.playImage];
    [self addSubview:self.leftlabel];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.letScoreLabel];
    
}

- (void)addConstraints
{
    [self.playImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(__SCALE(4 * 0.85));
        make.width.height.mas_offset(__SCALE(28.f * 0.85));
        
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.centerX.equalTo(self.mas_left).offset(__SCALE(178.f * 0.85));
        make.width.mas_equalTo(__SCALE(60.f * 0.85));
        make.top.bottom.equalTo(self);
        
    }];
    
    
    [self.leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.greaterThanOrEqualTo(self.playImage.mas_right).offset(__SCALE(4.f));
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.right.equalTo(self.letScoreLabel.mas_left).offset(__SCALE(-4.f * 0.85));
        make.height.mas_equalTo(__SCALE(17.f * 0.85));
    }];
    
    [self.letScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.scoreLabel.mas_left);
        make.height.mas_equalTo(__SCALE(17.f * 0.85));
        
    }];
    
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.scoreLabel.mas_right);
        make.right.lessThanOrEqualTo(self.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.playImage.mas_centerY);
        make.height.mas_equalTo(__SCALE(17.f * 0.85));
        
    }];
    

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.frame.size.height / 2;

}

- (void)setIsCancel:(NSInteger)isCancel
{

    _isCancel = isCancel;
    
    if (isCancel == 1) {
        
        self.scoreLabel.font = FONT_SCALE(12.f * 0.85);
        
    }else{
    
        self.scoreLabel.font = FONT_SCALE(16.f * 0.85);
        
    }
}

- (void)setDateWithString:(NSString *)str
{

    NSArray *dataArray = [str componentsSeparatedByString:@"_"];
    
    if (!(dataArray.count == 4)) return;
    
    self.leftlabel.text = dataArray[0];
    self.letScoreLabel.text = dataArray[1];
    self.scoreLabel.text = dataArray[2];
    self.rightLabel.text = dataArray[3];
    

}

#pragma mark --- Get Method ---
- (UIImageView *)playImage
{

    if (_playImage == nil) {
        
        _playImage = [[UIImageView alloc] initWithFrame:(CGRectZero)];
        _playImage.image = [UIImage imageNamed:@"draw_notice_football"];
    }
    
    return _playImage;
}

- (UILabel *)leftlabel
{

    if (_leftlabel == nil) {
        
        _leftlabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _leftlabel.text = @"皇家马德里里里";
        _leftlabel.textColor = UIColorFromRGB(0xFFFFFF);
        _leftlabel.font = FONT_SCALE(14.f * 0.85);
    }
    
    return _leftlabel;
}

- (UILabel *)scoreLabel
{
    
    if (_scoreLabel == nil) {
        
        _scoreLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _scoreLabel.text = @"3:2";
        _scoreLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _scoreLabel.font = FONT_SCALE(16.f * 0.85);
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        
        _scoreLabel.numberOfLines = 2;
    }
    
    return _scoreLabel;
}


- (UILabel *)rightLabel
{
    
    if (_rightLabel == nil) {
        
        _rightLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _rightLabel.text = @"巴塞罗那罗那";
        _rightLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _rightLabel.font = FONT_SCALE(14.f * 0.85);
    }
    
    return _rightLabel;
}

- (UILabel *)letScoreLabel
{
    
    if (_letScoreLabel == nil) {
        
        _letScoreLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _letScoreLabel.text = @"+1";
        _letScoreLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _letScoreLabel.font = FONT_SCALE(14.f * 0.85);
        
    }
    
    return _letScoreLabel;
}



@end

