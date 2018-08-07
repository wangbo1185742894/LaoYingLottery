//
//  CLOrderListSegmentControl.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLOrderListSegmentControlDelegate <NSObject>

- (void)segmentControlSelectChange:(NSInteger)selectedIndex;

@end

@interface CLOrderListSegmentControl : UIView

@property (nonatomic) NSInteger selectedIndex;

/**
 是否有竖线分隔  该属性必须加在 items 之前
 */
@property (nonatomic, assign) BOOL has_VerticalLine;//

@property (nonatomic, weak) id<CLOrderListSegmentControlDelegate> delegate;

- (void)setItems:(NSArray*)items;


@end
