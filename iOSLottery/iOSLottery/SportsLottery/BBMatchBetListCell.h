//
//  BBMatchBetListCell.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/4.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球投注 cell

#import <UIKit/UIKit.h>

@class BBMatchModel,BBSeletedGameModel;

typedef void(^BBMatchCellBlock)();

@interface BBMatchBetListCell : UITableViewCell

@property (nonatomic, copy) void(^showHistoryBlock)();

@property (nonatomic, copy) void(^reloadButtomViewBlock)();

@property (nonatomic, copy) void(^historyClickBlock)(NSString *);

@property (nonatomic, strong) BBMatchModel *matchModel;

@property (nonatomic, strong) BBSeletedGameModel *seletedModel;

+ (instancetype)createMatchBetListCellWithTableView:(UITableView *)tableView;


@end
