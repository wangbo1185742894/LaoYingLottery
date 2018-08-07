//
//  SLAllOddsUnsaleCell.m
//  SportsLottery
//
//  Created by huangyuchen on 2017/5/25.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "SLAllOddsUnsaleCell.h"
#import "SLConfigMessage.h"

@interface SLAllOddsUnsaleCell ()

/**
 未开售label
 */
@property (nonatomic, strong) UILabel *unsaleLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *danGuanImageView;

@end

@implementation SLAllOddsUnsaleCell


+ (instancetype)createAllOddsUnsaleCellWithTableView:(UITableView *)tableView
{

    static NSString *idcell = @"SLAllOddsUnsaleCell";
    
    SLAllOddsUnsaleCell *cell = [tableView dequeueReusableCellWithIdentifier:idcell];
    
    if (!cell) {
        cell = [[SLAllOddsUnsaleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idcell];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        self.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self addSubviews];
        
        [self addConstraints];

    }
    return self;
}

- (void)addSubviews
{
    [self.contentView addSubview:self.unsaleLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.danGuanImageView];
    
}

- (void)addConstraints
{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(SL__SCALE(10.f));
        make.top.equalTo(self.contentView).offset(SL__SCALE(10.f));
    }];
    [self.danGuanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel.mas_right).offset(SL__SCALE(5.f));
        make.centerY.equalTo(self.titleLabel);
    }];
    
    
    [self.unsaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(SL__SCALE(-10.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(SL__SCALE(6.f));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(SL__SCALE(35.f));
    }];
    
}
- (void)setTitleText:(NSString *)titleText{
    
    self.titleLabel.text = titleText;
}

- (void)setIsDanGuan:(BOOL)isDanGuan{
    
    self.danGuanImageView.hidden = !isDanGuan;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = SL_UIColorFromRGB(0x333333);
        _titleLabel.font = SL_FONT_SCALE(12.f);
    }
    return _titleLabel;
}

- (UIImageView *)danGuanImageView{
    
    if (!_danGuanImageView) {
        _danGuanImageView = [[UIImageView alloc] init];
        _danGuanImageView.contentMode = UIViewContentModeScaleAspectFit;
        _danGuanImageView.image = [UIImage imageNamed:@"allOddsDanGuan.png"];
    }
    return _danGuanImageView;
}

- (UILabel *)unsaleLabel{
    
    if (!_unsaleLabel) {
        _unsaleLabel = [[UILabel alloc] init];
        _unsaleLabel.backgroundColor = SL_UIColorFromRGB(0xffffff);
        _unsaleLabel.text = @"未开售";
        _unsaleLabel.textColor = SL_UIColorFromRGB(0x999999);
        _unsaleLabel.font = SL_FONT_SCALE(12.f);
        _unsaleLabel.textAlignment = NSTextAlignmentCenter;
        _unsaleLabel.layer.borderColor = SL_UIColorFromRGB(0xece5dd).CGColor;
        _unsaleLabel.layer.borderWidth = 0.5f;
    }
    return _unsaleLabel;
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
