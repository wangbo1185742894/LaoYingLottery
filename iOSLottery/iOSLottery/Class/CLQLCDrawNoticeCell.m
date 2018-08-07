//
//  CLQLCDrawNoticeCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLQLCDrawNoticeCell.h"

#import "CLConfigMessage.h"

#import "CLQLCDrawNoticeView.h"


@interface CLQLCDrawNoticeCell ()

@property (nonatomic, strong) CLQLCDrawNoticeView *drawNoticeView;

@end

@implementation CLQLCDrawNoticeCell

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView
{

    static NSString *cellID = @"CLQLCDrawNoticeCell";
    CLQLCDrawNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[CLQLCDrawNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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

#pragma mark ------- lazyLoad -------

- (CLQLCDrawNoticeView *)drawNoticeView
{
    
    if (_drawNoticeView == nil) {
        
        _drawNoticeView = [[CLQLCDrawNoticeView alloc] initWithFrame:(CGRectZero)];
    }
    return _drawNoticeView;
}
@end
