//
//  CLSettingLogoutCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSettingLogoutCell.h"
#import "CLConfigMessage.h"


@interface CLSettingLogoutCell ()

@property (nonatomic, strong) UILabel* middleLbl;

@end

@implementation CLSettingLogoutCell

+ (CLSettingLogoutCell*)logoutCellInitWithTableView:(UITableView *)tableView
{
    CLSettingLogoutCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CQUserCenterSettingTableViewLogOutCellId"];
    if (!cell) {
        cell = [[CLSettingLogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CQUserCenterSettingTableViewLogOutCellId"];
    }
    
    return cell;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.middleLbl = [[UILabel alloc] init];
        self.middleLbl.backgroundColor = [UIColor clearColor];
        self.middleLbl.font = FONT_SCALE(13);
        self.middleLbl.textAlignment = NSTextAlignmentCenter;
        self.middleLbl.textColor = UIColorFromRGB(0x000000);
        self.middleLbl.text = @"退出登录";
        
        [self.contentView addSubview:self.middleLbl];
        
        [self.middleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
        
    }
    return self;
}

@end
