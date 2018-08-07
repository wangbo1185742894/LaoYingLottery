//
//  CQInputTextFieldView.h
//  caiqr
//
//  Created by 彩球 on 16/3/24.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

//类型 是否有底部横线
typedef NS_ENUM(NSInteger, CQInputTextType)
{
    inputTextTypeRect,//带边框
    inputTextTypeUnderline,//带底部横线
    inputTextTypeNormal //普通
};

typedef NS_ENUM(NSInteger, CQInputLimitType) {
    
    CQInputLimitTypeNormal = 0, //不做限制  默认
    CQInputLimitTypeNumber , //只能数字
    CQInputLimitTypeNumberAndEnglish //数字 英文
};

typedef NS_ENUM(NSInteger, CLLeftViewEdgeType) {
    
    CLLeftViewEdgeTypeNormal,//左侧View的边距  默认10
    CLLeftViewEdgeTypeEdge//左侧View 无边距
};

@interface CQInputTextFieldView : UIView

@property (nonatomic, strong) NSString* textPlaceholder;

@property (nonatomic, assign) CLLeftViewEdgeType leftViewEdgeType;

@property (nonatomic, assign) UIKeyboardType keyBoardType;      //键盘类型

@property (nonatomic, assign) CQInputLimitType limitType; //输入限制类型

@property (nonatomic, assign) NSInteger limitLength;//输入长度限制

@property (nonatomic, assign) CQInputTextType inputTextType;    //样式

@property (nonatomic, readwrite) BOOL secureTextEntry;  //设置密码显示

@property (nonatomic) BOOL canShowSecureTxt;    //设置按钮支持密码明文切换

@property (nonatomic, copy) BOOL(^shouldChangeCharacters)(UITextField* textField,NSRange range,NSString* replacementString);

@property (nonatomic, copy) void(^keyboardReturnAction)(void);  //键盘按钮事件

@property (nonatomic, copy) BOOL(^checkImputTextValid)(NSString* text); //检验输入内容合法性

@property (nonatomic, copy) void(^textContentChange)(void); //内容发生改变

@property (nonatomic, readwrite) BOOL inputEnable;  //是否支持输入

@property (nonatomic, readonly) BOOL inputExistText;    //是否存在内容

@property (nonatomic, readonly) BOOL inputValidState;   //输入内容是否有效

@property (nonatomic, readonly, strong) NSString* text; //具体输入的内容

@property (nonatomic, strong) NSString* defautlText;    //默认内容 可退格删除

@property (nonatomic, strong) UIView *leftView;

@property (nonatomic, strong) UIView* rightView;

@property (nonatomic, strong) UIColor *textColor;

- (void)becomeFirstResponder;

- (void)resignFirstResponder;

@end
