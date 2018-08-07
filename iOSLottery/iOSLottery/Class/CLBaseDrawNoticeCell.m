//
//  CLBaseDrawNoticeCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseDrawNoticeCell.h"

#import "CLATDrawNoticeCell.h"
#import "CLConfigMessage.h"

#import "CLAwardNumberView.h"
#import "CLAwardNumberNewView.h"

#import "CLAwardVoModel.h"


@interface CLBaseDrawNoticeCell ()

@end

@implementation CLBaseDrawNoticeCell

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView
{

    return [[self alloc] init];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubviews];
        [self addConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)addSubviews
{

    [self addSubview:self.bottomLine];
    
}

- (void)addConstraints
{

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
    
}

- (void)setData:(CLAwardVoModel *)data
{

}

- (void)setShowLotteryName:(BOOL)show
{

    
}

- (void)setOnlyShowNumberText:(BOOL)show
{

}

#pragma mark ------- lazyLoad -------

- (UIView *)bottomLine
{
    
    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLine;
}

@end
