//
//  SLOddsButton.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
// 展开全部赔率列表 的按钮

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLOddsButtonType) {
    
    SLOddsButtonTypeHorizontal = 0, //横向
    SLOddsButtonTypeVertical //竖向
};

@interface SLOddsButton : UIButton

@property (nonatomic, strong) UILabel *playMothedLabel;//老鹰
@property (nonatomic, strong) UILabel *oddsLabel;
@property (nonatomic, assign) BOOL showLeftLine;
@property (nonatomic, assign) BOOL showRightLine;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;


- (instancetype)initWithType:(SLOddsButtonType)type;


@end
