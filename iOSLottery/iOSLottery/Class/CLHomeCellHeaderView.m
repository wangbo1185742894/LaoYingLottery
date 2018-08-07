//
//  CLHomeCellHeaderView.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeCellHeaderView.h"
#import "CLConfigMessage.h"

@interface CLHomeCellHeaderView ()

@property (nonatomic, strong) UIView* redFlagImgView;
@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UIView* grayLine;

@end

@implementation CLHomeCellHeaderView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.grayLine = [[UIView alloc] init];
        self.grayLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        self.redFlagImgView = [[UIView alloc] init];
        self.redFlagImgView.backgroundColor = THEME_COLOR;
        
        self.titleLbl = [[UILabel alloc] init];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.font = FONT_SCALE(13);
        self.titleLbl.textColor = UIColorFromRGB(0x333333);
        
        [self.contentView addSubview:self.grayLine];
        [self.contentView addSubview:self.redFlagImgView];
        [self.contentView addSubview:self.titleLbl];
        
        [self.grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(__SCALE(10.f));
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView);
            make.top.equalTo(self.grayLine.mas_bottom);
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        }];
        
        [self.redFlagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.width.mas_equalTo(__SCALE(2.f));
            make.height.mas_equalTo(__SCALE(20.f));
            make.centerY.equalTo(self).offset(__SCALE(2.5));
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    self.titleLbl.text = title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
