//
//  CLLotteryBetHelperView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryBetHelperView.h"
#import "CLConfigMessage.h"
@interface CLLotteryBetHelperView ()

@property (nonatomic, strong) UIView *helperBaseView;//助手下拉的View
@property (nonatomic, strong) UIImageView *helperArrowImageView;//上方的箭头图片

@end

@implementation CLLotteryBetHelperView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.helperBaseView];
        [self addSubview:self.helperArrowImageView];
        self.backgroundColor = UIColorFromRGBandAlpha(0xffffff, 0.f);
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
        make.right.equalTo(self).offset(__SCALE(- 10.f));
        make.top.equalTo(self).offset(64.5f);
        make.height.mas_equalTo(0);
    }];
    
    [self.helperArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.helperBaseView.mas_top);
        make.right.equalTo(self.helperBaseView).offset(__SCALE(- 20.f));
    }];
}
#pragma mark - 创建对应button
- (void)createButton{
    
    UIButton *lastBtn = nil;
    for (NSInteger i = 0; i < self.titleArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        button.titleLabel.font = FONT_SCALE(15);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
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
            make.width.mas_equalTo(__SCALE(90.f));
            make.height.mas_equalTo(__SCALE(35.f));
        }];
        if (i != self.titleArray.count - 1) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
            lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
            [self.helperBaseView addSubview:lineView];
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.helperBaseView).offset(__SCALE(3.f));
                make.right.equalTo(self.helperBaseView).offset(__SCALE(- 3.f));
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
        make.right.equalTo(self).offset(__SCALE(- 10.f));
        make.top.equalTo(self).offset(64.f);
    }];
    
    [UIView animateWithDuration:.1f animations:^{
        
        [self layoutIfNeeded];
    }];
}
- (void)recoverHelperView{
    
    [self.helperBaseView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- 10.f));
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
        _helperBaseView.backgroundColor = UIColorFromRGBandAlpha(0xffffff, .98f);
        _helperBaseView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
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
