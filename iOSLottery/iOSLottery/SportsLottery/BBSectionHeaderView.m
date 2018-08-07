//
//  BBSectionHeaderView.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBSectionHeaderView.h"

#import "SLConfigMessage.h"

@interface BBSectionHeaderView ()

@property (nonatomic, strong) UILabel *mainLable;

@property (nonatomic, strong) CALayer *arrowLayer;

@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation BBSectionHeaderView

+ (instancetype)createBBSectionHeaderViewWithTableView:(UITableView *)tableView
{
    
    static NSString *idHeadView = @"BBSectionHeaderView";
    BBSectionHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idHeadView];
    
    if (headView == nil) {
        
        headView = [[BBSectionHeaderView alloc] initWithReuseIdentifier:idHeadView];
    }
    
    return headView;
    
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xffffff);
        [self addSubviews];
        [self addConstraints];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
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

- (void)tapSelf
{

    self.visible = !self.isVisible;
    //刷新tableView
    !self.headerBlock ? nil : self.headerBlock(self.isVisible);
}

- (void)returnHeaderTapClick:(BBSectionHeaderBlock)block
{

    self.headerBlock = block;
}

- (void)setVisible:(BOOL)visible
{

    _visible = visible;
    
    if (!self.isVisible) {
        
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    }else{
        
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI * 2, 1, 0, 0);
    }
}

- (void)setHeaderTitle:(NSString *)headerTitle
{
    _headerTitle = headerTitle;
    
    self.mainLable.text = headerTitle;
}


#pragma mark ------------ getter Mothed ------------
- (UILabel *)mainLable{
    
    if (!_mainLable) {
        _mainLable = [[UILabel alloc] init];
        _mainLable.text = @"";
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
        
        _arrowLayer.contents = (id)[UIImage imageNamed:@"play_date_open"].CGImage;
    }
    
    return _arrowLayer;
}
- (UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = SL_UIColorFromRGB(0xece5dd);
    }
    return _bottomLineView;
}


@end
