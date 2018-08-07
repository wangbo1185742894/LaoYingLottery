//
//  SLOrderDetailsMessageCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/29.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLOrderDetailsMessageCell.h"
#import "SLConfigMessage.h"
#import "SLBODAllModel.h"

@interface SLOrderDetailsMessageCell ()

@property (nonatomic, strong) UILabel *messageTitle;

@property (nonatomic, strong) UILabel *messageContent;

@property (nonatomic, strong) UITableView *GestureTableView;

@property (nonatomic, strong) UIButton *contentBtn;

@end

@implementation SLOrderDetailsMessageCell

+ (instancetype)createOrderDetailsMessageCellWithTableView:(UITableView *)tableView
{

    static NSString *cellID = @"SLOrderDetailsMessageCell";
    
    SLOrderDetailsMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[SLOrderDetailsMessageCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
    }
    cell.GestureTableView = tableView;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)addSubviews
{

    [self.contentView addSubview:self.messageTitle];
    
    [self.contentView addSubview:self.messageContent];
    
    [self.contentView addSubview:self.contentBtn];
}

- (void)addConstraints
{

    [self.messageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(SL__SCALE(10.f));
        make.width.mas_equalTo(SL__SCALE(60.f));
        make.height.mas_equalTo(SL__SCALE(14.f));
    }];
    
    [self.messageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.messageTitle.mas_top);
        make.left.equalTo(self.messageTitle.mas_right).offset(SL__SCALE(6.f));
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(SL__SCALE(-22.f));
    }];
    
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.messageContent.mas_top);
        make.left.equalTo(self.messageContent.mas_right).offset(SL__SCALE(6.f));
        make.height.mas_equalTo(SL__SCALE(15.f));
        
    }];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark --- Button Click ---
- (void)longPressGestureClick:(UILongPressGestureRecognizer *)gesture
{
    if (self.contentLongBlock) {
        [self becomeFirstResponder];
        if([UIMenuController sharedMenuController].isMenuVisible){
            return;
        }
        self.messageContent.backgroundColor = SL_UIColorFromRGB(0xd9d9d9);
        self.contentLongBlock([self.GestureTableView rectForRowAtIndexPath:[self.GestureTableView indexPathForCell:self]],self.messageContent);
    }
    
}

- (void)contentBtnClick
{

    self.messageCellBlock ? self.messageCellBlock() : nil;
}

#pragma mark --- Set Method ---
- (void)setMessageModel:(SLBODOrderMessageModel *)messageModel
{

    _messageModel = messageModel;
    
    _messageTitle.text = messageModel.title;
    
    [self setUpMessageContentAttributedString];
    
    self.hidden = messageModel.messageHeight == 0 ? YES : NO;
    
    self.contentBtn.hidden = (messageModel.is_Click == 22 ? NO : YES);

}

- (void)setUpMessageContentAttributedString
{
    if (!(self.messageModel.content && self.messageModel.content.length > 0)) return;

    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.messageModel.content];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:SL__SCALE(3.f)];
    
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:(NSMakeRange(0, self.messageModel.content.length))];
    
    self.messageContent.attributedText = attrStr;
}

#pragma mark --- Get Method ---
- (UILabel *)messageTitle
{
  
    if (_messageTitle == nil) {
        
        _messageTitle = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _messageTitle.text = @"投注方式:";
        _messageTitle.textAlignment = NSTextAlignmentLeft;
        _messageTitle.textColor = SL_UIColorFromRGB(0x8F6E51);
        
        _messageTitle.font = SL_FONT_SCALE(12.f);
        
        //_messageTitle.backgroundColor = [UIColor redColor];
        
    }
    return _messageTitle;
}

- (UILabel *)messageContent
{

    if (_messageContent == nil) {
        
        _messageContent = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _messageContent.text = @"单关，2串1，20注，1倍";
        _messageContent.textColor = SL_UIColorFromRGB(0x8F6E51);
        _messageContent.textAlignment = NSTextAlignmentLeft;
        
        _messageContent.font = SL_FONT_SCALE(12.f);
        
        _messageContent.numberOfLines = 0;
        
        //_messageContent.backgroundColor = [UIColor blueColor];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureClick:)];
        
        longPressGesture.minimumPressDuration = 0.8f;
        _messageContent.userInteractionEnabled = YES;
        [_messageContent addGestureRecognizer:longPressGesture];
        
    }
    return _messageContent;
}

- (UIButton *)contentBtn
{

    if (_contentBtn == nil) {
        
        _contentBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        
        [_contentBtn setTitle:@"出票详情" forState:(UIControlStateNormal)];
        [_contentBtn setTitleColor:SL_UIColorFromRGB(0x45A2F7) forState:(UIControlStateNormal)];
        
        _contentBtn.titleLabel.font = SL_FONT_SCALE(12.f);
        
        [_contentBtn addTarget:self action:@selector(contentBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _contentBtn;
}


@end
