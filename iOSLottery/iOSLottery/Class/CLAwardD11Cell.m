//
//  CLAwardD11Cell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardD11Cell.h"
#import "CLAwardD11View.h"
#import "CLConfigMessage.h"
#import "CLAwardVoModel.h"

@interface CLAwardD11Cell ()

@property (nonatomic, strong) CLAwardD11View* d11View;
@property (nonatomic, strong) UIView* lineView;
@end

@implementation CLAwardD11Cell

+ (CLAwardD11Cell *)createAwardD11CellWithTableView:(UITableView *)tableView
{
    
    static NSString *ID = @"CLAwardD11Cell";
    CLAwardD11Cell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[CLAwardD11Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.d11View = [[CLAwardD11View alloc] init];
        [self.contentView addSubview:self.d11View];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:self.lineView];
        
        [self.d11View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

- (void)configureD11Data:(CLAwardVoModel*)data {
    
    self.d11View.lotteryNameLbl.text = data.gameName;
    self.d11View.timeLbl.text = data.awardTime;
    self.d11View.periodLabel.text = [NSString stringWithFormat:@"第%@期", data.periodId];
    self.d11View.numbers = [data.winningNumbers componentsSeparatedByString:@" "];
}

- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.d11View.isShowLotteryName = isShowLotteryName;
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
