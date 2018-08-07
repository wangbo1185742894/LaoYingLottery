//
//  CLPayCardListCell.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/4/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLPayCardListCell.h"
#import "CLConfigMessage.h"
#import "CLBankCardInfoModel.h"
#import "UIImageView+CQWebImage.h"
@interface CLPayCardListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIView *bottomLineView;


@end
@implementation CLPayCardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.bottomLineView];
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(__SCALE(33));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(__SCALE(10.f));
        make.left.equalTo(self.iconImageView.mas_right).offset(__SCALE(10.f));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.titleLabel.mas_bottom).offset(__SCALE(10.f));
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(__SCALE(-10.f));
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(__SCALE(-10.f));
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}

- (void)assignData:(CLBankCardInfoModel *)data{
    
    if (data.card_no && data.card_no.length > 4) {
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", data.bank_short_name, [data.card_no substringFromIndex:data.card_no.length - 4]];
    }else{
        self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)", data.bank_short_name, data.card_no];
    }
    
    
    self.contentLabel.text = data.card_type_name;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:data.bank_img_url]];
}

- (void)setSelectedBackCard:(BOOL)selectedBackCard{
    
    if (_selectedBackCard == selectedBackCard) {
        return;
    }
    _selectedBackCard = selectedBackCard;
    self.rightImageView.image = [UIImage imageNamed:_selectedBackCard ? @"accountSel_YES" : @"accountSel_NO"];
    
}
#pragma mark ------------ getter Mothed ------------
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = FONT_SCALE(13.f);
        _titleLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = @"";
        _contentLabel.font = FONT_SCALE(13.f);
        _contentLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _contentLabel;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}
- (UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rightImageView.image = [UIImage imageNamed:@"accountSel_NO"];
    }
    return _rightImageView;
}
- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLineView;
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
