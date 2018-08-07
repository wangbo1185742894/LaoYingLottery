//
//  SLMatchBetHelperView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchBetHelperView.h"
#import "SLConfigMessage.h"

@interface SLMatchBetHelperView ()

/**
 助手下拉的View
 */
@property (nonatomic, strong) UIView *helperBaseView;

/**
 上方的箭头图片
 */
@property (nonatomic, strong) UIImageView *helperArrowImageView;

@end

@implementation SLMatchBetHelperView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.helperBaseView];
        [self addSubview:self.helperArrowImageView];
        self.backgroundColor = [UIColor clearColor];
        [self configConstraint];
        
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}



#pragma mark ------------ event Response ------------
- (void)tapOnSelf:(UITapGestureRecognizer *)tap{
    
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
}
#pragma mark ------------ private Mothed ------------
- (void)configConstraint{
    
    [self.helperBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SL__SCALE(- 10.f));
        make.top.equalTo(self).offset(64.5f);
        make.height.mas_equalTo(0);
    }];
    
    [self.helperArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.helperBaseView.mas_top).offset(1);
        make.right.equalTo(self.helperBaseView).offset(SL__SCALE(- 5.f));
    }];
}
#pragma mark - 创建对应button
- (void)createButton{
    
    UIButton *lastBtn = nil;
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.titleLabel.font = SL_FONT_SCALE(15);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:SL_UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.helperBaseView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastBtn) {
                make.top.equalTo(lastBtn.mas_bottom).offset(1.f);
            }else{
                make.top.equalTo(self.helperBaseView);
            }
            make.left.right.equalTo(self.helperBaseView);
            make.width.mas_equalTo(SL__SCALE(110.f));
            make.height.mas_equalTo(SL__SCALE(49.f));
        }];
        if (i != self.titleArray.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = SL_UIColorFromRGB(0xECE5DD);
            [self.helperBaseView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.helperBaseView).offset(SL__SCALE(15.f));
                make.right.equalTo(self.helperBaseView).offset(SL__SCALE(- 15.f));
                make.height.mas_equalTo(1.f);
                make.top.equalTo(button.mas_bottom);
            }];
        }
        lastBtn = button;
    }
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.helperBaseView);
    }];
    
}
#pragma mark - 动画
- (void)helperAnmation{
    
    [self.helperBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SL__SCALE(- 10.f));
        make.top.equalTo(self).offset(64.f);
    }];
    
    [UIView animateWithDuration:.1f animations:^{
        
        [self layoutIfNeeded];
    }];
}
- (void)recoverHelperView{
    
    [self.helperBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(SL__SCALE(- 10.f));
        make.top.equalTo(self).offset(64.f);
        make.height.mas_equalTo(0);
    }];
}
#pragma mark ------------ event Response ------------
- (void)buttonOnClick:(UIButton *)btn{
    
    self.hidden = YES;
    [self.superview sendSubviewToBack:self];
    self.helperButtonBlock ? self.helperButtonBlock(btn) : nil;
}
#pragma mark ------------ setter Mothed ------------
- (void)setTitleArray:(NSArray *)titleArray{
    
    _titleArray = titleArray;
    [self createButton];
}
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    
    if (!hidden) {
        [self helperAnmation];
    }else{
        [self recoverHelperView];
    }
    
}
#pragma mark ------------ getter Mothed ------------
- (UIView *)helperBaseView{
    
    if (!_helperBaseView) {
        _helperBaseView = [[UIView alloc] initWithFrame:CGRectZero];
        _helperBaseView.backgroundColor = SL_UIColorFromRGB(0XFFFFFF);
        _helperBaseView.layer.borderColor = SL_UIColorFromRGB(0xdddddd).CGColor;
        _helperBaseView.layer.borderWidth = 0.5f;
    }
    return _helperBaseView;
}
- (UIImageView *)helperArrowImageView{
    
    if (!_helperArrowImageView) {
        _helperArrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _helperArrowImageView.image = [UIImage imageNamed:@"LotteryHelperArrowImage.png"];
        _helperArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _helperArrowImageView;
}

@end
