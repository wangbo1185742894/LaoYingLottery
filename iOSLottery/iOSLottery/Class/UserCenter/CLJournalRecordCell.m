//
//  CLJournalRecordCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLJournalRecordCell.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CLUserCashJournalDeailModel.h"

@interface CLJournalRecordCell ()

@property (nonatomic, strong) UIView *line;

@end

@implementation CLJournalRecordCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self createUI];
        
    }
    return self;
}

- (void) createUI {
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    self.timeLbl = [[UILabel alloc] init];
    self.timeLbl.font = FONT_SCALE(13);
    self.timeLbl.backgroundColor = [UIColor clearColor];
    
    self.descLbl = [[UILabel alloc] init];
    self.descLbl.font = FONT_SCALE(13);
    self.descLbl.backgroundColor = [UIColor clearColor];
    self.descLbl.textAlignment = NSTextAlignmentCenter;
    
    self.journalLbl = [[UILabel alloc] init];
    self.journalLbl.font = FONT_SCALE(12);
    self.journalLbl.backgroundColor = [UIColor clearColor];
    self.journalLbl.textAlignment = NSTextAlignmentRight;
    
    self.timeLbl.textColor = self.descLbl.textColor = UIColorFromRGB(0x333333);
    
    [self.contentView addSubview:self.timeLbl];
    [self.contentView addSubview:self.descLbl];
    [self.contentView addSubview:self.journalLbl];
    [self addSubview:self.line];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(__SCALE(10));
        make.width.equalTo(self.contentView).multipliedBy(4.f / 15.f);
    }];
    
    [self.journalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.equalTo(self.contentView).multipliedBy(1.f / 3.f);
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.timeLbl.mas_right);
        make.right.equalTo(self.journalLbl.mas_left);
    }];

    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(.5f);
    }];
}

- (void)configureJournalData:(id)data {
    
    CLUserCashJournalDeailModel *userBalanceModel = (CLUserCashJournalDeailModel *)data;
    self.timeLbl.text = userBalanceModel.times;
    self.descLbl.text = userBalanceModel.type_name;
    self.journalLbl.text = userBalanceModel.amount;
    BOOL isIncome = [userBalanceModel.amount integerValue] > 0;
    self.journalLbl.textColor = isIncome ? THEME_COLOR : UIColorFromRGB(0x3bc824);
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
