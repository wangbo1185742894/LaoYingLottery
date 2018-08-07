//
//  CLArrangeFiveViewController.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLArrangeFiveViewController : CLBaseViewController

@property (nonatomic, strong) NSString *LotteryGameEn;

+ (void)presentFastThreeViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^)(void))completion;

@end
