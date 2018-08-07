//
//  CLSFCDrawNoticeCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/28.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSFCDrawNoticeCell.h"
#import "CLConfigMessage.h"

#import "CLSFCDrawNoticeView.h"

#import "CLAwardVoModel.h"

@interface CLSFCDrawNoticeCell ()

@property (nonatomic, strong) CLSFCDrawNoticeView *drawNoticeView;

@end

@implementation CLSFCDrawNoticeCell

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView
{

    static NSString *cellID = @"CLSFCDrawNoticeCell";
    CLSFCDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[CLSFCDrawNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      

        [self p_addSubviews];
        [self p_addConstraints];
    }
    return self;
}

- (void)p_addSubviews
{
    [self.contentView addSubview:self.drawNoticeView];
}

- (void)p_addConstraints
{

    [self.drawNoticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.contentView);
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

#pragma mark ----- lazyLoad ------
- (CLSFCDrawNoticeView *)drawNoticeView
{

    if (_drawNoticeView == nil) {
        
        _drawNoticeView = [[CLSFCDrawNoticeView alloc] initWithFrame:(CGRectZero)];
    }
    return _drawNoticeView;
}

@end
