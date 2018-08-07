//
//  SLBottomBtnView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//  底部通用 删除 确定 view

#import <UIKit/UIKit.h>

typedef void(^SLBottomBtnBlock)();

@interface SLBottomBtnView : UIView

@property (nonatomic, copy) SLBottomBtnBlock cancelBlock;

@property (nonatomic, copy) SLBottomBtnBlock sureBlock;

- (void)returnCancelClick:(SLBottomBtnBlock)block;

- (void)returnSureClick:(SLBottomBtnBlock)block;

@end
