//
//  CLEmptyView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLEmptyView;
@class CLEmptyButton;
@class EmptyViewTopView;

@protocol CLEmptyProtocol <NSObject>

- (void)clickButtonWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index;

@end

@interface CLEmptyView : UIView

@property (nonatomic, weak) id<CLEmptyProtocol> delegate;
@property (nonatomic, strong) NSString    *emptyImageName;//图片名
@property (nonatomic, strong) NSString    *contentString;//提示文字
@property (nonatomic, strong) NSString    *detailContentString;//副标题提示文字
@property (nonatomic, strong) NSArray     *butTitleArray;//底部按钮的title 数组


@end


@interface EmptyViewTopView : UIView

@property (nonatomic, strong) NSString    *emptyImageName;//图片名
@property (nonatomic, strong) NSString    *contentString;//提示文字
@property (nonatomic, strong) NSString    *detailContentString;//提示文字

@end
