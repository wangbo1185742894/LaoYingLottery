//
//  CLATBetOptionView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//  排列3 排列5 福彩3D 一组投注项

#import <UIKit/UIKit.h>

@class CLDEBetButton;

@protocol CLATBetOptionsViewDelegate <NSObject>

- (void)didSelectedOptions:(UIButton *)button groupTag:(NSString *)groupTag;

@end

@interface CLATBetOptionsView : UIView

/**
 选项组标记
 */
@property (nonatomic, strong) NSString *groupTag;

@property (nonatomic, weak) id <CLATBetOptionsViewDelegate> delegate;

//左侧标签label文字
- (void)setTagText:(NSString *)text;

//设置选中项
- (void)setSelectedOptionsWithData:(NSArray *)data;

//根据随机的tag值获取按钮
- (CLDEBetButton *)getRandomOptions:(NSInteger)tag;

//设置遗漏信息
- (void)setOmissionWithData:(NSArray *)data;

/**
 还原选项状态：未选中
 */
- (void)restoreOptionStatus;


@end
