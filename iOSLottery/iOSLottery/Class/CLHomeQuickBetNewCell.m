//
//  CLHomeQuickBetNewCell.m
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/20.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLConfigMessage.h"
#import "CLJumpLotteryManager.h"
#import "CLHomeQuickBetNewCell.h"
#import "CLHomeHotBetModel.h"
#import "CLHomeGamePeriodModel.h"
#import "CLHomeQuickBetService.h"
#import "CLAwardNumberNewView.h"
#import "CLCheckProgessManager.h"

@interface CLHomeQuickBetNewCell ()<CLHomeQuickBetServiceDelegate>

/**
 玩法label
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 加奖说明label
 */
@property (nonatomic, strong) UILabel *addBonusLabel;

/**
 更多玩法说明
 */
@property (nonatomic, strong) UIButton *moreGameButton;

/**
 更多玩法说明图片
 */
@property (nonatomic, strong) UIButton *moreGameImgButton;

/**
 横线
 */
@property (nonatomic, strong) UIView *lineView;

/**
 选号重置按钮
 */
@property (nonatomic, strong) UIButton* resetBallNumber;

/**
 选号重置按钮中间图
 */
@property (nonatomic, strong) UIImageView *resetBallNumberImageView;

/**
 选号内容图
 */
@property (nonatomic, strong) UIView *baseView;

/**
 红球view
 */
@property (nonatomic, strong) CLAwardNumberNewView *redBallView;

/**
 蓝球view
 */
@property (nonatomic, strong) CLAwardNumberNewView *blueBallView;

/**
 开奖时间
 */
@property (nonatomic, strong) UILabel *openTime;

/**
 立即投注
 */
@property (nonatomic, strong) UIButton *goBetBtn;

/**
 底部灰色横线
 */
@property (nonatomic, strong) UIView *bottomGrayLine;

@property (nonatomic, strong) CLHomeGamePeriodModel *gamePeriod;
/**
 快速投注服务类
 */
@property (nonatomic, strong) CLHomeQuickBetService *quickBetService;

@end

@implementation CLHomeQuickBetNewCell

//类方法
+ (instancetype)homeQuickBetNewCellCreateWithTableView:(UITableView *)tableView
{
    
    CLHomeQuickBetNewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CLHomeQuickBetNewCellId"];
    
    if (cell == nil) {
        
        cell = [[CLHomeQuickBetNewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"CLHomeQuickBetNewCellId"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        

        //添加控件
        [self setUpContentView];
        
        //添加约束
        [self addConstraintsForcContentView];
        
    }

    return self;
}

//添加子视图
- (void)setUpContentView
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addBonusLabel];
    [self.contentView addSubview:self.moreGameImgButton];
    [self.contentView addSubview:self.moreGameButton];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.baseView];
    [self.baseView addSubview:self.redBallView];
    [self.baseView addSubview:self.blueBallView];
    [self.contentView addSubview:self.resetBallNumber];
    [self.resetBallNumber addSubview:self.resetBallNumberImageView];
    [self.contentView addSubview:self.openTime];
    [self.contentView addSubview:self.goBetBtn];
    [self.contentView addSubview:self.bottomGrayLine];
}

//添加约束
- (void)addConstraintsForcContentView
{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(__SCALE(10.f));
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(25.f));
    }];
    
    [self.addBonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(__SCALE(3.f));
    }];
    
    [self.moreGameImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(__SCALE(- 10.f));
    }];
    
    [self.moreGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.moreGameImgButton);
        make.right.equalTo(self.moreGameImgButton.mas_left).offset(- 2.f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(0.5f);
        make.right.equalTo(self.moreGameImgButton);
    }];
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lineView.mas_bottom).offset(__SCALE(10.f));
        make.left.equalTo(self.titleLabel.mas_left);
    }];
    
    [self.redBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.equalTo(self.baseView);
        make.height.mas_equalTo(__SCALE(40.f));
    }];
    
    [self.blueBallView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.redBallView.mas_right).offset(self.redBallView.space);
        make.top.bottom.right.equalTo(self.baseView);
        //make.right.equalTo(self.baseView);
    }];
    
    [self.resetBallNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(__SCALE(24.f));
        make.width.mas_equalTo(__SCALE(33.f));
        make.centerY.equalTo(self.baseView);
        make.right.equalTo(self).offset(__SCALE(- 10.f));
    }];
    
    [self.resetBallNumberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.resetBallNumber);
        make.height.width.mas_equalTo(__SCALE(15.f));
    }];
    
    [self.goBetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.contentView).offset(__SCALE(-5.f));
        make.right.equalTo(self.contentView).offset(__SCALE(-10.f));
        make.height.mas_equalTo(__SCALE(30.f));
        make.width.mas_equalTo(__SCALE(120.f));
    }];
    
    [self.openTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left).offset(5.f);
        make.centerY.equalTo(self.goBetBtn);
    }];
    
    [self.bottomGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(__SCALE(5.f));
        
    }];

}
#pragma mark ------------ betService Delegate ------------
- (void)requestFinishBet:(id)data{
    
    if ([self.delegate respondsToSelector:@selector(createOrderSuccess:payAccount:)]) {
        [self.delegate createOrderSuccess:data payAccount:1 * 2];
    }
}

