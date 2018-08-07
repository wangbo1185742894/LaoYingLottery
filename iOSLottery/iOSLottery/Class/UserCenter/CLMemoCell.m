//
//  CLMemoCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLMemoCell.h"
#import "Masonry.h"

@interface CLMemoCell ()

@property (nonatomic, strong) UITapGestureRecognizer* contentTap;

@property (nonatomic, copy) void(^eventMessage)(void);
@end

@implementation CLMemoCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLbl = [[UILabel alloc] init];
        self.contentLbl = [[UILabel alloc] init];
        
        self.titleLbl.textAlignment = NSTextAlignmentCenter;
        self.titleLbl.font = self.contentLbl.font = [UIFont systemFontOfSize:13];
        
        self.contentLbl.numberOfLines = 0;
        self.contentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentEvent:)];
        [self.contentLbl addGestureRecognizer:self.contentTap];
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.contentLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.height.mas_lessThanOrEqualTo(60);
            make.bottom.equalTo(self.contentLbl);
            make.width.equalTo(self.contentView).multipliedBy(.2f);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-10);
            make.bottom.equalTo(self.contentView).offset(-10);
            
        }];
        
    }
    return self;
}


- (void) setSuppleEvent:(BOOL(^)())suppleEvent message:(void(^)())message {
    
    BOOL canClick = (suppleEvent)?suppleEvent():NO;
    
    self.contentLbl.userInteractionEnabled = canClick;
    
    if (canClick) {
        self.eventMessage = message;
    } else {
        self.eventMessage = nil;
    }
    
}

- (void)contentEvent:(id)sender {
    
    (self.eventMessage)?self.eventMessage():nil;
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
