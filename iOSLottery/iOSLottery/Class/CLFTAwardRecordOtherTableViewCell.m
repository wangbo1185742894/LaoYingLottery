//
//  CLFTAwardRecordOtherTableViewCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTAwardRecordOtherTableViewCell.h"
#import "CQDefinition.h"
#import "Masonry.h"
#import "CLConfigMessage.h"
#import "CLFastThreeConfigMessage.h"
#import "CLLotteryBonusNumModel.h"
@interface CLFTAwardRecordOtherTableViewCell ()

@property (nonatomic, strong) UILabel *periodLabel;//期次
@property (nonatomic, strong) UIView *baseAwardNumberView;//保证开奖号View居中
@property (nonatomic, strong) UIView *awardNumberView;//开奖号码的View
@property (nonatomic, strong) UILabel *shapeLabel;//形态label
@property (nonatomic, strong) UIImageView *lineImageView;//竖线imageView
@property (nonatomic, strong) UIImageView *circleView;//中间的圆

@property (nonatomic, strong) UIImageView *firstDiceImageView;//第一个骰子
@property (nonatomic, strong) UIImageView *secondDiceImageView;//第二个骰子
@property (nonatomic, strong) UIImageView *thirdDiceImageView;//第三个骰子
@property (nonatomic, strong) UILabel *numberLabel;//开奖号码的label
@property (nonatomic, strong) UILabel *waitAwardLabel;//等待开奖



@end
@implementation CLFTAwardRecordOtherTableViewCell

- (void)assignCellWithData:(id)data{
    
    self.backgroundColor = CLEARCOLOR;
    CLLotteryBonusNumModel *model = data;
    NSDictionary *resultMapDic = model.resultMap;
    //期次
    if (model.periodId && model.periodId.length > 0) {
        self.periodLabel.text = [NSString stringWithFormat:@"%@期",model.periodId];
    }else{
        //如果期次数据不正确
        self.periodLabel.text = @"--";
    }
    //配置中奖号
    [self assignAwardNumberWithNumber:model.winningNumbers awardStatusCn:resultMapDic[awardStatusCn]];
    if (resultMapDic[awardShape] && ((NSString *)resultMapDic[awardShape]).length > 0) {
        self.shapeLabel.text = resultMapDic[awardShape];
    }else{
        self.shapeLabel.text = @"--";
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.awardNumberView];
        [self.contentView addSubview:self.shapeLabel];
        [self.contentView addSubview:self.lineImageView];
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.baseAwardNumberView];
        [self.baseAwardNumberView addSubview:self.awardNumberView];
        [self.awardNumberView addSubview:self.firstDiceImageView];
        [self.awardNumberView addSubview:self.secondDiceImageView];
        [self.awardNumberView addSubview:self.thirdDiceImageView];
        [self.awardNumberView addSubview:self.numberLabel];
        [self.awardNumberView addSubview:self.waitAwardLabel];
        [self configConstraints];
    }
    return self;
}
#pragma mark ------ private Mothed ------
#pragma mark - 配置开奖号码view
- (void)assignAwardNumberWithNumber:(NSString *)numberString awardStatusCn:(NSString *)awardStatusCn{
    
    if (numberString && numberString.length > 0) {
        //存在开奖号码
        NSArray *numberArray = [numberString componentsSeparatedByString:@" "];
        if (numberArray.count == 3) {
            self.firstDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", numberArray[0]]];
            self.secondDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", numberArray[1]]];
            self.thirdDiceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"dice_v%@_small.png", numberArray[2]]];
            self.numberLabel.text = numberString;
            [self showWaitAwardLabel:NO];
        }else{
            [self showWaitAwardLabel:YES];
            self.waitAwardLabel.text = @"等待开奖";
        }
    }else{
        [self showWaitAwardLabel:YES];
        if (awardStatusCn && awardStatusCn.length > 0) {
            self.waitAwardLabel.text = awardStatusCn;
        }else{
            self.waitAwardLabel.text = @"等待开奖";
        }
    }
}
- (void)configConstraints{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(45.f));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(1.f);
    }];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.lineImageView);
        make.width.height.mas_equalTo(__SCALE(4));
    }];
    
    [self.baseAwardNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineImageView.mas_right);
        make.centerY.equalTo(self.contentView);
    }];
    [self.awardNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.baseAwardNumberView);
    }];
    [self.shapeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseAwardNumberView.mas_right);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(__SCALE(90.f));
        make.right.mas_equalTo(__SCALE(- 20));
    }];
    [self.firstDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awardNumberView).offset(__SCALE(5.f));
        make.top.bottom.equalTo(self.awardNumberView);
        make.width.height.mas_equalTo(__SCALE(17.f));
    }];
    [self.secondDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.firstDiceImageView.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.firstDiceImageView);
        make.width.height.mas_equalTo(__SCALE(17.f));
    }];
    [self.thirdDiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondDiceImageView.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.secondDiceImageView);
        make.width.height.mas_equalTo(__SCALE(17.f));
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.thirdDiceImageView.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.thirdDiceImageView);
        make.right.equalTo(self.awardNumberView);
    }];
    [self.waitAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.periodLabel);
        make.left.equalTo(self.periodLabel.mas_right);
        make.right.equalTo(self);
    }];
}
- (void)showWaitAwardLabel:(BOOL)is_show{
    
    self.waitAwardLabel.hidden = !is_show;
    self.firstDiceImageView.hidden = is_show;
    self.secondDiceImageView.hidden = is_show;
    self.thirdDiceImageView.hidden = is_show;
    self.shapeLabel.hidden = is_show;
    self.numberLabel.hidden = is_show;
    
}

