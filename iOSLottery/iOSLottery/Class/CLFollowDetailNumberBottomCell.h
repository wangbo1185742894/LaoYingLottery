//
//  CLFollowDetailNumberBottomCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLFollowDetailNumberBottomCell : UITableViewCell

@property (nonatomic, assign) BOOL isEmpty;//标志是否是空白View

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *contentImageView;

@property (nonatomic, copy) void(^cellEventTouchUp)();

@end
