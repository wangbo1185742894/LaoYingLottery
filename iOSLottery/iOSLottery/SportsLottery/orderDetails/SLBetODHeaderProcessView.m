//
//  CQBetODHeaderProcessView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetODHeaderProcessView.h"
#import "SLBODAllModel.h"
#import "CQDefinition.h"

#import "SLConfigMessage.h"

#import "CQViewQuickAllocDef.h"
#import "SLBetODHeaderProcessSubView.h"
@interface SLBetODHeaderProcessView ()

@property (nonatomic, strong) SLBODHeaderProcessModel *mainProcessModel;
@property (nonatomic, strong) NSMutableArray *layerArray;


@end

@implementation SLBetODHeaderProcessView
#pragma mark - 配置相关数据
- (void)assignHeaderProcessWithData:(id)data{
    //配置数据源
    self.mainProcessModel = data;
    
    //移除原有子视图  防止 视图重复添加，造成叠加
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //移除原有子layer
    if (self.layerArray.count > 0) {
        
        [self.layerArray makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        
        [self.layerArray removeAllObjects];
    }
    [self createProcedureViewData];
    
}
#pragma mark - 配置流程图数据
- (void)createProcedureViewData{
    //创建流程图横线
    /**
     *  说明   横线layer必须得先绘制 ，后添加子View ，但必须先获取子View的中点位置
     */
    CGFloat layerY = 0;//记录layer的位置
    SLBetODHeaderProcessSubView *processSubView = [[SLBetODHeaderProcessSubView alloc] initWithFrame:__Rect(0, 0, 100, self.frame.size.height)];
    if (self.mainProcessModel.subProcessArr.count > 0) {
        [processSubView assignBetODHeaderSubViewWithData:self.mainProcessModel.subProcessArr[0]];
    }
    layerY = processSubView.getLayerY;////到此只为了先获取横线的y值
    //创建横线
    [self createWithdrawDetailProcedureLineWithData:self.mainProcessModel.lineStatusArr positionY:layerY];
    
    //创建ProcessSubView
    [self createSubProcessView];

}
#pragma mark - 创建流程图的横线
- (void)createWithdrawDetailProcedureLineWithData:(NSArray *)lineStatusArr  positionY:(CGFloat)layerY{
    //每一段蓝灰线的宽度
    NSInteger oneLineWidth = CGRectGetWidth(self.bounds) / (lineStatusArr.count + 1);
    for (NSInteger i = 0; i < lineStatusArr.count; i++) {
        //动弹创建每一段layer
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = __Rect(0, 0, oneLineWidth, __SCALE(3));
        layer.position = CGPointMake(oneLineWidth * (i + 1), layerY);
        if ([lineStatusArr[i] isEqualToString:@"1"]) {
            //layer.contents = (id)[UIImage imageNamed:@"finishBlue.png"].CGImage;
            layer.backgroundColor = SL_REDCOLOR.CGColor;
        }else if ([lineStatusArr[i] isEqualToString:@"0"]){
            //layer.contents = (id)[UIImage imageNamed:@"unfinished.png"].CGImage;
            layer.backgroundColor = SL_GRAYCOLOR.CGColor;
        }
        [self.layer addSublayer:layer];
        [self.layerArray addObject:layer];
    }
}
#pragma mark - 添加流程的子View
- (void)createSubProcessView{
    CGFloat width = CGRectGetWidth(self.bounds) / self.mainProcessModel.subProcessArr.count;
    for (NSInteger i = 0; i < self.mainProcessModel.subProcessArr.count; i++) {
        SLBetODHeaderProcessSubView *processSubView = [[SLBetODHeaderProcessSubView alloc] initWithFrame:__Rect(i * width , 0, width, self.frame.size.height)];
        [processSubView assignBetODHeaderSubViewWithData:self.mainProcessModel.subProcessArr[i]];
        [self addSubview:processSubView];
    }
}

#pragma mark - getterMothed
- (NSMutableArray *)layerArray{
    if (!_layerArray) {
        _layerArray = [NSMutableArray array];
    }
    return _layerArray;
}
@end
