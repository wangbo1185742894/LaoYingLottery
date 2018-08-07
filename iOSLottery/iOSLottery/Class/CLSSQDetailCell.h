//
//  CLSSQDetailCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLSSQDetailCell : UITableViewCell

/**
 点击了删除按钮
 */
@property (nonatomic, copy) void(^deleteCellBlock)();

/**
 配置数据
 
 @param data 数据
 */
- (void)assignBetDetailCellWithData:(id)data;

@end
