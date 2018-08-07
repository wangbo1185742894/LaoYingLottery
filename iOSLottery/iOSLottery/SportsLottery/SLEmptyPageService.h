//
//  SLEmptyPageService.h
//  SportsLottery
//
//  Created by huangyuchen on 2017/6/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SLEmptyPageView;
typedef NS_ENUM(NSInteger , SLEmptyType) {
    
    SLEmptyTypeHasData = 0,//有数据 即移除该视图
    SLEmptyTypeNoData, //无数据  即添加该视图
};

@protocol SLEmptyPageServiceDelegate <NSObject>

/**
 点击了按钮
 
 @param emptyView 空页面
 @param index     点击按钮index
 */
- (void)sl_noDataOnClickWithEmpty:(SLEmptyPageView *)emptyView clickIndex:(NSInteger)index;

/**
 点击了无网按钮
 
 @param emptyView emptyView
 */
- (void)sl_noWebOnClickWithEmpty:(SLEmptyPageView *)emptyView;

@end


@interface SLEmptyPageService : NSObject

@property (nonatomic, weak) id<SLEmptyPageServiceDelegate> delegate;
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
- (void)sl_showEmptyWithType:(SLEmptyType)emptyType superView:(UIView *)superView;

/**
 显示无网络页面
 */
- (void)sl_showNoWebWithSuperView:(UIView *)superView;

- (void)sl_removeEmptyView;


@end
