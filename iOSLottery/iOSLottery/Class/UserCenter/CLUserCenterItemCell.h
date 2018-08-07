//
//  CLUserCenterItemCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLUserCenterItem;

@interface CLUserCenterItemCell : UITableViewCell

@property (nonatomic, strong) UILabel* textLbl;
@property (nonatomic, strong) UIImageView* iconImgView;
@property (nonatomic, assign) BOOL has_bottomLine;
@property (nonatomic, strong) CLUserCenterItem *item;

+ (CLUserCenterItemCell *)userCenterItemCreateWithTableView:(UITableView *)tableView;

@end
