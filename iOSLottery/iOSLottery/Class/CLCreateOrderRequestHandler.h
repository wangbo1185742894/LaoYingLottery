//
//  CLCreateOrderRequestHandler.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/20.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CLCreateOrderDelegate <NSObject>

- (void)requestFinishWithOrderInfo:(id)OrderInfo;
- (void)requestFailWithOrderInfo:(id)OrderInfo;

@end
@interface CLCreateOrderRequestHandler : NSObject

@property (nonatomic, weak) id<CLCreateOrderDelegate> delegate;

- (void)createOrderRequestWithType:(NSString *)lotteryGameEn;

@end
