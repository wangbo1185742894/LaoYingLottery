//
//  CQBetODHeaderProcessSubView.h
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//
//投注订单详情页的头部视图中的 流程视图 中的每一部分的子视图

#import <UIKit/UIKit.h>

@interface SLBetODHeaderProcessSubView : UIView
//获取图片layer的中点Y值，确保外面的横线与layer保持一致
@property (nonatomic, readonly) CGFloat getLayerY;

- (void)assignBetODHeaderSubViewWithData:(id)data;
@end
