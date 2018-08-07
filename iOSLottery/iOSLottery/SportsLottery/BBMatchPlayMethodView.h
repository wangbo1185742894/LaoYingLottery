//
//  BBMatchPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBMatchModel,BBSeletedGameModel;

@interface BBMatchPlayMethodView : UIView

@property (nonatomic, strong) BBMatchModel *playMethodModel;

@property (nonatomic, strong) BBSeletedGameModel *selectedModel;

@property (nonatomic, copy) void(^reloadUIBlock)();

@end
