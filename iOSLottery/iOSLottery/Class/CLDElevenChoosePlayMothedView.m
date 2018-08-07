//
//  CLDElevenChoosePlayMothedView.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLDElevenChoosePlayMothedView.h"
#import "CLConfigMessage.h"
#import "CLDElevenPlayMothedButton.h"
#import "CLLotteryDataManager.h"
@interface CLDElevenChoosePlayMothedView ()

@property (nonatomic, strong) NSMutableArray *palyMothedButtonArray;//按钮数组
@property (nonatomic, strong) UIImageView *topLeftImageView;//普通投注的左侧的线
@property (nonatomic, strong) UIImageView *topRightImageView;//普通投注的右侧的线
@property (nonatomic, strong) UIImageView *bottomLeftImageView;//胆拖投注的左侧的线
@property (nonatomic, strong) UIImageView *bottomRightImageView;//胆拖投注的右侧的线

@property (nonatomic, strong) UILabel *normalBetLabel;//普通投注
@property (nonatomic, strong) UILabel *danTuoBetLabel;//胆拖投注

@end
@implementation CLDElevenChoosePlayMothedView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shadowColor = UIColorFromRGB(0x333333).CGColor;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowOpacity = 0.1;
        self.backgroundColor = UIColorFromRGB(0xf7f7ee);
        [self addSubview:self.topLeftImageView];
        [self addSubview:self.topRightImageView];
        [self addSubview:self.bottomLeftImageView];
        [self addSubview:self.bottomRightImageView];
        
        [self addSubview:self.normalBetLabel];
        [self addSubview:self.danTuoBetLabel];
        [self configNormalPlayMothedTypeButton];
        [self configDanTuoPlayMothedTypeButton];
        [self configContraint];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)reloadDataForAddBonus{
    
    NSArray *bonus = [CLLotteryDataManager getAddBonusGameEn:self.gameEn];
    if (bonus && bonus.count == 21) {
        
        for (NSInteger i = 0; i < bonus.count; i++) {
            ((CLDElevenPlayMothedButton *)self.palyMothedButtonArray[i]).bonusType = [bonus[i] integerValue];
        }
    }
}
#pragma mark ------------ event Response ------------
#pragma mark - 点击了自身（无响应）
- (void)tapSelf:(UIGestureRecognizer *)ges{
    
}
#pragma mark - 点击了玩法按钮
- (void)buttonOnClick:(CLDElevenPlayMothedButton *)btn{
    
    btn.selected = YES;
    self.dElevenChoosePlayMothedBlock ? self.dElevenChoosePlayMothedBlock(btn.tag) : nil;
    for (CLDElevenPlayMothedButton *otherBtn in self.palyMothedButtonArray) {
        if (![otherBtn isEqual:btn]) {
            otherBtn.selected = NO;
        }
    }
}

