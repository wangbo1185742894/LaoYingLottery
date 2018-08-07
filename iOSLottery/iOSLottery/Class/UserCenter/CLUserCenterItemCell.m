//
//  CLUserCenterItemCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLUserCenterItemCell.h"

#import "CLConfigMessage.h"

#import "CLUserCenterItem.h"

@interface CLUserCenterItemCell ()

@property (nonatomic, strong) UIView *bottomLine;//底部线

@end

@implementation CLUserCenterItemCell

#pragma mark --- Class Methods ---

+ (CLUserCenterItemCell *)userCenterItemCreateWithTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier = @"CLUserCenterItemCellId";
    
    CLUserCenterItemCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[CLUserCenterItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.clipsToBounds = YES;
    
    return cell;

}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.textLbl];
        [self.contentView addSubview:self.iconImgView];
        [self.contentView addSubview:self.bottomLine];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10));
            make.height.equalTo(self.contentView).multipliedBy(.5f);
            make.width.equalTo(self.iconImgView.mas_height);
            make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(.5f);
        }];
        
        [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(self.contentView);
            make.left.equalTo(self.iconImgView.mas_right).offset(__SCALE(10));
        }];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

#pragma mark --- Set Model ---
- (void)setItem:(CLUserCenterItem *)item
{
    _item = item;
    
    self.textLbl.text = item.title;
    
    self.iconImgView.image = [UIImage imageNamed:item.imgStr];
   

}

#pragma mark --- lazyLoad ---

- (void)setHas_bottomLine:(BOOL)has_bottomLine
{
    _has_bottomLine = has_bottomLine;
    self.bottomLine.hidden = !has_bottomLine;
}

- (UILabel *)textLbl {
    
    if (!_textLbl) {
        _textLbl = [[UILabel alloc] init];
        _textLbl.backgroundColor = [UIColor clearColor];
        _textLbl.textColor = UIColorFromRGB(0x333333);
        _textLbl.font = FONT_SCALE(13);
    }
    return _textLbl;
}

- (UIImageView *)iconImgView {
    
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UIView *)bottomLine{
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _bottomLine;
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
