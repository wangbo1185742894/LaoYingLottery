//
//  CQPasswordView.h
//  caiqr
//
//  Created by 彩球 on 16/4/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQPasswordView : UIView

@property (nonatomic, copy) void(^inputMixNoFinish)(NSString* string);

@property (nonatomic, copy) void(^inputContentChange)(void);

@property (nonatomic, readonly, strong) NSString* password;

@property (nonatomic, strong) UIColor* selectedColor;

@property (nonatomic, readonly) BOOL isValid;

@property (nonatomic, readwrite) BOOL isSelectState;

@property (nonatomic, readwrite) BOOL canEdit;

- (void)clearInputContent;

- (void)showKeyboard;

- (void)hideKeyboard;

@end
