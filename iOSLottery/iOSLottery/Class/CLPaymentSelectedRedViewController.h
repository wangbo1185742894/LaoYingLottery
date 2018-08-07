//
//  CLPaymentSelectedRedViewController.h
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//  正常投注选择红包页面

#import "CLBaseViewController.h"

@interface CLPaymentSelectedRedViewController : CLBaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) void(^selectedBlock)(id model);

- (void)updataRedViewWithDataSource:(NSMutableArray *)dataSource;

@end
