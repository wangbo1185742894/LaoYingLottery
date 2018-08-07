//
//  CLQuickBetHomeView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLQuickBetHomeView.h"
#import "CLConfigMessage.h"
#import "CQViewQuickAllocDef.h"
#import "CQDefinition.h"
#import "CLQuickRedPacketsModel.h"
#import "CLAccountInfoModel.h"
#import "CLQuickBetHomeTableViewCell.h"
#import "UILabel+CLAttributeLabel.h"
#define CQQuickBetViewWidth SCREEN_WIDTH - 2 * 30.f

@interface CLQuickBetHomeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *betBackView;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *quickbetHomeHeaderView;
@property (nonatomic, strong) UILabel *quickBetLabel;
@property (nonatomic, strong) UIView *quickLineView;

@property (nonatomic, strong) UILabel *quickNeedPayLabel;
@property (nonatomic, strong) UIButton *quickConfirmButton;

@property (nonatomic, strong) id quickPayCustomObj;

@property (nonatomic, strong) NSMutableArray *mainDataSource;

@property (nonatomic, readwrite) BOOL hasPaymentInfo;
@property (nonatomic, readwrite) BOOL hasRedParketsModel;
@end

@implementation CLQuickBetHomeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.closeButton];
        [self addSubview:self.betBackView];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self);
            make.width.height.mas_equalTo(__SCALE(20));
        }];
        [self.betBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.top.mas_equalTo(self.closeButton.mas_bottom).offset(5.f);
            make.width.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

- (void)reloadBetHomeView
{
    [self.mainTableView reloadData];
}

#pragma mark - confirmButton
- (void)paymentConfirmAction
{
    if (self.nextActionBlock) {
        self.nextActionBlock();
    }
}

#pragma mark - closebuttonClick
- (void)cancelButtonClick
{
    if (self.dissmissBlock) self.dissmissBlock();
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CLQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLQuickBetHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CLQuickBetHomeTableViewCellID"];
    if (!cell) {
        cell = [[CLQuickBetHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLQuickBetHomeTableViewCellID"];
    }
    id quickCellObj = self.mainDataSource[indexPath.row];
    NSString *itemString = nil;
    NSString *iconSring = nil;
    if ([quickCellObj isKindOfClass:[CLAccountInfoModel class]]) {
        if (((CLAccountInfoModel *)quickCellObj).account_type_id == 1) {
            //如果支付方式是账户
            itemString = [NSString stringWithFormat:@"%@ : %.2f元", ((CLAccountInfoModel *)quickCellObj).account_type_nm, ((CLAccountInfoModel *)quickCellObj).balance];
        }else{
            itemString = [NSString stringWithFormat:@"%@", ((CLAccountInfoModel *)quickCellObj).account_type_nm];
        }
        iconSring = ((CLAccountInfoModel *)quickCellObj).img_url;
    }else if([quickCellObj isKindOfClass:[CLQuickRedPacketsModel class]]){
        itemString = ((CLQuickRedPacketsModel *)quickCellObj).pay_name;
        iconSring = nil;
    }
    cell.itemString = itemString;
    cell.iconString = iconSring;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id obj = self.mainDataSource[indexPath.row];
    NSString *objClassString = NSStringFromClass([obj class]);
    if ([objClassString isEqualToString:@"CLAccountInfoModel"]) {
        /** 支付方式Cell */
        if (self.selectedPaymentBlock) {
            self.selectedPaymentBlock(self.mainDataSource[indexPath.row],quickHomePayChannelType);
        }
    }else if([objClassString isEqualToString:@"CLQuickRedPacketsModel"]){
        /** 红包Cell */
        if (self.selectedPaymentBlock) {
            self.selectedPaymentBlock(self.mainDataSource[indexPath.row],quickHomeRedParketsType);
        }
    }
}

#pragma mark - settingMethod

- (void)setQuickDataSource:(NSArray *)quickDataSource
{
    _quickDataSource = quickDataSource;
    if (!(quickDataSource && quickDataSource.count > 0)) return;
    self.quickPayCustomObj = quickDataSource.firstObject;
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:quickDataSource];
    [self.mainDataSource removeObjectAtIndex:0];
    //根据数据个数 改变tableView的高度
    [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([CLQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight] * self.mainDataSource.count);
    }];
    [self layoutIfNeeded];
    [self.mainTableView reloadData];
}
- (void)setQuickBetTitle:(NSString *)quickBetTitle{
    
    _quickBetTitle = quickBetTitle;
    self.quickBetLabel.text = quickBetTitle;
}

- (void)setNeedPayAmount:(NSString *)needPayAmount
{
    _needPayAmount = needPayAmount;
    self.quickNeedPayLabel.hidden =  !(needPayAmount && needPayAmount.length);
    if (needPayAmount && needPayAmount.length) {
        [self.quickNeedPayLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainTableView.mas_bottom).offset(__SCALE(20.f));
            make.left.mas_equalTo(__SCALE(10.f));
            
        }];
        [self.quickConfirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(__SCALE(40.f));
            make.top.equalTo(self.quickNeedPayLabel.mas_bottom).offset(__SCALE(20.f));
            make.left.mas_equalTo(self.betBackView).offset(__SCALE(20.f));
            make.right.equalTo(self.betBackView).offset(__SCALE(- 20.f));
            make.bottom.mas_equalTo(self.betBackView).offset(__SCALE(- 20.f));
        }];
        [self.quickNeedPayLabel attributeWithText:needPayAmount controParams:@[[AttributedTextParams attributeRange:NSMakeRange([needPayAmount rangeOfString:@"："].location + 1, needPayAmount.length - [needPayAmount rangeOfString:@"："].location - 1) Color:UIColorFromRGB(0xd80000)]]];
    }else{
        self.quickNeedPayLabel.text = @"";
        
        [self.quickConfirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(__SCALE(40.f));
            make.top.equalTo(self.mainTableView.mas_bottom).offset(__SCALE(20.f));
            make.left.mas_equalTo(self.betBackView).offset(__SCALE(20.f));
            make.right.equalTo(self.betBackView).offset(__SCALE(- 20.f));
            make.bottom.mas_equalTo(self.betBackView).offset(__SCALE(- 20.f));
        }];
    }
    [self layoutIfNeeded];
}

