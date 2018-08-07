//
//  BBDrawNoticeHeaderView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/16.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBDrawNoticeGroupModel;

typedef void(^BBDrawNoticeHeaderBlock)();

@interface BBDrawNoticeHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) BBDrawNoticeHeaderBlock headerBlock;

/**
 数据模型
 */
@property (nonatomic, strong) BBDrawNoticeGroupModel *headerModel;

+ (instancetype)createBBDrawNoticeHeaderViewWithTableView:(UITableView *)tableView;

- (void)returnHeaderTapClick:(BBDrawNoticeHeaderBlock)block;

@end
