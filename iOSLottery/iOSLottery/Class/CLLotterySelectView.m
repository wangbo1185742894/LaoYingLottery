//
//  CLLotterySelectView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotterySelectView.h"
#import "CLConfigMessage.h"

@interface CLLotterySelectView ()

@property (nonatomic, strong) UIImageView *tagImageView;//特殊标记的尖角
@property (nonatomic, strong) UIView *tagBackgroundView;

@property (nonatomic, weak) id target;
@property (nonatomic) SEL sel;

@end

@implementation CLLotterySelectView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self =[super initWithFrame:frame ];
    if (self) {
        
        self.lotteryIconImgView = [[UIImageView alloc] init];
        self.lotteryIconImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.rightTopImageView = [[UIImageView alloc] init];
        self.rightTopImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.rightTopImageView.image = [UIImage imageNamed:@"homeSelectTopRight"];
        
        self.tagImageView = [[UIImageView alloc] init];
        self.tagImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.tagImageView.image = [UIImage imageNamed:@"homeLotterySelectTagCorner.png"];
        
        self.tagBackgroundView = [[UIView alloc] init];
        self.tagBackgroundView.backgroundColor = UIColorFromRGB(0xe03731);
        self.tagBackgroundView.layer.cornerRadius = __SCALE(5.f);
        self.lotteryNameLbl = [[UILabel alloc] init];
        self.lotteryNameLbl.backgroundColor = [UIColor clearColor];
        self.lotteryNameLbl.font = FONT_SCALE(15);
        self.lotteryNameLbl.textColor = UIColorFromRGB(0x333333);
        
        self.lotteryDesLbl = [[UILabel alloc] init];
        self.lotteryDesLbl.backgroundColor = [UIColor clearColor];
        self.lotteryDesLbl.font = FONT_SCALE(11);
        self.lotteryDesLbl.textColor = UIColorFromRGB(0x999999);
        
//        self.lotteryCutDownLbl = [[UILabel alloc] init];
//        self.lotteryCutDownLbl.backgroundColor = [UIColor clearColor];
//        self.lotteryCutDownLbl.font = FONT_SCALE(11);
//        self.lotteryCutDownLbl.textColor = UIColorFromRGB(0xd80000);
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        
        [self addSubview:self.lotteryIconImgView];
        [self addSubview:self.lotteryNameLbl];
        
        [self addSubview:self.tagBackgroundView];
        [self addSubview:self.tagImageView];
        
        [self addSubview:self.lotteryDesLbl];
//        [self addSubview:self.lotteryCutDownLbl];
        [self addSubview:self.rightTopImageView];
        
        [self.lotteryIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self).multipliedBy(3.f/8.f);
            make.centerY.equalTo(self);
            make.centerX.equalTo(self.mas_right).multipliedBy(7.f/32.f);
            make.height.equalTo(self.lotteryIconImgView.mas_width);
        }];
        
        [self.lotteryNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_right).multipliedBy(7.f/16.f);
            make.centerY.equalTo(self.mas_bottom).multipliedBy(5.f/14.f);
            make.right.equalTo(self).offset(-5);
            make.height.equalTo(self.lotteryIconImgView).multipliedBy(.5f);
        }];
        
        [self.lotteryDesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lotteryNameLbl);
            make.centerY.equalTo(self.mas_bottom).multipliedBy(9.5f/14.f);
        }];
        
//        [self.lotteryCutDownLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.lotteryDesLbl.mas_right);
//            make.centerY.equalTo(self.lotteryDesLbl);
//        }];
        
        [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.tagBackgroundView).offset(__SCALE(- 1.6f));
            make.top.equalTo(self.tagBackgroundView);
            make.width.mas_equalTo(__SCALE(12.5f));
            make.height.mas_equalTo(__SCALE(5));
        }];
        
        [self.tagBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.lotteryDesLbl);
            make.width.equalTo(self.lotteryDesLbl).offset(__SCALE(5.f));
            make.height.equalTo(self.lotteryDesLbl).offset(__SCALE(5.f));
        }];
        
        [self.rightTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.equalTo(self);
            make.width.height.mas_equalTo(__SCALE(25.f));
        }];
//        self.isTag = YES;
    }
    return self;
}

- (void) addTarget:(id)target selector:(SEL)sel {
    
    self.target = target;
    self.sel = sel;
}

- (void)tapEvent:(id)sender {
    
    
    
    if (self.target && self.sel) {
        if ([self.target respondsToSelector:self.sel]) {
            
            IMP imp = [self.target methodForSelector:self.sel];
            void (*func)(id, SEL) = (void *)imp;
            func(self.target, self.sel);
//            [self.target performSelector:self.sel];
        }
    }else if (self.tapBlock){
        self.tapBlock();
    }
}
- (void)setIsTag:(BOOL)isTag{
    
    _isTag = isTag;
    
    [self.lotteryDesLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lotteryNameLbl).offset(isTag ? __SCALE(5.f) : 0);
    }];
    
    self.tagImageView.hidden = self.tagBackgroundView.hidden = !isTag;
    self.lotteryDesLbl.textColor = isTag ? UIColorFromRGB(0xffffff) : UIColorFromRGB(0x999999);
}
- (void)setTag:(BOOL)tag color:(NSString *)color{
    
    _isTag = tag;
    
    [self.lotteryDesLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lotteryNameLbl).offset(_isTag ? __SCALE(5.f) : 0);
    }];
    
    self.tagImageView.hidden = self.tagBackgroundView.hidden = !_isTag;
    UIColor *tempColor = UIColorFromRGB(0x999999);
    if (color && color.length > 0) {
        tempColor = UIColorFromStr(color);
    }
    self.lotteryDesLbl.textColor = _isTag ? UIColorFromRGB(0xffffff) : tempColor;
    
}

//- (void)timerNotificationResponse:(NSNotification *)notif
//{
//    
//}
//
//- (void)setAddNotifi:(BOOL)addNotifi
//{
//    if (addNotifi) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timerNotificationResponse:) name:GlobalTimerRuning object:nil];
//    }
//}
//
//- (void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

@end
