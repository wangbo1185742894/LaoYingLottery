//
//  CLDLTDanTuoBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLDLTDanTuoBetView.h"
#import "CLFTImageLabel.h"
#import "CLConfigMessage.h"
#import "CLOneGroupBallView.h"
#import "CLLotteryBallView.h"
#import "CLAllJumpManager.h"
#import "CLShowHUDManager.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"
@interface CLDLTDanTuoBetView ()

@property (nonatomic, strong) UIButton *danTanButton;//什么是胆拖
@property (nonatomic, strong) CLFTImageLabel *danImageLabel;
@property (nonatomic, strong) UILabel *danInfoLabel;//胆码说明label
@property (nonatomic, strong) CLFTImageLabel *tuoImageLabel;
@property (nonatomic, strong) UILabel *tuoInfoLabel;//拖码说明label
@property (nonatomic, strong) UILabel *danblueInfoLabel;//胆码蓝球说明label
@property (nonatomic, strong) CLFTImageLabel *danBlueImageLabel;
@property (nonatomic, strong) CLFTImageLabel *tuoBlueImageLabel;
@property (nonatomic, strong) UILabel *tuoBlueInfoLabel;//胆码蓝球说明label
@property (nonatomic, strong) CLOneGroupBallView *danRedView;
@property (nonatomic, strong) CLOneGroupBallView *tuoRedView;
@property (nonatomic, strong) CLOneGroupBallView *danblueView;
@property (nonatomic, strong) CLOneGroupBallView *tuoBlueView;
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) NSString *activityUrl;

@end
@implementation CLDLTDanTuoBetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.danTanButton];
        [self addSubview:self.activityButton];
        [self addSubview:self.danImageLabel];
        [self addSubview:self.danInfoLabel];
        [self addSubview:self.tuoImageLabel];
        [self addSubview:self.tuoInfoLabel];
        [self addSubview:self.danblueInfoLabel];
        [self addSubview:self.danBlueImageLabel];
        [self addSubview:self.tuoBlueImageLabel];
        [self addSubview:self.tuoBlueInfoLabel];
        [self addSubview:self.danRedView];
        [self addSubview:self.tuoRedView];
        [self addSubview:self.danblueView];
        [self addSubview:self.tuoBlueView];
        
        [self configConstraint];
    }
    return self;
}
- (void)configConstraint{
    
    [self.danTanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self).offset(__SCALE(12.f));
    }];
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(__SCALE(- 20.f));
        make.centerY.equalTo(self.danTanButton);
    }];
    [self.danImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self.danTanButton.mas_bottom).offset(__SCALE(10.f));
    }];
    
    [self.danInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.danImageLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.danImageLabel);
    }];
    [self.danRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f));
        make.height.mas_equalTo([self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    
    [self.tuoImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    [self.tuoInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tuoImageLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.tuoImageLabel);
    }];
    [self.tuoRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) +  [self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.tuoRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    [self.danBlueImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.left.equalTo(self.danImageLabel);
    }];
//
    [self.danblueInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.danBlueImageLabel);
        make.left.equalTo(self.danBlueImageLabel.mas_right).offset(__SCALE(5.f));
    }];
