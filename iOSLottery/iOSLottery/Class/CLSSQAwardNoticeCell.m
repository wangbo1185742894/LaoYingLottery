//
//  CLSSQAwardNoticeCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/8.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQAwardNoticeCell.h"
#import "CLConfigMessage.h"
#import "CLAwardVoModel.h"
@interface CLSSQAwardNoticeCell()

@property (nonatomic, strong) CLSSQAwardNoticeView* ssqView;
@property (nonatomic, strong) UIView* lineView;

@end
@implementation CLSSQAwardNoticeCell

+ (instancetype)createSSQAwardNoticeCellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellID = @"CLSSQAwardNoticeCell";
    CLSSQAwardNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[CLSSQAwardNoticeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ssqView = [[CLSSQAwardNoticeView alloc] init];
        [self.contentView addSubview:self.ssqView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [self.contentView addSubview:self.lineView];
        
        [self.ssqView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

- (void)configureSQQData:(CLAwardVoModel*)data type:(CLAwardLotteryType)type{
    
    self.ssqView.lotteryNameLbl.text = data.gameName;
    self.ssqView.timeLbl.text = data.awardTime;
    self.ssqView.periodLabel.text = [NSString stringWithFormat:@"第%@期", data.periodId];
    self.ssqView.type = type;
    NSString *string = [data.winningNumbers stringByReplacingOccurrencesOfString:@":" withString:@" "];
    self.ssqView.numbers = [string componentsSeparatedByString:@" "];
}

- (void)setIsShowLotteryName:(BOOL)isShowLotteryName {
    
    self.ssqView.isShowLotteryName = isShowLotteryName;
}

- (void)setOnlyShowNumberText:(BOOL)show
{
    [self.ssqView setOnlyShowNumberText:show];
    
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
