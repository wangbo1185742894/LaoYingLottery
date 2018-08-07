//
//  CLSFCDetailsCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/27.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCDetailsCell.h"
#import "CLConfigMessage.h"

#import "CLSFCManager.h"

#import "CLSFCBetOption.h"
#import "CLSFCBetModel.h"
#import "CLSFCSelectedModel.h"

#import "UIResponder+CLRouter.h"

@interface CLSFCDetailsCell ()

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *middleLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) CLSFCBetOption *leftButton;

@property (nonatomic, strong) CLSFCBetOption *middleButton;

@property (nonatomic, strong) CLSFCBetOption *rightButton;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) CLSFCBetModel *dataModel;

@property (nonatomic, strong) NSMutableArray *optionsArray;

@end

@implementation CLSFCDetailsCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellID = @"CLSFCBetDetailsCell";
    CLSFCDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[CLSFCDetailsCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.contentView.backgroundColor = UIColorFromRGB(0xFFFFFF);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)p_addSubviews
{
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.middleLabel];
    [self.contentView addSubview:self.rightLabel];
    
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.middleButton];
    [self.contentView addSubview:self.rightButton];
    
    [self.contentView addSubview:self.bottomLine];
}

- (void)p_addConstraints
{
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.middleLabel.mas_left).offset(CL__SCALE(-5.f));
        make.bottom.centerY.equalTo(self.contentView);
        
    }];
    
    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(CL__SCALE(70.f));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.middleLabel.mas_right).offset(CL__SCALE(5.f));
    }];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(CL__SCALE(155.f));
        make.width.mas_equalTo(CL__SCALE(60.f));
        make.height.mas_equalTo(CL__SCALE(30.f));
        make.centerY.equalTo(self.contentView);
    }];
    [self.middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.leftButton.mas_right);
        make.width.height.centerY.equalTo(self.leftButton);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.middleButton.mas_right);
        make.width.height.centerY.equalTo(self.middleButton);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.51);
    }];
}

- (void)setData:(CLSFCBetModel *)data
{
    
    self.dataModel = data;
    
    self.leftLabel.text = data.hostName;
    
    self.rightLabel.text = data.awayName;
    
    
    CLSFCSelectedModel *model = [[CLSFCManager shareManager] getSelectedModelWithMatchId:data.serialNumber];
    
    [self.optionsArray enumerateObjectsUsingBlock:^(CLSFCBetOption *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn.selected = [model.optionsArray containsObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    }];
}


#pragma mark ----- 点击事件 -----
- (void)betOptionClick:(UIButton *)btn
{
    
    btn.selected = !btn.selected;
    
    NSString *option = [NSString stringWithFormat:@"%ld",btn.tag];
    
    if (btn.selected) {
        
        [[CLSFCManager shareManager] saveOneOption:option matchId:self.dataModel.serialNumber];
        
    }else{
        
        [[CLSFCManager shareManager] removeOneOptions:option matchId:self.dataModel.serialNumber];
    }
    
    [self routerWithEventName:@"CLSFCBETDETAILSOPTIONSRELOADUI" userInfo:nil];
    
}


#pragma mark ----- lazyLoad ------

- (UILabel *)leftLabel
{
    
    if (_leftLabel == nil) {
        
        _leftLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x333333) font:FONT_SCALE(14.f)];
    }
    return _leftLabel;
}

- (UILabel *)middleLabel
{
    if (_middleLabel == nil) {
        
        _middleLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x999999) font:FONT_SCALE(12.f)];
        _middleLabel.text = @"VS";
    }
    return _middleLabel;
    
}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        
        _rightLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x333333) font:FONT_SCALE(14.f)];
    }
    return _rightLabel;
}

- (UILabel *)p_createLabelWithTextColor:(UIColor *)color font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.textColor = color;
    label.font = font;
    
    return label;
}

- (CLSFCBetOption *)leftButton
{
    
    if (_leftButton == nil) {
        
        _leftButton = [self p_createButtonWithTitle:@"3"];
    }
    return _leftButton;
}

- (CLSFCBetOption *)middleButton
{
    
    if (_middleButton == nil) {
        
        _middleButton = [self p_createButtonWithTitle:@"1"];
    }
    return _middleButton;
}

- (CLSFCBetOption *)rightButton
{
    
    if (_rightButton == nil) {
        
        _rightButton = [self p_createButtonWithTitle:@"0"];
        [_rightButton setShowRightLine:YES];
    }
    return _rightButton;
}

- (CLSFCBetOption *)p_createButtonWithTitle:(NSString *)title
{
    
    CLSFCBetOption *btn = [[CLSFCBetOption alloc] initWithFrame:(CGRectZero)];
    
    [btn setPlayName:title];
    [btn setShowBottomLine:YES];
    
    [btn setNormalColor:UIColorFromRGB(0xF5F5F5)];
    
    btn.tag = [title integerValue];
    
    [self.optionsArray addObject:btn];
    
    [btn addTarget:self action:@selector(betOptionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return btn;
}

- (UIView *)bottomLine
{
    
    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] initWithFrame:(CGRectZero)];
        
        _bottomLine.backgroundColor = UIColorFromRGB(0xDDDDDD);
    }
    return _bottomLine;
}

- (NSMutableArray *)optionsArray
{
    
    if (_optionsArray == nil) {
        
        _optionsArray = [NSMutableArray new];
    }
    return _optionsArray;
}
@end
