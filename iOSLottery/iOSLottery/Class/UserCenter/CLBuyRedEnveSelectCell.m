//
//  CLBuyRedEnveSelectCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBuyRedEnveSelectCell.h"
#import "CLConfigMessage.h"
#import "UITextField+InputLimit.h"
#import "UILabel+CLAttributeLabel.h"
#define redPicWHSCALE (228.f / 600.f)

@interface CLBuyRedEnveSelectCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel* buyLabel;
@property (nonatomic, strong) UILabel* priceLable;
@property (nonatomic, strong) UIButton* purchaseButton;
@property (nonatomic, strong) UITextField* priceTextFeild;
@property (nonatomic, strong) UIView* mainView;
@property (nonatomic) CLBuyRedEnveSelectType showType;

@property (nonatomic, weak) UITableView* weakTableView;
@end

@implementation CLBuyRedEnveSelectCell

+ (CGFloat) cellHeight {
    
    return (SCREEN_WIDTH - 20.f) * redPicWHSCALE + 10.f;
}

+ (CLBuyRedEnveSelectCell*)redEnvelopeCellInitWithTableView:(UITableView*)tableView {
    CLBuyRedEnveSelectCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLBuyRedEnveSelectCellId"];
    if (!cell) {
        cell = [[CLBuyRedEnveSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLBuyRedEnveSelectCellId"];
        cell.weakTableView = tableView;
    }
    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
        self.buyLabel.text = @"买300送5";
        self.priceLable.text  = @"价格:305";
    }
    return self;
}

- (void)configureRedValue:(long long) redValue amountValue:(long long) amountValue isCustom:(BOOL)isCustom {
    
    self.buyLabel.hidden = isCustom;
    self.priceTextFeild.hidden = !isCustom;
    if (!isCustom) {
        self.priceLable.text = [NSString stringWithFormat:@"价格:%lld",amountValue];
        long long addNum = redValue - amountValue;
        NSString *buyString = [NSString stringWithFormat:@"买%zi送%zi", amountValue, addNum];
        
        
        //改变买和送的字体大小
        AttributedTextParams *params1 = [[AttributedTextParams alloc] init];
        params1 = [AttributedTextParams attributeRange:NSMakeRange(0, 1) Font:[UIFont boldSystemFontOfSize:__SCALE(19)]];
        //判断“送”的位置
        NSString *amountStrLength = [NSString stringWithFormat:@"%zi", amountValue];
        AttributedTextParams *params2 = [[AttributedTextParams alloc] init];
        params2 = [AttributedTextParams attributeRange:NSMakeRange(1 + amountStrLength.length, 1) Font:[UIFont boldSystemFontOfSize:__SCALE(19)]];
        [_buyLabel attributeWithText:buyString controParams:@[params1, params2]];

        
    } else {
        if (amountValue > 0) {
            self.priceTextFeild.text = [NSString stringWithFormat:@"%zi", amountValue];
            NSString *value = nil;
            if ([self.delegate respondsToSelector:@selector(inputAmountChangeFor:)]) {
                value = [self.delegate inputAmountChangeFor:self.priceTextFeild.text];
            }
            if ([value integerValue] - [self.priceTextFeild.text integerValue] > 0) {
                self.priceLable.text = [NSString stringWithFormat:@"价格:%@元(多送%zi元)",self.priceTextFeild.text, [value integerValue] - [self.priceTextFeild.text integerValue]];
            }else{
                self.priceLable.text = [NSString stringWithFormat:@"价格:%@元", self.priceTextFeild.text];
            }
        }else{
            self.priceLable.text = [NSString stringWithFormat:@"价格:%zi元", amountValue];
        }
        
    }
    self.showType = (isCustom)?CLBuyRedEnveSelectTypeCustom:CLBuyRedEnveSelectTypeNormal;
}

- (void)purchaseClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(purchaseRedEnveolpeAtIndexPath:)]) {
        [self.delegate purchaseRedEnveolpeAtIndexPath:[self.weakTableView indexPathForCell:self]];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL ret = [textField limitNumberLength:5 ShouldChangeCharactersInRange:range replacementString:string];
    
    if (ret) {
        //可处理
//        NSLog(@"可对数据进行处理");
        NSString* inputText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString* value = @"";
        if ([self.delegate respondsToSelector:@selector(inputAmountChangeFor:)]) {
            value = [self.delegate inputAmountChangeFor:inputText];
        }
        if ([value integerValue] - [inputText integerValue] > 0) {
            self.priceLable.text = [NSString stringWithFormat:@"价格:%@元(多送%zi元)",inputText, [value integerValue] - [inputText integerValue]];
        }else{
            self.priceLable.text = [NSString stringWithFormat:@"价格:%@元", inputText];
        }
    }
    return ret;
}



