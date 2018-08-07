//
//  CLOrderDetailBetNumCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLOrderDetailBetNumCell.h"
#import "CLOrderDLTHintView.h"
#import "CLConfigMessage.h"
#import "CLOrderDetailBetNumModel.h"
#import "CLTools.h"
#import "CLAllJumpManager.h"
@interface CLOrderDetailBetNumCell ()

@property (nonatomic, strong) UILabel *beiLabel;
@property (nonatomic, strong) UIButton *quesBtn;

@property (nonatomic, strong) UIView* topLine;
@property (nonatomic, strong) UIView* bottomLine;
@property (nonatomic, strong) UIView* sepLine;

@property (nonatomic, strong) CLOrderDLTHintView *hintView;
@end

@implementation CLOrderDetailBetNumCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLbl = [[UILabel alloc] init];
        self.nameLbl.backgroundColor = [UIColor clearColor];
        self.nameLbl.font = FONT_SCALE(13);
        self.nameLbl.textColor = UIColorFromRGB(0x333333);
        
        self.numLbl = [[UILabel alloc] init];
        self.numLbl.backgroundColor = [UIColor clearColor];
        self.numLbl.font = FONT_SCALE(14);
        self.numLbl.textColor = UIColorFromRGB(0x333333);
        self.numLbl.numberOfLines = 0;
        
        self.beiLabel = [[UILabel alloc] init];
        self.beiLabel.backgroundColor = [UIColor clearColor];
        self.beiLabel.font = FONT_SCALE(12);
        self.beiLabel.textColor = UIColorFromRGB(0x999999);
        
        self.quesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.quesBtn setBackgroundImage:[UIImage imageNamed:@"DLTQuestion"] forState:UIControlStateNormal];
        [self.quesBtn addTarget:self action:@selector(quesAction) forControlEvents:UIControlEventTouchUpInside];
        self.quesBtn.hidden = YES;
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = SEPARATE_COLOR;
        
        self.topLine = [[UIView alloc] init];
        self.topLine.backgroundColor = UIColorFromRGB(0xdddddd);
        self.topLine.hidden = YES;
        
        self.sepLine = [[UIView alloc] init];
        self.sepLine.backgroundColor = SEPARATE_COLOR;
        
        self.hintView = [[CLOrderDLTHintView alloc] initWithFrame:CGRectZero];
        
        
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:self.numLbl];
        [self.contentView addSubview:self.beiLabel];
        [self.contentView addSubview:self.quesBtn];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.sepLine];
        [self.contentView addSubview:self.topLine];
//        [self.contentView addSubview:self.hintView];
        
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5f);
        }];
        
        [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5f);
        }];
        
        [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.top.equalTo(self.contentView).offset(10);
            make.height.lessThanOrEqualTo(self).offset(-5);
            make.bottom.equalTo(self.numLbl);
            make.width.mas_equalTo(__SCALE(90));
        }];
        
        [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLbl.mas_right);
            make.width.mas_equalTo(.5f);
            make.top.bottom.equalTo(self.contentView);
        }];
        
        [self.numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.sepLine.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(__SCALE(-10));
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.quesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(__SCALE(12));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-__SCALE(10));
        }];
        [self.beiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.quesBtn.mas_left).offset(-__SCALE(5));
        }];

    }
    return self;
}

- (void)quesAction {
    
    [[CLAllJumpManager shareAllJumpManager] open:@"https://m.caiqr.com/daily/dltleshanjiang/index.htm"];
    
}

- (void)configureData:(CLOrderDetailBetNumModel*)data {
    
    self.nameLbl.text = data.title;
    self.numLbl.text = data.betNumber;
    self.numLbl.textColor = UIColorFromRGB(0x333333);
    self.quesBtn.hidden = YES;
    self.beiLabel.hidden = YES;
    self.numLbl.hidden = NO;
    [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.top.equalTo(self.contentView).offset(10);
        make.height.lessThanOrEqualTo(self).offset(-5);
        make.bottom.equalTo(self.numLbl);
        make.width.mas_equalTo(__SCALE(90));
    }];
    switch (data.titleType) {
        case TitleNormal:{
            self.nameLbl.font = FONT_SCALE(13);
            self.nameLbl.textColor = UIColorFromRGB(0x999999);
            self.sepLine.hidden = YES;
        }
            break;
        case TitleTypeBonusNumber:{
            self.nameLbl.font = FONT_SCALE(14);
            self.nameLbl.textColor = UIColorFromRGB(0x333333);
            self.numLbl.textColor = data.betNumberColor;
            self.sepLine.hidden = NO;
        }
            break;
        case TitleTypeBetNumber:{
            self.nameLbl.font = FONT_SCALE(13);
            self.nameLbl.textColor = UIColorFromRGB(0x333333);
            self.sepLine.hidden = NO;
            if (data.betNumberColor) {
                self.numLbl.textColor = data.betNumberColor;
            }
        }
            break;
        case TitleTypeLeShanNumber:{
            self.nameLbl.font = FONT_SCALE(12);
            self.nameLbl.textColor = UIColorFromRGB(0x999999);
            self.sepLine.hidden = YES;
            self.quesBtn.hidden = NO;
            self.beiLabel.hidden = NO;
            self.numLbl.hidden = YES;
            self.beiLabel.text = data.betNumber;
            [self.nameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(__SCALE(10.f));
                make.top.equalTo(self.contentView).offset(10);
                make.height.lessThanOrEqualTo(self).offset(-5);
                make.bottom.equalTo(self.numLbl);
            }];
        }
            break;
        default:
            break;
    }
    if ([data.betNumber isKindOfClass:NSString.class] && data.betNumber.length > 0) {
        
        NSString *str = [data.betNumber mutableCopy];
        NSArray* redRanges = [CLTools getRangeNeedColorWithTag:@"^" string:str endFlagString:@"() #|"];
        str = [str stringByReplacingOccurrencesOfString:@"^" withString:@""];
        NSArray* blueRanges = [CLTools getRangeNeedColorWithTag:@"&" string:str endFlagString:@"() #|"];
        str = [str stringByReplacingOccurrencesOfString:@"&" withString:@""];
        
        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc] initWithString:str];
        for (NSValue* value in redRanges) {
            [attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xe00000) range:[value rangeValue]];
        }
        for (NSValue* value in blueRanges) {
            [attribute addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x5494ff) range:[value rangeValue]];
        }
        self.numLbl.attributedText = attribute;
    }
    [self updateConstraints];
}
- (void)setIsTop:(BOOL)isTop{
    
    self.topLine.hidden = !isTop;
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
