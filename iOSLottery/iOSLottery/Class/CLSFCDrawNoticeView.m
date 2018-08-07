//
//  CLSFCDrawNoticeView.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/28.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCDrawNoticeView.h"

#import "CLConfigMessage.h"

#import "CLAwardVoModel.h"
@interface CLSFCDrawNoticeView ()

@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation CLSFCDrawNoticeView

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self p_createTagLabels];
    }
    return self;
}

- (void)p_createTagLabels
{
    
    CGFloat width = CL__SCALE(18.f);
    CGFloat height = CL__SCALE(30.f);
    CGFloat margin = CL__SCALE(5.f);
    
    for (int i = 0; i < 14; i ++) {
        
        UILabel *label = [self p_createTagLabel];
        
        label.frame = CGRectMake(i * (width + margin) , CL__SCALE(19.f), width, height);
        
        [self.baseView addSubview:label];
        [self.labelArray addObject:label];
    }
    
}

- (UILabel *)p_createTagLabel
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRectZero)];
    
    label.textColor = UIColorFromRGB(0xFFFFFF);
    label.backgroundColor = UIColorFromRGB(0x3FA974);
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = FONT_SCALE(17.f);
    return label;
}


- (void)setData:(CLAwardVoModel *)data
{
    [super setData:data];

    NSArray *numbers = [data.winningNumbers componentsSeparatedByString:@" "];
    
    if (numbers.count != 14) return;
    
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
       
        label.text = numbers[idx];
    }];
}

- (void)setOnlyShowNumberText:(BOOL)show
{
    
    [self.labelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
       
        label.textColor = show ? UIColorFromRGB(0xE63222) : UIColorFromRGB(0xFFFFFF);
        label.backgroundColor = show ? [UIColor clearColor] : UIColorFromRGB(0x3FA974);
    }];
}

- (void)setShowInCenter:(BOOL)show
{

    if (!show) return;
    
//    CGFloat width = CL__SCALE(18.f);
//    CGFloat height = CL__SCALE(30.f);
//    CGFloat margin = CL__SCALE(5.f);
//    
//    [self.labelArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
//       
//       label.frame = CGRectMake(idx * (width + margin) +  , CL__SCALE(19.f), width, height);
//    }];
    
    [self.baseView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(CL__SCALE(29.f));
    }];
}


- (NSMutableArray *)labelArray
{
    
    if (_labelArray == nil) {
        
        _labelArray = [NSMutableArray new];
    }
    return _labelArray;
}
@end
