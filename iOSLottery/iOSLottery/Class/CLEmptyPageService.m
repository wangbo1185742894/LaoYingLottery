//
//  CLEmptyPageService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLEmptyPageService.h"
#import "CLEmptyView.h"
#import "Masonry.h"
#import "CLAppContext.h"
#import "CLConfigMessage.h"
@interface CLEmptyPageService () <CLEmptyProtocol>

@property (nonatomic, strong) CLEmptyView *noDataEmptyView;//空页面
@property (nonatomic, strong) CLEmptyView *noWebEmptyView;


@end

@implementation CLEmptyPageService
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.emptyBackgroundColor = UIColorFromRGB(0xefefef);
    }
    return self;
}
#pragma mark ------------ emptyView delegate ------------
- (void)clickButtonWithEmpty:(CLEmptyView *)emptyView clickIndex:(NSInteger)index{
    
    if (emptyView == self.noDataEmptyView) {
        if ([self.delegate respondsToSelector:@selector(noDataOnClickWithEmpty:clickIndex:)]) {
            [self.delegate noDataOnClickWithEmpty:emptyView clickIndex:index];
        }
    }
    
    if (emptyView == self.noWebEmptyView) {
        if ([self.delegate respondsToSelector:@selector(noWebOnClickWithEmpty:)]) {
            [self.delegate noWebOnClickWithEmpty:emptyView];
        }
    }
    
}
- (void)showEmptyWithType:(CLEmptyType)emptyType superView:(UIView *)superView{
    
    switch (emptyType) {
        case CLEmptyTypeNormal:{
            [self removeEmptyView];
        }
            break;
        case CLEmptyTypeNoData:{
            [self showNoDataOrNoNetWithSuperView:superView];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark - 无数据 或 无网
- (void)showNoDataOrNoNetWithSuperView:(UIView *)superView{
    
    if ([[CLAppContext context] isReachable]) {
        //有网
        [self showNoDataWithSuperView:superView];
    }else{
        //无网
        [self showNoWebWithSuperView:superView];
    }
}
#pragma mark - 空数据提示图展示
- (void)showNoDataWithSuperView:(UIView *)superView{
    
    //属性赋值
    if (self.noDataEmptyView) {
        [self.noDataEmptyView removeFromSuperview];
        self.noDataEmptyView = nil;
    }
    self.noDataEmptyView = [[CLEmptyView alloc] initWithFrame:CGRectZero];
    self.noDataEmptyView.delegate = self;
    self.noDataEmptyView.butTitleArray = self.butTitleArray;
    self.noDataEmptyView.contentString = self.contentString;
    self.noDataEmptyView.detailContentString = self.detailContentString;
    self.noDataEmptyView.emptyImageName = self.emptyImageName;
    //将视图添加到指定View
    if (superView) {
        [self.noWebEmptyView removeFromSuperview];
        [superView addSubview:self.noDataEmptyView];
        [superView bringSubviewToFront:self.noDataEmptyView];
        
        [self.noDataEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.width.height.equalTo(superView);
        }];
    }
}
- (void)showNoWebWithSuperView:(UIView *)superView{
    
    //属性赋值
    if (self.noWebEmptyView) {
        [self.noWebEmptyView removeFromSuperview];
        self.noWebEmptyView = nil;
    }
    self.noWebEmptyView = [[CLEmptyView alloc] initWithFrame:CGRectZero];
    self.noWebEmptyView.delegate = self;
    self.noWebEmptyView.butTitleArray = @[@"重新加载"];
    self.noWebEmptyView.contentString = @"网络异常，请重试";
    self.noWebEmptyView.detailContentString = @"请检查您的网络设置";
    self.noWebEmptyView.emptyImageName = @"empty_loadFail.png";
    //将视图添加到指定View
    if (superView) {
        
        [self.noDataEmptyView removeFromSuperview];
        [superView addSubview:self.noWebEmptyView];
        [superView bringSubviewToFront:self.noWebEmptyView];
        
        [self.noWebEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.width.height.equalTo(superView);
        }];
    }
}
#pragma mark - 移除空页面视图
- (void)removeEmptyView{
    
    [self.noDataEmptyView removeFromSuperview];
    [self.noWebEmptyView removeFromSuperview];
}

#pragma mark ------------ setter Mothed ------------
- (void)setButTitleArray:(NSArray *)butTitleArray{
    
    _butTitleArray = butTitleArray;
    self.noDataEmptyView.butTitleArray = butTitleArray;
}
-(void)setContentString:(NSString *)contentString{
    
    _contentString = contentString;
    self.noDataEmptyView.contentString = contentString;
}
- (void)setEmptyImageName:(NSString *)emptyImageName{
    
    _emptyImageName = emptyImageName;
    self.noDataEmptyView.emptyImageName = emptyImageName;
}
- (void)setDetailContentString:(NSString *)detailContentString{
    
    _detailContentString = detailContentString;
    self.noDataEmptyView.detailContentString = detailContentString;
}
- (void)setEmptyBackgroundColor:(UIColor *)emptyBackgroundColor{
    
    _emptyBackgroundColor = emptyBackgroundColor;
    self.noWebEmptyView.backgroundColor = _emptyBackgroundColor;
    self.noDataEmptyView.backgroundColor = _emptyBackgroundColor;
}
@end
