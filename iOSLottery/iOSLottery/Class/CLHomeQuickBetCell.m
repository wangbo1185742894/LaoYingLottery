//
//  CLHomeQuickBetCell.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/7.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeQuickBetCell.h"
#import "CLConfigMessage.h"
#import "CLHomeQuickGameView.h"
#import "CLHomeHotBetModel.h"
#import "CLHomeGamePeriodModel.h"
#import "UITextField+InputLimit.h"
#import "CLTools.h"
#import "CLHomeQuickBetService.h"
#import "CLLotteryBaseBetTerm.h"
#import "CLCheckProgessManager.h"
#import "CLJumpLotteryManager.h"
#import "CLShowHUDManager.h"
@interface CLHomeQuickBetCell () <UITextFieldDelegate , CLHomeQuickBetServiceDelegate>

@property (nonatomic, strong) UILabel* lotteryTitleLbl;
@property (nonatomic, strong) UILabel *addBonusLabel;//加奖说明label
@property (nonatomic, strong) UIButton *moreGameButton;//更多玩法说明
@property (nonatomic, strong) UIButton *moreGameImgButton;//更多玩法图片
@property (nonatomic, strong) CLHomeGamePeriodModel *gamePeriod;

@property (nonatomic, strong) UILabel *infoLabel;//说明label

/**
 选号重置按钮
 */
@property (nonatomic, strong) UIButton* switchLotteryBtn;

/**
 选号重置按钮中间图
 */
@property (nonatomic, strong) UIImageView *switchLotteryImageView;

/**
 分割线
 */
@property (nonatomic, strong) UIView* lineView;

/**
 中间类型view
 */
@property (nonatomic, strong) CLHomeQuickGameView* lotteryView;

/**
 立刻购买按钮
 */
@property (nonatomic, strong) UIButton* betBtn;

/**
 输入框前文字
 */
@property (nonatomic, strong) UILabel* betLbl;

/**
 输入框后文字
 */
@property (nonatomic, strong) UILabel* mulLbl;

/**
 倍数输入框
 */
@property (nonatomic, strong) UITextField* mulTextField;

/**
 截止时间titleLabel
 */
@property (nonatomic, strong) UILabel *timeNameLabel;

/**
 定时器label
 */
@property (nonatomic, strong) UILabel* timerLbl;

/**
 底部灰色横线
 */
@property (nonatomic, strong) UIView *bottomGrayLine;

/**
 快速投注服务类
 */
@property (nonatomic, strong) CLHomeQuickBetService *quickBetService;
@end

@implementation CLHomeQuickBetCell
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

