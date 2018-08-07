//
//  CLUserCenterHeaderView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCenterHeaderView.h"
#import "CLConfigMessage.h"
#import "UIImageView+CQWebImage.h"


@interface CLUserCenterHeaderView()

@property (nonatomic, strong) UIImageView* mainBackView;
@property (nonatomic, strong) UIImageView* headerImgView;
@property (nonatomic, strong) UILabel* textLbl;
@property (nonatomic, strong) UIImageView* rightArrowImgView;

@property (nonatomic, strong) UIButton* vcBtn;  //voucher center
@property (nonatomic, strong) UIView *firstLineView;//第一条竖线
@property (nonatomic, strong) UIView *secondLineView;//第二条竖线
@property (nonatomic, strong) UIButton* dfBtn;  //提现
@property (nonatomic, strong) UIView *redBaseView;//买红包的底层View
@property (nonatomic, strong) UIButton* reBtn;  //red envelope  红包

@property (nonatomic, strong) UIView* funcView;

@property (nonatomic, strong) UITapGestureRecognizer* headImgTapGesture;

@end

@implementation CLUserCenterHeaderView {
    
    
    CLUserCenterHeaderActionType __actionType;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
        
        [self.headerImgView setImage:[UIImage imageNamed:@"loginUserHeadImage"]];
        self.textLbl.text = @"快速登录";
        [self.rightArrowImgView setImage:[UIImage imageNamed:@"nextPage"]];
        self.funcView.backgroundColor = [UIColor colorWithWhite:1 alpha:.3];
        
        [self.vcBtn setTitle:@"充值" forState:UIControlStateNormal];
        [self.dfBtn setTitle:@"提现" forState:UIControlStateNormal];
        [self.reBtn setTitle:@"买红包" forState:UIControlStateNormal];
        
        [self.vcBtn addTarget:self action:@selector(voucherCenterAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.dfBtn addTarget:self action:@selector(dfAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.reBtn addTarget:self action:@selector(redEnvelopeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UITapGestureRecognizer* backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction:)];
        [self addGestureRecognizer:backTap];
    }
    return self;
}

- (void) updateData {
    
    self.textLbl.text = self.isLoginning?self.userNickName:@"快速登录";
    self.headerImgView.userInteractionEnabled = self.isLoginning;
    if (self.isLoginning) {
        [self.headerImgView setImageWithURL:[NSURL URLWithString:self.userHeadImg] placeholderImage:[UIImage imageNamed:@"loginUserHeadImage"]];
    }else{
        [self.headerImgView setImage:[UIImage imageNamed:@"loginUserHeadImage"]];
    }

}

//- (void)setRedEnvopleImgUrl:(NSString *)redEnvopleImgUrl {
//    
//    [self.reBtn setImageWithURL:[NSURL URLWithString:redEnvopleImgUrl] placeholderImage:[UIImage imageNamed:@"buyRedPacketDefault.png"]];
//}

#pragma mark - Event

- (void) voucherCenterAction:(id)sender {
    
    __actionType = CLUserCenterHeaderActionTypeVC;
    [self executeCallback];
}

- (void) dfAction:(id)sender {
    
    __actionType = CLUserCenterHeaderActionTypeDF;
    [self executeCallback];
}

- (void) redEnvelopeAction:(id)sender {
    
    __actionType = CLUserCenterHeaderActionTypeRE;
    [self executeCallback];
}

- (void) backTapAction:(id)sender {
    
    __actionType = (self.isLoginning)?CLUserCenterHeaderActionTypePersonalMsg:CLUserCenterHeaderActionTypeLoginning;
    [self executeCallback];
}

- (void) executeCallback {
    
    if ([self.delegate respondsToSelector:@selector(userCenterHeaderActionType:)]) {
        [self.delegate userCenterHeaderActionType:__actionType];
    }
}

#pragma mark - UI


- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.headerImgView.layer.cornerRadius = self.headerImgView.bounds.size.height / 2.f;
    self.headerImgView.layer.masksToBounds = YES;
}

