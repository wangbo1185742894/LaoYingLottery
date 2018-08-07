//
//  SLSPFPlayView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/11.
//  Copyright © 2017年 caiqr. All rights reserved.
//
#import "SLConfigMessage.h"
#import "SLSPFPlayView.h"
#import "UIImage+SLImage.h"
#import "SLBetInfoManager.h"
#import "SLExternalService.h"
#import "SLSPFModel.h"

#import "SLBetDetailDataManager.h"

@interface SLSPFPlayView ()

/**
 让球书label
 */
@property (nonatomic, strong) UILabel *letBallNumber;

/**
 单关icon
 */
@property (nonatomic, strong) UIImageView *icon;


/**
 未开售View
 */
@property (nonatomic, strong) UILabel *unSaleLabel;

@end
@implementation SLSPFPlayView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
    }

    return self;
}

- (void)addSubviews
{
    [self.letBallNumber addSubview:self.icon];
    [self addSubview:self.letBallNumber];
    [self addSubview:self.hostWinBtn];
    [self addSubview:self.dogfallBtn];
    [self addSubview:self.guestWinBtn];
    [self addSubview:self.unSaleLabel];
}

- (void)addConstraints
{
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.letBallNumber);
        make.width.height.mas_offset(SL__SCALE(20.f));
    }];
    
    [self.letBallNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.equalTo(self);
        make.width.mas_offset(SL__SCALE(20.f));
        make.height.mas_offset(SL__SCALE(35.f));
    }];
    
    [self.hostWinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.letBallNumber.mas_right);
        make.top.bottom.equalTo(self.letBallNumber);
        make.width.mas_equalTo(SL__SCALE(78));
        make.height.equalTo(self.letBallNumber.mas_height);
    }];
    
    [self.dogfallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.hostWinBtn.mas_right);
        make.top.bottom.equalTo(self.letBallNumber);
        make.width.equalTo(self.hostWinBtn.mas_width);
        make.height.equalTo(self.hostWinBtn.mas_height);
    }];
    
    [self.guestWinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.dogfallBtn.mas_right);
        make.top.bottom.equalTo(self.letBallNumber);
        make.width.equalTo(self.hostWinBtn.mas_width);
        make.height.equalTo(self.hostWinBtn.mas_height);
        make.right.equalTo(self.mas_right);
    }];
    
    [self.unSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.equalTo(self.hostWinBtn);
        make.right.equalTo(self.guestWinBtn);
    }];
}
#pragma mark --- Button Click ---
- (void)hostButtonClick:(UIButton *)button
{    
    [self buttonClick:button selectNumber:3];
}

- (void)dogFallButtonClick:(UIButton *)button
{

    [self buttonClick:button selectNumber:1];
}

- (void)guestButtonClick:(UIButton *)button
{
    
    [self buttonClick:button selectNumber:0];
}

- (void)buttonClick:(UIButton *)button selectNumber:(NSInteger)selectNumber
{

    if (self.spfModel.danguan == 0) {
        
        if ([SLBetDetailDataManager isShowToast]) {
            
            [SLExternalService showError:@"只有一场赛事，不能选择非单关玩法"];
            
            return;
        }
        
    }
    
    
    if (!self.matchIssue || [SLBetInfoManager judgeCurrentSelectIsValid:self.matchIssue]) {
        
        button.selected = !button.isSelected;
        !self.clickButtonBlock ? : self.clickButtonBlock(button.selected, selectNumber);
        
    }else{
        
        [SLExternalService showError:@"最多支持8场"];
    }


}

#pragma mark --- Set Moethod ---
- (void)setSpfModel:(SLSPFModel *)spfModel
{

    _spfModel = spfModel;
    
    //校验是否是单关
    self.icon.hidden = !( spfModel.danguan && spfModel.danguan == 1) ;
    
    //校验让球数是否正确
    if (spfModel.handicap && spfModel.handicap.length != 0 ) {
        
        
        NSInteger number = [spfModel.handicap integerValue];
        self.letBallNumber.textColor = SL_UIColorFromRGB(0xFFFFFF);
        self.letBallNumber.text = [NSString stringWithFormat:@"%@",spfModel.handicap];
        self.letBallNumber.backgroundColor = (number > 0) ? SL_UIColorFromRGB(0xFF9C63) : SL_UIColorFromRGB(0x60CCA1);
    }else{
        
        self.letBallNumber.textColor = SL_UIColorFromRGB(0x8F6E51);
        self.letBallNumber.backgroundColor = SL_UIColorFromRGB(0xECE1DA);
        self.letBallNumber.text = @"0";
    
    }
    if (spfModel.isSale) {
        
        self.guestWinBtn.hidden = NO;
        self.dogfallBtn.hidden = NO;
        self.hostWinBtn.hidden = NO;
        self.unSaleLabel.hidden = YES;
        //检验主胜是否开售
        if (spfModel.sp.win && spfModel.sp.win.length > 0) {
            
            [self.hostWinBtn setTitle:[NSString stringWithFormat:@"主胜 %@",BetOddsTransitionString(spfModel.sp.win)] forState:(UIControlStateNormal)];
            self.hostWinBtn.userInteractionEnabled = YES;
        }else{
            
            [self.hostWinBtn setTitle:@"未开售" forState:(UIControlStateNormal)];
            self.hostWinBtn.userInteractionEnabled = NO;
            
        }
        //检验平是否开售
        if (spfModel.sp.win && spfModel.sp.draw.length > 0) {
            
            [self.dogfallBtn setTitle:[NSString stringWithFormat:@"平 %@",BetOddsTransitionString(spfModel.sp.draw)] forState:(UIControlStateNormal)];
            
            self.dogfallBtn.userInteractionEnabled = YES;
        }else{
            
            [self.dogfallBtn setTitle:@"未开售" forState:(UIControlStateNormal)];
            self.dogfallBtn.userInteractionEnabled = NO;
        }
        
        //检验主负是否开售
        if (spfModel.sp.loss && spfModel.sp.loss.length > 0) {
            
            [self.guestWinBtn setTitle:[NSString stringWithFormat:@"主负 %@",BetOddsTransitionString(spfModel.sp.loss)] forState:(UIControlStateNormal)];
            self.guestWinBtn.userInteractionEnabled = YES;
        }else{
            
            [self.guestWinBtn setTitle:@"未开售" forState:(UIControlStateNormal)];
            self.guestWinBtn.userInteractionEnabled = NO;
        }
    }else{
        
        self.guestWinBtn.hidden = YES;
        self.dogfallBtn.hidden = YES;
        self.hostWinBtn.hidden = YES;
        self.unSaleLabel.hidden = NO;
    }
}
#pragma mark ---- Get Method ---

