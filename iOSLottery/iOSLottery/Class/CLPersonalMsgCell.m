//
//  CLPersonalMsgCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersonalMsgCell.h"
#import "CLConfigMessage.h"
#import "UIImageView+CQWebImage.h"
#import "CLPersonalMsgViewModel.h"


@interface CLPersonalMsgCell ()

@property (nonatomic, strong) UILabel* textLbl;
@property (nonatomic, strong) UIImageView* imgView;
@property (nonatomic, strong) UILabel* stateLbl;
@property (nonatomic, strong) UIView* bottomLine;

@end

@implementation CLPersonalMsgCell

+ (CLPersonalMsgCell*)getPersonalMsgCellWithTableView:(UITableView __weak *)tableView
{
    CLPersonalMsgCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLPersonalMsgCellID"];
    if (!cell) {
        cell = [[CLPersonalMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLPersonalMsgCellID"];
    }
    return cell;
}


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)configurePersonalMessage:(CLPersonalMsgViewModel*)viewModel {
    
    self.textLbl.hidden = viewModel.isHeadImgShow;
    self.imgView.hidden = !viewModel.isHeadImgShow;
    
    if (viewModel.isHeadImgShow) {
        [self.imgView setImageWithURL:[NSURL URLWithString:viewModel.headImgStr]];
    } else {
        self.textLbl.text = [NSString stringWithFormat:@"%@ %@",viewModel.title,viewModel.content];
    }
    
    self.stateLbl.text = viewModel.state;
    self.accessoryType = (viewModel.canClicking)?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
    
    [self.stateLbl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(viewModel.canClicking?0:-10);
    }];
    
    //[self setNeedsLayout];
    [self updateConstraints];
}

- (void)createView {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textLbl.textColor = UIColorFromRGB(0x333333);
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (44 * 0.7), (44 * 0.7))];
    self.stateLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.stateLbl.textAlignment = NSTextAlignmentRight;
    self.stateLbl.font = FONT_SCALE(13);
    self.stateLbl.textColor = UIColorFromRGB(0x333333);
    
    self.textLbl.font = FONT_SCALE(13);
    self.bottomLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self.contentView addSubview:self.textLbl];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.stateLbl];
    [self.contentView addSubview:self.bottomLine];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(.66f);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.textLbl);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(self.contentView.mas_height).multipliedBy(.7);
        make.width.equalTo(self.imgView.mas_height);
    }];
    
    [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-5);
        make.left.equalTo(self.textLbl.mas_right);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(.5f);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)setHas_BottomLine:(BOOL)has_BottomLine{
    
    _has_BottomLine = has_BottomLine;
    self.bottomLine.hidden = !has_BottomLine;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.height / 2.f;
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.masksToBounds = YES;
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
