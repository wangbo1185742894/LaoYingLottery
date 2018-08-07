//
//  CLWithdrawCashCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/12.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawCashCell.h"
#import "CLConfigMessage.h"
#import "CLWithdrawInfoModel.h"
#import "UITextField+InputLimit.h"

@interface CLWithdrawCashCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField* withdrawTextF;
@property (nonatomic, strong) UIView* lineView;

@end

@implementation CLWithdrawCashCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
    }
    return self;
}

+ (CGFloat) cellHeight {
    
    return __SCALE(100);
}
- (void)textFieldChangeValue:(UITextField *)textField{
    
    if ([textField.text rangeOfString:@"."].length && [textField.text rangeOfString:@"."].location < (textField.text.length - 2)) {
        textField.text = [textField.text substringToIndex:[textField.text rangeOfString:@"."].location + 3];
        if ([textField.text rangeOfString:@"."].location == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }else if([textField.text rangeOfString:@"."].location == NSNotFound && textField.text.length && [[textField.text substringToIndex:1] isEqualToString:@"0"]){
        textField.text = [NSString stringWithFormat:@"%lld",textField.text.longLongValue];
    }
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL ret = [textField limitNumberSum:0 ShouldChangeCharactersInRange:range replacementString:string];

    if (ret) {
        NSString* tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (tempStr.length == 0) {
            if ([self.delegate respondsToSelector:@selector(userInputWithdrawCash:)]) {
                
                [self.delegate userInputWithdrawCash:@""];
            }
        } else {
            NSDecimalNumber* number = [NSDecimalNumber decimalNumberWithString:tempStr];
            number = [number decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
            
            NSDecimalNumber* maxMoney = [NSDecimalNumber decimalNumberWithMantissa:self.availWithdrawCash exponent:0 isNegative:NO];
            
            NSComparisonResult result = [number compare:maxMoney];
            if (result == NSOrderedDescending) {
                number = maxMoney;
                textField.text = [number decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"100"]].stringValue;
                ret = NO;
            }
            
            if ([self.delegate respondsToSelector:@selector(userInputWithdrawCash:)]) {
                
                [self.delegate userInputWithdrawCash:number.stringValue];
            }
        }
    }
    return ret;
}

- (void)createUI {
    
    self.withdrawTitleLbl = [[UILabel alloc] init];
    self.withdrawTitleLbl.backgroundColor = [UIColor clearColor];
    self.withdrawTitleLbl.font = FONT_SCALE(13);
    self.withdrawTitleLbl.textColor = UIColorFromRGB(0x333333);
    
    UILabel* flag = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(30), __SCALE(30))];
    flag.text = @"￥";
    flag.font = FONT_SCALE(28);
    flag.textColor = UIColorFromRGB(0x333333);
    flag.backgroundColor = [UIColor whiteColor];
    
    self.withdrawTextF = [[UITextField alloc] init];
    self.withdrawTextF.backgroundColor = [UIColor clearColor];
    self.withdrawTextF.keyboardType = UIKeyboardTypeNumberPad;
    self.withdrawTextF.leftView = flag;
    self.withdrawTextF.font = FONT_SCALE(30);
    self.withdrawTextF.leftViewMode = UITextFieldViewModeAlways;
    self.withdrawTextF.tintColor = UIColorFromRGB(0x000000);
    self.withdrawTextF.delegate = self;
    [self.withdrawTextF addTarget:self action:@selector(textFieldChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    self.withdrawCashLbl = [[UILabel alloc] init];
    self.withdrawCashLbl.backgroundColor = [UIColor clearColor];
    self.withdrawCashLbl.font = FONT_SCALE(12);
    self.withdrawCashLbl.textColor = UIColorFromRGB(0x666666);
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    [self.contentView addSubview:self.withdrawCashLbl];
    [self.contentView addSubview:self.withdrawTitleLbl];
    [self.contentView addSubview:self.withdrawTextF];
    [self.contentView addSubview:self.lineView];
    
    self.withdrawTitleLbl.text = @"提现金额";
    
    [self.withdrawTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10));
        make.top.equalTo(self.contentView).offset(__SCALE(5));
        make.right.equalTo(self.contentView).offset(__SCALE(- 10));
        make.height.mas_equalTo(__SCALE(20));
    }];
    
    [self.withdrawTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.withdrawTitleLbl);
        make.top.equalTo(self.withdrawTitleLbl.mas_bottom).offset(5);
        make.right.equalTo(self.withdrawTitleLbl);
        make.bottom.equalTo(self.lineView).offset(-5);
    }];
    
    
    [self.withdrawCashLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.withdrawTitleLbl);
        make.bottom.equalTo(self.contentView).offset(__SCALE(- 5.f));
        make.height.mas_equalTo(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.withdrawTitleLbl);
        make.bottom.equalTo(self.withdrawCashLbl.mas_top).offset(-5);
        make.height.mas_equalTo(.5f);
    }];
    
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
