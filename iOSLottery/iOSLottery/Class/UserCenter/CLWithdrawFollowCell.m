//
//  CLWithdrawFollowCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/13.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawFollowCell.h"
#import "CLConfigMessage.h"
#import "CLWithdrawFollowModel.h"

@interface CLWithdrawFollowCell ()

@property (nonatomic, strong) UILabel* timeLbl;
@property (nonatomic, strong) UILabel* cashLbl;
@property (nonatomic, strong) UILabel* stateLbl;

@property (nonatomic, strong) UIView* lineView;
@end

@implementation CLWithdrawFollowCell

+ (CGFloat) cellHeight {
    
    return __SCALE(44.f);
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

/* 未审核  已批准 未通过 已到账   0123  */

- (void)configureWithFollow:(CLWithdrawFollowModel*)follow {
    
    self.timeLbl.text = follow.times;
    self.cashLbl.text = [NSString stringWithFormat:@"%@元",follow.amount];
    self.stateLbl.text = follow.ratify_status_str;
    
    if (follow.ratify_status == 2) {
        self.stateLbl.textColor = UIColorFromRGB(0x666666);
    } else if (follow.ratify_status == 3) {
        self.stateLbl.textColor = UIColorFromRGB(0xe00000);
    } else{
        self.stateLbl.textColor = LINK_COLOR;
    }
}

- (void)createUI {
    self.timeLbl = [[UILabel alloc] init];
    self.timeLbl.backgroundColor = [UIColor clearColor];
    self.timeLbl.font = FONT_SCALE(13);
    self.timeLbl.textColor = UIColorFromRGB(0x333333);
    self.timeLbl.textAlignment = NSTextAlignmentLeft;
    
    self.cashLbl = [[UILabel alloc] init];
    self.cashLbl.backgroundColor = [UIColor clearColor];
    self.cashLbl.font = FONT_SCALE(13);
    self.cashLbl.textColor = UIColorFromRGB(0x333333);
    self.cashLbl.textAlignment = NSTextAlignmentCenter;
    
    self.stateLbl = [[UILabel alloc] init];
    self.stateLbl.backgroundColor = [UIColor clearColor];
    self.stateLbl.font = FONT_SCALE(13);
    self.stateLbl.textColor = [UIColor redColor];
    self.stateLbl.textAlignment = NSTextAlignmentRight;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self.contentView addSubview:self.timeLbl];
    [self.contentView addSubview:self.cashLbl];
    [self.contentView addSubview:self.stateLbl];
    [self.contentView addSubview:self.lineView];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.cashLbl.mas_left);
    }];
    
    [self.cashLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLbl.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.stateLbl.mas_left);
        make.width.equalTo(self.timeLbl);
    }];
    
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cashLbl.mas_right);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
        make.width.equalTo(self.cashLbl);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
