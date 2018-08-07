//
//  CLWithdrawBankCardCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawBankCardCell.h"
#import "CLConfigMessage.h"
#import "CLBankCardInfoModel.h"
#import "UIImageView+CQWebImage.h"

@interface CLWithdrawBankCardCell ()

@property (nonatomic, strong) UIImageView* bankCardIcon;
@property (nonatomic, strong) UILabel* bankNameLbl;
@property (nonatomic, strong) UILabel* bankMsgLbl;

@property (nonatomic, strong) UIImageView* selectImgView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CLWithdrawBankCardCell

+ (CGFloat) cellHeight {
    
    return __SCALE(60);
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.bankCardIcon = [[UIImageView alloc] init];
    
    self.bankNameLbl = [[UILabel alloc] init];
    self.bankNameLbl.backgroundColor = [UIColor clearColor];
    self.bankNameLbl.font = FONT_SCALE(14);
    self.bankNameLbl.textColor = [UIColor blackColor];
    
    self.bankMsgLbl = [[UILabel alloc] init];
    self.bankMsgLbl.backgroundColor = [UIColor clearColor];
    self.bankMsgLbl.font = FONT_SCALE(11);
    self.bankMsgLbl.textColor = [UIColor redColor];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self.contentView addSubview:self.bankCardIcon];
    [self.contentView addSubview:self.bankNameLbl];
    [self.contentView addSubview:self.bankMsgLbl];
    [self.contentView addSubview:self.lineView];
    
    [self.bankCardIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10));
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(self.contentView).multipliedBy(.5f);
        make.width.equalTo(self.bankCardIcon.mas_height);
    }];
    
    [self.bankNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankCardIcon.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(.25f);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(20));
    }];
    
    [self.bankMsgLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankNameLbl);
        make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(.75f);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void) configureData:(CLBankCardInfoModel*) infoModel {
    
    self.bankNameLbl.text = [NSString stringWithFormat:@"%@ (%@)",infoModel.bank_short_name,[infoModel.card_no substringFromIndex:infoModel.card_no.length - 4]];
    self.bankMsgLbl.text = infoModel.withdraw_memo;
    [self.bankCardIcon setImageWithURL:[NSURL URLWithString:infoModel.bank_img_url]];
}

#pragma mark - setter

- (void)setCellStyle:(CLWithdrawBankCardCellStyle)cellStyle {
    
    _cellStyle = cellStyle;
    if (_cellStyle == CLWithdrawBankCardCellNormal) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    } else {
        self.accessoryView = self.selectImgView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setIsSelect:(BOOL)isSelect {
    
    self.accessoryView = self.selectImgView;
    [self.selectImgView setImage:[UIImage imageNamed:isSelect?@"accountSel_YES":@"accountSel_NO"]];
}

#pragma mark - getter

- (UIImageView *)selectImgView {
    
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _selectImgView;
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
