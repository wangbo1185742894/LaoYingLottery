//
//  CQUserCashWithdrawFooterView.h
//  caiqr
//
//  Created by 小铭 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CQ_INSTRUCTION(_msg)
typedef NS_ENUM(NSInteger, CQFooterActionStyle)
{
    CQFooterActionAppendBankCard = 1,
    CQFooterActionInstruction,
    CQFooterActionEvent,
};

@class CQFooterAction;

@interface CQUserCashWithdrawFooterView : UIView

/** 设置每个Action与上边的距离 必须在设置items之前设置 */
@property (nonatomic, strong) NSArray* topMarginValues;
/** 设置展示Action集合 */
@property (nonatomic, strong) NSArray* items;
/** 修改某个Action的样式 */
@property (nonatomic, strong) CQFooterAction* modifyAction;

@end

@interface CQFooterAction : NSObject

+ (CQFooterAction*)initWithTitle:(NSString*)title actionStyle:(CQFooterActionStyle)style frame:(CGRect)frame;

@property (nonatomic, strong) NSString* title;              //标题
@property (nonatomic, strong) UIFont* font;                 //标题字体
@property (nonatomic, strong) UIColor* titleColor;          //标题颜色
@property (nonatomic, strong) UIColor* backgroundColor;     //可用时背景色

@property (nonatomic, assign) CGRect frame;                 //位置
@property (nonatomic, assign) CQFooterActionStyle style;    //类型


//Instruction relate (UILabel)
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) NSTextAlignment textAlignment;

//Event relate (UIButton)
@property (nonatomic, copy) void(^footerActionEvent)(void); //点击事件
@property (nonatomic, readwrite) BOOL enable;               //是否可用
@property (nonatomic, strong) UIColor* unableBackgroundColor;//不可用时背景色

@end

@interface CQFooterButton : UIButton

@property (nonatomic, strong) CQFooterAction* action;

@end


@interface CQFooterLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end


