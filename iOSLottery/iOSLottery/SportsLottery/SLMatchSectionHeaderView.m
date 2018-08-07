//
//  SLMatchSectionHeaderView.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLMatchSectionHeaderView.h"
#import "SLConfigMessage.h"
#import "SLMatchBetGroupModel.h"
@interface SLMatchSectionHeaderView ()

@property (nonatomic, strong) UILabel *mainLable;

@property (nonatomic, strong) CALayer *arrowLayer;

@property (nonatomic, strong) UIView *bottomLineView;


@end


@implementation SLMatchSectionHeaderView

+ (SLMatchSectionHeaderView *)createMatchSecionHeaderViewWithTableView:(UITableView *)tableView
{

    static NSString *idHeadView = @"SLMatchSectionHeaderView";
    SLMatchSectionHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idHeadView];
    
    if (headView == nil) {
        
        headView = [[SLMatchSectionHeaderView alloc] initWithReuseIdentifier:idHeadView];
    }
    
    return headView;

}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self addSubviews];
        [self addConstraints];
        
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xFFFFFF);
    
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




- (void)setHeaderModel:(SLMatchBetGroupModel *)headerModel
{

    _headerModel = headerModel;
    
    if (headerModel.title.length > 0) {
        if ([headerModel.title rangeOfString:@"%s"].location != NSNotFound) {
            
            NSString *str = [headerModel.title stringByReplacingOccurrencesOfString:@"%s" withString:@"%zi"];
            self.mainLable.text = [NSString stringWithFormat:str, headerModel.matches.count];
        }
    }else{
        
        self.mainLable.text = @"";
    }
    
    if (!headerModel.isVisible) {
        
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    }else{
        
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI * 2, 1, 0, 0);
    }
    
}

- (void)tapSelf
{
    //改变是否展开状态
    self.headerModel.visible = !self.headerModel.isVisible;
    
    //刷新tableView
    !self.clickSectionHeadviewBlock ? nil : self.clickSectionHeadviewBlock(self);
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
