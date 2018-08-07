//
//  CKPayHeaderView.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayHeaderView.h"
#import "CKDefinition.h"
#import "Masonry.h"
@class CKTwoLabelView;
@interface CKPayHeaderView ()

@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;

@end

@implementation CKPayHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.redLabel];
        [self addSubview:self.needPayLabel];
        [self.layer addSublayer:self.topLine];
        [self.layer addSublayer:self.bottomLine];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.redLabel];
        [self addSubview:self.needPayLabel];
        [self.layer addSublayer:self.topLine];
        [self.layer addSublayer:self.bottomLine];
    }
    return self;
}
- (void)setHasRedPacket:(BOOL)hasRedPacket{
    
    self.redLabel.hidden = self.needPayLabel.hidden = self.bottomLine.hidden = !hasRedPacket;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, hasRedPacket ? __SCALE(130.f) : __SCALE(45.f));
}

#pragma mark ------------ getter Mothed ------------
- (CKTwoLabelView *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[CKTwoLabelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(40.f))];
        _titleLabel.leftLabel.text = @"支付总额：";
    }
    return _titleLabel;
}
- (CALayer *)topLine{
    
    if (!_topLine) {
        _topLine = [[CALayer alloc] init];
        _topLine.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), SCREEN_WIDTH, __SCALE(5.f));
    }
    return _topLine;
}
- (CKTwoLabelView *)redLabel{
    
    if (!_redLabel) {
        _redLabel = [[CKTwoLabelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLine.frame), SCREEN_WIDTH, CGRectGetHeight(self.titleLabel.frame))];
        _redLabel.leftLabel.text = @"红包抵扣：";
        WS(_weakSelf)
        _redLabel.onClickBlock = ^(){
           
            !_weakSelf.clickRedBlock ? : _weakSelf.clickRedBlock();
        };
        _redLabel.hasArrow = YES;
        _redLabel.hasLine = YES;
    }
    return _redLabel;
}

- (CKTwoLabelView *)needPayLabel{
    
    if (!_needPayLabel) {
        _needPayLabel = [[CKTwoLabelView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.redLabel.frame), SCREEN_WIDTH, CGRectGetHeight(self.titleLabel.frame))];
        _needPayLabel.leftLabel.text = @"还需支付：";
        _needPayLabel.rightLabel.textColor = UIColorFromRGB(0xd21100);
    }
    return _needPayLabel;
}
- (CALayer *)bottomLine{
    
    if (!_bottomLine) {
        _bottomLine = [[CALayer alloc] init];
        _bottomLine.frame = CGRectMake(0, CGRectGetMaxY(self.needPayLabel.frame), SCREEN_WIDTH, __SCALE(5.f));
    }
    return _bottomLine;
}
    
    
@end


@interface CKTwoLabelView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end
@implementation CKTwoLabelView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.lineView];
        [self addSubview:self.arrowImageView];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.centerY.equalTo(self);
        }];
        [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftLabel.mas_right).offset(__SCALE(2.f));
            make.centerY.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self).offset(__SCALE(-10.f));
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(__SCALE(15.f));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapSelf{
    
    !self.onClickBlock ? : self.onClickBlock();
}

- (void)setHasLine:(BOOL)hasLine{
    
    self.lineView.hidden = !hasLine;
}

- (void)setHasArrow:(BOOL)hasArrow{
    
    self.arrowImageView.hidden = !hasArrow;
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)leftLabel{
    
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.text = @"aaaa";
        _leftLabel.textColor = UIColorFromRGB(0x333333);
        _leftLabel.font = FONT_SCALE(13.f);
    }
    return _leftLabel;
}
- (UILabel *)rightLabel{
    
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.text = @"bbbb";
        _rightLabel.textColor = UIColorFromRGB(0x333333);
        _rightLabel.font = FONT_SCALE(13.f);
    }
    return _rightLabel;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xefefef);
        _lineView.hidden = YES;
    }
    
    return _lineView;
}

- (UIImageView *)arrowImageView{
    
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _arrowImageView.image = [UIImage imageNamed:@"ck_sectionRightArrow.png"];
        _arrowImageView.hidden = YES;
    }
    return _arrowImageView;
}

@end
