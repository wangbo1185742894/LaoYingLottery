//
//  CLSFCMainBetCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCMainBetCell.h"

#import "UIResponder+CLRouter.h"

#import "CLConfigMessage.h"

#import "CLSFCManager.h"

#import "CLSFCMatchInfoView.h"

#import "CLSFCBetOption.h"

#import "CLSFCBetModel.h"
#import "CLSFCSelectedModel.h"

#import "UILabel+CLAttributeLabel.h"

#import "CLSFCHistoryView.h"

@interface CLSFCMainBetCell ()

@property (nonatomic, strong) CLSFCMatchInfoView *infoView;

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *middleLabel;

@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) CLSFCBetOption *leftButton;

@property (nonatomic, strong) CLSFCBetOption *middleButton;

@property (nonatomic, strong) CLSFCBetOption *rightButton;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) CLSFCHistoryView *historyView;

@property (nonatomic, strong) CLSFCBetModel *dataModel;

@property (nonatomic, strong) NSMutableArray *optionsArray;

@end

@implementation CLSFCMainBetCell

+ (instancetype)createCellWithTableView:(UITableView *)tableView
{

    static NSString *cellID = @"CLSFCMainBetCell";
    CLSFCMainBetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[CLSFCMainBetCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        
        self.contentView.backgroundColor = UIColorFromRGB(0XF7F7EE);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)p_addSubviews
{

    [self.contentView addSubview:self.infoView];
    
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.middleLabel];
    [self.contentView addSubview:self.rightLabel];
    
    [self.contentView addSubview:self.leftButton];
    [self.contentView addSubview:self.middleButton];
    [self.contentView addSubview:self.rightButton];
    
    [self.contentView addSubview:self.bottomLine];
    
    [self.contentView addSubview:self.historyView];
}

- (void)p_addConstraints
{
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.left.equalTo(self.contentView);
        make.width.mas_offset(CL__SCALE(90.f));
        make.height.mas_offset(CL__SCALE(80.f));
    }];

    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.bottom.equalTo(self.leftButton.mas_top).offset(CL__SCALE(-8.f));
        make.bottom.centerX.equalTo(self.leftButton);

    }];

    [self.middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.leftLabel);
        make.centerX.equalTo(self.middleButton);
    }];

    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self.leftLabel);
        make.centerX.equalTo(self.rightButton);
    }];

    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.contentView).offset(CL__SCALE(90.f));
        make.width.mas_equalTo(CL__SCALE(90.f));
        make.height.mas_equalTo(CL__SCALE(35.f));
        make.bottom.equalTo(self.bottomLine.mas_top).offset(CL__SCALE(-10.f));
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

        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.infoView.mas_bottom);
        make.height.mas_equalTo(0.51);
    }];

    [self.historyView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.bottomLine.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(CL__SCALE(0.f));
    }];
}

- (void)setData:(CLSFCBetModel *)data
{

    self.dataModel = data;
    
    self.leftLabel.text = data.hostName;
    
    self.rightLabel.text = data.awayName;
    
    
    //校验主队名字是否存在
    /** 主队 */
    if (data.hostRank && data.hostRank.length > 0) {
        
        NSString *hostStr = [NSString stringWithFormat:@"%@%@",data.hostRank,data.hostName];
        
        [self.leftLabel attributeWithText:hostStr controParams:@[[AttributedTextParams attributeRange:[hostStr rangeOfString:data.hostRank] Font:FONT_SCALE(12.f)]]];
    }
    
    /** 客队 */
    //校验主队名字是否存在
    if (data.awayRank && data.awayRank.length > 0) {
        
        NSString *hostStr = [NSString stringWithFormat:@"%@%@",data.awayName,data.awayRank];
        
        [self.rightLabel attributeWithText:hostStr controParams:@[[AttributedTextParams attributeRange:[hostStr rangeOfString:data.awayRank] Font:FONT_SCALE(12.f)]]];
    }
    
    self.infoView.infoModel = data;
    
    self.historyView.historyModel = data;
    
    //校验
    if (self.historyView.hidden == data.isShowHistory) {
        self.historyView.hidden = !data.isShowHistory;
        
        [self setUpHistoryViewConstrainsWithIsShow:data.isShowHistory];
        
    }
    
    CLSFCSelectedModel *model = [[CLSFCManager shareManager] getSelectedModelWithMatchId:data.serialNumber];
    
    [self.optionsArray enumerateObjectsUsingBlock:^(CLSFCBetOption *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        
        btn.selected = [model.optionsArray containsObject:[NSString stringWithFormat:@"%ld",btn.tag]];
    }];
}

//设置历史详情约束
- (void)setUpHistoryViewConstrainsWithIsShow:(BOOL)isShow
{
    
    [self.historyView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(isShow ? 120.f : 0);
        
    }];
    
    [self updateConstraintsIfNeeded];
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
    
    [self routerWithEventName:@"CLSFCOPTIONSRELOADUI" userInfo:nil];

}


#pragma mark ----- lazyLoad ------

- (CLSFCMatchInfoView *)infoView
{

    if (_infoView == nil) {
        
        _infoView = [[CLSFCMatchInfoView alloc] initWithFrame:(CGRectZero)];
        
        WS(weak)
        [_infoView returnShowHistoryClick:^{
            
            !weak.showHistoryBlock ? : weak.showHistoryBlock(weak);
        }];
        
    }
    return _infoView;
}

- (UILabel *)leftLabel
{

    if (_leftLabel == nil) {
        
        _leftLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x151515) font:FONT_SCALE(14.f)];
    }
    return _leftLabel;
}

- (UILabel *)middleLabel
{
    if (_middleLabel == nil) {
        
        _middleLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x333333) font:FONT_SCALE(12.f)];
        _middleLabel.text = @"VS";
    }
    return _middleLabel;

}

- (UILabel *)rightLabel
{
    if (_rightLabel == nil) {
        
        _rightLabel = [self p_createLabelWithTextColor:UIColorFromRGB(0x151515) font:FONT_SCALE(14.f)];
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
    }
    return _rightButton;
}

- (CLSFCBetOption *)p_createButtonWithTitle:(NSString *)title
{

    CLSFCBetOption *btn = [[CLSFCBetOption alloc] initWithFrame:(CGRectZero)];
    
    [btn setPlayName:title];
    
    btn.tag = [title integerValue];
    
    [btn addTarget:self action:@selector(betOptionClick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.optionsArray addObject:btn];
    
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

- (CLSFCHistoryView *)historyView
{

    if (_historyView == nil) {
        
        _historyView = [[CLSFCHistoryView alloc] initWithFrame:(CGRectZero)];
        
        _historyView.hidden = YES;
        
    }
    return _historyView;
}

- (NSMutableArray *)optionsArray
{

    if (_optionsArray == nil) {
        
        _optionsArray = [NSMutableArray new];
    }
    return _optionsArray;
}

@end
