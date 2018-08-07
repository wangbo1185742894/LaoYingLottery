//
//  CLFTChoosePlayMothedView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTChoosePlayMothedView.h"
#import "CLPlayMothedOptionView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "Masonry.h"
#import "CLLotteryDataManager.h"

@interface CLFTChoosePlayMothedView ()

@property (nonatomic, strong) UIImageView *backgroundView;//背景图片

@property (nonatomic, strong) CLPlayMothedOptionView *heZhiView;//和值
@property (nonatomic, strong) CLPlayMothedOptionView *threeSameView;//三同
@property (nonatomic, strong) CLPlayMothedOptionView *twoSameView;//二同
@property (nonatomic, strong) CLPlayMothedOptionView *threeNoSameView;//三不同
@property (nonatomic, strong) CLPlayMothedOptionView *twoNoSameView;//二不同
@property (nonatomic, strong) CLPlayMothedOptionView *threeNoSameDanView;//三不同 胆拖
@property (nonatomic, strong) CLPlayMothedOptionView *twoNoSameDanView;//二不同 胆拖

@property (nonatomic, strong) UIImageView *topLeftImageView;//普通投注的左侧的线
@property (nonatomic, strong) UIImageView *topRightImageView;//普通投注的右侧的线
@property (nonatomic, strong) UIImageView *bottomLeftImageView;//胆拖投注的左侧的线
@property (nonatomic, strong) UIImageView *bottomRightImageView;//胆拖投注的右侧的线

@property (nonatomic, strong) UILabel *normalBetLabel;//普通投注
@property (nonatomic, strong) UILabel *danTuoBetLabel;//胆拖投注

@end
@implementation CLFTChoosePlayMothedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x338866);
        self.layer.masksToBounds = YES;
        [self addSubview:self.backgroundView];
        [self addSubview:self.heZhiView];
        [self addSubview:self.threeSameView];
        [self addSubview:self.twoSameView];
        [self addSubview:self.threeNoSameView];
        [self addSubview:self.twoNoSameView];
        [self addSubview:self.threeNoSameDanView];
        [self addSubview:self.twoNoSameDanView];

        [self addSubview:self.topLeftImageView];
        [self addSubview:self.topRightImageView];
        [self addSubview:self.bottomLeftImageView];
        [self addSubview:self.bottomRightImageView];

        [self addSubview:self.normalBetLabel];
        [self addSubview:self.danTuoBetLabel];
        
        [self configConstrait];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
#pragma mark - 刷新加奖标志
- (void)reloadDataForAddBonus{
    
    NSArray *bonus = [CLLotteryDataManager getAddBonusGameEn:self.gameEn];
    if (bonus && bonus.count == 7) {
        self.heZhiView.bonusType = [bonus[0] integerValue];
        self.threeSameView.bonusType = [bonus[1] integerValue];
        self.twoSameView.bonusType = [bonus[2] integerValue];
        self.threeNoSameView.bonusType = [bonus[3] integerValue];
        self.twoNoSameView.bonusType = [bonus[4] integerValue];
        self.threeNoSameDanView.bonusType = [bonus[5] integerValue];
        self.twoNoSameDanView.bonusType = [bonus[6] integerValue];
    }
}

