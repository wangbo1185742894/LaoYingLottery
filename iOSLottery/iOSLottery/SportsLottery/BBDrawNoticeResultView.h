//
//  BBDrawNoticeResultView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBDrawNoticeResultView : UIView

- (void)setDataWithArray:(NSArray *)dataArray isCancel:(NSInteger)isCancel;

@end

@interface BBDrawNoticeResultItem : UIView

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
