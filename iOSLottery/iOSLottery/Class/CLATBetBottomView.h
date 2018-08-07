//
//  CLATBetBottomView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//  排列3 排列5 福彩3D 选号页底部View

#import <UIKit/UIKit.h>

@interface CLATBetBottomView : UIView

@property (nonatomic, copy) void(^clearButtonClickBlock)(BOOL);//点击了清空按钮 或机选
@property (nonatomic, copy) void(^confirmButtonClickBlock)();//点击了确认按钮

/**
 排列3 排列5 福彩3D 刷新数据
 */
- (void)reloadDataWithNoteNumber:(NSInteger)number hasSelectedOptions:(BOOL)isHas;


@end