#pragma mark ------------ private Mothed ------------
#pragma mark - 添加普通投注按钮
- (void)configNormalPlayMothedTypeButton{
    
    CLDElevenPlayMothedButton *lastButtonY = nil;
    for (NSInteger j = 0; j < 4; j++) {
        //这是一行
        CLDElevenPlayMothedButton *lastButton = nil;
        for (NSInteger i = 0; i < 3; i++) {
            CLDElevenPlayMothedButton *button = [[CLDElevenPlayMothedButton alloc] initWithFrame:CGRectZero];
            [button setTitle:[self getButtonTitleWithPlayMothed:(3 * j) + i] forState:UIControlStateNormal];
            button.tag = (3 * j) + i;
            button.titleLabel.font = FONT_SCALE(14);
            [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [button setTitleColor:THEME_COLOR forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [self.palyMothedButtonArray addObject:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (lastButtonY) {
                    make.top.equalTo(lastButtonY.mas_bottom).offset(__SCALE(10.f));
                }else{
                    make.top.equalTo(self).offset(__SCALE(45.f));
                }
                
                if (lastButton) {
                    make.left.equalTo(lastButton.mas_right).offset(__SCALE(10.f));
                }else{
                    make.left.equalTo(self).offset(__SCALE(10.f));
                }
                
                if (lastButton) {
                    make.width.equalTo(lastButton);
                }
                make.height.equalTo(button.mas_width).multipliedBy(0.33);
            }];
            lastButton = button;
        }
        //再给最后一个加一个约束 距离右边界
        [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(__SCALE(- 10.f));
        }];
        lastButtonY = lastButton;
    }
    //给胆拖投注 添加一条top 约束
    [self.danTuoBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastButtonY.mas_bottom).offset(__SCALE(15.f));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(__SCALE(50.f)).priorityHigh();
    }];
}
#pragma mark - 添加胆拖投注按钮
- (void)configDanTuoPlayMothedTypeButton{
    
    CLDElevenPlayMothedButton *lastButtonY = nil;
    for (NSInteger j = 0; j < 3; j++) {
        //这是一行
        CLDElevenPlayMothedButton *lastButton = nil;
        for (NSInteger i = 0; i < 3; i++) {
            CLDElevenPlayMothedButton *button = [[CLDElevenPlayMothedButton alloc] initWithFrame:CGRectZero];
            [button setTitle:[self getButtonTitleWithPlayMothed:(3 * j) + i + 12] forState:UIControlStateNormal];
            button.titleLabel.font = FONT_SCALE(14);
            [button setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
            [button setTitleColor:THEME_COLOR forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//            button.layer.cornerRadius = 2.f;
//            button.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
//            button.layer.borderWidth = .5f;
            
            button.tag = (3 * j) + i + 12;
            [self addSubview:button];
            [self.palyMothedButtonArray addObject:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (lastButtonY) {
                    make.top.equalTo(lastButtonY.mas_bottom).offset(__SCALE(10.f));
                }else{
                    make.top.equalTo(self.danTuoBetLabel.mas_bottom).offset(__SCALE(10.f));
                }
                
                if (lastButton) {
                    make.left.equalTo(lastButton.mas_right).offset(__SCALE(10.f));
                }else{
                    make.left.equalTo(self).offset(__SCALE(10.f));
                }
                
                if (lastButton) {
                    make.width.equalTo(lastButton);
                }
                make.height.equalTo(button.mas_width).multipliedBy(0.33);
            }];
            lastButton = button;
        }
        //再给最后一个加一个约束 距离右边界
        [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(__SCALE(- 10.f));
        }];
        lastButtonY = lastButton;
    }
    [lastButtonY mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(__SCALE(- 20.f));
    }];
}
- (void)configContraint{
    
    [self.normalBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(__SCALE(10.f));
        make.centerX.equalTo(self);
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    [self.topLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.normalBetLabel.mas_left).offset(__SCALE(- 10.f));
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.centerY.equalTo(self.normalBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
    }];
    [self.topRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.normalBetLabel.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.normalBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.right.equalTo(self).offset(__SCALE(- 10.f));
    }];
    
    [self.bottomLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.danTuoBetLabel.mas_left).offset(__SCALE(- 10.f));
        make.centerY.equalTo(self.danTuoBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.left.equalTo(self).offset(__SCALE(10.f));
    }];
    [self.bottomRightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.danTuoBetLabel.mas_right).offset(__SCALE(10.f));
        make.centerY.equalTo(self.danTuoBetLabel);
        make.height.mas_equalTo(__SCALE(.5f));
        make.right.equalTo(self).offset(__SCALE(- 10.f));
    }];
    
}
- (NSString *)getButtonTitleWithPlayMothed:(CLDElevenPlayMothedType)playMothed{
    
    switch (playMothed) {
        case CLDElevenPlayMothedTypeTwo:
            return @"任选二";
            break;
        case CLDElevenPlayMothedTypeThree:
            return @"任选三";
            break;
        case CLDElevenPlayMothedTypeFour:
            return @"任选四";
            break;
        case CLDElevenPlayMothedTypeFive:
            return @"任选五";
            break;
        case CLDElevenPlayMothedTypeSix:
            return @"任选六";
            break;
        case CLDElevenPlayMothedTypeSeven:
            return @"任选七";
            break;
        case CLDElevenPlayMothedTypeEight:
            return @"任选八";
            break;
        case CLDElevenPlayMothedTypePreOne:
            return @"前一";
            break;
        case CLDElevenPlayMothedTypePreTwoDirect:
            return @"前二直选";
            break;
        case CLDElevenPlayMothedTypePreTwoGroup:
            return @"前二组选";
            break;
        case CLDElevenPlayMothedTypePreThreeDirect:
            return @"前三直选";
            break;
        case CLDElevenPlayMothedTypePreThreeGroup:
            return @"前三组选";
            break;
        case CLDElevenPlayMothedTypeDTTwo:
            return @"任选二";
            break;
        case CLDElevenPlayMothedTypeDTThree:
            return @"任选三";
            break;
        case CLDElevenPlayMothedTypeDTFour:
            return @"任选四";
            break;
        case CLDElevenPlayMothedTypeDTFive:
            return @"任选五";
            break;
        case CLDElevenPlayMothedTypeDTSix:
            return @"任选六";
            break;
        case CLDElevenPlayMothedTypeDTSeven:
            return @"任选七";
            break;
        case CLDElevenPlayMothedTypeDTEight:
            return @"任选八";
            break;
        case CLDElevenPlayMothedTypeDTPreTwoGroup:
            return @"前二组选";
            break;
        case CLDElevenPlayMothedTypeDTPreThreeGroup:
            return @"前三组选";
            break;
        default:
            break;
    }
    return @"";
}
- (void)setCurrentPlayMothedType:(CLDElevenPlayMothedType)currentPlayMothedType{
    
    for (CLDElevenPlayMothedButton *btn in self.palyMothedButtonArray) {
        if (btn.tag == currentPlayMothedType) {
            btn.selected = YES;
            btn.layer.borderColor = THEME_COLOR.CGColor;
        }else{
            btn.selected = NO;
            btn.layer.borderColor = UIColorFromRGB(0xcbbdaa).CGColor;
        }
    }
}
#pragma mark ------------ getter Mothed ------------
- (UIImageView *)topLeftImageView{
    
    if (!_topLeftImageView) {
        _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topLeftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topLeftImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _topLeftImageView;
}
- (UIImageView *)topRightImageView{
    
    if (!_topRightImageView) {
        _topRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topRightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _topRightImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
    }
    return _topRightImageView;
}
- (UIImageView *)bottomLeftImageView{
    
    if (!_bottomLeftImageView) {
        _bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomLeftImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomLeftImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
    }
    return _bottomLeftImageView;
}
- (UIImageView *)bottomRightImageView{
    
    if (!_bottomRightImageView) {
        _bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bottomRightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _bottomRightImageView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomRightImageView;
}

- (UILabel *)normalBetLabel{
    
    if (!_normalBetLabel) {
        _normalBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _normalBetLabel.text = @"普通投注";
        _normalBetLabel.textColor = UIColorFromRGB(0x000000);
        _normalBetLabel.font = FONT_SCALE(15);
        _normalBetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _normalBetLabel;
}
- (UILabel *)danTuoBetLabel{
    
    if (!_danTuoBetLabel) {
        _danTuoBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _danTuoBetLabel.text = @"胆拖投注";
        _danTuoBetLabel.textColor = UIColorFromRGB(0x000000);
        _danTuoBetLabel.font = FONT_SCALE(15);
        _danTuoBetLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _danTuoBetLabel;
}
- (NSMutableArray *)palyMothedButtonArray{
    
    if (!_palyMothedButtonArray) {
        _palyMothedButtonArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _palyMothedButtonArray;
}
@end
