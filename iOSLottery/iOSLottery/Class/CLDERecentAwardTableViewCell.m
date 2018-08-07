//
//  CLDERecentAwardTableViewCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDERecentAwardTableViewCell.h"
#import "CLConfigMessage.h"
#import "CLLotteryBonusNumModel.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLDERecentAwardTableViewCell ()

@property (nonatomic, strong) UILabel *periodLabel;//期次label
@property (nonatomic, strong) UILabel *bonusNumberLabel;//开奖号码label
@property (nonatomic, strong) UILabel *sumLabel;//和值label
@property (nonatomic, strong) UIImageView *leftLineView;//左边线的View
@property (nonatomic, strong) UIImageView *rightLineView;//右边线的View
@property (nonatomic, strong) UILabel *waitAwardLabel;//等待开奖的label

@end
@implementation CLDERecentAwardTableViewCell
+ (CLDERecentAwardTableViewCell *)createRecentAwardTableViewCell:(UITableView *__weak)tableView isBackground:(BOOL)isBackGround data:(id)data{
    
    static NSString * cellID = @"recentAwardCell";
    CLDERecentAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLDERecentAwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell assigndata:data];
    cell.backgroundColor = isBackGround ? UIColorFromRGB(0xeeeee5) : UIColorFromRGB(0xffffff);
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.periodLabel];
        [self.contentView addSubview:self.bonusNumberLabel];
        [self.contentView addSubview:self.sumLabel];
        [self.contentView addSubview:self.leftLineView];
        [self.contentView addSubview:self.rightLineView];
        [self.contentView addSubview:self.waitAwardLabel];
        //配置约束
        [self configConstraint];
    }
    return self;
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.mas_equalTo(__SCALE(22.f));
        make.width.mas_equalTo(__SCALE(75.f));
    }];
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.width.mas_equalTo(.5f);
        make.top.height.equalTo(self.periodLabel);
    }];
    [self.bonusNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(self.periodLabel);
        make.left.equalTo(self.leftLineView.mas_right);
        make.right.equalTo(self.rightLineView.mas_left);
    }];
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self.sumLabel.mas_left);
        make.width.height.equalTo(self.leftLineView);
    }];
    [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self.periodLabel);
    }];
    [self.waitAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLineView.mas_right);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.rightLineView);
    }];
}
- (void)assigndata:(id)data{
    
    CLLotteryBonusNumModel *model = data;
    
    if (model.periodId && model.periodId.length > 0) {
        self.periodLabel.text = model.periodId;
    }
    if (model.awardStatus == 1) {
        self.waitAwardLabel.hidden = YES;
        self.bonusNumberLabel.hidden = NO;
        self.rightLineView.hidden = NO;
        self.sumLabel.hidden = NO;
        if (model.winningNumbers && model.winningNumbers.length > 0) {
            self.bonusNumberLabel.text = model.winningNumbers;
            NSArray *numberArray = [model.winningNumbers componentsSeparatedByString:@" "];
            NSInteger number = 0;
            for (NSString *numberStr in numberArray) {
                number += [numberStr integerValue];
            }
            self.sumLabel.text = [NSString stringWithFormat:@"%zi", number];
        }
    }else{
        //等待开奖
        id string = model.resultMap[@"awardStatusCn"];
        if ([string isKindOfClass:[NSString class]] && ((NSString *)string).length > 0) {
            self.waitAwardLabel.text = string;
        }
        self.waitAwardLabel.hidden = NO;
        self.bonusNumberLabel.hidden = YES;
        self.rightLineView.hidden = YES;
        self.sumLabel.hidden = YES;
    }
}
#pragma mark ------------ setter Mothed ------------
- (void)setSignCount:(NSInteger)signCount{
    
    _signCount = signCount;
    if (self.bonusNumberLabel.text.length > 0) {
        self.bonusNumberLabel.textColor = UIColorFromRGB(0x333333);
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(0, (2 * _signCount) + (_signCount - 1)) Color:THEME_COLOR];
        [self.bonusNumberLabel attributeWithText:self.bonusNumberLabel.text controParams:@[params]];
    }
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {
        _periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _periodLabel.text = @"期次";
        _periodLabel.textColor = UIColorFromRGB(0x333333);
        _periodLabel.font = FONT_SCALE(13);
        _periodLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _periodLabel;
}
- (UILabel *)bonusNumberLabel{
    
    if (!_bonusNumberLabel) {
        _bonusNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bonusNumberLabel.text = @"10 10 02 10 11";
        _bonusNumberLabel.textColor = UIColorFromRGB(0x333333);
        _bonusNumberLabel.font = [UIFont fontWithName:@"Courier" size:__SCALE_HALE(15)];
        _bonusNumberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bonusNumberLabel;
}
- (UILabel *)sumLabel{
    
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sumLabel.text = @"和值";
        _sumLabel.textColor = UIColorFromRGB(0x333333);
        _sumLabel.font = FONT_SCALE(13);
        _sumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sumLabel;
}
- (UIImageView *)leftLineView{
    
    if (!_leftLineView) {
        _leftLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _leftLineView;
}
- (UIImageView *)rightLineView{
    
    if (!_rightLineView) {
        _rightLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightLineView.backgroundColor = UIColorFromRGB(0xcccccc);
    }
    return _rightLineView;
}
- (UILabel *)waitAwardLabel{
    
    if (!_waitAwardLabel) {
        _waitAwardLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _waitAwardLabel.text = @"等待开奖...";
        _waitAwardLabel.textColor = UIColorFromRGB(0x000000);
        _waitAwardLabel.font = FONT_SCALE(13);
        _waitAwardLabel.hidden = YES;
        _waitAwardLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _waitAwardLabel;
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