#pragma mark - gettingMethod

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton.frame = CGRectZero;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"testNO"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)betBackView
{
    if (!_betBackView) {
        _betBackView = [[UIView alloc] init];
        _betBackView.backgroundColor = UIColorFromRGB(0xffffff);
        _betBackView.clipsToBounds = YES;
        _betBackView.layer.cornerRadius = 5.f;
        [_betBackView addSubview:self.quickbetHomeHeaderView];
        [_betBackView addSubview:self.mainTableView];
        [_betBackView addSubview:self.quickNeedPayLabel];
        [_betBackView addSubview:self.quickConfirmButton];
        [self.quickbetHomeHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.betBackView);
            make.width.equalTo(self.betBackView);
            make.bottom.equalTo(self.quickBetLabel).offset(1.f);
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quickbetHomeHeaderView.mas_bottom);
            make.left.width.mas_equalTo(self.betBackView);
            make.height.mas_equalTo(0);
        }];
        [self.quickNeedPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mainTableView.mas_bottom).offset(__SCALE(20.f));
            make.left.mas_equalTo(__SCALE(10.f));
            
        }];
        [self.quickConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.quickNeedPayLabel.mas_bottom).offset(__SCALE(20.f));
            make.left.mas_equalTo(self.betBackView).offset(__SCALE(20.f));
            make.right.equalTo(self.betBackView).offset(__SCALE(- 20.f));
            make.bottom.mas_equalTo(self.betBackView).offset(__SCALE(- 20.f));
            make.height.equalTo(self.quickConfirmButton.mas_width).multipliedBy(2.0/15);
        }];
    }
    return _betBackView;
}

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.scrollEnabled = NO;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

- (UIView *)quickbetHomeHeaderView
{
    if (!_quickbetHomeHeaderView) {
        _quickbetHomeHeaderView = [[UIView alloc] init];
        [_quickbetHomeHeaderView addSubview:self.quickBetLabel];
        [_quickbetHomeHeaderView addSubview:self.quickLineView];
        [self.quickBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_quickbetHomeHeaderView).offset(__SCALE(5.f));
            make.left.mas_equalTo(_quickbetHomeHeaderView).offset(__SCALE(10.f));
            make.right.mas_equalTo(_quickbetHomeHeaderView).offset(-__SCALE(10.f));
            make.height.mas_equalTo(__SCALE(50.f));
        }];
        [self.quickLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.quickBetLabel.mas_bottom);
            make.left.right.equalTo(self.quickBetLabel);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _quickbetHomeHeaderView;
}

- (UILabel *)quickBetLabel
{
    if (!_quickBetLabel) {
        
        AllocNormalLabel(_quickBetLabel, @"快速投注", FONT_SCALE(16), NSTextAlignmentLeft, UIColorFromRGB(0x333333), CGRectZero);
    }
    return _quickBetLabel;
}

- (UILabel *)quickNeedPayLabel
{
    if (!_quickNeedPayLabel) {
        AllocNormalLabel(_quickNeedPayLabel, @"", FONT(15), NSTextAlignmentLeft, UIColorFromRGB(0x333333), CGRectZero);
    }
    return _quickNeedPayLabel;
}

- (UIView *)quickLineView{
    
    if (!_quickLineView) {
        _quickLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _quickLineView.backgroundColor = UIColorFromRGB(0xeeeeee);
    }
    return _quickLineView;
}
- (UIButton *)quickConfirmButton
{
    if (!_quickConfirmButton) {
        _quickConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickConfirmButton setTintColor:UIColorFromRGB(0xffffff)];
        [_quickConfirmButton setBackgroundColor:THEME_COLOR];
        [_quickConfirmButton setTitle:@"确定支付" forState:UIControlStateNormal];
        _quickConfirmButton.layer.cornerRadius = 3.f;
        _quickConfirmButton.layer.masksToBounds = YES;
        [_quickConfirmButton addTarget:self action:@selector(paymentConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickConfirmButton;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}

@end
