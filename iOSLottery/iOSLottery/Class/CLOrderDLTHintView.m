//
//  CLOrderDLTHintView.m
//  iOSLottery
//
//  Created by 小铭 on 2018/5/3.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import "CLOrderDLTHintView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"

@interface CLOrderDLTHintView()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) CLOrderDLTHintSTView *topView;
@property (nonatomic, strong) CLOrderDLTHintSView *bottomView;

@end

@implementation CLOrderDLTHintView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        self.topView.hidden = YES;
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(CL__SCALE(10));
            make.right.equalTo(self.contentView).offset(-CL__SCALE(10));
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(CL__SCALE(10));
            make.bottom.equalTo(self.contentView).offset(-CL__SCALE(10));
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CL__SCALE(20));
            make.bottom.equalTo(self);
            make.height.mas_equalTo(CL__SCALE(10));
            make.width.mas_equalTo(CL__SCALE(15));
        }];
    }
    return self;
}

- (void)setIsTop:(BOOL)isTop {
    _isTop = isTop;
    if (isTop) {
        self.topView.hidden = YES;
        self.bottomView.hidden = NO;
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CL__SCALE(20));
            make.bottom.equalTo(self);
            make.height.mas_equalTo(CL__SCALE(10));
            make.width.mas_equalTo(CL__SCALE(15));
        }];
    } else {
        self.topView.hidden = NO;
        self.bottomView.hidden = YES;
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.top.equalTo(self.topView.mas_bottom);
        }];
    
        [self.topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CL__SCALE(20));
            make.top.equalTo(self);
            make.height.mas_equalTo(CL__SCALE(10));
            make.width.mas_equalTo(CL__SCALE(15));
        }];
    }
    [self needsUpdateConstraints];
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = UIColorFromRGBandAlpha(0x000000, 0.7);
        _contentView.layer.cornerRadius = CL__SCALE(6);
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"以下情况将分批出票：";
        [_titleLabel sizeToFit];
        _titleLabel.font = FONT_SCALE(13);
        _titleLabel.textColor = UIColorFromRGB(0xffffff);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"1.单式投注，每张票最多允许 5注单式，超出后分批出票\n2.复式投注，每张票只允许有1注复式，超出后分批出票\n3.单式投注与复式投注同时选择时，分批出票\n4.倍数超出99倍后分批出票\n5.单张票基本投注最大金额20000元，追加投注最大金额30000元，超出后分票出票";
        [_contentLabel sizeToFit];
        _contentLabel.font = FONT_SCALE(11);
        _contentLabel.textColor = UIColorFromRGB(0xffffff);
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (CLOrderDLTHintSView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[CLOrderDLTHintSView alloc] init];
    }
    return _bottomView;
}

- (CLOrderDLTHintSTView *)topView
{
    if (!_topView) {
        _topView = [[CLOrderDLTHintSTView alloc] init];
    }
    return _topView;
}

@end


@interface CLOrderDLTHintSView()

@end

@implementation CLOrderDLTHintSView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    
    
    //定义画图的path
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    
    //path移动到开始画图的位置
    
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    
    //从开始位置画一条直线到（rect.origin.x + rect.size.width， rect.origin.y）
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
    
    //再从rect.origin.x + rect.size.width， rect.origin.y））画一条线到(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    
    
    
    //关闭path
    
    [path closePath];
    
    //三角形内填充颜色
    
    [UIColorFromRGBandAlpha(0x000000, 0.7) setFill];
    
    [path fill];
    
    //    //三角形的边框为红色
    
    //    [[UIColor clearColor] setStroke];
    
    //    [path stroke];
    
}
@end


@interface CLOrderDLTHintSTView()

@end

@implementation CLOrderDLTHintSTView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    
    
    
    //定义画图的path
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    
    //path移动到开始画图的位置
    
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)];
    
    //从开始位置画一条直线到（rect.origin.x + rect.size.width， rect.origin.y）
    
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
    
    //再从rect.origin.x + rect.size.width， rect.origin.y））画一条线到(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height)];
    
    
    
    //关闭path
    
    [path closePath];
    
    //三角形内填充颜色
    
    [UIColorFromRGBandAlpha(0x000000, 0.7) setFill];
    
    [path fill];
    
    //    //三角形的边框为红色
    
    //    [[UIColor clearColor] setStroke];
    
    //    [path stroke];
    
}
@end
