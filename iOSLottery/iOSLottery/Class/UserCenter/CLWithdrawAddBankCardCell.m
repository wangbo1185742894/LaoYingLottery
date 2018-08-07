//
//  CLWithdrawAddBankCardCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/15.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawAddBankCardCell.h"
#import "CLConfigMessage.h"
#import "CLUserCenterPageConfigure.h"
#import "CLAllJumpManager.h"
@interface CLWithdrawAddBankCardCell ()

@property (nonatomic, strong) UIButton* button;

@end

@implementation CLWithdrawAddBankCardCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"accountAddCard"] forState:UIControlStateNormal];
        self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [self.button addTarget:self action:@selector(tapAddBankCard) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.button];
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

- (void)tapAddBankCard{
    
    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"CLAddBankCardViewController_push/1//"]];
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
