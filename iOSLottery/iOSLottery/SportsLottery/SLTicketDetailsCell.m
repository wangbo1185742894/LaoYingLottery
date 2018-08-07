//
//  CLTicketDetailsCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLConfigMessage.h"

#import "SLTicketDetailsCell.h"

#import "SLTicketDetailsBetItem.h"

#import "SLTicketDetailsModel.h"

@interface SLTicketDetailsCell ()

/**
  票号label
 */
@property (nonatomic, strong) UILabel *ticketNumber;

/**
 投注信息
 */
@property (nonatomic, strong) SLTicketDetailsBetItem *messageView;

/**
 倍数
 */
@property (nonatomic, strong) UILabel *multiple;

/**
 出票状态
 */
@property (nonatomic, strong) UILabel *ticketstatu;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@end


@implementation SLTicketDetailsCell

#pragma mark --- Class Methods ---

+ (instancetype)createTicketDetailsCellWithTableView:(UITableView *)tableView;
{
    static NSString *ID = @"SLTicketDetailsCell";
    
    SLTicketDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[SLTicketDetailsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        //添加子控件
        [self setUpContentView];
        
        //设置约束
        [self addConstraintsForContentView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);

        
    }
    
    return self;
}

- (void)setUpContentView
{
    [self.contentView addSubview:self.ticketNumber];
    [self.contentView addSubview:self.messageView];
    [self.contentView addSubview:self.multiple];
    [self.contentView addSubview:self.ticketstatu];
    [self.contentView addSubview:self.bottomLine];

}

- (void)addConstraintsForContentView
{

    [self.ticketNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView.mas_top).with.offset(SL__SCALE(15.f));
        make.left.equalTo(self.contentView.mas_left).with.offset(SL__SCALE(15.f));
        make.right.equalTo(self.contentView.mas_right).with.offset(SL__SCALE(-15.f));
        make.height.mas_equalTo(SL__SCALE(18.f));
        
    }];
    
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.ticketNumber.mas_left);
        make.top.equalTo(self.ticketNumber.mas_bottom).with.offset(SL__SCALE(5.f));
        //make.right.lessThanOrEqualTo(self.multiple.mas_left).offset(SL__SCALE(-5.f)).priority(1000);
        make.bottom.equalTo(self.bottomLine.mas_top).offset(SL__SCALE(-10.f));
        
    }];
    
    [self.multiple mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //make.centerX.equalTo(self.contentView.mas_centerX).offset(SL__SCALE(32.f));
        make.centerY.equalTo(self.messageView.mas_centerY);
        
        make.left.greaterThanOrEqualTo(self.messageView.mas_right).offset(SL__SCALE(5.f)).priority(1000);
        make.right.lessThanOrEqualTo(self.contentView.mas_centerX).offset(SL__SCALE(30.f)).priority(500);
        
    }];
    
    [self.ticketstatu mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(SL__SCALE(-20.f));
        make.centerY.equalTo(self.multiple.mas_centerY);        
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(10.f));
    }];
}

- (void)setTicketModel:(SLTicketDetailsItemModel *)ticketModel
{

    _ticketModel = ticketModel;
    
    self.ticketNumber.text = [NSString stringWithFormat:@"票号:%@",ticketModel.ticketId];
    
    self.multiple.text = [NSString stringWithFormat:@"%ld倍",ticketModel.times];

    self.ticketstatu.text = ticketModel.ticketStatusCn;
    
    if (ticketModel.statusColor.length != 0) {
     
        self.ticketstatu.textColor = SL_UIColorFromStr(ticketModel.statusColor);
    }
    self.messageView.itemArray = ticketModel.lotteryNumbers;
}

#pragma mark --- lazyLoad ---
- (UILabel *)ticketNumber
{

    if (_ticketNumber == nil) {
        
        _ticketNumber = [[UILabel alloc] init];
        _ticketNumber.text = @"票号：200203010203012004012030401123";
        _ticketNumber.textColor = [UIColor grayColor];
        _ticketNumber.font = SL_FONT_SCALE(12.f);
        _ticketNumber.textAlignment = NSTextAlignmentLeft;
    }
    return _ticketNumber;
}

- (SLTicketDetailsBetItem *)messageView
{
    if (_messageView == nil) {
        
        _messageView = [[SLTicketDetailsBetItem alloc] init];
    }
    return _messageView;

}

- (UILabel *)multiple
{
    if (_multiple == nil) {
        
        _multiple = [[UILabel alloc] init];
        _multiple.text = @"10陪";
        _multiple.textColor = SL_UIColorFromRGB(0x333333);
        _multiple.textAlignment = NSTextAlignmentCenter;
        _multiple.font = SL_FONT_SCALE(14.f);
    }
    
    return _multiple;
}

- (UILabel *)ticketstatu
{

    if (_ticketstatu == nil) {
        
        _ticketstatu = [[UILabel alloc] init];
        _ticketstatu.text = @"出票失败";
        _ticketstatu.textColor = SL_UIColorFromRGB(0x333333);
        _ticketstatu.textAlignment = NSTextAlignmentCenter;
        _ticketstatu.font = SL_FONT_SCALE(14.f);
    }

    return _ticketstatu;
}

- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
    }

    return _bottomLine;
}

@end
