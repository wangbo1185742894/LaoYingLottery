//
//  CLWithdrawDetailCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawDetailCell.h"
#import "CLConfigMessage.h"
#import "CLWithdrawDetailContent.h"

@interface CLWithdrawDetailCell ()

@property (nonatomic, strong) UILabel* leftLbl;
@property (nonatomic, strong) UILabel* rightLbl;

@end

@implementation CLWithdrawDetailCell

+ (instancetype)createDetailCellWithTableView:(UITableView *)tableView withData:(id)data{
    static NSString *idCell = @"CLWithdrawDetailCellId";
    CLWithdrawDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (!cell) {
        cell = [[CLWithdrawDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
    }
    [cell configCellWithData:data];
    return cell;
}

- (void)configCellWithData:(CLWithdrawDetailContent*)data {
    
    self.leftLbl.text = data.title;
    self.rightLbl.text = data.content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.leftLbl = [[UILabel alloc] init];
        self.leftLbl.backgroundColor = [UIColor clearColor];
        self.leftLbl.textColor = UIColorFromRGB(0x999999);
        self.leftLbl.font = FONT_SCALE(13);
        
        self.rightLbl = [[UILabel alloc] init];
        self.rightLbl.backgroundColor = [UIColor clearColor];
        self.rightLbl.textColor = UIColorFromRGB(0x999999);
        self.rightLbl.font = FONT_SCALE(13);
        self.rightLbl.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:self.leftLbl];
        [self.contentView addSubview:self.rightLbl];
        
        [self.leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.rightLbl.mas_left);
        }];
        
        [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftLbl.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.equalTo(self.leftLbl.mas_width);
        }];
    }
    return self;
}


@end
