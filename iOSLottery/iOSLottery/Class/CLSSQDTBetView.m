//
//  CLSSQDTBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/2.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQDTBetView.h"
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
@interface CLSSQDTBetView ()

@property (nonatomic, strong) UIButton *danTanButton;//什么是胆拖
@property (nonatomic, strong) CLTwoImageButton *activityButton;
@property (nonatomic, strong) NSString *activityUrl;
@property (nonatomic, strong) CLFTImageLabel *danImageLabel;
@property (nonatomic, strong) UILabel *danInfoLabel;//胆码说明label
@property (nonatomic, strong) CLFTImageLabel *tuoImageLabel;
@property (nonatomic, strong) UILabel *tuoInfoLabel;//拖码说明label
@property (nonatomic, strong) UILabel *blueInfoLabel;//蓝球说明label
@property (nonatomic, strong) CLOneGroupBallView *danRedView;
@property (nonatomic, strong) CLOneGroupBallView *tuoRedView;
@property (nonatomic, strong) CLOneGroupBallView *blueView;

@end

@implementation CLSSQDTBetView

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
        [self addSubview:self.blueInfoLabel];
        [self addSubview:self.danRedView];
        [self addSubview:self.tuoRedView];
        [self addSubview:self.blueView];
        
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
        make.height.mas_equalTo([self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
    }];
    
    [self.tuoImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
        make.width.mas_equalTo(__SCALE(57.f));
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.tuoInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tuoImageLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.tuoImageLabel);
    }];
    [self.tuoRedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.tuoRedView getOneGroupBallVeiwHeightWithCount:33]);
    }];
    [self.blueInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33] * 2);
        make.left.equalTo(self).offset(__SCALE(10.f));
    }];
    
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(15.f) + [self.tuoRedView getOneGroupBallVeiwHeightWithCount:33] * 2);
        make.height.mas_equalTo([self.blueView getOneGroupBallVeiwHeightWithCount:16]);
        make.bottom.equalTo(self).offset(__SCALE(-10.f));
    }];
}