+ (instancetype)homeQuickBetCellCreateWithTableView:(UITableView *)tableView
{
    
    CLHomeQuickBetCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLHomeQuickBetCellId"];
    
    if (cell == nil) {
        
        cell = [[CLHomeQuickBetCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CLHomeQuickBetCellId"];
    }

    return cell;
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lotteryTitleLbl];
        [self.contentView addSubview:self.moreGameButton];
        [self.contentView addSubview:self.moreGameImgButton];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.addBonusLabel];
        
        [self.contentView addSubview:self.switchLotteryBtn];
        [self.switchLotteryBtn addSubview:self.switchLotteryImageView];
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.timerLbl];
        [self.contentView addSubview:self.lotteryView];
        [self.contentView addSubview:self.betBtn];
        
        [self.contentView addSubview:self.betLbl];
        [self.contentView addSubview:self.mulTextField];
        [self.contentView addSubview:self.mulLbl];
        
        [self.contentView addSubview:self.timeNameLabel];
        [self.contentView addSubview:self.timerLbl];
        [self.contentView addSubview:self.bottomGrayLine];
        WS(_weakSelf)
        
        [self.lotteryTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.contentView).offset(__SCALE(5.f));
            make.top.equalTo(_weakSelf.contentView);
            make.height.mas_equalTo(__SCALE(25.f));
        }];
        [self.addBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.lotteryTitleLbl);
            make.left.equalTo(self.lotteryTitleLbl.mas_right).offset(__SCALE(3.f));
        }];
        [self.moreGameImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.lotteryTitleLbl);
            make.right.equalTo(self.contentView).offset(__SCALE(- 10.f));
        }];
        
        [self.moreGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.moreGameImgButton);
            make.right.equalTo(self.moreGameImgButton.mas_left).offset(- 2.f);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.lotteryTitleLbl);
            make.top.equalTo(_weakSelf.lotteryTitleLbl.mas_bottom);
            make.height.mas_equalTo(.5f);
            make.right.equalTo(_weakSelf.moreGameImgButton);
        }];
        
        [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(__SCALE(10.f));
            make.top.equalTo(self.lineView.mas_bottom).offset(__SCALE(5.f));
        }];
        
        [self.timeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.timerLbl.mas_left).offset(- 1.f);
            make.centerY.equalTo(self.timerLbl);
        }];
        [self.timerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_weakSelf.moreGameImgButton);
            make.width.mas_greaterThanOrEqualTo(__SCALE(40.f));
            make.top.equalTo(self.infoLabel);
        }];

        [self.lotteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_weakSelf.timerLbl.mas_bottom).offset(__SCALE(10.f));
            make.centerX.equalTo(self.contentView);
        }];
        
        [self.switchLotteryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(__SCALE(24));
            make.width.mas_equalTo(__SCALE(33));
            make.centerY.equalTo(self.lotteryView);
            make.right.equalTo(self).offset(__SCALE(- 10.f));
        }];
        
        [self.switchLotteryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.switchLotteryBtn);
            make.height.width.mas_equalTo(__SCALE(15.f));
        }];
        
        [self.betBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(_weakSelf.contentView).offset(__SCALE(-5));
            make.right.equalTo(_weakSelf.contentView).offset(__SCALE(-10.f));
            make.height.mas_equalTo(__SCALE(30.f));
            make.width.mas_equalTo(__SCALE(200.f));
        }];
        
        [self.betLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_weakSelf.contentView).offset(10);
            make.centerY.equalTo(_weakSelf.betBtn);
            make.height.mas_equalTo(__SCALE(20.f));
        }];
        
        [self.mulTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.betLbl.mas_right).offset(5.f);
            make.centerY.equalTo(_weakSelf.betLbl);
            make.width.mas_equalTo(__SCALE(40.f));
            make.height.mas_equalTo(__SCALE(24.f));
        }];
        
        [self.mulLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_weakSelf.mulTextField.mas_right).offset(5.f);
            make.centerY.equalTo(_weakSelf.betLbl);
        }];
        [self.bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(__SCALE(5.f));
            
        }];
       // 添加倒计时通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeCutDown:) name:GlobalTimerRuning object:nil];
        
    }
    return self;
}

#pragma mark ------------ event Response ------------

- (void)switchLotteryNumber:(id)sender {
    
    NSArray *randomArray = nil;
    randomArray = [self.quickBetService getRandomBetTermWithType:self.gamePeriod.gameEn];
    [self.lotteryView switchNumberWithArray:randomArray];
}

- (void)betClicked:(id)sender {
    
    if ([self.mulTextField.text integerValue] < 1) {
        
        [CLShowHUDManager showHUDWithView:self text:@"请输入倍数" type:CLShowHUDTypeOnlyText delayTime:1.f];
        return;
    }
    
    if (self.gamePeriod.saleEndTime < 1) {
        
        [CLShowHUDManager showHUDWithView:self text:@"当前期次已截止，请刷新" type:CLShowHUDTypeOnlyText delayTime:1.f];
        if ([self.delegate respondsToSelector:@selector(refreshData)]) {
            [self.delegate refreshData];
        }
        return;
    }
    
    WS(_weakSelf)
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        [_weakSelf.quickBetService createOrderNumberWithMultiple:[_weakSelf.mulTextField.text integerValue] periodModel:_weakSelf.gamePeriod];
    }];
}

- (void)moreGameButtonOnClick:(UIButton *)btn{
    
    //更多玩法
    [CLJumpLotteryManager jumpLotteryWithGameEn:self.gamePeriod.gameEn];
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger maxTimes = 9999;
    if (self.gamePeriod.maxBetTimes > 0) {
        maxTimes = self.gamePeriod.maxBetTimes;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (toBeString.length == 1 && [toBeString isEqualToString:@"0"]) {
        [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最小输入1倍"] type:CLShowHUDTypeOnlyText delayTime:.5f];
    }
    if ([toBeString longLongValue] > maxTimes) { //如果输入框内容大于5则弹出警告
        [CLShowHUDManager showInWindowWithText:[NSString stringWithFormat:@"最大输入%zi倍", maxTimes] type:CLShowHUDTypeOnlyText delayTime:.5f];
    }
    return [textField limitNumberWithMaxNumber:maxTimes ShouldChangeCharactersInRange:range replacementString:string];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text integerValue] < 1) {
        textField.text = @"5";
    }
}
#pragma mark ------------ betService Delegate ------------
- (void)requestFinishBet:(id)data{
    
    if ([self.delegate respondsToSelector:@selector(createOrderSuccess:payAccount:)]) {
        [self.delegate createOrderSuccess:data payAccount:[self.mulTextField.text integerValue] * 2];
    }
}

