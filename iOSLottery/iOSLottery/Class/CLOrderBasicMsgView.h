//
//  CLOrderBasicMsgView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLOrderBasicCashViewModel.h"

@protocol CLOrderBasicMsgViewDelegate <NSObject>

- (void) orderBasicMsgEvent;

@end

@interface CLOrderBasicMsgView : UIView

@property (nonatomic, assign) NSInteger saleTime;
@property (nonatomic, strong) NSArray* basicMsgArray;
@property (nonatomic, weak) id<CLOrderBasicMsgViewDelegate> delegate;

@end




@interface CLOrderBasicCashView : UIView

@property (nonatomic, assign) NSInteger saleTime;

- (void)setUpCashMessage:(CLOrderBasicCashViewModel*)msg;

- (void) addTarget:(id)target sel:(SEL)sel;

@end