//
    [self.danblueView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.height.mas_equalTo([self.danblueView getOneGroupBallVeiwHeightWithCount:12]);
    }];
    [self.tuoBlueImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danblueView getOneGroupBallVeiwHeightWithCount:12] + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.left.equalTo(self.danImageLabel);
    }];
    [self.tuoBlueInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.tuoBlueImageLabel);
        make.left.equalTo(self.tuoBlueImageLabel.mas_right).offset(__SCALE(5.f));
    }];
    
    [self.tuoBlueView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + [self.danblueView getOneGroupBallVeiwHeightWithCount:12] + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.height.mas_equalTo([self.tuoBlueView getOneGroupBallVeiwHeightWithCount:12]);
        make.bottom.equalTo(self).offset(__SCALE(-10.f));
    }];
}
#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认数据
- (void)assginDefaultData:(CLDLTDanTuoBetTerm *)betTerm{
    
    for (NSString *tag in betTerm.redDanArray) {
        [self.danRedView selectBetButtonWithTag:[tag integerValue]];
    }
    
    for (NSString *tag in betTerm.redTuoArray) {
        [self.tuoRedView selectBetButtonWithTag:[tag integerValue]];
    }
    
    for (NSString *tag in betTerm.blueDanArray) {
        [self.danblueView selectBetButtonWithTag:[tag integerValue]];
    }
    for (NSString *tag in betTerm.blueTuoArray) {
        [self.tuoBlueView selectBetButtonWithTag:[tag integerValue]];
    }
}
- (void)ssq_danTuoClearAll{
    
    [self.tuoRedView clearAllBet];
    [self.danRedView clearAllBet];
    [self.danblueView clearAllBet];
    [self.tuoBlueView clearAllBet];
}
#pragma mark - 刷新注数
- (void)refreshNote{
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueDanArray.count || self.betTerm.blueTuoArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
#pragma mark - 配置遗漏
- (void)assignOmissionDataWithRed:(NSArray *)redArray blue:(NSArray *)blueArray{
    
    [self.danRedView assignOmissionData:redArray];
    [self.tuoRedView assignOmissionData:redArray];
    [self.danblueView assignOmissionData:blueArray];
    [self.tuoBlueView assignOmissionData:blueArray];
}
#pragma mark - 隐藏遗漏
- (void)hiddenOmission:(BOOL)hidden{
    
    [self.danRedView hiddenOmissionView:hidden];
    [self.tuoRedView hiddenOmissionView:hidden];
    [self.danblueView hiddenOmissionView:hidden];
    [self.tuoBlueView hiddenOmissionView:hidden];
    [self.danRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f));
        make.height.mas_equalTo([self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    
    [self.tuoImageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    [self.tuoInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tuoImageLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.tuoImageLabel);
    }];
    [self.tuoRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) +  [self.danRedView getOneGroupBallVeiwHeightWithCount:35]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.tuoRedView getOneGroupBallVeiwHeightWithCount:35]);
    }];
    [self.danBlueImageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.left.equalTo(self.danImageLabel);
    }];
    //
    [self.danblueInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.danBlueImageLabel);
        make.left.equalTo(self.danBlueImageLabel.mas_right).offset(__SCALE(5.f));
    }];
    //
    [self.danblueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.height.mas_equalTo([self.danblueView getOneGroupBallVeiwHeightWithCount:12]);
    }];
    [self.tuoBlueImageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danblueView getOneGroupBallVeiwHeightWithCount:12] + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.left.equalTo(self.danImageLabel);
    }];
    [self.tuoBlueInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.tuoBlueImageLabel);
        make.left.equalTo(self.tuoBlueImageLabel.mas_right).offset(__SCALE(5.f));
    }];
    
    [self.tuoBlueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + [self.danblueView getOneGroupBallVeiwHeightWithCount:12] + [self.danRedView getOneGroupBallVeiwHeightWithCount:35] * 2);
        make.height.mas_equalTo([self.tuoBlueView getOneGroupBallVeiwHeightWithCount:12]);
        make.bottom.equalTo(self).offset(__SCALE(-10.f));
    }];
}
#pragma mark - 配置活动链接
- (void)assignActicityLink:(id)data{
    
    CLLotteryActivitiesModel *model = data;
    if (model.activityImgUrl && model.activityImgUrl.length > 0) {
        
        if ([model.activityImgUrl hasPrefix:@"http"]) {
            
            [self.activityButton.mainImageView setImageWithURL:[NSURL URLWithString:model.activityImgUrl]];
            [self.activityButton setTitle:@"" forState:UIControlStateNormal];
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self).offset(__SCALE(0.f));
                make.right.equalTo(self);
                make.height.equalTo(self.activityButton.mas_width).multipliedBy(11.0 / 26);
                make.width.mas_equalTo(__SCALE(130.f));
            }];
            [self.activityButton assignMianImageViewHidden:NO];
        }else{
            [self.activityButton setTitle:model.activityImgUrl forState:UIControlStateNormal];
            
            [self.activityButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.equalTo(self.danTanButton);
                make.right.equalTo(self).offset(__SCALE(-20.f));
            }];
            [self.activityButton assignMianImageViewHidden:YES];
        }
        self.activityUrl = model.activityUrl;
        self.activityButton.hidden = NO;
    }else{
        self.activityButton.hidden = YES;
    }
}
#pragma mark ------------ event Response ------------
- (void)danTuoInfoButtonOnClick:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:@"https://m.caiqr.com/daily/dantuoshuoming-daletou/index.htm"];
}
- (void)selectRedDanBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.redDanArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.redDanArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.redDanArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.redDanArray removeObject:betStr];
        }
    }
    if (button.selected) {
        [self.tuoRedView changeMutualExclusionBetButton:button.tag];
    }
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueDanArray.count || self.betTerm.blueTuoArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}

