//
//  BBSFPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBSelectPlayMethodInfo,BBMatchModel;

@interface BBSFPlayMethodView : UIView

@property (nonatomic, strong) BBSelectPlayMethodInfo *sfInfo;

@property (nonatomic, strong) BBMatchModel *matchModel;

@end
