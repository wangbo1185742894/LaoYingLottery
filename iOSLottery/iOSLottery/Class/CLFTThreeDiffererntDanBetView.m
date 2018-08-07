//
//  CLFTThreeDiffererntDanBetView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFTThreeDiffererntDanBetView.h"
#import "CLFastThreeConfigMessage.h"
#import "CLFTBetButtonView.h"
#import "CLFTImageLabel.h"
#import "CLFTDanThreeDifferentBetInfo.h"
#import "CLFTBonusInfo.h"
#import "CLShowHUDManager.h"
#import "CLAllJumpManager.h"
#import "CLLotteryOmissionView.h"
#import "CLTwoImageButton.h"
#import "CLLotteryActivitiesModel.h"
#import "CLNativePushService.h"
#import "UIImageView+CQWebImage.h"
#import "UILabel+CLAttributeLabel.h"
#define DanBetTag 10
#define TuoBetTag 100

@interface CLFTThreeDiffererntDanBetView ()
@property (nonatomic, strong) UILabel *infoLabel;//说明label
@property (nonatomic, strong) UIButton *danTuoButton;//什么是胆拖按钮
@property (nonatomic, strong) CLTwoImageButton *activityButton;

@property (nonatomic, strong) CLFTImageLabel *danNumberLabel;//胆码
@property (nonatomic, strong) CLFTImageLabel *tuoNumberLabel;//拖码
@property (nonatomic, strong) NSMutableArray *danBetViewArray;//胆码投注按钮数组
@property (nonatomic, strong) NSMutableArray *tuoBetViewArray;//拖码投注按钮数组

