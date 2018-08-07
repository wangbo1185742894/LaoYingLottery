//
//  SLBetListDetailsCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表页，cell

#import <UIKit/UIKit.h>

@class SLBetDetailsModel;

typedef void(^BetDetailsBlock)(NSString *matchIssue);

@interface SLBetDetailsCell : UITableViewCell

@property (nonatomic, strong) BetDetailsBlock deleteBlock;

@property (nonatomic, strong) BetDetailsBlock editBetBlock;

@property (nonatomic, strong) SLBetDetailsModel *betDetailModel;

+ (SLBetDetailsCell *)createBetDetailsCellWithTableView:(UITableView *)tableView;

/**
 删除按钮点击事件
 */
- (void)returnDeleteClick:(BetDetailsBlock)block;

/**
 编辑投注内容点击事件
 */
- (void)returnEditBetClick:(BetDetailsBlock)block;

@end