- (void)requestFailBet:(id)data{
    
    if ([self.delegate respondsToSelector:@selector(createOrderFail:)]) {
        [self.delegate createOrderFail:data];
    }
}
#pragma mark ------------ private Mothed ------------
- (void)timeCutDown:(NSNotification *)noti{
    
    if (self.gamePeriod.saleEndTime > 0) {
        self.gamePeriod.saleEndTime --;
        [self configUI];
    }else{
        
        if ([self.delegate respondsToSelector:@selector(timeOut)]) {
            [self.delegate timeOut];
        }
    }
}
- (void)configUI{
    
    self.timerLbl.text = [NSString stringWithFormat:@"%@", [CLTools timeFormatted:self.gamePeriod.saleEndTime]];
    self.lotteryTitleLbl.text = [NSString stringWithFormat:@"%@",self.gamePeriod.gameName];
}
#pragma mark - setter
- (void)setHotBetModel:(CLHomeHotBetModel *)hotBetModel{
    
    _hotBetModel = hotBetModel;
    self.addBonusLabel.text = hotBetModel.hotTitle;
    self.infoLabel.text = hotBetModel.hotTips;
    self.gamePeriod = hotBetModel.periodVo;
}
- (void)setGamePeriod:(CLHomeGamePeriodModel *)gamePeriod{
    
    _gamePeriod = gamePeriod;
    _lotteryView.gameEn = _gamePeriod.gameEn;
    [self switchLotteryNumber:nil];
    [self configUI];
}
- (void)setIsShowBottomLine:(BOOL)isShowBottomLine{
    
    self.bottomGrayLine.hidden = !isShowBottomLine;
    [self.betBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(isShowBottomLine ? __SCALE(-10) : __SCALE(-5));
    }];
    [self updateConstraintsIfNeeded];
}

#pragma mark - getter

- (UILabel *)lotteryTitleLbl {
    
    if (!_lotteryTitleLbl) {
        _lotteryTitleLbl = [[UILabel alloc] init];
        _lotteryTitleLbl.backgroundColor = [UIColor clearColor];
        _lotteryTitleLbl.font = FONT_SCALE(12);
        _lotteryTitleLbl.textColor = UIColorFromRGB(0x333333);
        _lotteryTitleLbl.text = @"【新快3】";
        
    }
    return _lotteryTitleLbl;
}

- (UILabel *)addBonusLabel{
    
    if (!_addBonusLabel) {
        _addBonusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addBonusLabel.text = @"加奖123";
        _addBonusLabel.textColor = THEME_COLOR;
        _addBonusLabel.font = FONT_SCALE(12);
    }
    return _addBonusLabel;
}