@property (nonatomic, strong) NSMutableArray *omissionArray;
@property (nonatomic, strong) NSString *activityUrl;
@end
@implementation CLFTThreeDiffererntDanBetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        [self assginSubView];
    }
    return self;
}
#pragma mark ------ delegate ------
- (void)assignUIWithData:(id)data{
    
    if (((CLLotteryBaseBetTerm *)data).betType == CLFTBetTypeDanTuoThreeDifferent) {
        CLFTDanThreeDifferentBetInfo *selectBetInfo = data;
        for (NSString *betTerm in selectBetInfo.danThreeDifferentBetArray) {
            for (CLFTBetButtonView *betButton in self.danBetViewArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue] + DanBetTag) {
                    betButton.is_Selected = YES;
                }
            }
        }
        for (NSString *betTerm in selectBetInfo.tuoThreeDifferentBetArray) {
            for (CLFTBetButtonView *betButton in self.tuoBetViewArray) {
                if (betButton.tag == [[betTerm substringToIndex:1] integerValue] + TuoBetTag) {
                    betButton.is_Selected = YES;
                }
            }
        }
    }
}
#pragma mark - 清空所有选项
- (void)clearAllBetButton{
    
    for (CLFTBetButtonView *betView in self.danBetViewArray) {
        betView.is_Selected = NO;
    }
    for (CLFTBetButtonView *betView in self.tuoBetViewArray) {
        betView.is_Selected = NO;
    }
}
#pragma mark - 刷新奖金
- (void)ft_RefreshBonusInfo:(CLFTBonusInfo *)bonusInfo{
    
    self.infoLabel.text = [NSString stringWithFormat:@"选3个不同号码，与开奖相同即中%zi元", bonusInfo.bonus_threeDiff];
    self.betInfo.bonus = bonusInfo.bonus_threeDiff;
}
#pragma mark - 是否有投注项
- (BOOL)ft_hasSelectBetButton{
    
    return ((self.betInfo.danThreeDifferentBetArray.count + self.betInfo.tuoThreeDifferentBetArray.count) > 0);
}
#pragma mark - 配置遗漏
- (void)setOmissionWithData:(NSArray *)omission{
    
    for (NSInteger i = 0; i < omission.count; i++) {
        
        UILabel *label = self.omissionArray[i];
        NSString *omissionStr = omission[i];
        if ([omissionStr rangeOfString:@"^"].location != NSNotFound) {
            
            label.text =  [omissionStr stringByReplacingOccurrencesOfString:@"^" withString:@""];
            label.textColor = UIColorFromRGB(0xffff00);
        }else{
            label.textColor = UIColorFromRGB(0x8eeacc);
            label.text = omissionStr;
        }
    }
}
#pragma mark - 配置默认遗漏
- (void)setDefaultOmission{
    
    for (UILabel *label in self.omissionArray) {
        label.text = @"-";
        label.textColor = UIColorFromRGB(0x8eeacc);
    }
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
                
                make.centerY.equalTo(self.danTuoButton);
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
#pragma mark - 配置奖金信息
- (void)assignBonusInfo:(NSArray *)bonusInfo{
    
    if (bonusInfo && bonusInfo.count == 25) {
        
        [self.infoLabel attributeWithText:bonusInfo[23] beginTag:@"^" endTag:@"&" color:UIColorFromRGB(0xffff00)];
    }
}
#pragma mark ------ private Mothed ------
- (void)assginSubView{
    [self addSubview:self.infoLabel];
    [self addSubview:self.danTuoButton];
    [self addSubview:self.danNumberLabel];
    [self addSubview:self.tuoNumberLabel];
    [self addSubview:self.activityButton];
    [self.danTuoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10));
        make.top.equalTo(self).offset(__SCALE(25.f));
    }];
    
    [self.activityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.danTuoButton);
        make.right.equalTo(self).offset(__SCALE(-20.f));
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.right.equalTo(self).offset(__SCALE(-10.f));
        make.top.equalTo(self.danTuoButton.mas_bottom).offset(__SCALE(5.f));
    }];
    [self.danNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.infoLabel.mas_bottom).offset(__SCALE(10.f));
    }];
    //添加 胆码投注按钮
    [self addDanNumberBetView];
    //添加 拖码投注按钮
    [self addTuoNumberBetView];
    
}
- (void)addDanNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    UILabel *lastLabel = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi", i + 1];
        [self addSubview:betButton];
        [self.danBetViewArray addObject:betButton];
        betButton.tag = i + 1 + DanBetTag;
        betButton.betTerm = [NSString stringWithFormat:@"*%zi", i + 1];
        betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf danBetButtonOnClick:betButton];
        };
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf selectedButton:betButton];
        };
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.danNumberLabel.mas_bottom).offset(__SCALE(20.f));
            
            if (lastSizeBetButton) {
                make.left.equalTo(lastSizeBetButton.mas_right).offset(__SCALE(MAINBETBUTTONDISTANCE));
            }else{
                make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
            }
            
            if (lastSizeBetButton) {
                make.width.equalTo(lastSizeBetButton);
            }
            make.height.equalTo(betButton.mas_width).multipliedBy(0.84);
        }];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x8eeacc);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        if (i == 0) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"遗漏" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x8eeacc) forState:UIControlStateNormal];
            button.titleLabel.font = FONT_SCALE(11.f);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(showOmissionAlert) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(betButton);
                make.centerY.equalTo(label);
//                make.width.mas_equalTo(__SCALE(30.f));
            }];
            label.textAlignment = NSTextAlignmentLeft;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(button.mas_right).offset(0.f);
