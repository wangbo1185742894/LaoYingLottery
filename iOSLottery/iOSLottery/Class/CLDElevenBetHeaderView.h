//
//  CLDElevenBetHeaderView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDElevenBetHeaderView : UIView

@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, copy) void(^de_headViewOnClickBlock)();
@property (nonatomic, strong) UIImage *arrowImage;

@property (nonatomic, assign) BOOL isShowAllPeriod;

/**
 向下箭头 转动
 
 @param isRotation 是否转动
 */
- (void)arrowImageViewIsRotation:(BOOL)isRotation;

/**
 刷新头部视图
 */
- (void)reloadDataForBetHeaderView;

@end
