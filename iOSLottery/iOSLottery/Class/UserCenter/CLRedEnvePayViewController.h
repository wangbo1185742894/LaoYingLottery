//
//  CLRedEnvePayViewController.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@class CLBuyRedEnveSelectModel;

@interface CLRedEnvePayViewController : CLBaseViewController

@property (nonatomic, strong) NSArray* payChannelArrays;
@property (nonatomic, strong) CLBuyRedEnveSelectModel* userSelectModel;

@end
