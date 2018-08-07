//
//  CLQLCBetOptionsView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDEBetButton;

@protocol CLQLCBetOptionsViewDelegate <NSObject>

- (void)didSelectedOptions:(UIButton *)button groupTag:(NSString *)groupTag;

@end

@interface CLQLCBetOptionsView : UIView

/**
 选项组标记
 */
@property (nonatomic, strong) NSString *groupTag;

@property (nonatomic, weak) id <CLQLCBetOptionsViewDelegate> delegate;

/**
 设置提示文字，和标签文字
 */
- (void)setPromptText:(NSString *)text andTagText:(NSString *)tag;


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
