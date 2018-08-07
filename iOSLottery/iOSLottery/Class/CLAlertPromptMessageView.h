//
//  CLAlertPromptMessageView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/6.
//  Copyright © 2017年 caiqr. All rights reserved.

//自定义 弹窗 信息  可以直接在任意页面使用

#import <UIKit/UIKit.h>

@interface CLAlertPromptMessageView : UIView

@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *desTitle;//描述文字
@property (nonatomic, strong) NSString *cancelTitle;//取消按钮的文字
@property (nonatomic, copy) void(^blockWhenHidden)();
@property (nonatomic, copy) void(^btnOnClickBlock)();//点击了按钮
- (void)showInView:(UIView *)superView;
- (void)showInWindow;
- (void)hide;

@end
