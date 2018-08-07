//
//  CQDoubleView.m
//  caiqr
//
//  Created by huangyuchen on 16/7/23.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQDoubleView.h"
#import "CQDefinition.h"
@interface CQDoubleView ()

@property (nonatomic, strong) UIView *leftMainView;
@property (nonatomic, strong) UIView *rightMainView;

@end

@implementation CQDoubleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftRightDistance = 0;
        [self addSubview:self.leftMainView];
        [self addSubview:self.rightMainView];
        [self.leftMainView addSubview:self.leftLabel];
        [self.rightMainView addSubview:self.rightLabel];
    }
    return self;
}
#pragma mark - 重写setFrame方法  更新子View的frame
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.leftMainView.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
    self.leftLabel.frame = self.leftMainView.bounds;
    self.rightMainView.frame = CGRectMake(CGRectGetMaxX(self.leftMainView.bounds) + self.leftRightDistance, 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.leftMainView.bounds) - self.leftRightDistance - __SCALE(10), CGRectGetHeight(self.bounds));
    self.rightLabel.frame = self.rightMainView.bounds;
}
#pragma mark - setterMothed
//设置左侧label的text
- (void)setLeftLabelTitle:(NSString *)leftLabelTitle{
    
    _leftLabelTitle = leftLabelTitle;
    
    if (_leftLabelTitle && _leftLabelTitle.length > 0) {
        self.leftLabel.text = _leftLabelTitle;
    }else{
        self.leftLabel.text = @"";
    }
    self.leftMainView.frame = CGRectMake(0, 0, 80, self.bounds.size.height);
    //self.leftMainView.backgroundColor = [UIColor redColor];
    self.leftLabel.frame = self.leftMainView.bounds;
    
    [self.leftSubView removeFromSuperview];
    [self.leftMainView addSubview:self.leftLabel];
}
//设置左侧label的font
- (void)setLeftFont:(UIFont *)leftFont{
    _leftFont = leftFont;
    self.leftLabel.font = _leftFont;
}
//设置左侧label的textColor
- (void)setLeftTextColor:(UIColor *)leftTextColor{
    _leftTextColor = leftTextColor;
    self.leftLabel.textColor = _leftTextColor;
}
//设置左侧label的textAligment
- (void)setLeftTextAlignment:(NSTextAlignment)leftTextAlignment{
    _leftTextAlignment = leftTextAlignment;
    self.leftLabel.textAlignment = _leftTextAlignment;
}
//设置左侧label的行间距
- (void)setLeftLineSpacing:(CGFloat)leftLineSpacing{
    _leftLineSpacing = leftLineSpacing;
    self.leftLabel.labelLineSpacing = _leftLineSpacing;
}
//设置左侧子View
- (void)setLeftSubView:(UIView *)leftSubView{
    _leftSubView = leftSubView;
    if (_leftSubView) {
        [self.leftLabel removeFromSuperview];
        [self.leftMainView addSubview:_leftSubView];
    }
}


//设置右侧label的text
- (void)setRightLabelTitle:(NSString *)rightLabelTitle{
    _rightLabelTitle = rightLabelTitle;
    if (_rightLabelTitle && _rightLabelTitle.length > 0) {
        self.rightLabel.text = _rightLabelTitle;
    }else{
        self.rightLabel.text = @"";
    }
    self.rightMainView.frame = CGRectMake(CGRectGetMaxX(self.leftMainView.bounds) + self.leftRightDistance, 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.leftMainView.bounds) - self.leftRightDistance - __SCALE(10), CGRectGetHeight(self.bounds));
    self.rightLabel.frame = self.rightMainView.bounds;
    [self.rightSubView removeFromSuperview];
    [self.rightMainView addSubview:self.rightLabel];
}
//设置右侧label的font
- (void)setRightFont:(UIFont *)rightFont{
    _rightFont = rightFont;
    self.rightLabel.font = _rightFont;
}
//设置右侧label的textColor
- (void)setRightTextColor:(UIColor *)rightTextColor{
    _rightTextColor = rightTextColor;
    self.rightLabel.textColor = _rightTextColor;
}
//设置右侧label的textAligment
- (void)setRightTextAlignment:(NSTextAlignment)rightTextAlignment{
    _rightTextAlignment = rightTextAlignment;
    self.rightLabel.textAlignment = _rightTextAlignment;
}
//设置右侧label的行间距
- (void)setRightLineSpacing:(CGFloat)rightLineSpacing{
    _rightLineSpacing = rightLineSpacing;
    self.rightLabel.labelLineSpacing = _rightLineSpacing;
}
//设置右侧子View
- (void)setRightSubView:(UIView *)rightSubView{
    _rightSubView = rightSubView;
    if (_rightSubView) {
        [self.rightLabel removeFromSuperview];
        [self.rightMainView addSubview:_rightSubView];
    }
}

#pragma mark - 设置左右间距
- (void)setLeftRightDistance:(CGFloat)leftRightDistance{
    _leftRightDistance = leftRightDistance;
    self.rightMainView.frame = CGRectMake(CGRectGetMaxX(self.leftMainView.frame) + leftRightDistance, 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.leftMainView.frame) - leftRightDistance - __SCALE(10), CGRectGetHeight(self.bounds));
    self.rightLabel.frame = self.rightMainView.bounds;
}


#pragma mark - getterMothed
- (UIView *)leftMainView{
    if (!_leftMainView) {
        _leftMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, self.bounds.size.height)];
        _leftMainView.backgroundColor = [UIColor clearColor];
        _leftMainView.userInteractionEnabled = YES;
    }
    return _leftMainView;
}
- (UIView *)rightMainView{
    if (!_rightMainView) {
        _rightMainView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftMainView.bounds), 0, CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.leftMainView.bounds) - __SCALE(10), CGRectGetHeight(self.bounds))];
        _rightMainView.backgroundColor = [UIColor clearColor];
        _rightMainView.userInteractionEnabled = YES;
    }
    return _rightMainView;
}
- (CQUpDownAligmentLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[CQUpDownAligmentLabel alloc] initWithFrame:self.leftMainView.bounds];
        _leftLabel.numberOfLines = 0;
        _leftLabel.verticalAlignmentType = CQVerticalAlignmentTypeTop;
        _leftLabel.labelLineSpacing = __SCALE(5);
        _leftLabel.horizontalAlignmentType = NSTextAlignmentCenter;

    }
    return _leftLabel;
}
- (CQUpDownAligmentLabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[CQUpDownAligmentLabel alloc] initWithFrame:self.rightMainView.bounds];
        _rightLabel.numberOfLines = 0;
        _rightLabel.labelLineSpacing = __SCALE(5);
        _rightLabel.verticalAlignmentType = CQVerticalAlignmentTypeTop;
        _rightLabel.horizontalAlignmentType = NSTextAlignmentLeft;

    }
    return _rightLabel;
}
@end
