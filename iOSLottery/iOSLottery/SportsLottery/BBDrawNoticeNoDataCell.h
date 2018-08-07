//
//  BBDrawNoticeNoDataCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateDrawNoticeDelegate.h"

@class BBDrawNoticeModel;

@interface BBDrawNoticeNoDataCell : UITableViewCell<CreateDrawNoticeDelegate>

@property (nonatomic, strong) BBDrawNoticeModel *cellModel;

+ (instancetype)createBBDrawNoticeCellWithTableView:(UITableView *)tableView;

@end
