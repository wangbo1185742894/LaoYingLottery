//
//  SLDrawNoticeHeaderView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeHeaderView.h"
#import "SLConfigMessage.h"
#import "SLDrawNoticeGroupModel.h"

@interface SLDrawNoticeHeaderView ()

/**
 标题label
 */
@property (nonatomic, strong) UILabel *mainLable;

/**
 左侧箭头image
 */
@property (nonatomic, strong) UIButton *arrowBtn;

@property (nonatomic, strong) CALayer *arrowLayer;

/**
 底部分割线
 */
@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation SLDrawNoticeHeaderView

+ (instancetype)createDrawNoticeHeaderViewWithTableView:(UITableView *)tableView
{
    
    static NSString *idHeadView = @"SLDrawNoticeHeaderView";
    
    SLDrawNoticeHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idHeadView];
    
    if (headView == nil) {
        
        headView = [[SLDrawNoticeHeaderView alloc] initWithReuseIdentifier:idHeadView];
    }
    return headView;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        
        [self addSubviews];
        [self addConstraints];

        self.contentView.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)addSubviews
{
    
    [self.contentView addSubview:self.mainLable];

    [self.contentView addSubview:self.bottomLineView];
}

- (void)addConstraints
{
    [self.mainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SL__SCALE(10.f));
        make.bottom.equalTo(self.contentView).offset(SL__SCALE(-10.f));
        make.centerX.equalTo(self.contentView);
    }];

    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
    }];
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    [self.layer addSublayer:self.arrowLayer];

}

- (void)setHeaderModel:(SLDrawNoticeGroupModel *)headerModel
{

    _headerModel = headerModel;
    
    if (_headerModel.isNoData && _headerModel.isVisible) {
        
        _bottomLineView.hidden = YES;
        
    }else{
    
        _bottomLineView.hidden = NO;
    }

    //除去"_"
    self.mainLable.text = [headerModel.msg stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    
    if (headerModel.isVisible == YES) {
        
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    }else{
    
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI * 2, 1, 0, 0);
    }
}

- (void)returnHeaderTapClick:(SLDrawNoticeHeaderBlock)block
{

    _headerBlock = block;
}

- (void)tapClick
{

    //展开或关闭分组
    self.headerModel.visible = !self.headerModel.isVisible;;
    
    //刷新tableView
    self.headerBlock ? self.headerBlock() : nil;
}
#pragma mark --- Get Mothed ---

- (UILabel *)mainLable{
    
    if (_mainLable == nil) {
        _mainLable = [[UILabel alloc] init];
        _mainLable.text = @"2017-04-02 周一 13场可投";
        _mainLable.textColor = [UIColor blackColor];
        _mainLable.font = SL_FONT_SCALE(14.f);
    }
    return _mainLable;
}

- (CALayer *)arrowLayer
{
    if (_arrowLayer == nil) {
        
        _arrowLayer = [[CALayer alloc] init];
        
        _arrowLayer.bounds = CGRectMake(0, 0, SL__SCALE(12.f), SL__SCALE(8.f));
        _arrowLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        _arrowLayer.position = CGPointMake(SL__SCALE(351.f), SL__SCALE(20.f));
        _arrowLayer.anchorPoint = CGPointMake(0.5, 0.5);
        
        _arrowLayer.contents = (id)[UIImage imageNamed:@"play_date_close"].CGImage;
    }
    
    return _arrowLayer;
}

- (UIView *)bottomLineView{
    
    if (_bottomLineView == nil) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _bottomLineView;
}


@end
