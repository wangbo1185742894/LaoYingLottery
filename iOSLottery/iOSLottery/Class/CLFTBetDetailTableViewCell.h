//
//  CLFTBetDetailTableViewCell.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLFTBetDetailTableViewCell : UITableViewCell

/**
 点击了删除按钮
 */
@property (nonatomic, copy) void(^deleteCellBlock)();
- (void)assignBetDetailCellWithData:(id)data;

@end
