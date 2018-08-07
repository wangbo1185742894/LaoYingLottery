//
//  CLATDrawNoticeCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLATDrawNoticeCell.h"
#import "CLConfigMessage.h"

#import "CLAwardNumberView.h"
#import "CLAwardNumberNewView.h"

#import "CLAwardVoModel.h"

#import "CLATDrawNoticeView.h"

@interface CLATDrawNoticeCell ()

@property (nonatomic, strong) CLATDrawNoticeView *drawNoticeView;

@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CLATDrawNoticeCell

+ (instancetype)createATDrawNoticeCellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellID = @"CLATDrawNoticeCell";
    CLATDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[CLATDrawNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self p_addSubviews];
        [self p_addConstraints];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)p_addSubviews
{
    
    [self.contentView addSubview:self.drawNoticeView];
    
    [self.contentView addSubview:self.bottomLine];

}

- (void)p_addConstraints
{
    
    [self.drawNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.contentView);
        //make.left.top.equalTo(self.contentView);
    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];

}

- (void)setData:(CLAwardVoModel *)data
{
    [self.drawNoticeView setData:data];
}

- (void)setShowLotteryName:(BOOL)show
{
    [self.drawNoticeView setShowLotteryName:show];
}

- (void)setOnlyShowNumberText:(BOOL)show
{
    [self.drawNoticeView setOnlyShowNumberText:show];
}

#pragma mark ------- lazyLoad -------

- (CLATDrawNoticeView *)drawNoticeView
{

    if (_drawNoticeView == nil) {
        
        _drawNoticeView = [[CLATDrawNoticeView alloc] initWithFrame:(CGRectZero)];
    }
    return _drawNoticeView;
}

- (UIView *)bottomLine
{

    if (_bottomLine == nil) {
        
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLine;
}

@end
