//
//  CLQuickBetPublicHeaderView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLQuickBetPublicHeaderView.h"
#import "CLConfigMessage.h"
#import "CQViewQuickAllocDef.h"
#import "CQDefinition.h"

#define CLQuickBetViewWidth (SCREEN_WIDTH - (2 * 30))

@interface CLQuickBetPublicHeaderView()

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *listTitleLabel;
@property (nonatomic, strong) CALayer *bottomLayer;
@property (nonatomic, copy) void(^backBlock)(void);
@end

@implementation CLQuickBetPublicHeaderView

+ (instancetype)quickBetPublicHeaderViewWithTitle:(NSString *)title backBlock:(void (^)(void))backBlock
{
    CLQuickBetPublicHeaderView *headerView = [[CLQuickBetPublicHeaderView alloc] init];
    headerView.backBlock = backBlock;
    headerView.listTitleLabel.text = title;
    return headerView;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bottomLayer.frame = __Rect(0, __Obj_Bounds_Height(self.listTitleLabel), __Obj_Bounds_Width(self), .5f);
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.listTitleLabel];
        [self insertSubview:self.closeButton aboveSubview:self.listTitleLabel];
        [self.layer addSublayer:self.bottomLayer];
        self.frame = __Rect(0, 0, CLQuickBetViewWidth, CLQuickBetPublicHeaderViewHeight + .5f);
    }
    return self;
}

- (void)cancelButtonClick
{
    if (self.backBlock) self.backBlock();
}

#pragma mark - gettingMethod

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = __Rect(0, 0, __SCALE(30.f), CLQuickBetPublicHeaderViewHeight);
        //        [_closeButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [_closeButton setImage:[UIImage imageNamed:@"lotteryBackArrow"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)listTitleLabel
{
    if (!_listTitleLabel) {
        AllocNormalLabel(_listTitleLabel, @"", FONT_SCALE(14), NSTextAlignmentCenter, UIColorFromRGB(0x333333), __Rect(0, 0, CLQuickBetViewWidth, CLQuickBetPublicHeaderViewHeight));
        _listTitleLabel.backgroundColor = CLEARCOLOR;
    }
    return _listTitleLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.frame = __Rect(0, __Obj_Bounds_Height(self.listTitleLabel), CLQuickBetViewWidth, .5f);
        _bottomLayer.backgroundColor = UIColorFromRGB(0xdcdcdc).CGColor;
    }
    return _bottomLayer;
}

@end
