//
//  CLEmptyPageService.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class CLEmptyView;

typedef NS_ENUM(NSInteger , CLEmptyType) {
    
    CLEmptyTypeNormal = 0,
    CLEmptyTypeNoData,
};

@protocol CLEmptyPageServiceDelegate <NSObject>

/**
 点击了按钮

 @param emptyView 空页面
 @param index     点击按钮index
 */
- (void)noDataOnClickWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index;

/**
 点击了无网按钮

 @param emptyView emptyView
 */
- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView;
@end

@interface CLEmptyPageService : NSObject

@property (nonatomic, weak) id<CLEmptyPageServiceDelegate> delegate;

/**
 * 空数据页面的数据配置
 */
@property (nonatomic, strong) UIColor *emptyBackgroundColor;//背景颜色
@property (nonatomic, strong) NSArray *butTitleArray;//按钮title 有几个就放几个按钮
@property (nonatomic, strong) NSString *contentString;//描述文字
@property (nonatomic, strong) NSString *detailContentString;//副标题
@property (nonatomic, strong) NSString *emptyImageName;//图片


/**
 是否无数据

 @param emptyType    无数据类型
 @param superView 父视图
 */
- (void)showEmptyWithType:(CLEmptyType)emptyType superView:(UIView *)superView;

/**
 在superView上展示无数据样式

 @param superView superView
 */
- (void)showNoDataWithSuperView:(UIView *)superView;

/**
 在superView上展示无网络样式

 @param superView superView
 */
- (void)showNoWebWithSuperView:(UIView *)superView;
/**
 移除
 */
- (void)removeEmptyView;

@end
