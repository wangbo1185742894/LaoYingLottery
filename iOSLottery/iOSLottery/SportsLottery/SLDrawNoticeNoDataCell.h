//
//  SLDrawNoticeNoDataCell.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CreateDrawNoticeDelegate.h"

@class SLDrawNoticeModel;

@interface SLDrawNoticeNoDataCell : UITableViewCell<CreateDrawNoticeDelegate>

@property (nonatomic, strong) SLDrawNoticeModel *cellModel;

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView;

@end
