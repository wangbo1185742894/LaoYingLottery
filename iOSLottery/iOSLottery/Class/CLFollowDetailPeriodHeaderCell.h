//
//  CLFollowDetailPeriodHeaderCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLFollowDetailPeriodHeaderCell : UITableViewCell

@property (nonatomic, strong) UILabel* followPeriodLbl;
@property (nonatomic, strong) UIButton* refundBtn;

- (void) configurePeroidData:(id)data;

@end