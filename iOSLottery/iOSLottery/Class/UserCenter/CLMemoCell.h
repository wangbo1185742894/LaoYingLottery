//
//  CLMemoCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CLMemoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;

- (void) setSuppleEvent:(BOOL(^)())suppleEvent message:(void(^)())message;

@end
