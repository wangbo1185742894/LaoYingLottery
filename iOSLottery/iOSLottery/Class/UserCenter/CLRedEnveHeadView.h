//
//  CLRedEnveHeadView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLRedEnveHeadViewDelegate <NSObject>

- (void) switchREIndex:(NSInteger) selectIdx;

@end

@interface CLRedEnveHeadView : UIView

@property (weak, nonatomic) id<CLRedEnveHeadViewDelegate> delegate;

@property (nonatomic) NSInteger selectIdx;

- (void)assignData:(id)obj;

@end