//                make.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom);
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }
        [self.omissionArray addObject:label];
        lastLabel = label;
        lastSizeBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastSizeBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
    }];
    //添加 拖码label约束
    [self.tuoNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(lastLabel.mas_bottom).offset(__SCALE(35.f));
    }];
}
- (void)addTuoNumberBetView{
    WS(_weakSelf)
    CLFTBetButtonView *lastSizeBetButton = nil;
    for (NSInteger i = 0; i < 6; i++) {
        CLFTBetButtonView *betButton = [[CLFTBetButtonView alloc] initWithFrame:CGRectZero];
        betButton.betNumber = [NSString stringWithFormat:@"%zi", i + 1];
        [self addSubview:betButton];
        [self.tuoBetViewArray addObject:betButton];
        betButton.tag = i + 1 + TuoBetTag;
        betButton.betTerm = [NSString stringWithFormat:@"%zi", i + 1];
        betButton.betButtonClickBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf tuoBetButtonOnClick:betButton];
        };
        betButton.betButtonSelectedBlock = ^(CLFTBetButtonView *betButton){
            
            [_weakSelf selectedButton:betButton];
        };
        [betButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.tuoNumberLabel.mas_bottom).offset(__SCALE(20.f));
            
            if (lastSizeBetButton) {
                make.left.equalTo(lastSizeBetButton.mas_right).offset(__SCALE(MAINBETBUTTONDISTANCE));
            }else{
                make.left.equalTo(self).offset(__SCALE(MAINBETBUTTONEDGE));
            }
            
            if (lastSizeBetButton) {
                make.width.equalTo(lastSizeBetButton);
            }
            make.height.equalTo(betButton.mas_width).multipliedBy(0.84);
        }];
        
        //创建遗漏lebal
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = @"-";
        label.font = FONT_SCALE(13);
        label.textColor = UIColorFromRGB(0x8eeacc);
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        if (i == 0) {
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"遗漏" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x8eeacc) forState:UIControlStateNormal];
            button.titleLabel.font = FONT_SCALE(11.f);
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button addTarget:self action:@selector(showOmissionAlert) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(betButton);
                make.centerY.equalTo(label);
//                make.width.mas_equalTo(__SCALE(30.f));
            }];
            label.textAlignment = NSTextAlignmentLeft;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(button.mas_right).offset(0.f);
//                make.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom).offset(__SCALE(0.f));
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(betButton);
                make.top.equalTo(betButton.mas_bottom);
                make.height.mas_equalTo(__SCALE(25.f));
            }];
        }
        [self.omissionArray addObject:label];
        lastSizeBetButton = betButton;
    }
    //再给最后一个加一个约束 距离右边界
    [lastSizeBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(__SCALE(- MAINBETBUTTONEDGE));
    }];
}
#pragma mark ------ event Response ------
- (void)danTuoButtonOnClick:(UIButton *)btn{
//    NSLog(@"点击了什么是胆拖");

    [[CLAllJumpManager shareAllJumpManager] open:@"http://m.caiqr.com/help/courageStatment.html"];
}
- (void)danBetButtonOnClick:(CLFTBetButtonView *)betbutton{
    NSInteger count = 0;
    for (CLFTBetButtonView *tmpBetButton in self.danBetViewArray) {
        if (tmpBetButton.is_Selected && tmpBetButton != betbutton) {
            count++;
        }
    }
    if (count == 2) {
        betbutton.is_Selected = NO;
        [CLShowHUDManager showHUDWithView:self text:@"三不同号胆码最多选2个" type:CLShowHUDTypeOnlyText delayTime:1.f];
        return;
    }
    for (CLFTBetButtonView *tmpBetView in self.tuoBetViewArray) {
        if ((tmpBetView.tag - TuoBetTag) == (betbutton.tag - DanBetTag)) {
            tmpBetView.is_Selected = NO;
        }
    }
}
- (void)tuoBetButtonOnClick:(CLFTBetButtonView *)betbutton{
    NSInteger count = 0;
    for (CLFTBetButtonView *tmpBetButton in self.tuoBetViewArray) {
        
        if (tmpBetButton.is_Selected && tmpBetButton != betbutton) {
            count++;
        }
    }
    if (count == 5) {
        betbutton.is_Selected = NO;
        [CLShowHUDManager showHUDWithView:self text:@"三不同号拖码最多选5个" type:CLShowHUDTypeOnlyText delayTime:1.f];
        return;
    }
    for (CLFTBetButtonView *tmpBetView in self.danBetViewArray) {
        if ((tmpBetView.tag - DanBetTag) == (betbutton.tag - TuoBetTag)) {
            tmpBetView.is_Selected = NO;
        }
    }
}
- (void)showOmissionAlert{
    
    [CLLotteryOmissionView showLotteryOmissionInWindowWithType:CLOmissionPromptTypeKuaiSan];
}

