//
//  CQBetODHeaderProcessSubView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SLBetODHeaderProcessSubView.h"

#import "SLConfigMessage.h"

#import "SLBODAllModel.h"

#define LabelWH (26) //图片的宽高

@interface SLBetODHeaderProcessSubView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CALayer *picLayer;

@end

@implementation SLBetODHeaderProcessSubView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        [self.layer addSublayer:self.picLayer];
    }
    return self;
}
#pragma mark - 配置view
- (void)assignBetODHeaderSubViewWithData:(id)data{
    
    SLBODHeaderSubProcessModel *model = data;

    if ([NSStringFromValidData(model.number) isEqualToString:@"Y"]) {
        //则显示对号图片
        self.picLayer.contents = (id)[UIImage imageNamed:@"order_ progress_finish"].CGImage;
        if ([NSStringFromValidData(model.status) isEqualToString:@"R"]) {
            //高亮颜色
            self.titleLabel.textColor = SL_UIColorFromRGB(0xFC5548);
        }else{
            //灰暗颜色
            self.titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        }
    }else if ([NSStringFromValidData(model.number) isEqualToString:@"X"]){
        //显示差号图片
        self.picLayer.contents = (id)[UIImage imageNamed:@"order_progress_fail"].CGImage;
        if ([NSStringFromValidData(model.status) isEqualToString:@"R"]) {
            //高亮颜色
            self.titleLabel.textColor = SL_UIColorFromRGB(0xFC5548);
        }else{
            //灰暗颜色
            self.titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        }
    }else{
        //显示数字
        if ([NSStringFromValidData(model.status) isEqualToString:@"R"]) {
            //高亮颜色
            NSString *numberStr = [NSString stringWithFormat:@"order_statu_%@_yes",model.number];
            self.picLayer.contents = (id)[UIImage imageNamed:numberStr].CGImage;
            self.titleLabel.textColor = SL_UIColorFromRGB(0xFC5548);
        }else{
            //灰暗颜色
            NSString *numberStr = [NSString stringWithFormat:@"order_statu_%@_no",model.number];
            self.picLayer.contents = (id)[UIImage imageNamed:numberStr].CGImage;
            self.titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        }
    }
    self.titleLabel.text = model.title;
}

#pragma mark - getterMothed
- (CALayer *)picLayer{
    if (!_picLayer) {
        _picLayer = [[CALayer alloc] init];
        _picLayer.bounds = SL__Rect(0, 0, 30, 30);
        _picLayer.position = CGPointMake(CGRectGetWidth(self.frame) / 2, (CGRectGetHeight(self.bounds) - SL__SCALE(LabelWH)) / 2);
        
        _picLayer.contentsScale = [UIScreen mainScreen].scale;
//        
//        _picLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.5, 0.5);
//        
//        _picLayer.contentsGravity = kCAGravityResize;
    }
    return _picLayer;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:SL__Rect(0, CGRectGetMaxY(self.picLayer.frame), CGRectGetWidth(self.frame), SL__SCALE(20))];
        
        _titleLabel.text = @"";
        _titleLabel.font = SL_FONT_SCALE(14.f);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = SL_UIColorFromRGB(0x666666);
    }
    return _titleLabel;
}
//获取流程圆圈的中点，确保流程横线的位置
- (CGFloat)getLayerY{
    return self.picLayer.position.y;
}

@end
