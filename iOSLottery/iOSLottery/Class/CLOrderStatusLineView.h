//
//  CLOrderStatusLineView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLOrderStatusViewModel;


@interface CLOrderStatusLineView : UIView

@property (nonatomic, strong) NSArray <CLOrderStatusViewModel*> *lineParams;

@property (nonatomic, strong) NSArray <CLOrderStatusViewModel*> *dotParams;

@end
