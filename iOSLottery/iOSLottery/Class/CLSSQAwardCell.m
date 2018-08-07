//
//  CLSSQAwardCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/3.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQAwardCell.h"
#import "CLConfigMessage.h"
#import "CLLotteryBonusNumModel.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLSSQAwardCell ()

@property (nonatomic, strong) UILabel *periodLabel;//期次信息
@property (nonatomic, strong) UIImageView *lineView;//竖线View
@property (nonatomic, strong) UILabel *numberLabel;//中奖号码

@end

@implementation CLSSQAwardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.periodLabel];
        [self configConstaint];
    }
    return self;
}

- (void)configConstaint{
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.width.mas_equalTo(__SCALE(70.f));
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.periodLabel.mas_right).offset(__SCALE(10.f));
        make.width.mas_equalTo(0.5f);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lineView.mas_right).offset(__SCALE(10.f));
        make.right.equalTo(self.contentView).offset(__SCALE(- 10.f));
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)assignData:(id)data{
    
    CLLotteryBonusNumModel *model = data;
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@期", model.periodId];
    if (model.awardStatus == 1) {
        if (model.winningNumbers && model.winningNumbers.length > 0) {
            
            NSRange range = [model.winningNumbers rangeOfString:@":"];
            
            model.winningNumbers = [model.winningNumbers stringByReplacingOccurrencesOfString:@":" withString:@" "];
            
            AttributedTextParams *param = [AttributedTextParams attributeRange:NSMakeRange(range.location, model.winningNumbers.length - range.location) Color:UIColorFromRGB(0x295fcc)];
            [self.numberLabel attributeWithText:model.winningNumbers controParams:@[param]];
            self.numberLabel.font = [UIFont fontWithName:@"Courier" size:__SCALE_HALE(15)];
        }
    }else{
        NSString *str = model.resultMap[@"awardStatusCn"];
        if (str && str.length > 0) {
            self.numberLabel.text = str;
            self.numberLabel.textColor = UIColorFromRGB(0x000000);
            self.numberLabel.font = FONT_SCALE(12);
        }else{
            self.numberLabel.text = @"等待开奖";
            self.numberLabel.font = FONT_SCALE(12);
            self.numberLabel.textColor = UIColorFromRGB(0x000000);
        }
    }
}

#pragma mark ------------ getter Mothed -----------
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

- (UILabel *)numberLabel{
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.text = @"";
        _numberLabel.textColor = THEME_COLOR;
        _numberLabel.font = [UIFont fontWithName:@"Courier" size:__SCALE_HALE(15)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _numberLabel;
}
- (UIImageView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
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
