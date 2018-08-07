//
//  SLDrawNoticeNoDataCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/6/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLDrawNoticeNoDataCell.h"
#import "SLConfigMessage.h"

@interface SLDrawNoticeNoDataCell ()

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation SLDrawNoticeNoDataCell

+ (id)creatDrawNoticeCellWithTableViewNew:(id)tableView
{

    return [self createDrawNoticeCellWithTableView:tableView];
}

+ (instancetype)createDrawNoticeCellWithTableView:(UITableView *)tableView
{

    static NSString *idcell = @"SLDrawNoticeNoDataCell";
    SLDrawNoticeNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    
    if (!cell) {
        cell = [[SLDrawNoticeNoDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self addSubview:self.noDataLabel];
        
        [self.noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                       
            make.left.right.top.bottom.equalTo(self);
            make.height.mas_equalTo(SL__SCALE(50.f));
        }];
        
        self.contentView.backgroundColor = SL_UIColorFromRGB(0xEEEEEE);
    }
    return self;
}

#pragma mark --- Get Method ---
- (UILabel *)noDataLabel
{

    if (_noDataLabel == nil) {
        
        _noDataLabel = [[UILabel alloc] initWithFrame:(CGRectZero)];
        
        _noDataLabel.text = @"当日无比赛";
        _noDataLabel.textColor = SL_UIColorFromRGB(0x999999);
        
        _noDataLabel.font = SL_FONT_SCALE(12.f);
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noDataLabel;
}

@end