- (UILabel *)letBallNumber
{

    if (_letBallNumber == nil) {
        
        _letBallNumber = [[UILabel alloc] initWithFrame:(CGRectZero)];
        _letBallNumber.text = @"0";
        _letBallNumber.textColor = SL_UIColorFromRGB(0x8F6E51);
        _letBallNumber.textAlignment = NSTextAlignmentCenter;
        _letBallNumber.font = SL_FONT_SCALE(12);
        _letBallNumber.backgroundColor = SL_UIColorFromRGB(0xECE1DA);
    }

    return _letBallNumber;
}

- (UIButton *)hostWinBtn
{

    if (_hostWinBtn == nil) {
        
        _hostWinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_hostWinBtn setTitle:@"主胜 88.88" forState:(UIControlStateNormal)];
        
        [_hostWinBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_hostWinBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        
        [_hostWinBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xFFFFFF)] forState:(UIControlStateNormal)];
        [_hostWinBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xE63222)] forState:(UIControlStateSelected)];
        
        _hostWinBtn.titleLabel.font = SL_FONT_SCALE(14);
        _hostWinBtn.layer.masksToBounds = YES;
        _hostWinBtn.layer.borderWidth = 0.25;
        _hostWinBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        [_hostWinBtn setAdjustsImageWhenHighlighted:NO];
        
        [_hostWinBtn addTarget:self action:@selector(hostButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];

    }
    
    return _hostWinBtn;

}

- (UIButton *)dogfallBtn
{

    if (_dogfallBtn == nil) {
        
        _dogfallBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_dogfallBtn setTitle:@"平 13.40" forState:(UIControlStateNormal)];
        
        [_dogfallBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_dogfallBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        
        [_dogfallBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xFFFFFF)] forState:(UIControlStateNormal)];
        [_dogfallBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xE63222)] forState:(UIControlStateSelected)];
        
        _dogfallBtn.titleLabel.font = SL_FONT_SCALE(14);
        _dogfallBtn.layer.borderWidth = 0.25;
        _dogfallBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        [_dogfallBtn setAdjustsImageWhenHighlighted:NO];
        
        [_dogfallBtn addTarget:self action:@selector(dogFallButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _dogfallBtn;
}

- (UIButton *)guestWinBtn
{
    
    if (_guestWinBtn == nil) {
        
        _guestWinBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_guestWinBtn setTitle:@"主负 12.40" forState:(UIControlStateNormal)];
        
        [_guestWinBtn setTitleColor:SL_UIColorFromRGB(0x333333) forState:(UIControlStateNormal)];
        [_guestWinBtn setTitleColor:SL_UIColorFromRGB(0xFFFFFF) forState:(UIControlStateSelected)];
        
        [_guestWinBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xFFFFFF)] forState:(UIControlStateNormal)];
        [_guestWinBtn setBackgroundImage:[UIImage sl_imageWithColor:SL_UIColorFromRGB(0xE63222)] forState:(UIControlStateSelected)];
        
        _guestWinBtn.titleLabel.font = SL_FONT_SCALE(14);
        _guestWinBtn.layer.borderWidth = 0.25;
        _guestWinBtn.layer.borderColor = SL_UIColorFromRGB(0xECE5DD).CGColor;
        
        [_guestWinBtn setAdjustsImageWhenHighlighted:NO];
        
        [_guestWinBtn addTarget:self action:@selector(guestButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    return _guestWinBtn;
}

- (UIImageView *)icon
{

    if (_icon == nil) {
        
        _icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_danguan"]];
    }
    
    return _icon;
}

- (UILabel *)unSaleLabel{
    
    if (!_unSaleLabel) {
        _unSaleLabel = [[UILabel alloc] init];
        _unSaleLabel.backgroundColor = SL_UIColorFromRGB(0xffffff);
        _unSaleLabel.text = @"未开售";
        _unSaleLabel.textColor = SL_UIColorFromRGB(0x999999);
        _unSaleLabel.font = SL_FONT_SCALE(12.f);
        _unSaleLabel.hidden = YES;
        _unSaleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _unSaleLabel;
}

@end
