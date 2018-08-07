//
//  BBSFCPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//  篮球全部玩法 胜分差View

#import <UIKit/UIKit.h>

@class BBSelectPlayMethodInfo,BBMatchModel;

@interface BBSFCPlayMethodView : UIView

@property (nonatomic, strong) BBSelectPlayMethodInfo *sfcInfo;

@property (nonatomic, strong) BBMatchModel *matchModel;

@end
