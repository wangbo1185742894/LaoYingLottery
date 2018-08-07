//
//  CQUserCashWithdrawFooterView.m
//  caiqr
//
//  Created by 小铭 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQUserCashWithdrawFooterView.h"
#import "CQCreditCardCell.h"
#import "CLConfigMessage.h"
#import "CQImgAndTextView.h"


@interface CQUserCashWithdrawFooterView()
{
    CGFloat __footerViewTagOffset;
}
@end

@implementation CQUserCashWithdrawFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.frame = __Rect(0, 0, SCREEN_WIDTH, __SCALE(90));
        __footerViewTagOffset = 1000;
    }
    return self;
}

#pragma mark -Runloop Init Views

- (void)setItems:(NSArray *)items
{
    if (!items || items.count == 0) return;
    if (!self.topMarginValues || self.topMarginValues.count == 0) return;
    //每次set清空子视图
    if (self.subviews.count) [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _items = items;
    CGFloat height = 0.f;
    
    for (CQFooterAction* action in items) {
        NSUInteger index = [items indexOfObject:action];
        height += [[self.topMarginValues objectAtIndex:index] floatValue];
        action.frame = CGRectMake(action.frame.origin.x, height, action.frame.size.width, action.frame.size.height);
        UIView* contentView = nil;
        if (CQFooterActionAppendBankCard == action.style) {
            contentView = [self createAddBankCardViewWithAction:action];
        } else if (CQFooterActionInstruction == action.style) {
            contentView = [self createAddInstructionWithAction:action];
        } else if (CQFooterActionEvent == action.style) {
            contentView = [self createAddEventWithAction:action];
        }
        contentView.tag = __footerViewTagOffset + index;
        [self addSubview:contentView];
        height += contentView.frame.size.height;
        contentView = nil;
    }
    self.frame = __Rect(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, height + 10.f);
}

#pragma mark -Create different View

- (UIView*)createAddInstructionWithAction:(CQFooterAction*)action
{
    CQFooterLabel* label = [[CQFooterLabel alloc] initWithFrame:action.frame];
    label.text = action.title;
    label.textColor = action.titleColor;
    label.font = action.font;
    label.backgroundColor = action.backgroundColor;
    label.textAlignment = action.textAlignment;
    label.edgeInsets = action.edgeInsets;
    return label;
}

- (CQFooterButton*)createAddEventWithAction:(CQFooterAction*)action
{
    CQFooterButton* button = [CQFooterButton buttonWithType:UIButtonTypeCustom];
    button.action = action;
    button.frame = action.frame;
    button.layer.cornerRadius = 3.f;
    [button setTitle:action.title forState:UIControlStateNormal];
    [button setTitleColor:action.titleColor forState:UIControlStateNormal];
    button.titleLabel.font = action.font;
    button.enabled = action.enable;
    [button setBackgroundColor:action.enable?action.backgroundColor:action.unableBackgroundColor];
    [button addTarget:self action:@selector(eventClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIView*)createAddBankCardViewWithAction:(CQFooterAction*)action
{
    CQImgAndTextView *tableFooterView = [[CQImgAndTextView alloc] initWithFrame:__Rect(0, action.frame.origin.y, SCREEN_WIDTH, __SCALE(60))];
    tableFooterView.title = @"添加银行卡";
    tableFooterView.backgroundColor = UIColorFromRGB(0xffffff);
    tableFooterView.titleColor = UIColorFromRGB(0xbbbbbb);
    tableFooterView.titleFont = FONT(14);
    tableFooterView.img = [UIImage imageNamed:@"accountAddCard"];
    tableFooterView.imgToHeightScale = .15f;
    tableFooterView.tapGestureHandler = ^{
        if (action.footerActionEvent)
            action.footerActionEvent();
        
    };
    return tableFooterView;
}

#pragma mark -Footer Button Event

- (void)eventClicked:(CQFooterButton*)button
{
    if (button.action.footerActionEvent) {
        button.action.footerActionEvent();
    }
}

#pragma mark -Modify Action UI

- (void)setModifyAction:(CQFooterAction *)modifyAction
{
    NSUInteger index = [self.items indexOfObject:modifyAction];
    UIView* view = [self viewWithTag:(__footerViewTagOffset + index)];
    
    if (modifyAction.style == CQFooterActionEvent) {
        CQFooterButton* button = (CQFooterButton*)view;
        [button setTitle:modifyAction.title forState:UIControlStateNormal];
        [button setTitleColor:modifyAction.titleColor forState:UIControlStateNormal];
        button.titleLabel.font = modifyAction.font;
        button.enabled = modifyAction.enable;
        [button setBackgroundColor:modifyAction.enable?modifyAction.backgroundColor:modifyAction.unableBackgroundColor];
    } else if (modifyAction.style == CQFooterActionInstruction) {
        UILabel* label = (UILabel*)view;
        label.text = modifyAction.title;
        label.font = modifyAction.font;
        label.textColor = modifyAction.titleColor;
    }
    
}

@end

#pragma mark - 
#pragma mark @Class CQFooterAction

@implementation CQFooterAction


+ (CQFooterAction*)initWithTitle:(NSString*)title actionStyle:(CQFooterActionStyle)style frame:(CGRect)frame
{
    CQFooterAction* action = [[CQFooterAction alloc] init];
    action.title = title;
    action.style = style;
    action.frame = frame;
    action.enable = YES;
    return action;
}

- (UIColor *)titleColor
{
    return  (_titleColor) ? _titleColor : UIColorFromRGB(0x666666);
}

- (UIColor *)backgroundColor
{
    return  (_backgroundColor) ? _backgroundColor : CLEARCOLOR;
}

- (UIColor *)unableBackgroundColor
{
    return  (_unableBackgroundColor) ? _unableBackgroundColor : [UIColor lightGrayColor];
}

@end

@implementation CQFooterButton


@end

@implementation CQFooterLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = self.edgeInsets;
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}



@end
