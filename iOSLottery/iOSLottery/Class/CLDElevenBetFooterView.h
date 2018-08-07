//
//  CLDElevenBetFooterView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//
//D11主页面的底部视图
#import <UIKit/UIKit.h>

@interface CLDElevenBetFooterView : UIView

@property (nonatomic, copy) void(^clearButtonClickBlock)(BOOL);//点击了清空按钮 或机选
@property (nonatomic, copy) void(^confirmButtonClickBlock)();//点击了确认按钮
- (void)assignBetNote:(NSInteger)note minBonus:(NSInteger)minBonus maxBonus:(NSInteger)maxBonus hasSelectBetButton:(BOOL)hasSelectBetButton playMothed:(NSInteger)playMothed;

@end