- (void)createViews {
    
    self.layer.masksToBounds = YES;
    self.mainBackView = [[UIImageView alloc] init];
    self.mainBackView.image = [UIImage imageNamed:@"UserCenterHeaderBgImg"];
    self.mainBackView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgView = [[UIImageView alloc] init];
    self.headerImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImgView.layer.borderWidth = 1.f;
    self.headerImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textLbl = [[UILabel alloc] init];
    self.textLbl.textColor = [UIColor whiteColor];
    self.rightArrowImgView = [[UIImageView alloc] init];
    self.rightArrowImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.funcView = [[UIView alloc] init];
    self.vcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.reBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.vcBtn.titleLabel.font = self.dfBtn.titleLabel.font = self.reBtn.titleLabel.font = FONT_SCALE(15);
    self.firstLineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.secondLineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.firstLineView.backgroundColor = UIColorFromRGBandAlpha(0xffffff, .2);
    self.secondLineView.backgroundColor = UIColorFromRGBandAlpha(0xffffff, .2);
    self.redBaseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redBaseView.backgroundColor = CLEARCOLOR;
    [self addSubview:self.mainBackView];
    [self addSubview:self.headerImgView];
    [self addSubview:self.textLbl];
    [self addSubview:self.rightArrowImgView];
    [self addSubview:self.funcView];
    [self addSubview:self.redBaseView];
    
    [self addSubview:self.vcBtn];
    [self addSubview:self.dfBtn];
    [self addSubview:self.reBtn];
    
    [self addSubview:self.firstLineView];
    [self addSubview:self.secondLineView];
    [self setConstraint];
}

- (void)setConstraint {
    
    [self.mainBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.funcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self).multipliedBy(.33f);
    }];
    
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self.funcView.mas_top).offset(-15);
        make.width.equalTo(self.headerImgView.mas_height);
    }];

    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImgView.mas_right).offset(20);
        make.centerY.equalTo(self.headerImgView.mas_centerY);
        make.height.mas_offset(30.f);
        make.right.equalTo(self.rightArrowImgView.mas_left);
    }];

    [self.rightArrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.headerImgView.mas_centerY);
        make.width.mas_offset(10);
        make.height.mas_offset(15);
    }];
    
    [self.vcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.funcView);
    }];
    
    [self.dfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vcBtn.mas_right);
        make.top.bottom.equalTo(self.funcView);
        make.width.equalTo(self.vcBtn);
    }];
    
    [self.reBtn mas_makeConstraints:^(MASConstraintMaker *make) {
     
        make.left.equalTo(self.dfBtn.mas_right);
        make.top.bottom.right.equalTo(self.funcView);
        make.width.equalTo(self.dfBtn);
    }];
    [self.firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.vcBtn.mas_right);
        make.top.equalTo(self.vcBtn).offset(__SCALE(10));
        make.bottom.equalTo(self.vcBtn).offset(- __SCALE(10));
        make.width.mas_equalTo(.5f);
    }];
    [self.secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.dfBtn.mas_right);
        make.top.equalTo(self.vcBtn).offset(__SCALE(10));
        make.bottom.equalTo(self.vcBtn).offset(- __SCALE(10));
        make.width.mas_equalTo(.5f);
    }];
}

- (void)setIsShowBottomView:(BOOL)isShowBottomView{
    self.funcView.hidden = !isShowBottomView;
    self.vcBtn.hidden = !isShowBottomView;
    self.dfBtn.hidden = !isShowBottomView;
    self.reBtn.hidden = !isShowBottomView;
    self.firstLineView.hidden = !isShowBottomView;
    self.secondLineView.hidden = !isShowBottomView;
}

- (void)dealloc {
    
    self.delegate = nil;
    
}

@end


