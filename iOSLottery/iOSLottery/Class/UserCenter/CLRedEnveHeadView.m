//
//  CLRedEnveHeadView.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveHeadView.h"
#import "CQDefinition.h"
#import "CLConfigMessage.h"
#import "CQUserRedPacketsNewModel.h"
#import "UILabel+CLAttributeLabel.h"
#import "CaiqrWebImage.h"
#import "CLAllJumpManager.h"
@interface CLRedEnveHeadView ()

@property (nonatomic, strong) UILabel* redEnvelopeLbl;
@property (nonatomic, strong) UILabel* redEnvelopeDesLbl;

@property (nonatomic, strong) UIButton* buyBtn;

@property (nonatomic, strong) UIView* separateView;

@property (nonatomic, strong) UIButton* availBtn;
@property (nonatomic, strong) UIButton* unavailBtn;

@property (nonatomic, strong) UIView* eventSpearateLine;
@property (nonatomic, strong) UIView* selectLine;

@end

@implementation CLRedEnveHeadView

- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        
        self.redEnvelopeLbl.text = @"账户红包余额:";
    }
    return self;
}


- (void) switchREIndex:(UIButton*) sender {
 
    _selectIdx = sender.tag - 1;
    [self updateSelectIdx:sender.tag - 1 animate:YES];
}

- (void)setSelectIdx:(NSInteger)selectIdx {
    
    
    if (selectIdx < 0 || selectIdx > 1) {
        return;
    }
    _selectIdx = selectIdx;
    [self updateSelectIdx:selectIdx animate:NO];
}

- (void)updateSelectIdx:(NSInteger)idx animate:(BOOL)animate {
    
    BOOL isAvailable = (idx == 0);
    
    [self.selectLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(isAvailable?self.availBtn.mas_left:self.unavailBtn.mas_left);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2.f);
        make.width.equalTo(self).multipliedBy(.5f);
    }];
    
    [UIView animateWithDuration:animate?.3f:0.f animations:^{
        [self layoutIfNeeded];
    }];
    
    [self.availBtn setTitleColor:(isAvailable)?THEME_COLOR:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.unavailBtn setTitleColor:(!isAvailable)?THEME_COLOR:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    
    
    if ([self.delegate respondsToSelector:@selector(switchREIndex:)]) {
        [self.delegate switchREIndex:idx];
    }
    
}


- (void)assignData:(id)obj
{
    CQUserRedPacketsNewModel *model = obj;
    if (!model) return;
    NSString *redBalanceString = [NSString stringWithFormat:@"%@",model.red_balance];
    NSString *balanceInfoString = [NSString stringWithFormat:@"%@：%@%@",@"红包余额",redBalanceString,@"元"];
    [self.redEnvelopeLbl attributeWithText:balanceInfoString controParams:@[[AttributedTextParams attributeRange:[balanceInfoString rangeOfString:redBalanceString] Color:THEME_COLOR Font:FONT_SCALE(22)],[AttributedTextParams attributeRange:[balanceInfoString rangeOfString:@"元"] Color:UIColorFromRGB(0x333333) Font:FONT_SCALE(11)]]];
    NSString *redAdString = [NSString stringWithFormat:@"%@",model.red_ad_img];
    if ([redAdString isKindOfClass:[NSString class]] && redAdString.length)
    {
//        self.buyBtn.hidden = NO;
        [CaiqrWebImage downloadImageUrl:redAdString progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
            
            [self.buyBtn setImage:image forState:UIControlStateNormal];
        }];
    }
    //** 如果用户没有红包判断 */
    if (model.red_memo) {
        if (model.red_memo.memo && model.red_memo.memo.length > 0) {
            self.redEnvelopeDesLbl.text = [NSString stringWithFormat:@"%@",model.red_memo.memo];
        }
        NSString *colorSring = nil;
        if (model.red_memo.color && model.red_memo.color.length > 0) {
            colorSring = [NSString stringWithFormat:@"%@",model.red_memo.color];
        }
        if (colorSring != nil && colorSring.length > 0)
        {
            //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
            self.redEnvelopeDesLbl.textColor = UIColorFromRGB(strtoul([colorSring UTF8String],0,16));
        }
    }
    else
    {
        self.redEnvelopeDesLbl.text = @"";
    }
    
    [self.redEnvelopeLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.buyBtn.mas_left);
        make.height.mas_equalTo(35);

        make.centerY.equalTo(self.separateView.mas_top).multipliedBy((model.red_memo)?.4f:.5f);
    }];
    
    
    [self updateConstraints];
    
}
- (void)buyBtnOnClick:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:@"CQBuyRedPacketsViewController_push"];
}

