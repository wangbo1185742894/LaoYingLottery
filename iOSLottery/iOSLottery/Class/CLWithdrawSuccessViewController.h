//
//  CLWithdrawSuccessViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLWithdrawSuccessViewController : CLBaseViewController

+ (instancetype)withdrawSuccessWithTitile:(NSString *)titleString
                                         method:(id)obj
                                 definiteAction:(void(^)(void))definiteAction;

@end
