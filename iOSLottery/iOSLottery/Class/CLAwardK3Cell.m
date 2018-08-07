//
//  CLAwardK3Cell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardK3Cell.h"
#import "CLAwardK3View.h"
#import "CLConfigMessage.h"
#import "CLAwardVoModel.h"

@interface CLAwardK3Cell ()

@property (nonatomic, strong) CLAwardK3View* awardView;
@property (nonatomic, strong) UIView* lineView;

@end

@implementation CLAwardK3Cell

+ (CLAwardK3Cell *)createAwardK3CellWithTableView:(UITableView *)tableView
{

    static NSString *ID = @"CLAwardK3Cell11";
    CLAwardK3Cell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[CLAwardK3Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addSubviews
{
    [self.contentView addSubview:self.awardView];
    [self.contentView addSubview:self.lineView];
}

- (void)addConstraints
{
    [self.awardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
}

- (void)configureKuai3Data:(CLAwardVoModel*)data {
    
    self.awardView.lottNameLbl.text = data.gameName;
    self.awardView.timeLbl.text = data.awardTime;
    self.awardView.periodLabel.text = [NSString stringWithFormat:@"第%@期", data.periodId];
    [self.awardView setNumbers:[data.winningNumbers componentsSeparatedByString:@" "]];
}

- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.awardView.isShowLotteryName = isShowLotteryName;
}

#pragma mark --- Get Method ---
- (CLAwardK3View *)awardView
{

    if (_awardView == nil) {
        
        _awardView = [[CLAwardK3View alloc] init];
    }
    return _awardView;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}

@end