- (void) createUI {
    
    self.redEnvelopeLbl = [[UILabel alloc] init];
    self.redEnvelopeLbl.font = FONT_SCALE(14);
    self.redEnvelopeLbl.backgroundColor = [UIColor clearColor];
    
    self.redEnvelopeDesLbl = [[UILabel alloc] init];
    self.redEnvelopeDesLbl.font = FONT_SCALE(13);
    self.redEnvelopeDesLbl.backgroundColor = [UIColor clearColor];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.hidden = YES;
    self.buyBtn.adjustsImageWhenHighlighted = NO;
    [self.buyBtn addTarget:self action:@selector(buyBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn setImage:[UIImage imageNamed:@"buyRedPacketDefault.png"] forState:UIControlStateNormal];
    
    self.separateView = [[UIView alloc] init];
    self.separateView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    self.availBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.availBtn setTitle:@"可用红包" forState:UIControlStateNormal];
    self.availBtn.titleLabel.font = FONT_SCALE(12);
    self.availBtn.tag = 1;
    [self.availBtn addTarget:self action:@selector(switchREIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    self.unavailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.unavailBtn setTitle:@"用完/过期" forState:UIControlStateNormal];
    self.unavailBtn.titleLabel.font = FONT_SCALE(12);
    self.unavailBtn.tag = 2;
    [self.unavailBtn addTarget:self action:@selector(switchREIndex:) forControlEvents:UIControlEventTouchUpInside];

    
    self.eventSpearateLine = [[UIView alloc] init];
    self.eventSpearateLine.backgroundColor = UIColorFromRGB(0xe5e5e5);
    
    self.selectLine = [[UIView alloc] init];
    self.selectLine.backgroundColor = [UIColor redColor];
    
    
    [self addSubview:self.redEnvelopeLbl];
    [self addSubview:self.redEnvelopeDesLbl];
    [self addSubview:self.buyBtn];
    [self addSubview:self.separateView];
    [self addSubview:self.availBtn];
    [self addSubview:self.unavailBtn];
    [self addSubview:self.eventSpearateLine];
    [self addSubview:self.selectLine];
    
    [self.availBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(.5f);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.unavailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availBtn.mas_right);
        make.right.equalTo(self);
        make.width.equalTo(self.availBtn);
        make.bottom.height.equalTo(self.availBtn);
    }];
    
    [self.eventSpearateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.availBtn.mas_right).offset(-.5f);
        make.width.mas_equalTo(1);
        make.top.equalTo(self.availBtn.mas_top).offset(5);
        make.bottom.equalTo(self.availBtn.mas_bottom).offset(-5);
    }];
    
    [self.selectLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo(2.f);
        make.width.equalTo(self).multipliedBy(.5f);
        make.left.equalTo(self);
    }];

    [self.separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(self.availBtn.mas_top);
    }];

    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(self).multipliedBy(.3f);
        make.height.mas_equalTo(__SCALE(40.f));
        make.centerY.equalTo(self.separateView.mas_top).multipliedBy(.5f);
    }];

    [self.redEnvelopeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self.buyBtn.mas_left);
        make.height.mas_equalTo(35);
        make.centerY.equalTo(self.separateView.mas_top).multipliedBy(.5f);
    }];

    [self.redEnvelopeDesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.redEnvelopeLbl);
        make.right.equalTo(self.redEnvelopeLbl);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.separateView.mas_top).multipliedBy(.75f);
    }];
    
}

@end
