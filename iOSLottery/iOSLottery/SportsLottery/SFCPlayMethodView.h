//
//  SFCPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBMatchModel,BBSeletedGameModel;

@interface SFCPlayMethodView : UIView

@property (nonatomic, strong) BBMatchModel *matchModel;

@property (nonatomic, strong) BBSeletedGameModel *selectedInfo;

@property (nonatomic, copy) void(^reloadUIBlock)();

- (void)show;

@end
