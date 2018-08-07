//
//  CLPaymentCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPaymentCell.h"
#import "CLConfigMessage.h"

@interface CLPaymentCell ()

@property (nonatomic, strong) UIImageView* selectImgView;
@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CLPaymentCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc] init];
        
        
        self.textLbl = [[UILabel alloc] init];
        self.textLbl.backgroundColor = [UIColor clearColor];
        self.textLbl.font = FONT_SCALE(13);
        self.textLbl.textColor = UIColorFromRGB(0x333333);
        
        self.subTextLbl = [[UILabel alloc] init];
        self.subTextLbl.backgroundColor = [UIColor clearColor];
        self.subTextLbl.font = FONT_SCALE(11);
        self.subTextLbl.textColor = UIColorFromRGB(0x999999);
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = UIColorFromRGB(0xEEEEEE);
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.textLbl];
        [self.contentView addSubview:self.markTextLbl];
        [self.contentView addSubview:self.subTextLbl];
        [self.contentView addSubview:self.bottomLine];
        
        WS(_weakSelf)
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_weakSelf);
            make.height.equalTo(_weakSelf).multipliedBy(.5f);
            make.left.mas_equalTo(__SCALE(10));
            make.width.equalTo(_weakSelf.icon.mas_height);
        }];
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.icon.mas_right).offset(__SCALE(10));
            make.height.mas_equalTo(__SCALE(25));
            make.centerY.equalTo(_weakSelf.contentView.mas_bottom).multipliedBy(.25f);
        }];
        
        [self.markTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.textLbl.mas_right).offset(__SCALE(5.f));
            make.centerY.equalTo(self.textLbl);
        }];
        
        [self.subTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.textLbl);
            make.right.equalTo(_weakSelf.textLbl);
            make.height.mas_equalTo(__SCALE(20.f));
            make.centerY.equalTo(_weakSelf.contentView.mas_bottom).multipliedBy(2.f/3.f);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_weakSelf);
            make.height.mas_equalTo(.5f);
        }];
        
    }
    
    return self;
}

- (void)setOnlyShowTitle:(BOOL)onlyShowTitle {
    
    _onlyShowTitle = onlyShowTitle;
    self.subTextLbl.hidden = _onlyShowTitle;
    self.markTextLbl.hidden = !_onlyShowTitle;
    WS(_weakSelf)
    [self.textLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weakSelf.icon.mas_right).offset(__SCALE(10));
        make.height.mas_equalTo(__SCALE(25));
        if (_onlyShowTitle) {
            make.centerY.equalTo(_weakSelf.contentView.mas_bottom).multipliedBy(.5f);
        } else {
            make.centerY.equalTo(_weakSelf.contentView.mas_bottom).multipliedBy(.25f);
        }
        
    }];
    
    [self updateConstraints];
}

- (void)setIsSelectState:(BOOL)isSelectState  {
    
    _isSelectState = isSelectState;
    [self.selectImgView setImage:[UIImage imageNamed:(_isSelectState)?@"accountSel_YES":@"accountSel_NO"]];
}

- (void)setCellType:(PaymentCellType)cellType {
    
    _cellType = cellType;
    switch (_cellType) {
        case PaymentCellTypeNormal:
            self.accessoryView = nil;
            break;
        case PaymentCellTypeSelect:
            self.accessoryView = self.selectImgView;
            break;
        case PaymentCellTypeMarking:
            self.accessoryView = self.markTextLbl;
            break;
        default:
            break;
    }
}

- (void)setMarkColor:(UIColor *)markColor {
    
    if (_markTextLbl) {
        _markTextLbl.textColor = markColor;
    }
}

#pragma mark - getter

- (UIImageView *)selectImgView {
    
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    }
    return _selectImgView;
}

- (UILabel *)markTextLbl {
    
    if (!_markTextLbl) {
        _markTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(100), __SCALE(30))];
        _markTextLbl.backgroundColor = [UIColor clearColor];
        _markTextLbl.font = FONT_SCALE(13);
        _markTextLbl.textColor = [UIColor blackColor];
        _markTextLbl.textAlignment = NSTextAlignmentRight;
    }
    return _markTextLbl;
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