#pragma mark - setter

- (void)setShowType:(CLBuyRedEnveSelectType)showType {
    
    _showType = showType;
    BOOL ret = (_showType == CLBuyRedEnveSelectTypeNormal);
    self.priceTextFeild.hidden = ret;
    self.buyLabel.hidden = !ret;
}

- (void) createUI {
    
    self.buyLabel = [[UILabel alloc] init];
    self.buyLabel.backgroundColor = [UIColor clearColor];
    self.buyLabel.font = FONT_BOLD(30);
    self.buyLabel.textColor = UIColorFromRGB(0xffe13b);
    
    self.priceLable = [[UILabel alloc] init];
    self.priceLable.backgroundColor = [UIColor clearColor];
    self.priceLable.font = FONT_SCALE(15);
    self.priceLable.textColor = [UIColor whiteColor];
    
    self.purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.purchaseButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.purchaseButton setTitleColor:UIColorFromRGB(0x3d2700) forState:UIControlStateNormal];
    [self.purchaseButton setBackgroundColor:UIColorFromRGB(0xffed1f)];
    self.purchaseButton.layer.shadowColor = UIColorFromRGB(0x7a0000).CGColor;
    self.purchaseButton.layer.shadowOffset = CGSizeMake(0, __SCALE(0.5));
    self.purchaseButton.layer.shadowRadius = 3;
    self.purchaseButton.layer.shadowOpacity = 0.2;
    [self.purchaseButton addTarget:self action:@selector(purchaseClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.priceTextFeild = [[UITextField alloc] init];
    self.priceTextFeild.adjustsFontSizeToFitWidth = YES;
    self.priceTextFeild.textColor = UIColorFromRGB(0x693a11);
    self.priceTextFeild.textAlignment = NSTextAlignmentCenter;
    self.priceTextFeild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.priceTextFeild.delegate = self;
    self.priceTextFeild.backgroundColor = UIColorFromRGB(0xffffff);
    self.priceTextFeild.layer.borderColor = UIColorFromRGB(0xfdeb2f).CGColor;
    self.priceTextFeild.layer.borderWidth = 1;
//
    self.priceTextFeild.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTextFeild.placeholder = @"最低50元";
    [self.priceTextFeild setValue:UIColorFromRGB(0xdcdcdc) forKeyPath:@"_placeholderLabel.textColor"];
    self.priceTextFeild.font = FONT_FIX(14);

    
    self.mainView = [[UIView alloc] init];
    UIImage *image = [UIImage imageNamed:@"redPacketsBackgroud.png"];
    self.mainView.layer.contents = (id)image.CGImage;
    
    
    [self.contentView addSubview:self.mainView];
    
    [self.mainView addSubview:self.buyLabel];
    [self.mainView addSubview:self.priceLable];
    [self.mainView addSubview:self.purchaseButton];
    [self.mainView addSubview:self.priceTextFeild];
    
    WS(_weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_weakSelf.contentView).with.insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [self.purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_weakSelf.mainView);
        make.right.equalTo(_weakSelf.mainView).offset(-20);
        make.height.equalTo(_weakSelf.mainView).multipliedBy(.3f);
        make.width.equalTo(_weakSelf.mainView).multipliedBy(.35f);
    }];
    
    [self.buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_weakSelf.purchaseButton.mas_centerY).offset(__SCALE(5));
        make.left.equalTo(_weakSelf.mainView).offset(20);
        make.right.equalTo(_weakSelf.purchaseButton.mas_left);
        make.height.mas_equalTo(__SCALE(40));
    }];
    
    [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weakSelf.buyLabel);
        make.top.equalTo(_weakSelf.purchaseButton.mas_centerY);
        make.right.equalTo(_weakSelf.buyLabel);
        make.height.mas_equalTo(__SCALE(25));
    }];

    [self.priceTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weakSelf.buyLabel);
        make.bottom.equalTo(_weakSelf.buyLabel).offset(__SCALE(-5));
        make.height.mas_equalTo(__SCALE(30));
        make.width.mas_equalTo(__SCALE(100));
    }];
    
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.mainView.layer.cornerRadius = 5;
    self.priceTextFeild.layer.cornerRadius = 3;
    self.purchaseButton.layer.cornerRadius = 3;
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
