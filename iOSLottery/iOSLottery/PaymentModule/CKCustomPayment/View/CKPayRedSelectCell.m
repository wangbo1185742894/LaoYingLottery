//
//  CKPayRedSelectCell.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayRedSelectCell.h"
#import "Masonry.h"
#import "CKDefinition.h"
@interface  CKPayRedSelectCell ()

@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *selectImg;
@property (nonatomic, strong) UIView *lineView;

@end
@implementation CKPayRedSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.amountLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView addSubview:self.selectImg];
        [self.contentView addSubview:self.lineView];
        
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(40.f));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
    }];
    
    [self.selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(__SCALE(-10.f));
        make.centerY.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
}
- (void)setRedAmount:(NSString *)redAmount{
    
    self.amountLabel.text = redAmount;
}

- (void)setIsSelectState:(BOOL)isSelectState  {
    
    _isSelectState = isSelectState;
    [self.selectImg setImage:[UIImage imageNamed:(_isSelectState)?@"ck_selected":@"ck_unselected"]];
}

- (void)setDescString:(NSString *)descString
{
    self.descLabel.text = descString;
}

- (void)setDescColorString:(NSString *)descColorString
{
    if (descColorString!= nil && descColorString.length > 0)
    {
        //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
        self.descLabel.textColor = UIColorFromRGB(strtoul([descColorString UTF8String],0,16));
    }
    else
    {
        self.descLabel.textColor = UIColorFromRGB(0x333333);
    }
}

#pragma mark ------------ getter Mothed ------------
- (UILabel *)amountLabel{
    
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _amountLabel.text = @"";
        _amountLabel.textColor = UIColorFromRGB(0x333333);
        _amountLabel.font = FONT_SCALE(13.f);
    }
    return _amountLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.text = @"";
        _descLabel.textColor = UIColorFromRGB(0x333333);
        _descLabel.font = FONT_SCALE(13.f);
    }
    return _descLabel;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xefefef);
    }
    return _lineView;
}
- (UIImageView *)selectImg{
    
    if (!_selectImg) {
        _selectImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _selectImg;
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
