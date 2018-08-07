//
//  BBMatchNewPlayMethodView.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBPlayMethodModel;

@interface BBMatchNewPlayMethodView : UIView

@property (nonatomic, strong) BBPlayMethodModel *playMethodModel;

@property (nonatomic, strong) NSArray *selectedArray;

@property (nonatomic, copy) void(^reloadUIBlock)();

@end