- (void)selectRedTuoBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.redTuoArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.redTuoArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.redTuoArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.redTuoArray removeObject:betStr];
        }
    }
    
    if (button.selected) {
        [self.danRedView changeMutualExclusionBetButton:button.tag];
    }
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueDanArray.count || self.betTerm.blueTuoArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
- (void)selectDanBlueBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.blueDanArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.blueDanArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.blueDanArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.blueDanArray removeObject:betStr];
        }
    }
    
    if (button.selected) {
        [self.tuoBlueView changeMutualExclusionBetButton:button.tag];
    }
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueDanArray.count || self.betTerm.blueTuoArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
- (void)selectTuoBlueBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.blueTuoArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.blueTuoArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.blueTuoArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.blueTuoArray removeObject:betStr];
        }
    }
    
    if (button.selected) {
        [self.danblueView changeMutualExclusionBetButton:button.tag];
    }
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueDanArray.count || self.betTerm.blueTuoArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark ------------ getter Mothed ------------
- (UIButton *)danTanButton{
    
    if (!_danTanButton) {
        _danTanButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_danTanButton setTitle:@"什么是胆拖？" forState:UIControlStateNormal];
        [_danTanButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _danTanButton.titleLabel.font = FONT_SCALE(14);
        [_danTanButton addTarget:self action:@selector(danTuoInfoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danTanButton;
}
- (CLTwoImageButton *)activityButton{
    
    if (!_activityButton) {
        _activityButton = [[CLTwoImageButton alloc] init];
        _activityButton.hidden = YES;
//        [_activityButton setTitle:@"史无前例大加奖" forState:UIControlStateNormal];
        [_activityButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _activityButton.titleLabel.font = FONT_SCALE(14);
        _activityButton.leftImage = [UIImage imageNamed:@"de_star.png"];
        _activityButton.rightImage = [UIImage imageNamed:@"de_arrow.png"];
        [_activityButton addTarget:self action:@selector(activityButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _activityButton;
}
- (CLFTImageLabel *)danImageLabel{
    
    if (!_danImageLabel) {
        _danImageLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _danImageLabel.contentString = @"胆码";
        _danImageLabel.contentFont = FONT_SCALE(13.f);
        _danImageLabel.contentColor = UIColorFromRGB(0x333333);
        _danImageLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _danImageLabel;
}
- (UILabel *)danInfoLabel{
    
    if (!_danInfoLabel) {
        _danInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _danInfoLabel.text = @"前区，至少选择1个，最多选4个";
        _danInfoLabel.font = FONT_SCALE(13);
        _danInfoLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _danInfoLabel;
}
- (CLFTImageLabel *)tuoImageLabel{
    
    if (!_tuoImageLabel) {
        _tuoImageLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tuoImageLabel.contentString = @"拖码";
        _tuoImageLabel.contentFont = FONT_SCALE(13.f);
        _tuoImageLabel.contentColor = UIColorFromRGB(0x333333);
        _tuoImageLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _tuoImageLabel;
}
- (UILabel *)tuoInfoLabel{
    
    if (!_tuoInfoLabel) {
        _tuoInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tuoInfoLabel.text = @"至少选择2个";
        _tuoInfoLabel.font = FONT_SCALE(13);
        _tuoInfoLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _tuoInfoLabel;
}

- (CLFTImageLabel *)danBlueImageLabel{
    
    if (!_danBlueImageLabel) {
        _danBlueImageLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _danBlueImageLabel.contentString = @"胆码";
        _danBlueImageLabel.contentFont = FONT_SCALE(13.f);
        _danBlueImageLabel.contentColor = UIColorFromRGB(0x333333);
        _danBlueImageLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _danBlueImageLabel;
}
- (UILabel *)danblueInfoLabel{
    
    if (!_danblueInfoLabel) {
        _danblueInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _danblueInfoLabel.text = @"后区，最多选择1";
        _danblueInfoLabel.font = FONT_SCALE(13);
        _danblueInfoLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _danblueInfoLabel;
}

- (CLFTImageLabel *)tuoBlueImageLabel{
    
    if (!_tuoBlueImageLabel) {
        _tuoBlueImageLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tuoBlueImageLabel.contentString = @"拖码";
        _tuoBlueImageLabel.contentFont = FONT_SCALE(13.f);
        _tuoBlueImageLabel.contentColor = UIColorFromRGB(0x333333);
        _tuoBlueImageLabel.backImage = [UIImage imageNamed:@"lotteryMainBetTag.png"];
    }
    return _tuoBlueImageLabel;
}
- (UILabel *)tuoBlueInfoLabel{
    
    if (!_tuoBlueInfoLabel) {
        _tuoBlueInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tuoBlueInfoLabel.text = @"至少选择2个";
        _tuoBlueInfoLabel.font = FONT_SCALE(13);
        _tuoBlueInfoLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _tuoBlueInfoLabel;
}

- (CLOneGroupBallView *)danRedView{
    
    WS(_weakSelf)
    if (!_danRedView) {
        _danRedView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:35 ballColor:UIColorFromRGB(0xd90000)];
        _danRedView.maxSelectedCount = 4;
        _danRedView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectRedDanBall:button];
        };
        _danRedView.needShowHUDBlock = ^(){
           
            [CLShowHUDManager showInWindowWithText:@"胆码前区最多选择4个" type:CLShowHUDTypeOnlyText delayTime:0.5f];
        };
    }
    return _danRedView;
}

- (CLOneGroupBallView *)tuoRedView{
    
    WS(_weakSelf)
    if (!_tuoRedView) {
        _tuoRedView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:35 ballColor:UIColorFromRGB(0xd90000)];
        _tuoRedView.maxSelectedCount = 34;
        _tuoRedView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectRedTuoBall:button];
        };
        _tuoRedView.needShowHUDBlock = ^(){
            
            [CLShowHUDManager showInWindowWithText:@"拖码前区最多选择34个" type:CLShowHUDTypeOnlyText delayTime:0.5f];
        };
    }
    return _tuoRedView;
}
- (CLOneGroupBallView *)danblueView{
    
    WS(_weakSelf)
    if (!_danblueView) {
        _danblueView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:12 ballColor:UIColorFromRGB(0x295fcc)];
        _danblueView.maxSelectedCount = 1;
        _danblueView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectDanBlueBall:button];
        };
        _danblueView.needShowHUDBlock = ^(){
            
            [CLShowHUDManager showInWindowWithText:@"胆码后区最多选择1个" type:CLShowHUDTypeOnlyText delayTime:0.5f];
        };
    }
    return _danblueView;
}
- (CLOneGroupBallView *)tuoBlueView{
    
    WS(_weakSelf)
    if (!_tuoBlueView) {
        _tuoBlueView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:12 ballColor:UIColorFromRGB(0x295fcc)];
        _tuoBlueView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectTuoBlueBall:button];
        };
    }
    return _tuoBlueView;
}
- (CLDLTDanTuoBetTerm *)betTerm{
    
    if (!_betTerm) {
        _betTerm = [[CLDLTDanTuoBetTerm alloc] init];
    }
    return _betTerm;
}

@end
