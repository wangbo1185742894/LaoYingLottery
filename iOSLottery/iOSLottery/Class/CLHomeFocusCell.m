//
//  CLHomeFocusCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeFocusCell.h"
#import "CLConfigMessage.h"
#import "CLHomeGameEnteranceModel.h"
#import "UIImageView+CQWebImage.h"
@interface CLHomeFocusCell ()

@property (nonatomic, strong) UIImageView* focusImgView;
@property (nonatomic, strong) UILabel* titleLbl;
@property (nonatomic, strong) UILabel* subTitleLbl;

@property (nonatomic, strong) UIView* lineView;

@end

@implementation CLHomeFocusCell

+ (CLHomeFocusCell*) focusCellInitWith:(UITableView*)tableView data:(id)data{
    
    CLHomeFocusCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLHomeFocusCellId"];
    if (!cell) {
        cell = [[CLHomeFocusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLHomeFocusCellId"];
    }
    [cell assignData:data];
    return cell;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.focusImgView = [[UIImageView alloc] init];
        self.focusImgView.backgroundColor = CLEARCOLOR;
        self.titleLbl = [[UILabel alloc] init];
        self.subTitleLbl = [[UILabel alloc] init];
        
        self.titleLbl.backgroundColor = self.subTitleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.font = FONT_SCALE(15);
        self.subTitleLbl.font = FONT_SCALE(11);
        self.titleLbl.textColor = UIColorFromRGB(0x333333);
        self.subTitleLbl.textColor = UIColorFromRGB(0x999999);
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.subTitleLbl];
        [self.contentView addSubview:self.focusImgView];
        [self.contentView addSubview:self.lineView];
        
        [self.focusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(__SCALE(5.f));
            make.bottom.equalTo(self.contentView).offset(__SCALE(- 5.f));
            make.left.equalTo(self.contentView).offset(__SCALE(5.f));
            make.height.mas_equalTo(__SCALE(60.f));
            make.width.equalTo(self.focusImgView.mas_height).multipliedBy(8.0/5);
        }];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.focusImgView.mas_right).offset(__SCALE(10));
            make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(5.f/14.f);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.mas_equalTo(__SCALE(30));
        }];
        
        [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.centerY.equalTo(self.contentView.mas_bottom).multipliedBy(10.f/14.f);
            make.right.equalTo(self.titleLbl);
            make.height.equalTo(self.titleLbl);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5f);
        }];
        
    }
    return self;
}
//配置数据
- (void)assignData:(id)data{
    
    CLHomeGameEnteranceModel *model = data;
    self.titleLbl.text = model.title;
    self.subTitleLbl.text = model.tips;
    [self.focusImgView setImageWithURL:[NSURL URLWithString:model.imgUrl]];
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
