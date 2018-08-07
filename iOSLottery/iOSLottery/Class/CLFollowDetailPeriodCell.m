//
//  CLFollowDetailPeriodCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailPeriodCell.h"
#import "CLConfigMessage.h"
#import "CLFollowDetailProgramModel.h"
#import "CLOrderStatus.h"
@interface CLFollowDetailPeriodCell ()

@property (nonatomic, strong) UILabel* periodLbl;
@property (nonatomic, strong) UILabel* betCashLbl;
@property (nonatomic, strong) UILabel* stateLbl;
@property (nonatomic, strong) UIView *bottonLine;
@property (nonatomic, strong) UIImageView *arrowImageView;//箭头View


@end

@implementation CLFollowDetailPeriodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.periodLbl = [[UILabel alloc] init];
        self.betCashLbl = [[UILabel alloc] init];
        self.stateLbl = [[UILabel alloc] init];
        self.arrowImageView = [[UIImageView alloc] init];
        self.arrowImageView.image = [UIImage imageNamed:@"homeNextPage.png"];
        self.arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.periodLbl.font = self.betCashLbl.font = self.stateLbl.font = FONT_SCALE(13);
        self.periodLbl.textColor = self.betCashLbl.textColor = self.stateLbl.textColor = UIColorFromRGB(0x333333);
        
        self.stateLbl.textAlignment = NSTextAlignmentRight;
        self.stateLbl.font = FONT_SCALE(12);
        
        self.bottonLine = [[UILabel alloc] init];
        self.bottonLine.backgroundColor = SEPARATE_COLOR;
        [self.contentView addSubview:self.periodLbl];
        [self.contentView addSubview:self.stateLbl];
        [self.contentView addSubview:self.betCashLbl];
        [self.contentView addSubview:self.bottonLine];
        [self.contentView addSubview:self.arrowImageView];
        
        [self.periodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.top.equalTo(self.contentView).offset(__SCALE(10.f));
            make.bottom.equalTo(self.contentView).offset(__SCALE(- 10.f));
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.3f);
        }];
        
        [self.betCashLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.periodLbl.mas_right);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.3f);
        }];
        
        [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.betCashLbl.mas_right);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.arrowImageView.mas_left).offset(__SCALE(- 5.f));
        }];
        
        [self.bottonLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.height.mas_offset(.5f);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView).offset(__SCALE(- 5.f));
            make.centerY.equalTo(self.contentView);
            make.width.height.mas_equalTo(__SCALE(10.f));
        }];
    }
    return self;
}
- (void)assignData:(id)data{
    
    CLFollowDetailProgramModel *proM = data;
    self.periodLbl.text = [NSString stringWithFormat:@"第%@期",proM.periodId];
    self.betCashLbl.text = [NSString stringWithFormat:@"%.f元",proM.orderAmount];
    self.stateLbl.text = proM.orderStatusCn;
    if (proM.click == 1) {
        self.userInteractionEnabled = YES;
        self.arrowImageView.hidden = NO;
    }else{
        self.userInteractionEnabled = NO;
        self.arrowImageView.hidden = YES;
    }
    
    if (proM.prizeStatus == orderPrizeStatusNoBonus) {
        
        self.periodLbl.textColor = UIColorFromRGB(0x999999);
        self.betCashLbl.textColor = UIColorFromRGB(0x999999);
        self.stateLbl.textColor = UIColorFromRGB(0x999999);
    }else if (proM.prizeStatus == orderPrizeStatusNoLottery){
        
        self.periodLbl.textColor = UIColorFromRGB(0x333333);
        self.betCashLbl.textColor = UIColorFromRGB(0x333333);
        self.stateLbl.textColor = UIColorFromRGB(0x333333);
    }else{
        
        self.periodLbl.textColor = THEME_COLOR;
        self.betCashLbl.textColor = THEME_COLOR;
        self.stateLbl.textColor = THEME_COLOR;
    }
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