#pragma mark - 清空所有View的选择中态
- (void)selectedViewWithPlayMothed:(CLFastThreePlayMothedType)playMothedType{
    self.heZhiView.is_selected = NO;
    self.threeSameView.is_selected = NO;
    self.twoSameView.is_selected = NO;
    self.threeNoSameView.is_selected = NO;
    self.twoNoSameView.is_selected = NO;
    self.threeNoSameDanView.is_selected = NO;
    self.twoNoSameDanView.is_selected = NO;
    switch (playMothedType) {
        case CLFastThreePlayMothedTypeHeZhi:
            self.heZhiView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeThreeSame:
            self.threeSameView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeTwoSame:
            self.twoSameView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeThreeDifferent:
            self.threeNoSameView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeTwoDifferent:
            self.twoNoSameView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeDanTuoThreeDifferent:
            self.threeNoSameDanView.is_selected = YES;
            break;
        case CLFastThreePlayMothedTypeDanTuoTwoDifferent:
            self.twoNoSameDanView.is_selected = YES;
            break;
        default:
            break;
    }
}
#pragma mark ------ event Respone ------
- (void)tapSelf:(UITapGestureRecognizer *)tap{
    
}
#pragma mark ------ private Mothed ------
- (void)configConstrait{
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.edges.equalTo(self);
    }];
    
    [self.topLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.normalBetLabel.mas_left).offset(__SCALE(- 10.f));
        make.left.equalTo(self.heZhiView);
        make.centerY.equalTo(self.normalBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
    }];
    [self.topRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalBetLabel.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.normalBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.right.equalTo(self.twoSameView);
    }];
    
    [self.normalBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(__SCALE(30.f));
    }];
    
    [self.heZhiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.normalBetLabel.mas_bottom).offset(__SCALE(10.f));
        make.left.equalTo(self).offset(__SCALE(12.f));
        make.width.mas_equalTo(__SCALE(90.f));
        make.height.mas_equalTo(__SCALE(70.f));
    }];
    [self.threeSameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heZhiView.mas_right).offset(__SCALE(12.f));
        make.top.bottom.width.height.equalTo(self.heZhiView);
    }];
    [self.twoSameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeSameView.mas_right).offset(__SCALE(12.f));
        make.top.bottom.width.height.equalTo(self.heZhiView);
        make.right.equalTo(self).offset(__SCALE(-12.f));
    }];
    [self.threeNoSameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heZhiView.mas_bottom).offset(__SCALE(10.f));
        make.left.right.width.height.equalTo(self.heZhiView);
    }];
    [self.twoNoSameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.heZhiView.mas_bottom).offset(__SCALE(10.f));
        make.left.right.width.height.equalTo(self.threeSameView);
    }];
    
    
    [self.danTuoBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.threeNoSameView.mas_bottom).offset(__SCALE(10.f));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(__SCALE(30.f));
    }];
    
    [self.bottomLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.danTuoBetLabel.mas_left).offset(__SCALE(- 10.f));
        make.centerY.equalTo(self.danTuoBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.left.equalTo(self.heZhiView);
    }];
    [self.bottomRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danTuoBetLabel.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.danTuoBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.right.equalTo(self.twoSameView);
    }];
    
    [self.threeNoSameDanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.danTuoBetLabel.mas_bottom).offset(__SCALE(10.f));
        make.left.right.width.equalTo(self.heZhiView);
        make.height.mas_equalTo(__SCALE(35.f));
        make.bottom.equalTo(self).offset(__SCALE(-20.f));
    }];
    [self.twoNoSameDanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.threeNoSameDanView);
        make.left.right.equalTo(self.twoNoSameView);
        make.height.equalTo(self.threeNoSameDanView);
        make.bottom.equalTo(self).offset(__SCALE(-20.f));
    }];
}
#pragma mark ------ setter Mothed ------
- (void)setWeakViewController:(id<CLFTChoosePlayMothedProtocol>)weakViewController{
    _weakViewController = weakViewController;
    self.heZhiView.delegate = weakViewController;
    self.threeSameView.delegate = weakViewController;
    self.twoSameView.delegate = weakViewController;
    self.threeNoSameView.delegate = weakViewController;
    self.twoNoSameView.delegate = weakViewController;
    self.threeNoSameDanView.delegate = weakViewController;
    self.twoNoSameDanView.delegate = weakViewController;
}
#pragma mark ------ getterMothed ------
- (UIImageView *)backgroundView{
    
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundView.image = [UIImage imageNamed:@"ft_backgroundVeinImage.png"];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}
- (CLPlayMothedOptionView *)heZhiView{
    
    if (!_heZhiView) {
        _heZhiView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _heZhiView.playMothedName = @"和值";
        _heZhiView.awardBonus = @"奖金9-240元";
        _heZhiView.imagesArray = @[[UIImage imageNamed:@"dice_v1_small.png"], [UIImage imageNamed:@"dice_v2_small.png"], [UIImage imageNamed:@"dice_v3_small.png"]];
        _heZhiView.isShowPlus = YES;
        _heZhiView.playMothedType = CLFastThreePlayMothedTypeHeZhi;
    }
    return _heZhiView;
}
- (CLPlayMothedOptionView *)threeSameView{
    
    if (!_threeSameView) {
        _threeSameView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _threeSameView.playMothedName = @"三同号";
        _threeSameView.awardBonus = @"奖金40-240元";
        _threeSameView.imagesArray = @[[UIImage imageNamed:@"dice_v1_small.png"], [UIImage imageNamed:@"dice_v1_small.png"], [UIImage imageNamed:@"dice_v1_small.png"]];
        _threeSameView.isShowPlus = NO;
        _threeSameView.playMothedType = CLFastThreePlayMothedTypeThreeSame;
    }
    return _threeSameView;
}
- (CLPlayMothedOptionView *)twoSameView{
    
    if (!_twoSameView) {
        _twoSameView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _twoSameView.playMothedName = @"二同号";
        _twoSameView.awardBonus = @"奖金15-80元";
        _twoSameView.imagesArray = @[[UIImage imageNamed:@"dice_v1_small.png"], [UIImage imageNamed:@"dice_v1_small.png"], [UIImage imageNamed:@"dice_v3_small.png"]];
        _twoSameView.isShowPlus = NO;
        _twoSameView.playMothedType = CLFastThreePlayMothedTypeTwoSame;
    }
    return _twoSameView;
}
- (CLPlayMothedOptionView *)threeNoSameView{
    
    if (!_threeNoSameView) {
        _threeNoSameView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _threeNoSameView.playMothedName = @"三不同号";
        _threeNoSameView.awardBonus = @"奖金10-40元";
        _threeNoSameView.imagesArray = @[[UIImage imageNamed:@"dice_v2_small.png"], [UIImage imageNamed:@"dice_v3_small.png"], [UIImage imageNamed:@"dice_v5_small.png"]];
        _threeNoSameView.isShowPlus = NO;
        _threeNoSameView.playMothedType = CLFastThreePlayMothedTypeThreeDifferent;
    }
    return _threeNoSameView;
}
- (CLPlayMothedOptionView *)twoNoSameView{
    
    if (!_twoNoSameView) {
        _twoNoSameView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _twoNoSameView.playMothedName = @"二不同号";
        _twoNoSameView.awardBonus = @"奖金8元";
        _twoNoSameView.imagesArray = @[[UIImage imageNamed:@"dice_v2_small.png"], [UIImage imageNamed:@"dice_v3_small.png"]];
        _twoNoSameView.isShowPlus = NO;
        _twoNoSameView.playMothedType = CLFastThreePlayMothedTypeTwoDifferent;
    }
    return _twoNoSameView;
}
- (CLPlayMothedOptionView *)threeNoSameDanView{
    
    if (!_threeNoSameDanView) {
        _threeNoSameDanView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _threeNoSameDanView.playMothedName = @"三不同号";
        _threeNoSameDanView.isShowPlus = NO;
        _threeNoSameDanView.playMothedType = CLFastThreePlayMothedTypeDanTuoThreeDifferent;
    }
    return _threeNoSameDanView;
}
- (CLPlayMothedOptionView *)twoNoSameDanView{
    
    if (!_twoNoSameDanView) {
        _twoNoSameDanView = [[CLPlayMothedOptionView alloc] initWithFrame:CGRectZero];
        _twoNoSameDanView.playMothedName = @"二不同号";
        _twoNoSameDanView.isShowPlus = NO;
        _twoNoSameDanView.playMothedType = CLFastThreePlayMothedTypeDanTuoTwoDifferent;
    }
    return _twoNoSameDanView;
}

