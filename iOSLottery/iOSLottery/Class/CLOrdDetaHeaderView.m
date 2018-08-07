//
//  CLOrdDetaHeaderView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrdDetaHeaderView.h"
#import "CLConfigMessage.h"

#import "CLOrderStatusLineView.h"
#import "CLOrderBasicMsgView.h"

#import "CLOrderDetailHeaderViewModel.h"
#import "UIImageView+CQWebImage.h"
#import "CLOrderStatus.h"
#import "CLAppContext.h"
@interface CLOrdDetaHeaderView () <CLOrderBasicMsgViewDelegate>

//彩种icon
@property (nonatomic, strong) UIImageView* lottIconImgView;
//彩种名称
@property (nonatomic, strong) UILabel* lottNameLbl;
//彩种期次
@property (nonatomic, strong) UILabel *lotteryPeriodLbl;

@property (nonatomic, strong) UIView* lottSeparatorLine;

@property (nonatomic, strong) CLOrderStatusLineView* orderProgressView;

@property (nonatomic, strong) CLOrderBasicMsgView* orderMessageView;

@property (nonatomic, strong) UILabel* lottStoreNameLbl;

@property (nonatomic, strong) UIImageView* bottomImgView;

@end

@implementation CLOrdDetaHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        [self setConstraints];
    }
    return self;
}

#pragma mark- CLOrderBasicMsgViewDelegate

- (void)orderBasicMsgEvent {
    
    (!self.detaHeadPayment)?:self.detaHeadPayment();
}

- (void) setUpHeaderViewModel:(CLOrderDetailHeaderViewModel*)viewModel {
    
    if (viewModel.lotteryPeriod.length > 2) {
        self.currentPeriod = [viewModel.lotteryPeriod substringWithRange:NSMakeRange(viewModel.lotteryPeriod.length - 3, 2)];
    }
    self.orderProgressView.lineParams = viewModel.lineArrays;
    self.orderProgressView.dotParams = viewModel.dotArrays;
    [self.orderProgressView setNeedsDisplay];
    
    self.orderMessageView.basicMsgArray = viewModel.basicArrays;
    
    [self.lottIconImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@.png", [[CLAppContext context] getPicturePrefix], viewModel.gameEn]]];
    self.lottNameLbl.text = viewModel.lotteryName;
    self.lotteryPeriodLbl.text = viewModel.lotteryPeriod;
    self.lottStoreNameLbl.text = (viewModel.lotteryStoreName.length > 0)?[NSString stringWithFormat:@"%@",viewModel.lotteryStoreName]:@"";
}

- (void) initViews {
    
    self.backgroundColor = [UIColor whiteColor];
    self.lottIconImgView = [[UIImageView alloc] init];
    self.lottNameLbl = [[UILabel alloc] init];
    self.lotteryPeriodLbl = [[UILabel alloc] init];
    self.lottSeparatorLine = [[UIView alloc] init];
    self.orderProgressView = [[CLOrderStatusLineView alloc] init];
    self.orderMessageView = [[CLOrderBasicMsgView alloc] init];
    self.orderMessageView.delegate = self;
    self.lottStoreNameLbl = [[UILabel alloc] init];
    self.bottomImgView = [[UIImageView alloc] init];
    self.bottomImgView.image = [UIImage imageNamed:@"CMTWareLine"];
    self.bottomImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self addSubview:self.lottIconImgView];
    [self addSubview:self.lottNameLbl];
    [self addSubview:self.lotteryPeriodLbl];
    [self addSubview:self.lottSeparatorLine];
    [self addSubview:self.orderProgressView];
    [self addSubview:self.orderMessageView];
    [self addSubview:self.lottStoreNameLbl];
    [self addSubview:self.bottomImgView];
    self.lottNameLbl.textColor = UIColorFromRGB(0x333333);
    self.lottNameLbl.font = FONT_BOLD(16.f);
    
    self.lotteryPeriodLbl.textColor = UIColorFromRGB(0x333333);
    self.lotteryPeriodLbl.font = FONT_SCALE(12);
    
    self.lottSeparatorLine.backgroundColor = SEPARATE_COLOR;
    
    self.lottStoreNameLbl.font = FONT_SCALE(11);
    self.lottStoreNameLbl.textColor = UIColorFromRGB(0x999999);
}

- (void)setConstraints {
    
    [self.lottIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.top.equalTo(self.mas_top).offset(__SCALE(5.f));
        make.width.height.mas_equalTo(__SCALE(30.f));
    }];
    
    [self.lottNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lottIconImgView.mas_right).offset(10.f);
        make.centerY.equalTo(self.lottIconImgView);
    }];
    
    [self.lotteryPeriodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lottNameLbl.mas_right).offset(__SCALE(3.f));
        make.centerY.equalTo(self.lottNameLbl);
    }];
    
    [self.lottSeparatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(.5f);
        make.top.equalTo(self.lottIconImgView.mas_bottom).offset(__SCALE(5.f));
    }];
    
    [self.orderProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.lottSeparatorLine.mas_bottom).offset(__SCALE(17));
        make.height.equalTo(self.mas_height).multipliedBy(0.28f);
    }];
    
    [self.orderMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.orderProgressView.mas_bottom).offset(__SCALE(10.f));
        make.bottom.equalTo(self.lottStoreNameLbl.mas_top);
    }];
    
    [self.lottStoreNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(__SCALE(10.f));
        make.right.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.12f);
        make.bottom.equalTo(self.bottomImgView.mas_top);
    }];
    
    [self.bottomImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(5.f);
    }];
}
- (NSInteger)saleTime{
    
    return self.orderMessageView.saleTime;
}
@end
