//
//  CLSFCOrderDetailsCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/30.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCMatchResultCell.h"
#import "CLConfigMessage.h"

#import "CLOrderDetailBetNumModel.h"

#import "UILabel+CLAttributeLabel.h"

@interface CLSFCMatchResultCell ()

/**
 场次label
 */
@property (nonatomic, strong) UILabel *sessionLabel;

/**
 主队label
 */
@property (nonatomic, strong) UILabel *hostLabel;

/**
 vslabel
 */
@property (nonatomic, strong) UILabel *vsLabel;

/**
 客队label
 */
@property (nonatomic, strong) UILabel *awayLabel;

/**
 投注内容label
 */
@property (nonatomic, strong) UILabel *betOptionLabel;

/**
 赛果label
 */
@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;

@property (nonatomic, assign) CLSFCMatchResultType type;

@end

@implementation CLSFCMatchResultCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView type:(CLSFCMatchResultType)type
{
    
    static NSString *cellID = @"CLQLCDrawNoticeCell";
    CLSFCMatchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[CLSFCMatchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID type:type];
    }
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(CLSFCMatchResultType)type
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        _type = type;
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)p_addSubviews
{
    [self.contentView addSubview:self.sessionLabel];
    [self.contentView addSubview:self.hostLabel];
    [self.contentView addSubview:self.vsLabel];
    [self.contentView addSubview:self.awayLabel];
    [self.contentView addSubview:self.betOptionLabel];
    [self.contentView addSubview:self.resultLabel];
    
    [self.contentView addSubview:self.line1];
    [self.contentView addSubview:self.line2];
    [self.contentView addSubview:self.line3];

}

- (void)p_addConstraints
{
    if (self.type == CLSFCMatchResultPeriodType) {
        
        
        [self.sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.contentView).offset(CL__SCALE(7.f));
            make.bottom.equalTo(self.contentView).offset(CL__SCALE(-7.f));
            make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(47.f));
            make.height.mas_offset(CL__SCALE(16.f));
        }];
        
        
        [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.sessionLabel);
            make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(141.f));
        }];
        
        [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.sessionLabel);
            make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(235.f));
        }];
        
        [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.sessionLabel);
            make.centerX.equalTo(self.contentView.mas_right).offset(CL__SCALE(-46.5));
        }];
        
        [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_offset(0.51);
            make.left.equalTo(self.contentView).offset(CL__SCALE(93.5));
        }];
        
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(CL__SCALE(187.5));
            make.height.width.equalTo(self.line1);
        }];
        
        [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(CL__SCALE(281.5));
            make.height.width.equalTo(self.line1);
        }];
        
        return;
        
    }

    [self.sessionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).offset(CL__SCALE(7.f));
        make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(37.f));
        make.height.mas_offset(CL__SCALE(16.f));
        make.bottom.equalTo(self.contentView).offset(CL__SCALE(-7.f));
    }];
    
    [self.vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.sessionLabel);
        make.centerX.equalTo(self.contentView.mas_left).offset(CL__SCALE(143.f + 12.f));
    }];
    
    [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.sessionLabel);
        make.right.equalTo(self.vsLabel.mas_left).offset(CL__SCALE(-8.5));
    }];
    
    [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.sessionLabel);
        make.left.equalTo(self.vsLabel.mas_right).offset(CL__SCALE(8.5));
    }];
    
    [self.betOptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.sessionLabel);
        make.centerX.equalTo(self.contentView.mas_right).offset(CL__SCALE(-110.f));
    }];
    
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.sessionLabel);
        make.centerX.equalTo(self.contentView.mas_right).offset(CL__SCALE(-36.f));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_offset(0.51);
        make.left.equalTo(self.contentView).offset(CL__SCALE(73.5));
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(CL__SCALE(227.5));
        make.height.width.equalTo(self.line1);
    }];
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(CL__SCALE(301.5));
        make.height.width.equalTo(self.line1);
    }];
}


- (void)setModel:(CLOrderDetailBetNumModel *)model
{
    if (model.serialNumber == 0) {
     
        self.sessionLabel.text = @"场次";
        self.sessionLabel.textColor = UIColorFromRGB(0x999999);
        self.hostLabel.textColor = UIColorFromRGB(0x999999);
        self.vsLabel.textColor = UIColorFromRGB(0x999999);
        self.awayLabel.textColor = UIColorFromRGB(0x999999);
        self.betOptionLabel.textColor = UIColorFromRGB(0x999999);
        self.resultLabel.textColor = UIColorFromRGB(0x999999);
    }else{

        self.sessionLabel.text = [NSString stringWithFormat:@"%ld",model.serialNumber];

        self.sessionLabel.textColor = UIColorFromRGB(0x333333);
        self.awayLabel.textColor = UIColorFromRGB(0x333333);
        self.vsLabel.textColor = UIColorFromRGB(0x333333);
        self.hostLabel.textColor = UIColorFromRGB(0x333333);
        self.resultLabel.textColor = UIColorFromRGB(0x333333);
        self.betOptionLabel.textColor = UIColorFromRGB(0x333333);
    
    }
    
    self.hostLabel.text = model.hostName;
    self.vsLabel.text = model.score;
    self.awayLabel.text = model.awayName;
    self.betOptionLabel.text = model.betOption;
    self.resultLabel.text = model.result;
    
    self.contentView.backgroundColor = (model.serialNumber % 2 == 0) ? UIColorFromRGB(0xFFFFFF) : UIColorFromRGB(0xFBFBF7);
    
    NSRange range = [model.betOption rangeOfString:@"^"];
    
    if (range.length < 1) return;
    
    AttributedTextParams *params = [AttributedTextParams attributeRange:NSMakeRange(range.location, 1) Color:UIColorFromRGB(0xd90000)];
    
    NSString *optionStr = [model.betOption stringByReplacingOccurrencesOfString:@"^" withString:@""];
    
    [self.betOptionLabel attributeWithText:optionStr controParams:@[params]];
}

#pragma mark ----- lazyLoad -----

- (UILabel *)sessionLabel
{

    if (_sessionLabel == nil) {
        
        _sessionLabel =  [self createLabel];
    }
    return _sessionLabel;
}

- (UILabel *)hostLabel
{

    if (_hostLabel == nil) {
        
        _hostLabel = [self createLabel];
    }
    return _hostLabel;
}

- (UILabel *)vsLabel
{
    
    if (_vsLabel == nil) {
        
        _vsLabel = [self createLabel];
        _vsLabel.text = @"VS";
    }
    return _vsLabel;
}

- (UILabel *)awayLabel
{
    
    if (_awayLabel == nil) {
        
        _awayLabel = [self createLabel];
    }
    return _awayLabel;
}

- (UILabel *)betOptionLabel
{
    
    if (_betOptionLabel == nil) {
        
        _betOptionLabel = [self createLabel];
    }
    return _betOptionLabel;
}

- (UILabel *)resultLabel
{
    
    if (_resultLabel == nil) {
        
        _resultLabel = [self createLabel];
    }
    return _resultLabel;
}

- (UILabel *)createLabel
{

    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.text = @"测试";
    label.textColor = UIColorFromRGB(0x333333);
    label.font = CL_FONT_SCALE(13.f);
    
    return label;
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

    UIView *line = [[UIView alloc] initWithFrame:(CGRectZero)];
    
    line.backgroundColor = UIColorFromRGB(0xDDDDDD);
    
    return line;
}
@end