#pragma mark ------------ public Mothed ------------
#pragma mark - 配置默认数据
- (void)assginDefaultData:(CLSSQDTBetTerm *)betTerm{
    
    for (NSString *tag in betTerm.redDanArray) {
        [self.danRedView selectBetButtonWithTag:[tag integerValue]];
    }
    
    for (NSString *tag in betTerm.redTuoArray) {
        [self.tuoRedView selectBetButtonWithTag:[tag integerValue]];
    }
    
    for (NSString *tag in betTerm.blueArray) {
        [self.blueView selectBetButtonWithTag:[tag integerValue]];
    }
}
- (void)ssq_danTuoClearAll{
    
    [self.tuoRedView clearAllBet];
    [self.danRedView clearAllBet];
    [self.blueView clearAllBet];
}
#pragma mark - 刷新注数
- (void)refreshNote{
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
#pragma mark - 配置遗漏
- (void)assignOmissionDataWithRed:(NSArray *)redArray blue:(NSArray *)blueArray{
    
    [self.danRedView assignOmissionData:redArray];
    [self.tuoRedView assignOmissionData:redArray];
    [self.blueView assignOmissionData:blueArray];
}
#pragma mark - 隐藏遗漏
- (void)hiddenOmission:(BOOL)hidden{
    
    [self.danRedView hiddenOmissionView:hidden];
    [self.tuoRedView hiddenOmissionView:hidden];
    [self.blueView hiddenOmissionView:hidden];
    [self.danRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f));
        make.height.mas_equalTo([self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
    }];
    
    [self.tuoImageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(__SCALE(5.f));
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(25.f) + __SCALE(10.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
        make.width.mas_equalTo(__SCALE(57.f));
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.tuoInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.tuoImageLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.tuoImageLabel);
    }];
    [self.tuoRedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33]);
        make.left.right.equalTo(self);
        make.height.mas_equalTo([self.tuoRedView getOneGroupBallVeiwHeightWithCount:33]);
    }];
    [self.blueInfoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + [self.danRedView getOneGroupBallVeiwHeightWithCount:33] * 2);
        make.left.equalTo(self).offset(__SCALE(10.f));
    }];
    
    [self.blueView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(self.danImageLabel.mas_bottom).offset(__SCALE(10.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(25.f) + __SCALE(25.f) + __SCALE(10.f) + __SCALE(15.f) + [self.tuoRedView getOneGroupBallVeiwHeightWithCount:33] * 2);
        make.height.mas_equalTo([self.blueView getOneGroupBallVeiwHeightWithCount:16]);
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
    
    [[CLAllJumpManager shareAllJumpManager] open:@"https://m.caiqr.com/daily/dantuoshuoming-shseqiu/index.htm"];
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
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
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
    
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
}
- (void)selectBlueBall:(CLLotteryBallView *)button{
    
    NSString *betStr = [NSString stringWithFormat:@"%02zi", button.tag];
    if (button.selected) {
        
        if ([self.betTerm.blueArray indexOfObject:betStr] == NSNotFound) {
            [self.betTerm.blueArray addObject:betStr];
        }
    }else{
        
        if ([self.betTerm.blueArray indexOfObject:betStr] != NSNotFound) {
            [self.betTerm.blueArray removeObject:betStr];
        }
    }
    self.ssq_normalCallBackNoteBonusBlock ? self.ssq_normalCallBackNoteBonusBlock(self.betTerm.minBetBonus, self.betTerm.MaxBetBonus, self.betTerm.betNote, (self.betTerm.redDanArray.count > 0 || self.betTerm.blueArray.count > 0 || self.betTerm.redTuoArray.count > 0)) : nil;
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
        _danInfoLabel.text = @"红球，至少选择1个，最多5个";
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
- (UILabel *)blueInfoLabel{
    
    if (!_blueInfoLabel) {
        _blueInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _blueInfoLabel.text = @"至少选择1个";
        _blueInfoLabel.font = FONT_SCALE(13);
        _blueInfoLabel.textColor = UIColorFromRGB(0x000000);
    }
    return _blueInfoLabel;
}

- (CLOneGroupBallView *)danRedView{
    
    WS(_weakSelf)
    if (!_danRedView) {
        _danRedView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:33 ballColor:UIColorFromRGB(0xd90000)];
        _danRedView.maxSelectedCount = 5;
        _danRedView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectRedDanBall:button];
        };
        _danRedView.needShowHUDBlock = ^(){
            
            //弹窗提示
            [CLShowHUDManager showInWindowWithText:@"胆码红球最多选择5个" type:CLShowHUDTypeOnlyText delayTime:0.5];
        };
    }
    return _danRedView;
}

- (CLOneGroupBallView *)tuoRedView{
    
    WS(_weakSelf)
    if (!_tuoRedView) {
        _tuoRedView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:33 ballColor:UIColorFromRGB(0xd90000)];
        _tuoRedView.maxSelectedCount = 32;
        _tuoRedView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectRedTuoBall:button];
        };
        _tuoRedView.needShowHUDBlock = ^(){
            
            //弹窗提示
            [CLShowHUDManager showInWindowWithText:@"拖码红球最多选择32个" type:CLShowHUDTypeOnlyText delayTime:0.5];
        };
    }
    return _tuoRedView;
}
- (CLOneGroupBallView *)blueView{
    
    WS(_weakSelf)
    if (!_blueView) {
        _blueView = [[CLOneGroupBallView alloc] initWithFrame:CGRectZero ballCount:16 ballColor:UIColorFromRGB(0x295fcc)];
        _blueView.selectStateChangeBlock = ^(CLLotteryBallView *button){
            
            [_weakSelf selectBlueBall:button];
        };
    }
    return _blueView;
}
- (CLSSQDTBetTerm *)betTerm{
    
    if (!_betTerm) {
        _betTerm = [[CLSSQDTBetTerm alloc] init];
    }
    return _betTerm;
}
@end
