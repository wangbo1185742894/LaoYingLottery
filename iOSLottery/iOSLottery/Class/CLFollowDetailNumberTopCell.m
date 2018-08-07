//
//  CLFollowDetailNumberTopCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailNumberTopCell.h"
#import "CLConfigMessage.h"

@interface CLFollowDetailNumberTopCell ()

@property (nonatomic, strong) UILabel* contentLbl;;
@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CLFollowDetailNumberTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentLbl = [[UILabel alloc] init];
        self.contentLbl.font = FONT_SCALE(14);
        self.contentLbl.textColor = UIColorFromRGB(0x333333);
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = SEPARATE_COLOR;
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.bottomLine];
        
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(__SCALE(12.5));
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.bottom.equalTo(self.contentView).offset(__SCALE(-5.f));
        }];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5f);
        }];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    self.contentLbl.text = title;
}

- (void)setTitle:(NSString *)title content:(NSString*)content {
    NSString* text = @"";
    if ([content isKindOfClass:NSString.class] && content.length > 0) {
        text = [NSString stringWithFormat:@"%@ (%@)",title,content];
        
        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc] initWithString:text];
        [attribute addAttribute:NSFontAttributeName
         
                              value:FONT_SCALE(12)
         
                              range:[text rangeOfString:content]];
        
        self.contentLbl.attributedText = attribute;
    } else {
        text = title;
        self.contentLbl.text = text;
    }
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
