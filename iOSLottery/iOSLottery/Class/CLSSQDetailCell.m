//
//  CLSSQDetailCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLSSQDetailCell.h"
#import "CLConfigMessage.h"
#import "CLSSQDetailModel.h"
#import "UILabel+CLAttributeLabel.h"
@interface CLSSQDetailCell ()

@property (nonatomic, strong) UILabel *numberLabel;//投注号
@property (nonatomic, strong) UILabel *typeLabel;//类型
@property (nonatomic, strong) UILabel *noteLabel;//注数
@property (nonatomic, strong) UILabel *moneyLabel;//总金额
@property (nonatomic, strong) UIButton *deleteButton;//删除一条按钮
@property (nonatomic, strong) UIImageView *topImageView;

@end

@implementation CLSSQDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.topImageView];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.typeLabel];
        [self.contentView addSubview:self.noteLabel];
        [self.contentView addSubview:self.moneyLabel];
        [self.contentView addSubview:self.deleteButton];
        self.backgroundColor = UIColorFromRGB(0xffffff);
        [self configConstraint];
        
    }
    return self;
}
#pragma mark ------ public Mothed ------
- (void)assignBetDetailCellWithData:(id)data{
    
    CLSSQDetailModel *model = data;
    self.numberLabel.text = model.betNumber;
    
    NSRange range = [model.betNumber rangeOfString:@"*"];
    
    NSString *betNumber = [model.betNumber stringByReplacingOccurrencesOfString:@"*" withString:@" "];
    
    AttributedTextParams *param = [AttributedTextParams attributeRange:NSMakeRange(range.location, betNumber.length - range.location) Color:UIColorFromRGB(0x295fcc)];
    [self.numberLabel attributeWithText:betNumber controParams:@[param]];
    
    self.typeLabel.text = model.betType;
    self.noteLabel.text = model.betNote;
    self.moneyLabel.text = model.betMoney;
}
#pragma mark ------ private Mothed ------
- (void)configConstraint{
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.width.height.mas_equalTo(__SCALE(20.f));
        make.centerY.equalTo(self.contentView);
    }];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right).offset(__SCALE(10.f));
        make.right.equalTo(self.contentView).offset(__SCALE(- 30.f));
        make.top.equalTo(self.topImageView.mas_bottom).offset(__SCALE(10.f));
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(__SCALE(3.f));
        make.bottom.equalTo(self.contentView).offset(__SCALE(- 5.f));
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.typeLabel);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.noteLabel);
        make.left.equalTo(self.noteLabel.mas_right).offset(__SCALE(3.f));
    }];
}
#pragma mark ------ event response ------
- (void)deleteButtonOnClick:(UIButton *)btn{
    
    self.deleteCellBlock ? self.deleteCellBlock() : nil;
    
}

#pragma mark ------ getter mothed ------
- (UILabel *)numberLabel{
    
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.text = @"1 2 3";
        _numberLabel.numberOfLines = 0;
        _numberLabel.textColor = THEME_COLOR;
        _numberLabel.font = FONT_SCALE(15);
    }
    return _numberLabel;
}
- (UILabel *)typeLabel{
    
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.text = @"三同号单选";
        _typeLabel.textColor = UIColorFromRGB(0x333333);
        _typeLabel.font = FONT_SCALE(12);
    }
    return _typeLabel;
}
- (UILabel *)noteLabel{
    
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _noteLabel.text = @"1注";
        _noteLabel.textColor = UIColorFromRGB(0x333333);
        _noteLabel.font = FONT_SCALE(12);
    }
    return _noteLabel;
}
- (UILabel *)moneyLabel{
    
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyLabel.text = @"2元";
        _moneyLabel.textColor = UIColorFromRGB(0x333333);
        _moneyLabel.font = FONT_SCALE(13);
    }
    return _moneyLabel;
}
- (UIButton *)deleteButton{
    
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deleteButton setImage:[UIImage imageNamed:@"lotteryDetailDelete.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}
- (UIImageView *)topImageView{
    
    if(!_topImageView){
        
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.image = [UIImage imageNamed:@"lotteryImaginaryLine.png"];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
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
