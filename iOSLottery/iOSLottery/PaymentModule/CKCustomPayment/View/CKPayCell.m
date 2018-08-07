//
//  CKPayCell.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayCell.h"
#import "Masonry.h"
#import "CKDefinition.h"
@interface CKPayCell ()

@property (nonatomic, strong) UIImageView* selectImgView;
@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CKPayCell



- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.icon = [[UIImageView alloc] init];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.textLbl = [[UILabel alloc] init];
        self.textLbl.backgroundColor = [UIColor clearColor];
        self.textLbl.font = FONT_SCALE(13);
        self.textLbl.textColor = UIColorFromRGB(0x333333);
        
        self.subTextLbl = [[UILabel alloc] init];
        self.subTextLbl.backgroundColor = [UIColor clearColor];
        self.subTextLbl.font = FONT_SCALE(11);
        self.subTextLbl.textColor = UIColorFromRGB(0x999999);
        
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = UIColorFromRGB(0xefefef);
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.textLbl];
        [self.contentView addSubview:self.markTextLbl];
        [self.contentView addSubview:self.subTextLbl];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.selectImgView];
        
        WS(_weakSelf)
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(__SCALE(10.f));
            make.bottom.equalTo(self.contentView).offset(__SCALE(-10.f));
            make.height.width.mas_equalTo(__SCALE(25.f));
            make.left.mas_equalTo(__SCALE(10));
        }];
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.icon.mas_right).offset(__SCALE(10));
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
            
        [self.subTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.textLbl);
            make.top.equalTo(self.textLbl.mas_bottom);
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_weakSelf);
            make.height.mas_equalTo(.5f);
        }];
        
        [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(__SCALE(-10));
            make.width.height.mas_equalTo(__SCALE(20));
        }];
        [self.markTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.selectImgView);
        }];
        
    }
    
    return self;
}

- (void)setOnlyShowTitle:(BOOL)onlyShowTitle {
    
    _onlyShowTitle = onlyShowTitle;
    self.subTextLbl.hidden = _onlyShowTitle;
    WS(_weakSelf)
    [self.textLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weakSelf.icon.mas_right).offset(__SCALE(10));
        if (_onlyShowTitle) {
            make.centerY.equalTo(self.contentView);
        } else {
            make.bottom.equalTo(self.contentView.mas_centerY);
        }
        
    }];
    
    [self updateConstraints];
}

- (void)setIsSelectState:(BOOL)isSelectState  {
    
    _isSelectState = isSelectState;
    [self.selectImgView setImage:[UIImage imageNamed:(_isSelectState)?@"ck_selected":@"ck_unselected"]];
}

- (void)setCellType:(CKPayCellType)cellType {
    
    _cellType = cellType;
    switch (_cellType) {
        case CKPayCellTypeNormal:
            self.markTextLbl.hidden = YES;
            self.selectImgView.hidden = YES;
            break;
        case CKPayCellTypeSelect:
 
            self.markTextLbl.hidden = YES;
            self.selectImgView.hidden = NO;
            break;
        case CKPayCellTypeMarking:
            self.markTextLbl.hidden = NO;
            self.selectImgView.hidden = YES;
            break;
        default:
            break;
    }
}

#pragma mark - getter

- (UIImageView *)selectImgView {
    
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _selectImgView;
}

- (UILabel *)markTextLbl {
    
    if (!_markTextLbl) {
        _markTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(100), __SCALE(30))];
        _markTextLbl.backgroundColor = [UIColor clearColor];
        _markTextLbl.font = FONT_SCALE(13);
        _markTextLbl.textColor = UIColorFromRGB(0x999999);
        _markTextLbl.textAlignment = NSTextAlignmentRight;
        _markTextLbl.hidden = YES;
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