- (UIImageView *)topLeftImageView{
    
    if (!_topLeftImageView) {
        _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topLeftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topLeftImageView.backgroundColor = UIColorFromRGB(0x71bb99);
    }
    return _topLeftImageView;
}
- (UIImageView *)topRightImageView{
    
    if (!_topRightImageView) {
        _topRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topRightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topRightImageView.backgroundColor = UIColorFromRGB(0x71bb99);

    }
    return _topRightImageView;
}
- (UIImageView *)bottomLeftImageView{
    
    if (!_bottomLeftImageView) {
        _bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomLeftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomLeftImageView.backgroundColor = UIColorFromRGB(0x71bb99);

    }
    return _bottomLeftImageView;
}
- (UIImageView *)bottomRightImageView{
    
    if (!_bottomRightImageView) {
        _bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomRightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomRightImageView.backgroundColor = UIColorFromRGB(0x71bb99);
    }
    return _bottomRightImageView;
}

- (UILabel *)normalBetLabel{
    
    if (!_normalBetLabel) {
        _normalBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalBetLabel.text = @"普通投注";
        _normalBetLabel.textColor = UIColorFromRGB(0xffffff);
        _normalBetLabel.font = FONT_SCALE(17);
        _normalBetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalBetLabel;
}
- (UILabel *)danTuoBetLabel{
    
    if (!_danTuoBetLabel) {
        _danTuoBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _danTuoBetLabel.text = @"胆拖投注";
        _danTuoBetLabel.textColor = UIColorFromRGB(0xffffff);
        _danTuoBetLabel.font = FONT_SCALE(17);
        _danTuoBetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _danTuoBetLabel;
}


@end