#pragma mark ------ getter Mothed ------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期次";
        _periodLabel.textAlignment = NSTextAlignmentCenter;
        _periodLabel.textColor = UIColorFromRGB(0xffffff);
        _periodLabel.font = FONT_SCALE(12);
    }
    return _periodLabel;
}
- (UIImageView *)lineImageView{
    
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineImageView.backgroundColor = UIColorFromRGB(0x063d27);
    }
    return _lineImageView;
}

- (UIImageView *)circleView{
    
    if (!_circleView) {
        _circleView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _circleView.backgroundColor = UIColorFromRGB(0x063d27);
        _circleView.layer.cornerRadius = __SCALE(2.f);
        _circleView.layer.masksToBounds = YES;
    }
    return _circleView;
}
- (UIView *)awardNumberView{
    
    if (!_awardNumberView) {
        _awardNumberView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _awardNumberView;
}
- (UILabel *)shapeLabel{
    
    if (!_shapeLabel) {
        _shapeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _shapeLabel.text = @"形态";
        _shapeLabel.textAlignment = NSTextAlignmentCenter;
        _shapeLabel.textColor = UIColorFromRGB(0xffffff);
        _shapeLabel.font = FONT_SCALE(14);
    }
    return _shapeLabel;
}

- (UIImageView *)firstDiceImageView{
    
    if (!_firstDiceImageView) {
        _firstDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firstDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        _firstDiceImageView.image = [UIImage imageNamed:@"dice_v1_small.png"];
    }
    return _firstDiceImageView;
}
- (UIImageView *)secondDiceImageView{
    
    if (!_secondDiceImageView) {
        _secondDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _secondDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        _secondDiceImageView.image = [UIImage imageNamed:@"dice_v2_small.png"];
    }
    return _secondDiceImageView;
}
- (UIImageView *)thirdDiceImageView{
    
    if (!_thirdDiceImageView) {
        _thirdDiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _thirdDiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        _thirdDiceImageView.image = [UIImage imageNamed:@"dice_v3_small.png"];
    }
    return _thirdDiceImageView;
}
- (UILabel *)numberLabel{
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.text = @"1 2 3";
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = UIColorFromRGB(0xffffff);
        _numberLabel.font = [UIFont fontWithName:@"Courier" size:__SCALE_HALE(15)];
    }
    return _numberLabel;
}
- (UILabel *)waitAwardLabel{
    
    if (!_waitAwardLabel) {
        _waitAwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _waitAwardLabel.text = @"等待开奖...";
        _waitAwardLabel.textColor = UIColorFromRGB(0xffffff);
        _waitAwardLabel.font = FONT_SCALE(14);
        _waitAwardLabel.textAlignment = NSTextAlignmentCenter;
        _waitAwardLabel.hidden = YES;
    }
    return _waitAwardLabel;
}
- (UIView *)baseAwardNumberView{
    
    if (!_baseAwardNumberView) {
        _baseAwardNumberView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseAwardNumberView.backgroundColor = CLEARCOLOR;
    }
    return _baseAwardNumberView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