- (void)requestFailBet:(id)data{
    
    if ([self.delegate respondsToSelector:@selector(createOrderFail:)]) {
        [self.delegate createOrderFail:data];
    }
}


#pragma mark --- Setter Method ----

-(void)setHotBetModel:(CLHomeHotBetModel *)hotBetModel
{
    _hotBetModel = hotBetModel;
    self.addBonusLabel.text = hotBetModel.hotTitle;
    self.gamePeriod = hotBetModel.periodVo;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.gamePeriod.gameName];
    
    if (hotBetModel.buttonTips && hotBetModel.buttonTips.length > 0) {
        
        [self.goBetBtn setTitle:hotBetModel.buttonTips forState:(UIControlStateNormal)];
        
    }else{
    
        [self.goBetBtn setTitle:@"立即投注" forState:(UIControlStateNormal)];
    }
    
    self.openTime.text = [NSString stringWithFormat:@"%@",hotBetModel.hotTips];

}

- (void)setGamePeriod:(CLHomeGamePeriodModel *)gamePeriod
{
    _gamePeriod = gamePeriod;
    
    [self randomBallNumber];
}

//随机球号
- (void)randomBallNumber
{
    NSArray *randomArray = nil;
    
    randomArray = [self.quickBetService getRandomBetTermWithType:self.gamePeriod.gameEn];
    
    //randomArray = [randomArray sortedArrayUsingSelector:@selector(compare:)];
    
    if ([[_gamePeriod.gameEn lowercaseString] hasSuffix:@"ssq"]) {
        
        [self.redBallView setNumbers:[self sortRandomArray:[randomArray subarrayWithRange:NSMakeRange(0, 6)]]];
        [self.blueBallView setNumbers:[self sortRandomArray:[randomArray subarrayWithRange:NSMakeRange(6, 1)]]];
        
    }else{
        
        [self.redBallView setNumbers:[self sortRandomArray:[randomArray subarrayWithRange:NSMakeRange(0, 5)]]];
        [self.blueBallView setNumbers:[self sortRandomArray:[randomArray subarrayWithRange:NSMakeRange(5, 2)]]];
        
    }
}

//随机球号排序
- (NSArray *)sortRandomArray:(NSArray *)array
{
    return [array sortedArrayUsingSelector:@selector(compare:)];
}
//判断是否显示，底部灰色横线
- (void)setIsShowBottomLine:(BOOL)isShowBottomLine{
    
    self.bottomGrayLine.hidden = !isShowBottomLine;
    
    [self.goBetBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(isShowBottomLine ? __SCALE(-10) : __SCALE(-5));
    }];
    [self updateConstraintsIfNeeded];
}

#pragma mark --- Button Click ---

- (void)moreGameButtonOnClick{
    
    //更多玩法
    [CLJumpLotteryManager jumpLotteryWithGameEn:self.gamePeriod.gameEn];
}

- (void)resetBallNumberClick
{

    [self randomBallNumber];

}

//立即购彩
- (void)gotoBetClicked
{
    WS(_weakSelf)
    [[CLCheckProgessManager shareCheckProcessManager] checkIsLoginWithCallBack:^{
        [_weakSelf.quickBetService createOrderNumberWithMultiple:1 periodModel:_weakSelf.gamePeriod];
    }];

}

#pragma mark --- lazyLoad ---

-(UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = FONT_SCALE(12);
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        
    }
    return _titleLabel;
}


