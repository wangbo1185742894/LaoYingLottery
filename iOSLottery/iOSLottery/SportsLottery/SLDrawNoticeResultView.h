//
//  SLMatchResultView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//  开奖公告 比赛结果 view

#import <UIKit/UIKit.h>

@interface SLDrawNoticeResultView : UIView

- (void)setDataWithArray:(NSArray *)dataArray isCancel:(NSInteger)isCancel;


@end

@interface SLDrawNoticeResultItem : UIView

/**
 玩法名Label
 */
@property (nonatomic, strong) UILabel *playLabel;

/**
 赔率Label
 */
@property (nonatomic, strong) UILabel *oddsLabel;

- (void)setUpItemDataWithString:(NSString *)str;


@end

