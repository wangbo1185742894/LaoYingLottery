//
//  CQSetPaymentPwdView.h
//  caiqr
//
//  Created by 彩球 on 16/4/7.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQSetPaymentPwdView : UIView

@property (nonatomic, copy) void(^closeViewHandler)(void);
@property (nonatomic, copy) void(^confirmEvent)(NSString* password);
@property (nonatomic, copy) void(^keyBoardObserver)(BOOL show,CGFloat height);
@property (nonatomic, copy) void(^exceptionMessage)(NSString* msg);


- (void)hideKeyboard;
- (void)startEdit;  /** 开始标记状态 弹出键盘 */
- (void)addkeyBoardObserver;
- (void)cancelKeyBoardObserver;
@end



@interface CQUserPaymentPwdView : UIView

@property (nonatomic, copy) void(^closeViewHandler)(void);
@property (nonatomic, copy) void(^confirmEvent)(NSString* password);
@property (nonatomic, copy) void(^forgetEvent)(void);
@property (nonatomic, copy) void(^keyBoardObserver)(BOOL show,CGFloat height);

@property (nonatomic, strong) NSString* errorMsg;
@property (nonatomic, readwrite) BOOL showForget;
@property (nonatomic, readwrite) BOOL controlCanInput;

- (void)hideKeyboard;
- (void)startEdit; /** 开始标记状态 弹出键盘 */
- (void)clearPassword;
- (void)addkeyBoardObserver;
- (void)cancelKeyBoardObserver;
- (void)startAnimate;   /** 输入内容错误时 抖动动画 */
@end


