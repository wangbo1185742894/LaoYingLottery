//
//  CLLotteryDetailTableFooterView.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/19.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryDetailTableFooterView.h"
#import "CLConfigMessage.h"
@interface CLLotteryDetailTableFooterView ()

@property (nonatomic, strong) UILabel *contenLabel;
@property (nonatomic, strong) UIImageView *topLineImageView;
@property (nonatomic, strong) UIImageView *bottomImageView;

@end
@implementation CLLotteryDetailTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contenLabel];
        [self addSubview:self.topLineImageView];
        [self addSubview:self.bottomImageView];
        [self.topLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(__SCALE(.5f));
        }];
        
        [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLineImageView.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(__SCALE(40.f));
            make.bottom.equalTo(self.bottomImageView.mas_top);
        }];
        
        [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.equalTo(self);
            make.height.mas_equalTo(__SCALE(5.f));
        }];
        
    }
    return self;
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)contenLabel{
    
    if (!_contenLabel) {
        _contenLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contenLabel.text = @"您还没有选号，机选一注天赐福气吧！";
        _contenLabel.font = FONT_SCALE(14);
        _contenLabel.textColor = UIColorFromRGB(0x666666);
        _contenLabel.backgroundColor = UIColorFromRGB(0xffffff);
        _contenLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contenLabel;
}
- (UIImageView *)topLineImageView{
    
    if (!_topLineImageView) {
        _topLineImageView = [[UIImageView alloc] init];
        _topLineImageView.image = [UIImage imageNamed:@"lotteryImaginaryLine.png"];
        _topLineImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topLineImageView;
}
- (UIImageView *)bottomImageView{
    
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bottomImageView.image = [UIImage imageNamed:@"lotteryWaveLine.png"];
    }
    return _bottomImageView;
}
@end
