//
//  SLEmptyPageView.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLEmptyPageView;

@protocol SLEmptyProtocol <NSObject>

- (void)sl_clickButtonWithEmpty:(SLEmptyPageView *)emptyView clickIndex:(NSInteger)index;

@end

@interface SLEmptyPageView : UIView

@property (nonatomic, weak) id<SLEmptyProtocol> delegate;
@property (nonatomic, strong) NSString    *emptyImageName;//图片名
@property (nonatomic, strong) NSString    *contentString;//提示文字
@property (nonatomic, strong) NSString    *detailContentString;//副标题提示文字
@property (nonatomic, strong) NSArray     *butTitleArray;//底部按钮的title 数组

@end

@interface SLEmptyViewTopView : UIView

@property (nonatomic, strong) NSString    *emptyImageName;//图片名
@property (nonatomic, strong) NSString    *contentString;//提示文字
@property (nonatomic, strong) NSString    *detailContentString;//提示文字

@end
