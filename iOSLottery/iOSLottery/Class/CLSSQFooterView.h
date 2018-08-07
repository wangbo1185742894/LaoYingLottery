//
//  CLSSQFooterView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSSQFooterView : UIView

@property (nonatomic, copy) void(^clearButtonClickBlock)(BOOL);//点击了清空按钮 或机选
@property (nonatomic, copy) void(^confirmButtonClickBlock)();//点击了确认按钮
- (void)assignBetNote:(NSInteger)note hasSelectBetButton:(BOOL)hasSelectBetButton playMothed:(NSInteger)playMothed;

@end
