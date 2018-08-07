//
//  SLBetDetailsCellItem.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//  投注列表 cell 中的每一个玩法项

#import <UIKit/UIKit.h>


@class SLBetDetailsItemModel;

@interface SLBetDetailsCellItem : UIView

@property (nonatomic, strong) SLBetDetailsItemModel *itemModel;

@end
