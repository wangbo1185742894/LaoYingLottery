//
//  CLAwardDetailBonusCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardDetailBonusCell.h"
#import "CLConfigMessage.h"

@interface CLAwardDetailBonusCell ()

@property (nonatomic, strong) NSMutableArray* views;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *leftLineView;

@property (nonatomic, strong) UIView *rightLineView;

@end

@implementation CLAwardDetailBonusCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.leftLineView];
    [self.contentView addSubview:self.rightLineView];

}

- (void)p_addConstraints
{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(.5f);
    }];
    
    [self.leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView).offset(CL__SCALE(-64.f));
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(.5f);
    }];
    
    [self.rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.contentView).offset(CL__SCALE(64.f));
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(.5f);
    }];
    
}

- (void)setLastLabelColor:(UIColor *)lastLabelColor{
    
    _lastLabelColor = lastLabelColor;
    UILabel *label = [self.views lastObject];
    label.textColor = lastLabelColor;
}

- (void)setCount:(NSInteger)count {
    
    _count = count;
    UILabel* tempLbl;
    if (count % 2 == 0) {
        [self.leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(.5f);
        }];
        self.rightLineView.hidden = YES;
    } else {
        [self.leftLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView).offset(CL__SCALE(-64.f));
            make.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(.5f);
        }];
        self.rightLineView.hidden = YES;
    }
    for (int i = 0; i < count; i++) {
        UILabel* lbl = [[UILabel alloc] init];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.font = FONT_SCALE(12);
        lbl.textColor = UIColorFromRGB(333333);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.tag = i + 1;
        
        [self.contentView addSubview:lbl];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(self.contentView);
            } else {
                if (i == (count - 1)) {
                    make.right.equalTo(self.contentView);
                }
                make.width.equalTo(tempLbl);
                make.left.equalTo(tempLbl.mas_right);
            }
            
            make.top.bottom.equalTo(self.contentView);
        }];
        tempLbl = lbl;
        [self.views addObject:lbl];
        
        lbl = nil;
    }
    [self updateConstraintsIfNeeded];
}

- (void)setIsShowColor:(BOOL)isShowColor {
    
    self.contentView.backgroundColor = isShowColor?[UIColor whiteColor]:UIColorFromRGB(0xFBFBF7);
}

- (void)setIsTitle:(BOOL)isTitle {
    
    [self.views enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.textColor = isTitle?UIColorFromRGB(0x999999):UIColorFromRGB(0x333333);
        if (self.lastLabelColor && !isTitle && idx == self.views.count - 1) {
            
            label.textColor = self.lastLabelColor;
        }
    }];
}
- (void)setHas_BottomLine:(BOOL)has_BottomLine{
    
    _has_BottomLine = has_BottomLine;
    self.lineView.hidden = !has_BottomLine;
}
- (void) configureItems:(NSString *)info {
    
    if (!(info && info.length > 0)) {
        return;
    }
    NSArray *array = [info componentsSeparatedByString:@","];
    if (self.views.count != array.count) {
        return;
    }
    [self.views enumerateObjectsUsingBlock:^(UILabel* label, NSUInteger idx, BOOL * _Nonnull stop) {
        label.text = array[idx];
    }];
}

- (NSMutableArray *)views {
    
    if (!_views) {
        _views = [NSMutableArray new];
    }
    return _views;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _lineView.backgroundColor = SEPARATE_COLOR;
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UIView *)leftLineView
{
    if (!_leftLineView) {
        
        _leftLineView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _leftLineView.backgroundColor = UIColorFromRGB(0xDDDDDD);
    }
    return _leftLineView;
    
}

- (UIView *)rightLineView
{
    if (!_rightLineView) {
        
        _rightLineView = [[UIView alloc] initWithFrame:(CGRectZero)];
        _rightLineView.backgroundColor = SEPARATE_COLOR;

    }
    return _rightLineView;
    
}

@end
