//
//  CLFollowDetailPeriodHeaderCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailPeriodHeaderCell.h"
#import "CLConfigMessage.h"
#import "CLFollowPeroidAndRefundModel.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllAlertInfo.h"
@interface CLFollowDetailPeriodHeaderCell ()

@property (nonatomic, strong) UIImageView* topImgeView;
@property (nonatomic, strong) UIView* bottomLine;
@property (nonatomic, strong) CLAlertPromptMessageView *alertView;


@end

@implementation CLFollowDetailPeriodHeaderCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xF7F7EE);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.topImgeView = [[UIImageView alloc] init];
        self.followPeriodLbl = [[UILabel alloc] init];
        self.followPeriodLbl.font = FONT_SCALE(14);
        self.refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.bottomLine = [[UIView alloc] init];
        
        self.topImgeView.image = [UIImage imageNamed:@"CMTWareLine"];
        [self.refundBtn setTitle:@"退款说明" forState:UIControlStateNormal];
        [self.refundBtn setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        self.refundBtn.titleLabel.font = FONT_SCALE(12);
        [self.refundBtn addTarget:self action:@selector(refundBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.bottomLine.backgroundColor = SEPARATE_COLOR;
        
        
        
        [self.contentView addSubview:self.topImgeView];
        [self.contentView addSubview:self.followPeriodLbl];
        [self.contentView addSubview:self.refundBtn];
        [self.contentView addSubview:self.bottomLine];
        
        
        [self.topImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.mas_equalTo(__SCALE(5.f));
            make.top.equalTo(self.contentView);
        }];
        
        [self.followPeriodLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.top.equalTo(self.topImgeView.mas_bottom).offset(__SCALE(10.f));
            make.bottom.equalTo(self.contentView).offset(__SCALE(-10.f));
            make.width.equalTo(self.contentView.mas_width).multipliedBy(.5f);
        }];
        
        [self.refundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(__SCALE(-10.f));
            make.centerY.equalTo(self.followPeriodLbl);
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
- (void)refundBtnOnClick:(UIButton *)btn{
    
    [self.alertView showInWindow];
}
- (void) configurePeroidData:(id)data {
    
    if ([data isKindOfClass:[CLFollowPeroidAndRefundModel class]]) {
        CLFollowPeroidAndRefundModel* period = (CLFollowPeroidAndRefundModel*)data;
        NSString* firstText = @"已追";
        NSString* periodDone = [NSString stringWithFormat:@"%zi",period.peroidDone];
        NSString* secText = @"期/共";
        NSString* totalPeriod = [NSString stringWithFormat:@"%zi",period.totalPeriod];
        NSString* thirdText = @"期";
        
        NSMutableString* text = [[NSMutableString alloc] initWithString:firstText];
        NSRange firstRange = NSMakeRange(text.length, periodDone.length);
        [text appendFormat:@"%@%@",periodDone,secText];
        NSRange secRange = NSMakeRange(text.length, totalPeriod.length);
        [text appendFormat:@"%@%@",totalPeriod,thirdText];

        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc] initWithString:text];
        [attribute addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:firstRange];
        [attribute addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:secRange];
        
        self.followPeriodLbl.attributedText = attribute;
        self.refundBtn.hidden = !period.isShowRefund;
        
        
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

- (CLAlertPromptMessageView *)alertView{
    
    if (!_alertView) {
        _alertView = [[CLAlertPromptMessageView alloc] init];
        _alertView.desTitle = allAlertInfo_RefundInfo;
        _alertView.cancelTitle = @"知道了";
    }
    return _alertView;
}
@end
