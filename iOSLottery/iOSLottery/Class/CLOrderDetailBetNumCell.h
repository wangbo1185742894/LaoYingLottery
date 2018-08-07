//
//  CLOrderDetailBetNumCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLOrderDetailBetNumModel;

@interface CLOrderDetailBetNumCell : UITableViewCell

- (void)configureData:(CLOrderDetailBetNumModel*)data;

@property (nonatomic) BOOL isTop;

@property (nonatomic, strong) UILabel* nameLbl;
@property (nonatomic, strong) UILabel* numLbl;

@end
