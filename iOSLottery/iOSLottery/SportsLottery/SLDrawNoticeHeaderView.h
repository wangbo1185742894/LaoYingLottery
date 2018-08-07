//
//  SLDrawNoticeHeaderView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告 tableView headerView

#import <UIKit/UIKit.h>

@class SLDrawNoticeGroupModel;

typedef void(^SLDrawNoticeHeaderBlock)();

@interface SLDrawNoticeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) SLDrawNoticeHeaderBlock headerBlock;

/**
 数据模型
 */
@property (nonatomic, strong) SLDrawNoticeGroupModel *headerModel;

+ (instancetype)createDrawNoticeHeaderViewWithTableView:(UITableView *)tableView;

- (void)returnHeaderTapClick:(SLDrawNoticeHeaderBlock)block;

@end
