//
//  CLlotteryFollowListCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/6/1.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLlotteryFollowListCell.h"
#import "CLConfigMessage.h"
#import "CLFollowListModel.h"
#import "CLOrderStatus.h"

#import "UILabel+CLAttributeLabel.h"

@interface CLlotteryFollowListCell ()

@property (nonatomic, strong) CALayer* arrowLayer;
@property (nonatomic, strong) UIView* bottomLine;

@end
@implementation CLlotteryFollowListCell

+ (CGFloat)cellHeight {
    float scale = [[UIScreen mainScreen] scale];
    return 60.f * scale;
}

+ (instancetype)createLotteryFollowListCellWith:(UITableView *)tableView
{

    static NSString *cellID = @"CLlotteryFollowListCell";
    
    CLlotteryFollowListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLlotteryFollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.timerLabel];
        [self.contentView addSubview:self.contentLable];
        [self.contentView addSubview:self.cashLable];
        [self.contentView  addSubview:self.bottomLine];
        
        [self setConstraints];
    }
    return self;
}

#pragma mark -

- (void) setConstraints {
    /**  */
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(__SCALE(10.f));
        make.top.equalTo(self.contentView).offset(__SCALE(10.f));
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLable.mas_right).offset(5.f);
        make.centerY.equalTo(self.titleLable);
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_left);
        make.bottom.equalTo(self.contentView).offset(__SCALE(- 10.f));
    }];
    
    [self.cashLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
        
    }];
}

- (void)setListModel:(CLFollowListModel *)listModel
{

    _listModel = listModel;
    
    self.titleLable.text = listModel.gameName;
    self.timerLabel.text = listModel.createTime;
    self.cashLable.text = listModel.followStatusCn;
    self.contentLable.text = [NSString stringWithFormat:@"已追%zi期/共%zi期",listModel.periodDone,listModel.totalPeriod];
    self.cashLable.textColor = UIColorFromStr(listModel.statusCnColor);
    
    if (listModel.followStatus < followOrderStatusBeting && listModel.followStatus != followOrderStatusUnPayCancel) {
        
        AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(2, [NSString stringWithFormat:@"%zi", listModel.periodDone].length) Color:THEME_COLOR];
        [self.contentLable attributeWithText:[NSString stringWithFormat:@"已追%zi期/共%zi期",listModel.periodDone,listModel.totalPeriod] controParams:@[params]];
    }
    
}

#pragma mark - getter

- (UILabel *)titleLable {
    
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = FONT_SCALE(13);
        _titleLable.textColor = UIColorFromRGB(0x333333);
        _titleLable.backgroundColor = CLEARCOLOR;
        
    }
    return _titleLable;
}
- (UILabel *)timerLabel{
    
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timerLabel.font = FONT_SCALE(12);
        _timerLabel.textColor = UIColorFromRGB(0x999999);
        _timerLabel.backgroundColor = CLEARCOLOR;
    }
    return _timerLabel;
}

- (UILabel *)contentLable {
    
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLable.font = FONT_SCALE(14);
        _contentLable.textColor = UIColorFromRGB(0x333333);
        _contentLable.backgroundColor = CLEARCOLOR;
    }
    return _contentLable;
}

- (UILabel *)cashLable {
    
    if (!_cashLable) {
        _cashLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _cashLable.font = FONT_SCALE(13);
        _cashLable.textColor = UIColorFromRGB(0x999999);
        _cashLable.textAlignment = NSTextAlignmentRight;
        _cashLable.backgroundColor = CLEARCOLOR;
        
    }
    return _cashLable;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
