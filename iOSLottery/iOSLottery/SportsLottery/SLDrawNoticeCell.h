//
//  SLDrawNoticeCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateDrawNoticeDelegate.h"

@class SLDrawNoticeModel;

@interface SLDrawNoticeCell : UITableViewCell<CreateDrawNoticeDelegate>

@property (nonatomic, strong) SLDrawNoticeModel *cellModel;

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView;

@end
