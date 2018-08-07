//
//  CLFastThreeViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLFastThreeViewController : CLBaseViewController

@property (nonatomic, strong) NSString *lotteryGameEn;


/**
 从投注详情 点击了投注号 跳转过来

 @param initial    源控制器
 @param index      选中位置
 @param isSelect   是否是选中投注号跳转
 @param gameEn     gameEn
 @param completion 回调
 */
+ (void)presentFastThreeViewControllerWithInitialVC:(UIViewController *__weak)initial selectedIndex:(NSInteger)index isSelectBetInfo:(BOOL)isSelect gameEn:(NSString *)gameEn completion:(void (^)(void))completion;
@end
