//
//  SLMatchsSelectCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLMatchSelectModel,BBLeagueModel;

@interface SLMatchsSelectCell : UICollectionViewCell

@property (nonatomic, strong) SLMatchSelectModel *selectModel;

@property (nonatomic, strong) BBLeagueModel *selectedBasModel;

@end
