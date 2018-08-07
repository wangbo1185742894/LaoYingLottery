//
//  CLATRecentAwardTableViewCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATRecentAwardTableViewCell.h"

#import "CLConfigMessage.h"

#import "CLLotteryBonusNumModel.h"

#import "UILabel+CLAttributeLabel.h"
@interface CLATRecentAwardTableViewCell ()

/**
 期次label
 */
@property (nonatomic, strong) UILabel *periodLabel;

/**
 开奖号码label
 */
@property (nonatomic, strong) UILabel *bonusNumberLabel;


/**
 形态Label
 */
@property (nonatomic, strong) UILabel *formLabel;

/**
 试机号
 */
@property (nonatomic, strong) UILabel *testNumber;

/**
 等待开奖的label
 */
@property (nonatomic, strong) UILabel *waitAwardLabel;

@end

@implementation CLATRecentAwardTableViewCell

+ (instancetype)createRecentAwardTableViewCell:(UITableView *__weak)tableView isBackground:(BOOL)isBackGround data:(id)data{
    
    static NSString * cellID = @"recentAwardCell";
    
    CLATRecentAwardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = [[CLATRecentAwardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell p_assigndata:data];
    
    cell.backgroundColor = isBackGround ? UIColorFromRGB(0xeeeee5) : UIColorFromRGB(0xffffff);
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
 
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

#pragma mark ------------ private Mothed ------------

- (void)p_addSubviews
{
    [self.contentView addSubview:self.periodLabel];
    [self.contentView addSubview:self.bonusNumberLabel];
    [self.contentView addSubview:self.formLabel];
    [self.contentView addSubview:self.testNumber];
    [self.contentView addSubview:self.waitAwardLabel];
}

- (void)p_addConstraints
{

    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(39.f));
        make.centerY.equalTo(self);
    }];
    
    [self.bonusNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(161.f));
        make.centerY.equalTo(self);
    }];
    
    [self.formLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(291.f));
        make.centerY.equalTo(self);
    }];
    
    [self.testNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.mas_left).offset(CL__SCALE(321.f));
        make.centerY.equalTo(self);
    }];
    
    [self.waitAwardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.periodLabel.mas_right);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self.contentView);
    }];
    
}


- (void)p_assigndata:(id)data{
    
    CLLotteryBonusNumModel *model = data;
    
    self.periodLabel.text = [NSString stringWithFormat:@"%@期",model.periodId];
    
    
    if (model.awardStatus == CLLotteryAwardStatusTypeAward) {
        
        self.waitAwardLabel.hidden = YES;
        self.bonusNumberLabel.hidden = NO;
        self.formLabel.hidden = NO;

        self.formLabel.text = model.resultMap[@"awardStyle"];
        
        if ([model.winningNumbers rangeOfString:@":"].length) {
            NSRange range = [model.winningNumbers rangeOfString:@":"];
            
            model.winningNumbers = [model.winningNumbers stringByReplacingOccurrencesOfString:@":" withString:@" "];
            
            AttributedTextParams *param = [AttributedTextParams attributeRange:NSMakeRange(range.location, model.winningNumbers.length - range.location) Color:UIColorFromRGB(0x295fcc)];
            [self.bonusNumberLabel attributeWithText:model.winningNumbers controParams:@[param]];
        } else {
            self.bonusNumberLabel.text = model.winningNumbers;
        }
    
        
    }else{
        //等待开奖
        id string = model.resultMap[@"awardStatusCn"];
        if ([string isKindOfClass:[NSString class]] && ((NSString *)string).length > 0) {
            self.waitAwardLabel.text = string;
        }
        self.waitAwardLabel.hidden = NO;
        self.bonusNumberLabel.hidden = YES;
        self.formLabel.hidden = YES;
    }
    
    if ([model.gameEn isEqualToString:@"fc3d"]) {
        
        self.testNumber.hidden = NO;
        
        self.testNumber.text = model.testNum;
        
        [self.bonusNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_left).offset(CL__SCALE(121.f));
            
        }];
        
        [self.formLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.mas_left).offset(CL__SCALE(231.f));
        }];
        
        [self.waitAwardLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self.contentView);
            make.centerX.equalTo(self.formLabel);
        }];
        
        [self updateConstraints];
    }else if ([model.gameEn isEqualToString:@"pl5"]){
    
        self.formLabel.hidden = YES;
        
        [self.bonusNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.periodLabel.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            
        }];
        
    }else if ([model.gameEn isEqualToString:@"qlc"] || [model.gameEn isEqualToString:@"qxc"]){
    
        [self.bonusNumberLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
           
            make.right.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.periodLabel.mas_right);
        }];
    }
    
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)periodLabel{
    
    if (!_periodLabel) {

        _periodLabel = [self createLabelWithText:@"159期"];
        
        //_periodLabel.backgroundColor = [UIColor redColor];
    }
    return _periodLabel;
}
- (UILabel *)bonusNumberLabel{
    
    if (_bonusNumberLabel == nil) {

        _bonusNumberLabel = [self createLabelWithText:@"8 7 2"];
        _bonusNumberLabel.font = [UIFont fontWithName:@"Courier" size:__SCALE_HALE(15)];
        _bonusNumberLabel.textColor = UIColorFromRGB(0xE63222);
        
        //_formLabel.backgroundColor = [UIColor redColor];
    }
    return _bonusNumberLabel;
}
- (UILabel *)formLabel
{
    
    if (_formLabel == nil ) {

        _formLabel = [self createLabelWithText:@"组六"];
        
//        _formLabel.backgroundColor = [UIColor redColor];
    }
    return _formLabel;
}

- (UILabel *)testNumber
{

    if (_testNumber == nil) {
        
        _testNumber = [self createLabelWithText:@"1 1 4"];
        
        _testNumber.hidden = YES;
    }
    return _testNumber;
}

- (UILabel *)waitAwardLabel{
    
    if (_waitAwardLabel == nil) {
        
        _waitAwardLabel = [self createLabelWithText:@"等待开奖"];
        
        _waitAwardLabel.hidden = YES;
    }
    return _waitAwardLabel;
}

- (UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    label.text = text;
    label.textColor = UIColorFromRGB(0x333333);
    label.font = FONT_SCALE(12);
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}


@end