- (UIButton *)moreGameButton{
    
    if (!_moreGameButton) {
        
        _moreGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreGameButton.titleLabel.font = FONT_SCALE(11);
        [_moreGameButton setTitleColor:UIColorFromRGB(0x5494ff) forState:UIControlStateNormal];
        [_moreGameButton setTitle:@"更多玩法" forState:UIControlStateNormal];
        [_moreGameButton addTarget:self action:@selector(moreGameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreGameButton;
}
- (UIButton *)moreGameImgButton{
    
    if (!_moreGameImgButton) {
        
        _moreGameImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreGameImgButton setImage:[UIImage imageNamed:@"home_MorePlay.png"] forState:UIControlStateNormal];
        [_moreGameImgButton addTarget:self action:@selector(moreGameButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreGameImgButton;
}
- (UILabel *)infoLabel{
    
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.text = @"和值：猜3个骰子点数之和";
        _infoLabel.textColor = UIColorFromRGB(0x999999);
        _infoLabel.font = FONT_SCALE(11);
    }
    return _infoLabel;
}

- (UIButton *)switchLotteryBtn {
    
    if (!_switchLotteryBtn) {
        _switchLotteryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_switchLotteryBtn setImage:[UIImage imageNamed:@"homeBetExchange.png"] forState:UIControlStateNormal];
        _switchLotteryBtn.layer.cornerRadius = 2.f;
        _switchLotteryBtn.layer.masksToBounds = YES;
        _switchLotteryBtn.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        _switchLotteryBtn.layer.borderWidth = .5f;
        
        [_switchLotteryBtn addTarget:self action:@selector(switchLotteryNumber:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchLotteryBtn;
}
- (UIImageView *)switchLotteryImageView{
    
    if (!_switchLotteryImageView) {
        _switchLotteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(__SCALE(3.f), __SCALE(7.5f), __SCALE(18), __SCALE(18))];
        _switchLotteryImageView.image = [UIImage imageNamed:@"homeBetExchange.png"];
        _switchLotteryImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _switchLotteryImageView;
}
- (UIView *)lineView {
    
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}

- (UIButton *)betBtn {
    
    if (!_betBtn) {
        _betBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_betBtn setTitle:@"立即投注" forState:UIControlStateNormal];
        [_betBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _betBtn.backgroundColor = UIColorFromRGB(0xDF3730);
        _betBtn.titleLabel.font = FONT_SCALE(16);
        [_betBtn addTarget:self action:@selector(betClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betBtn;
}

- (UILabel *)betLbl {
    
    if (!_betLbl) {
        _betLbl = [[UILabel alloc] init];
        _betLbl.backgroundColor = [UIColor clearColor];
        _betLbl.text = @"投注";
        _betLbl.textColor = UIColorFromRGB(0x333333);
        _betLbl.font = FONT_SCALE(13);
    }
    return _betLbl;
}

- (UILabel *)mulLbl {
    
    if (!_mulLbl) {
        _mulLbl = [[UILabel alloc] init];
        _mulLbl.backgroundColor = [UIColor clearColor];
        _mulLbl.text = @"倍";
        _mulLbl.textColor = UIColorFromRGB(0x333333);
        _mulLbl.font = FONT_SCALE(13);
    }
    return _mulLbl;
}

- (UITextField *)mulTextField {
    
    if (!_mulTextField) {
        _mulTextField = [[UITextField alloc] init];
        _mulTextField.textColor = UIColorFromRGB(0x333333);
        _mulTextField.font = FONT_SCALE(14);
        _mulTextField.text = @"5";
        _mulTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mulTextField.layer.borderWidth = .5f;
        _mulTextField.layer.cornerRadius = 2.f;
        _mulTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mulTextField.textAlignment = NSTextAlignmentCenter;
        _mulTextField.delegate = self;
    }
    return _mulTextField;
}

- (UILabel *)timeNameLabel{
    
    if (!_timeNameLabel) {
        _timeNameLabel = [[UILabel alloc] init];
        _timeNameLabel.textAlignment = NSTextAlignmentCenter;
        _timeNameLabel.backgroundColor = [UIColor clearColor];
        _timeNameLabel.font = FONT_SCALE(11);
        _timeNameLabel.textColor = UIColorFromRGB(0x999999);
        _timeNameLabel.text = @"距本期截止 ";
    }
    return _timeNameLabel;
}
- (UILabel *)timerLbl {
    
    if (!_timerLbl) {
        _timerLbl = [[UILabel alloc] init];
        _timerLbl.textAlignment = NSTextAlignmentLeft;
        _timerLbl.backgroundColor = [UIColor clearColor];
        _timerLbl.font = FONT_SCALE(11);
        _timerLbl.textColor = THEME_COLOR;
        _timerLbl.text = @"00:00";
    }
    return _timerLbl;
}

- (CLHomeQuickGameView *)lotteryView {
    
    if (!_lotteryView) {
        _lotteryView = [[CLHomeQuickGameView alloc] init];
    }
    return _lotteryView;
}

- (CLHomeQuickBetService *)quickBetService{
    
    if (!_quickBetService) {
        _quickBetService = [[CLHomeQuickBetService alloc] init];
        _quickBetService.delegate = self;
    }
    return _quickBetService;
}
- (UIView *)bottomGrayLine{
    
    if (!_bottomGrayLine) {
        _bottomGrayLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomGrayLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _bottomGrayLine;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
    [super layoutSublayersOfLayer:layer];
    self.betBtn.layer.cornerRadius = 3.f;
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
