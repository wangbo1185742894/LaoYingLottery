//
//  CLDiceAnimation.h
//  animationKuaiSan
//
//  Created by huangyuchen on 2016/11/4.
//  Copyright © 2016年 caiqr. All rights reserved.
//

/*
 *  摇骰子动画 
    协议： 当动画停止调用
    入参： 1.每个骰子动画结束的点 数组 (数组中：CGPoint的value值)
          2.每个骰子摇完后的点数 数组（数组中：string类型的值）
 */
#import <UIKit/UIKit.h>

@protocol CLDiceAnimationProtocol <NSObject>

- (void)diceAnimationDidStop;

@end
@interface CLDiceAnimationView : UIView

@property (nonatomic, weak) id<CLDiceAnimationProtocol> delegate;
@property (nonatomic, strong) NSMutableArray <NSValue *>*diceFinishPointArray;//骰子结束点
@property (nonatomic, strong) NSMutableArray <NSString *>*diceNumberArray;//每个骰子点数

- (void)startShakeDiceAnimation;

@end
