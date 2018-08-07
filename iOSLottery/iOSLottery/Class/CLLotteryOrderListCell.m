//
//  CLLotteryOrderListCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/11.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLLotteryOrderListCell.h"
#import "CLConfigMessage.h"

@interface UILabel (CLSet)

- (void) instanceDefault;

@end


@implementation UILabel (CLSet)

- (void) instanceDefault {
    
    self.backgroundColor = [UIColor clearColor];
    
}

@end

@interface CLLotteryOrderListCell ()

@property (nonatomic, strong) CALayer* arrowLayer;
@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CLLotteryOrderListCell

+ (CGFloat)cellHeight {
     float scale = [[UIScreen mainScreen] scale];
    return 60.f * scale;
}

+ (instancetype)createLotteryOrderListCell:(UITableView *)tableView
{

    static NSString *cellID = @"CLLotteryOrderListCell";
    
    CLLotteryOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CLLotteryOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        [self addSubviews];
        [self addConstraints];
    }
    return self;
}

#pragma mark -

- (void)addSubviews
{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.timerLabel];
    [self.contentView addSubview:self.contentLable];
    [self.contentView addSubview:self.cashLable];
    [self.contentView  addSubview:self.bottomLine];
}

- (void)addConstraints {
    /**  */
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.width.height.mas_equalTo(__SCALE(40.f));
        make.top.equalTo(self.contentView).offset(__SCALE(10.f));
        make.bottom.equalTo(self.contentView).offset(__SCALE(-10.f));
    }];
    
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(__SCALE(10.f));
        make.bottom.equalTo(self.contentView.mas_centerY).offset(__SCALE(-2.5f));
    }];
    
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLable);
        make.top.equalTo(self.contentView.mas_centerY).offset(__SCALE(2.5f));
    }];
    
    [self.cashLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.timerLabel.mas_right).offset(__SCALE(5.f));
        make.centerY.equalTo(self.timerLabel);
    }];
    
    [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.right.equalTo(self.contentView);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
    }];
}

#pragma mark - getter 

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *)titleLable {
    
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLable.font = FONT_SCALE(14);
        _titleLable.textColor = UIColorFromRGB(0x333333);
        [_titleLable instanceDefault];
        
    }
    return _titleLable;
}
- (UILabel *)timerLabel{
    
    if (!_timerLabel) {
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timerLabel.font = FONT_SCALE(12);
        _timerLabel.textColor = UIColorFromRGB(0x999999);
        [_timerLabel instanceDefault];
    }
    return _timerLabel;
}

- (UILabel *)contentLable {
    
    if (!_contentLable) {
        _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLable.font = FONT_SCALE(12);
        _contentLable.textColor = UIColorFromRGB(0x333333);
        [_contentLable instanceDefault];
        
    }
    return _contentLable;
}

- (UILabel *)cashLable {
    
    if (!_cashLable) {
        _cashLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _cashLable.font = FONT_SCALE(12);
        _cashLable.textColor = UIColorFromRGB(0x999999);
        _cashLable.textAlignment = NSTextAlignmentRight;
        [_cashLable instanceDefault];
        
    }
    return _cashLable;
}

- (UIView *)bottomLine {
    
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
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
