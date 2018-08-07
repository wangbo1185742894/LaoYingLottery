//
//  CLFollowDetailNumberBottomCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailNumberBottomCell.h"
#import "CLConfigMessage.h"

@interface CLFollowDetailNumberBottomCell ()

@property (nonatomic, strong) UIView *baseView;
//@property (nonatomic, strong) UIView *bottomLineView;

@end

@implementation CLFollowDetailNumberBottomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = FONT_SCALE(12);
        self.titleLabel.textColor = UIColorFromRGB(0x999999);
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.contentImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:self.baseView];
        [self.baseView addSubview:self.titleLabel];
        [self.baseView addSubview:self.contentImageView];
        
        [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(self.contentView);
            make.top.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(__SCALE(25.f));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.baseView);
            make.bottom.equalTo(self.baseView);
            make.left.equalTo(self.baseView);
        }];
        
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.titleLabel.mas_right).offset(3.f);
            make.centerY.equalTo(self.titleLabel);
            make.height.mas_equalTo(__SCALE(13.5));
            make.width.mas_equalTo(__SCALE(7.5));
            make.right.equalTo(self.baseView);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionClicked)];
        [self.baseView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setIsEmpty:(BOOL)isEmpty{
    
    self.baseView.hidden = isEmpty;
//    self.bottomLineView.hidden = isEmpty;
}

- (void)actionClicked {
    
    self.cellEventTouchUp?self.cellEventTouchUp():nil;
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
