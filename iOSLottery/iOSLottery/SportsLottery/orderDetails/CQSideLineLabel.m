//
//  CQSideLineLabel.m
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQSideLineLabel.h"
#import "CQDefinition.h"

#import "SLConfigMessage.h"

@interface CQSideLineLabel ()

@property (nonatomic, strong) CALayer *leftLayer;
@property (nonatomic, strong) CALayer *rightLayer;

@end

@implementation CQSideLineLabel

- (void)setLabelSideLineType:(CQLabelSideLineType)labelSideLineType{
    
    if (labelSideLineType == CQLabelSideLineTypeNone) {
        //无边线
        [self createNoneSideLine];
    }
    if (labelSideLineType == CQLabelSideLineTypeOnlyLeft) {
        //只创建左边线
        [self createOnlyLeftLine];
    }
    if (labelSideLineType == CQLabelSideLineTypeOnlyRight) {
        //只创建右边线
        [self createOnlyRightLine];
    }
    if (labelSideLineType == CQLabelSideLineTypeLeftRight) {
        //创建左右边线
        [self createLeftRightLine];
    }
}
#pragma mark - setterMothed
//重写setFrame方法，更新子view的方法
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _leftLayer.frame = CGRectMake(0, 0, 0.5f, CGRectGetHeight(self.bounds));
    
    _rightLayer.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 0.5f, 0, 0.5f, CGRectGetHeight(self.bounds));
}
- (void)setText:(NSString *)text{
    [super setText:text];
    //设置text的时候重设一遍行间距
    if (self.cqLineSpacing > 0) {
        [self installLineSpacingWithSpacing:self.cqLineSpacing];
    }
}
//设置行间距
- (void)setLineSpacing:(CGFloat)lineSpacing{
    _cqLineSpacing = lineSpacing;
    if (_cqLineSpacing > 0) {
        [self installLineSpacingWithSpacing:_cqLineSpacing];
    }
}

#pragma mark - 设置行间距方法
- (void)installLineSpacingWithSpacing:(CGFloat)lineSpacing{
    
    NSString *text = self.text;
    if (!(text && text.length > 0)) return;
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:lineSpacing];
    //判断内容长度是否大于Label内容宽度，如果不大于，则设置内容宽度为行宽（内容如果小于行宽，Label长度太短，如果Label有背景颜色，将影响布局效果）
    NSInteger leng = self.bounds.size.width;
    if (attStr.length < self.bounds.size.width) {
        leng = attStr.length;
    }
    //根据给定长度与style设置attStr式样
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    //Label获取attStr式样
    self.attributedText = attStr;
}

#pragma mark - 无边线
- (void)createNoneSideLine{
    //移除无用layer
    [self.rightLayer removeFromSuperlayer];
    [self.leftLayer removeFromSuperlayer];
}

#pragma mark - 只创建左边线
- (void)createOnlyLeftLine{
    //移除无用layer
    [self.rightLayer removeFromSuperlayer];
    //添加左layer
    [self.layer addSublayer:self.leftLayer];
    
}
#pragma mark - 只创建右边线
- (void)createOnlyRightLine{
    //移除无用layer
    [self.leftLayer removeFromSuperlayer];
    //添加左layer
    [self.layer addSublayer:self.rightLayer];
}
#pragma mark - 创建左右边线
- (void)createLeftRightLine{
    [self.layer addSublayer:self.leftLayer];
    [self.layer addSublayer:self.rightLayer];
}
#pragma mark - getterMothed
- (CALayer *)leftLayer{
    if (!_leftLayer) {
        _leftLayer = [[CALayer alloc] init];
        _leftLayer.frame = CGRectMake(0, 0, 0.5f, CGRectGetHeight(self.bounds));
        _leftLayer.backgroundColor = SL_SEPARATORCOLOR.CGColor;
    }
    return _leftLayer;
}
- (CALayer *)rightLayer{
    if (!_rightLayer) {
        _rightLayer = [[CALayer alloc] init];
        _rightLayer.frame = CGRectMake(CGRectGetMaxX(self.bounds) - 0.5f, 0, 0.5f, CGRectGetHeight(self.bounds));
        _rightLayer.backgroundColor = SL_SEPARATORCOLOR.CGColor;
    }
    return _rightLayer;
}



@end