- (UILabel *)addBonusLabel{
    
    if (_addBonusLabel == nil) {
        _addBonusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _addBonusLabel.textColor = THEME_COLOR;
        _addBonusLabel.font = FONT_SCALE(12);
    }
    return _addBonusLabel;
}

- (UIButton *)moreGameButton{
    
    if (_moreGameButton == nil) {
        
        _moreGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreGameButton.titleLabel.font = FONT_SCALE(11);
        [_moreGameButton setTitleColor:UIColorFromRGB(0x5494ff) forState:UIControlStateNormal];
        [_moreGameButton setTitle:@"更多玩法" forState:UIControlStateNormal];
        [_moreGameButton addTarget:self action:@selector(moreGameButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreGameButton;
}

- (UIButton *)moreGameImgButton{
    
    if (!_moreGameImgButton) {
        
        _moreGameImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreGameImgButton setImage:[UIImage imageNamed:@"home_MorePlay.png"] forState:UIControlStateNormal];
        [_moreGameImgButton addTarget:self action:@selector(moreGameButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreGameImgButton;
}

- (UIView *)lineView {
    
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}

- (UIView *)baseView
{

    if (_baseView == nil) {
        
        _baseView = [[UIView alloc] init];
        //_baseView.backgroundColor = [UIColor redColor];
    }

    return _baseView;
}

- (CLAwardNumberNewView *)redBallView
{
    
    if (_redBallView == nil) {
        
        _redBallView = [[CLAwardNumberNewView alloc] init];
        _redBallView.ballColor = THEME_COLOR;
        _redBallView.space = __SCALE(8.f);
    }
    
    return _redBallView;
}

- (CLAwardNumberNewView *)blueBallView
{
    
    if (_blueBallView == nil) {
        
        _blueBallView = [[CLAwardNumberNewView alloc] init];
        _blueBallView.ballColor = UIColorFromRGB(0x295fcc);
        _blueBallView.space = __SCALE(8.f);
    }
    
    return _blueBallView;
}

- (UIButton *)resetBallNumber
{
    
    if (_resetBallNumber == nil) {
        _resetBallNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_switchLotteryBtn setImage:[UIImage imageNamed:@"homeBetExchange.png"] forState:UIControlStateNormal];
        _resetBallNumber.layer.cornerRadius = 2.f;
        _resetBallNumber.layer.masksToBounds = YES;
        _resetBallNumber.layer.borderColor = UIColorFromRGB(0xcccccc).CGColor;
        _resetBallNumber.layer.borderWidth = .5f;
        
        [_resetBallNumber addTarget:self action:@selector(resetBallNumberClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBallNumber;
}
- (UIImageView *)resetBallNumberImageView
{
    
    if (_resetBallNumberImageView == nil) {
        _resetBallNumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(__SCALE(3.f), __SCALE(7.5f), __SCALE(18), __SCALE(18))];
        _resetBallNumberImageView.image = [UIImage imageNamed:@"homeBetExchange.png"];
        _resetBallNumberImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _resetBallNumberImageView;
}

- (UILabel *)openTime
{

    if (_openTime == nil) {
        
        _openTime = [[UILabel alloc] init];
        _openTime.backgroundColor = [UIColor clearColor];
        _openTime.font = FONT_SCALE(12);
        _openTime.textColor = UIColorFromRGB(0x999999);

    }
    
    return _openTime;

}

- (UIButton *)goBetBtn
{

    if (_goBetBtn == nil) {
        _goBetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBetBtn setTitle:@"立即投注" forState:UIControlStateNormal];
        [_goBetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goBetBtn.backgroundColor = THEME_COLOR;
        _goBetBtn.titleLabel.font = FONT_SCALE(16);
        _goBetBtn.layer.masksToBounds = YES;
        _goBetBtn.layer.cornerRadius = 3.f;
        [_goBetBtn addTarget:self action:@selector(gotoBetClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBetBtn;

}

- (UIView *)bottomGrayLine{
    
    if (!_bottomGrayLine) {
        _bottomGrayLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomGrayLine.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _bottomGrayLine;
}

- (CLHomeQuickBetService *)quickBetService{
    
    if (!_quickBetService) {
        _quickBetService = [[CLHomeQuickBetService alloc] init];
        _quickBetService.delegate = self;
    }
    return _quickBetService;
}


@end
