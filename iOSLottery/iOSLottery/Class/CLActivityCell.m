//
//  CLActivityCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLActivityCell.h"

#import "CLConfigMessage.h"

#import "CLActivityModel.h"

#import "UIImageView+CQWebImage.h"

@interface CLActivityCell ()

/**
 标题label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 活动时间label
 */
@property (nonatomic, strong) UILabel *timeLabel;

/**
 标记image:用户判断用户是否参加
 */
@property (nonatomic, strong) UIImageView *flagImage;

/**
 活动链接图片
 */
@property (nonatomic, strong) UIImageView *activityImage;

/**
 白色背景图
 */
@property (nonatomic, strong) UIView *backView;

@end

@implementation CLActivityCell

#pragma mark --- Class Methods ---

+ (CLActivityCell *)activityCellCreateWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CLActivityCell";
    
    CLActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[CLActivityCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //添加子控件
        [self setUpContentView];
        
        //设置约束
        [self setUpConstraints];
        
    }
    return self;
}

- (void)setUpContentView
{
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.flagImage];
    [self.contentView addSubview:self.activityImage];
}
#pragma mark --- LayoutSubviews ---

- (void)setUpConstraints
{
    WS(weakself);
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(weakself.contentView.mas_top).with.offset(__SCALE(4.f));
        make.left.equalTo(weakself.contentView.mas_left).with.offset(__SCALE(5.f));
        make.right.equalTo(weakself.contentView.mas_right).with.offset(__SCALE(-5.f));
        make.bottom.equalTo(weakself.contentView.mas_bottom).with.offset(__SCALE(-4.f));
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView.mas_top).with.offset(__SCALE(10.f));
        make.left.equalTo(self.backView.mas_left).with.offset(__SCALE(10.f));
        make.right.lessThanOrEqualTo(self.flagImage.mas_left);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(__SCALE(3.f));
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.lessThanOrEqualTo(self.flagImage.mas_left);
    }];
    
    [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView.mas_top);
        make.width.mas_equalTo(__SCALE(40.f));
        make.height.mas_equalTo(__SCALE(19.f));
        make.right.equalTo(self.backView.mas_right);
        
    }];
    
    [self.activityImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(__SCALE(5));
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.backView.mas_right).with.offset(__SCALE(-10.f));
        make.bottom.equalTo(self.backView.mas_bottom).with.offset(__SCALE(-8.f));
        make.height.equalTo(self.activityImage.mas_width).multipliedBy(5.0/16);
    }];

}

#pragma mark --- Set Model ---

- (void)setModel:(CLActivityModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.shareTitle;
    
    self.timeLabel.text = model.activityDate;
    
    if (model.isJoin == 1) {
        
        self.flagImage.hidden = NO;
        
    }else{
        
        self.flagImage.hidden = YES;
    }
    
    [self.activityImage setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    
}

#pragma mark --- lazyLoad ---

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"";
        //_titleLabel.backgroundColor = [UIColor blueColor];
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = FONT_SCALE(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.text = @"";
        //_timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.textColor = UIColorFromRGB(0x999999);
        _timeLabel.font = FONT_SCALE(12);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _timeLabel;
}

- (UIImageView *)flagImage
{
    if (_flagImage == nil) {
        
        _flagImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _flagImage.image = [UIImage imageNamed:@"activity_isjoin"];
    }
    
    return _flagImage;

}

- (UIImageView *)activityImage
{
    if (_activityImage == nil) {
        
        _activityImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        //_activityImage.backgroundColor = [UIColor blackColor];
    }
    return _activityImage;
}

- (UIView *)backView
{
    if (_backView == nil) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    
    return _backView;
}


@end
