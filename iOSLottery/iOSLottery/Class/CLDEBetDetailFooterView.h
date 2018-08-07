//
//  CLDEBetDetailFooterView.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDEBetDetailFooterView : UIView

@property (nonatomic, copy) void(^chaseButtonClickBlock)();//点击了追号按钮
@property (nonatomic, copy) void(^clearButtonClickBlock)();//点击了清空
@property (nonatomic, copy) void(^payButtonClickBlock)();//点击了付款按钮

/**
 配置数据
 
 @param note        注数
 @param periodCount 期数
 @param multiple    倍数
 */
- (void)assignBetNote:(NSInteger)note period:(NSInteger)periodCount multiple:(NSInteger)multiple;

- (void)assignBetNote:(NSInteger)note period:(NSInteger)periodCount multiple:(NSInteger)multiple money:(NSInteger)money;

@end