- (void)activityButtonOnClick:(UIButton *)btn{
    
    [CLNativePushService pushNativeUrl:self.activityUrl];
}
#pragma mark - 投注项选中态改变
- (void)selectedButton:(CLFTBetButtonView *)betButton{
    
    //存储投注项
    if (betButton.is_Selected) {
        [self.betInfo addBetTerm:betButton.betTerm];
    }else{
        [self.betInfo removeBetTerm:betButton.betTerm];
    }
    self.danThreeDifferentBetBonusAndNotesBlock ? self.danThreeDifferentBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
}
#pragma mark ------------ setter Mothed ------------
- (void)setHidden:(BOOL)hidden{
    
    [super setHidden:hidden];
    
    //如果当前显示的是和值 则需要向外传递 奖金 来更改底部视图的奖金
    if (!hidden) {
        //获取投注项的金额
        self.danThreeDifferentBetBonusAndNotesBlock ? self.danThreeDifferentBetBonusAndNotesBlock(self.betInfo.betNote, self.betInfo.minBetBonus, self.betInfo.MaxBetBonus) : nil;
    }
}
#pragma mark ------ getter Mothed ------
- (UILabel *)infoLabel{
    
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.text = @"选3个不同号码，与开奖相同即中40元";
        _infoLabel.textColor = UIColorFromRGB(0x8eeacc);
        _infoLabel.font = FONT_SCALE(13);
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}
- (CLTwoImageButton *)activityButton{
    
    if (!_activityButton) {
        _activityButton = [[CLTwoImageButton alloc] init];
        _activityButton.hidden = YES;
//        [_activityButton setTitle:@"史无前例大加奖" forState:UIControlStateNormal];
        [_activityButton setTitleColor:UIColorFromRGB(0xa4e800) forState:UIControlStateNormal];
        _activityButton.titleLabel.font = FONT_SCALE(14);
        _activityButton.leftImage = [UIImage imageNamed:@"ft_star.png"];
        _activityButton.rightImage = [UIImage imageNamed:@"ft_arrow.png"];
        [_activityButton addTarget:self action:@selector(activityButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _activityButton;
}
- (UIButton *)danTuoButton{
    
    if (!_danTuoButton) {
        _danTuoButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_danTuoButton setTitle:@"什么是胆拖？" forState:UIControlStateNormal];
        [_danTuoButton setTitleColor:UIColorFromRGB(0xa4e800) forState:UIControlStateNormal];
        _danTuoButton.titleLabel.font = FONT_SCALE(14);
        [_danTuoButton addTarget:self action:@selector(danTuoButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _danTuoButton;
}
- (CLFTImageLabel *)danNumberLabel{
    
    if (!_danNumberLabel) {
        _danNumberLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _danNumberLabel.contentString = @"胆码";
    }
    return _danNumberLabel;
}
- (CLFTImageLabel *)tuoNumberLabel{
    
    if (!_tuoNumberLabel) {
        _tuoNumberLabel = [[CLFTImageLabel alloc] initWithFrame:CGRectZero];
        _tuoNumberLabel.contentString = @"拖码";
    }
    return _tuoNumberLabel;
}
- (NSMutableArray *)danBetViewArray{
    
    if (!_danBetViewArray) {
        _danBetViewArray = [[NSMutableArray alloc] init];
    }
    return _danBetViewArray;
}
- (NSMutableArray *)tuoBetViewArray{
    
    if (!_tuoBetViewArray) {
        _tuoBetViewArray = [[NSMutableArray alloc] init];
    }
    return _tuoBetViewArray;
}
- (NSMutableArray *)omissionArray{
    
    if (!_omissionArray) {
        _omissionArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _omissionArray;
}
- (CLFTDanThreeDifferentBetInfo *)betInfo{
    
    if (!_betInfo) {
        _betInfo = [[CLFTDanThreeDifferentBetInfo alloc] init];
    }
    return _betInfo;
}
@end
