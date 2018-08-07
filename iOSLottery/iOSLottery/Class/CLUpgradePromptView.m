//
//  CLUpgradePromptView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLUpgradePromptView.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLUpgradeModel.h"
#import "NSString+CLExpandString.h"
#import "CQmyproxy.h"
#pragma mark - 更新提示的View
@interface CLUpgradePromptView ()

@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) CALayer *findNewVersionLayer;
@property (nonatomic, strong) UILabel *updatePromptLabel;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UIScrollView *promptScrollView;

@end
@implementation CLUpgradePromptView
#pragma mark - 重载系统方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBandAlpha(0x000000, 0.75);
        [self addSubview:self.baseView];
        [self.baseView.layer addSublayer:self.findNewVersionLayer];
        [self.baseView addSubview:self.promptScrollView];
        [self.promptScrollView addSubview:self.updatePromptLabel];
        [self.baseView addSubview:self.updateButton];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark - event Response
//立即升级点击事件
- (void)updateButtonOnClick:(UIButton *)btn{
    
    !self.updateBlock ? : self.updateBlock();
    [self closeSelf];
}
//tap点击事件
- (void)tapOnClick:(UITapGestureRecognizer *)tap{
    //响应为空，为了防止点击本View的时候 移除弹窗
    [self closeSelf];
}
- (void)closeSelf{
    
    [self removeFromSuperview];
//    [[CQmyproxy dealerProxy] alterClosed:@"UIView"];
}
#pragma mark - private Mothed
//计算文字高度
- (void)updateFrameWithHeight:(CGFloat)labelHeight{
    self.updatePromptLabel.frame = __Rect(__SCALE(10.f), 0, CGRectGetWidth(self.promptScrollView.frame) - __SCALE(10.f) * 2, labelHeight);
    self.promptScrollView.contentSize = self.updatePromptLabel.frame.size;
    self.updateButton.frame = __Rect((CGRectGetWidth(self.baseView.frame) - __SCALE(179.f)) / 2,CGRectGetMaxY(self.promptScrollView.frame) + __SCALE(15.f), __SCALE(179.f), __SCALE(32.f));
    //记录 self的原中心点
    CGPoint centerPoint = self.baseView.center;
    self.baseView.frame = __Rect(0, 0, CGRectGetWidth(self.baseView.frame), CGRectGetMaxY(self.updateButton.frame) + __SCALE(10.f));
    self.baseView.center = centerPoint;
}

#pragma mark - setterMothed
- (void)setUpdatePromptText:(NSString *)updatePromptText{
    //    _updatePromptText = updatePromptText;
    _updatePromptText = [updatePromptText stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    //富文本
    AttributedTextParams *params = [[AttributedTextParams alloc] init];
    params.font = FONT_SCALE(14.f);
    params.cqTextAligment = NSTextAlignmentLeft;
    params.lineSpacing = __SCALE(4.f);
    params.range = NSMakeRange(0, _updatePromptText.length);
    [self.updatePromptLabel attributeWithText:_updatePromptText controParams:@[params]];
    //计算文字高度
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = __SCALE(4.f);
    CGSize size = [_updatePromptText boundingRectFontOptionWithSize:CGSizeMake(CGRectGetWidth(self.updatePromptLabel.frame), MAXFLOAT) Font:FONT_SCALE(14.f) Paragraph:paragraph].size;
    //更新所有控件frame
    [self updateFrameWithHeight:size.height];
    
}

#pragma mark - getterMothed
- (UIView *)baseView{
    
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:__Rect(0, 0, __SCALE(203.f), __SCALE(235.f))];
        _baseView.backgroundColor = UIColorFromRGB(0xffffff);
        _baseView.center = self.center;
        _baseView.layer.cornerRadius = 2.f;
        _baseView.layer.masksToBounds = YES;
    }
    return _baseView;
}
- (CALayer *)findNewVersionLayer{
    if (!_findNewVersionLayer) {
        _findNewVersionLayer = [[CALayer alloc] init];
        _findNewVersionLayer.frame = __Rect(0, 0, CGRectGetWidth(self.baseView.frame), __SCALE(66.f));
        //        _findNewVersionLayer.cornerRadius = 2.f;
        _findNewVersionLayer.contents = (id)[UIImage imageNamed:@"VersionUpdatePrompt.png"].CGImage;
    }
    return _findNewVersionLayer;
}
- (UIScrollView *)promptScrollView{
    if (!_promptScrollView) {
        _promptScrollView = [[UIScrollView alloc] initWithFrame:__Rect(0, CGRectGetMaxY(self.findNewVersionLayer.frame) + __SCALE(15.f), CGRectGetWidth(self.baseView.frame), __SCALE(97.f))];
        _promptScrollView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _promptScrollView;
}
- (UILabel *)updatePromptLabel{
    if (!_updatePromptLabel) {
        _updatePromptLabel = [[UILabel alloc] initWithFrame:self.promptScrollView.bounds];
        _updatePromptLabel.textAlignment = NSTextAlignmentLeft;
        _updatePromptLabel.font = FONT_SCALE(14.f);
        _updatePromptLabel.numberOfLines = 0;
        _updatePromptLabel.textColor = UIColorFromRGB(0x555555);
    }
    return _updatePromptLabel;
}
- (UIButton *)updateButton{
    if (!_updateButton) {
        _updateButton = [[UIButton alloc] initWithFrame:__Rect((CGRectGetWidth(self.baseView.frame) - __SCALE(179.f)) / 2,CGRectGetMaxY(self.promptScrollView.frame) + __SCALE(15.f), __SCALE(179.f), __SCALE(32.f))];
        [_updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
        [_updateButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _updateButton.layer.cornerRadius = 2.f;
        [_updateButton setBackgroundColor:UIColorFromRGB(0x54a0ff)];
        [_updateButton addTarget:self action:@selector(updateButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _updateButton;
}




@end
