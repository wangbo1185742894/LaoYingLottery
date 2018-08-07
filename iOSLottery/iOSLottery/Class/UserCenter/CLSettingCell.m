//
//  CLSettingCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSettingCell.h"
#import "CLConfigMessage.h"

@interface CLSettingCell ()

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UISwitch* cusSwitch;

@property (nonatomic, strong) UILabel* titleLbl;

@property (nonatomic, strong) UILabel*  remarkLbl;

@end

@implementation CLSettingCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLbl = [[UILabel alloc] init];
        self.titleLbl.backgroundColor = [UIColor clearColor];
        self.titleLbl.font = FONT_SCALE(13);
        self.titleLbl.textColor = [UIColor blackColor];
        
        self.remarkLbl = [[UILabel alloc] init];
        self.remarkLbl.backgroundColor = [UIColor clearColor];
        self.remarkLbl.font = FONT_SCALE(12);
        self.remarkLbl.textColor = [UIColor lightGrayColor];
        self.remarkLbl.textAlignment = NSTextAlignmentRight;
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        self.cusSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [self.cusSwitch addTarget:self action:@selector(switchClicked:) forControlEvents:UIControlEventValueChanged];
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.remarkLbl];
        [self.contentView addSubview:self.line];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.width.equalTo(self.contentView).multipliedBy(.5f);
        }];
        
        [self.remarkLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(__SCALE(- 10.f));
        }];
        
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

- (void)setHas_bottomLine:(BOOL)has_bottomLine{
    
    _has_bottomLine = has_bottomLine;
    self.line.hidden = !has_bottomLine;
}

- (void)switchClicked:(UISwitch*)sw {
    
    self.SwitchChange?self.SwitchChange(sw.isOn):nil;
}


- (void) configureSettingCellWithModel:(CLSettingCellModel*)cellModel {
    
    if (cellModel.cellType == CLSettingCellTypeNormal) {
        self.titleLbl.text = cellModel.title;
        self.remarkLbl.text = @"";
        self.cusSwitch.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else if (cellModel.cellType == CLSettingCellTypeRemark) {
        self.titleLbl.text = cellModel.title;
        self.remarkLbl.text = cellModel.remark;
        self.cusSwitch.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        
    } else if (cellModel.cellType == CLSettingCellTypeSwitch) {
        self.titleLbl.text = cellModel.title;
        self.remarkLbl.text = @"";
        self.cusSwitch.hidden = NO;
        [self.cusSwitch setOn:cellModel.isOn];
        self.accessoryView = self.cusSwitch;
        
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
