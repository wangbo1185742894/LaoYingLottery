//
//  CKQuickBetHomeView.m
//  iOSLottery
//
//  Created by 小铭 on 2016/12/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CKQuickBetHomeView.h"
#import "CKDefinition.h"
#import "Masonry.h"
#import "UILabel+CKAttributeLabel.h"
#import "CKQuickBetHomeTableViewCell.h"
#import "CKPayChannelUISource.h"
#import "CKRedPacketUISource.h"
#define CKQuickBetViewWidth SCREEN_WIDTH - 2 * 30.f

@interface CKQuickBetHomeView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *betBackView;
@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) UIView *quickbetHomeHeaderView;
@property (nonatomic, strong) UILabel *quickBetLabel;

@property (nonatomic, strong) UILabel *quickNeedPayLabel;
@property (nonatomic, strong) UIButton *quickConfirmButton;

@property (nonatomic, strong) id quickPayCustomObj;

@property (nonatomic, strong) NSMutableArray *mainDataSource;

@property (nonatomic, readwrite) BOOL hasPaymentInfo;
@property (nonatomic, readwrite) BOOL hasRedParketsModel;

@property (nonatomic, strong) UILabel *subTitleLabel;//副标题  由支付方要求 需要实名认证

@end

@implementation CKQuickBetHomeView

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
    return [CKQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CKQuickBetHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CKQuickBetHomeTableViewCellID"];
    if (!cell) {
        cell = [[CKQuickBetHomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CKQuickBetHomeTableViewCellID"];
    }
    id quickCellObj = self.mainDataSource[indexPath.row];
    NSString *itemString = nil;
    NSString *iconSring = nil;
    if ([quickCellObj isKindOfClass:[CKPayChannelUISource class]]) {
        
        itemString = ((CKPayChannelUISource *)quickCellObj).channel_name;
        iconSring = ((CKPayChannelUISource *)quickCellObj).channel_icon_str;
    }else if([quickCellObj isKindOfClass:[CKRedPacketUISource class]]){
        itemString = ((CKRedPacketUISource *)quickCellObj).selectedTitle;
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
    if ([objClassString isEqualToString:@"CKPayChannelUISource"]) {
        /** 支付方式Cell */
        if (self.selectedPaymentBlock && ((CKPayChannelUISource *)obj).usability) {
            self.selectedPaymentBlock(self.mainDataSource[indexPath.row],quickHomePayChannelType);
        }
    }else if([objClassString isEqualToString:@"CKRedPacketUISource"]){
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
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:quickDataSource];  
    //根据数据个数 改变tableView的高度
    [self.mainTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([CKQuickBetHomeTableViewCell quickBetHomeTableViewCellHeight] * self.mainDataSource.count + 1.f);
    }];
    [self layoutIfNeeded];
    [self.mainTableView reloadData];
}
- (void)setQuickBetTitle:(NSString *)quickBetTitle{
    
    _quickBetTitle = quickBetTitle;
    self.quickBetLabel.text = quickBetTitle;
    /** 底部提示信息 */
}

- (void)setQuickConfirmTitle:(NSString *)quickConfirmTitle
{
    _quickConfirmTitle = quickConfirmTitle;
    [self.quickConfirmButton setTitle:quickConfirmTitle forState:UIControlStateNormal];
}

- (void)setNeedPayAmount:(NSString *)needPayAmount
{
    _needPayAmount = needPayAmount;
    self.quickNeedPayLabel.hidden =  !(needPayAmount && needPayAmount.length);
    if (needPayAmount && needPayAmount.length) {
        [self.quickbetHomeHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(self.betBackView);
            make.width.equalTo(self.betBackView);
            make.bottom.equalTo(self.quickNeedPayLabel).offset(__SCALE(10.f));
        }];
        
        
        self.quickNeedPayLabel.hidden = NO;
        [self.quickNeedPayLabel ck_attributeWithText:needPayAmount controParams:@[[CKAttributedTextParams attributeRange:NSMakeRange([needPayAmount rangeOfString:@"："].location + 1, needPayAmount.length - [needPayAmount rangeOfString:@"："].location - 2) Color:UIColorFromRGB(0xd80000)]]];
    }else{
        [self.quickbetHomeHeaderView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.equalTo(self.betBackView);
            make.width.equalTo(self.betBackView);
            make.bottom.equalTo(self.quickBetLabel).offset(__SCALE(10.f));
        }];
        self.quickNeedPayLabel.text = @"";
        self.quickNeedPayLabel.hidden = YES;
    }
    [self layoutIfNeeded];
}
- (void)setSubTitle:(NSString *)subTitle{
    
    self.subTitleLabel.text = subTitle;
}

#pragma mark - SttingMothed

- (void)setButtonStatus:(BOOL)buttonStatus
{
    self.quickConfirmButton.enabled = buttonStatus;
}

#pragma mark - gettingMethod

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton.frame = CGRectZero;
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"ck_europeClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIView *)betBackView
{
    if (!_betBackView) {
        _betBackView = [[UIView alloc] init];
        _betBackView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        _betBackView.clipsToBounds = YES;
        _betBackView.layer.cornerRadius = 5.f;
        [_betBackView addSubview:self.quickbetHomeHeaderView];
        [_betBackView addSubview:self.mainTableView];
        [_betBackView addSubview:self.subTitleLabel];
        [_betBackView addSubview:self.quickConfirmButton];
        [self.quickbetHomeHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.betBackView);
            make.width.equalTo(self.betBackView);
            make.bottom.equalTo(self.quickNeedPayLabel);
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quickbetHomeHeaderView.mas_bottom);
            make.left.width.mas_equalTo(self.betBackView);
            make.height.mas_equalTo(0);
        }];
        
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerX.equalTo(_betBackView);
            make.top.equalTo(self.mainTableView.mas_bottom).offset(__SCALE(10.f));
        }];
//
        [self.quickConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.height.mas_equalTo(__SCALE(35.f));
            make.top.equalTo(self.subTitleLabel.mas_bottom).offset(__SCALE(10.f));
            make.left.mas_equalTo(self.betBackView).offset(__SCALE(15.f));
            make.right.equalTo(self.betBackView).offset(__SCALE(- 15.f));
            make.bottom.mas_equalTo(self.betBackView).offset(__SCALE(- 15.f));
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
        _mainTableView.backgroundColor = self.betBackView.backgroundColor;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.showsHorizontalScrollIndicator = NO;
    }
    return _mainTableView;
}

- (UIView *)quickbetHomeHeaderView
{
    if (!_quickbetHomeHeaderView) {
        _quickbetHomeHeaderView = [[UIView alloc] init];
        _quickbetHomeHeaderView.backgroundColor = UIColorFromRGB(0xffffff);
        [_quickbetHomeHeaderView addSubview:self.quickBetLabel];
        [_quickbetHomeHeaderView addSubview:self.quickNeedPayLabel];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0xeeeeee);
        [_quickbetHomeHeaderView addSubview:lineView];
        
        [self.quickBetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_quickbetHomeHeaderView).offset(__SCALE(10.f));
            make.left.mas_equalTo(_quickbetHomeHeaderView).offset(__SCALE(10.f));
            make.right.mas_equalTo(_quickbetHomeHeaderView).offset(__SCALE(-10.f));
            make.height.mas_equalTo(30.f);
        }];
        [self.quickNeedPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.quickBetLabel.mas_bottom).offset(__SCALE(5.f));
            make.left.mas_equalTo(__SCALE(10.f));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.bottom.equalTo(_quickbetHomeHeaderView);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _quickbetHomeHeaderView;
}

- (UILabel *)quickBetLabel
{
    if (!_quickBetLabel) {
        _quickBetLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _quickBetLabel.backgroundColor = [UIColor clearColor];
        _quickBetLabel.textAlignment = NSTextAlignmentLeft;
        _quickBetLabel.font = FONT_SCALE(15);
        _quickBetLabel.text = @"快速投注";
        _quickBetLabel.textColor = UIColorFromRGB(0x333333);
    }
    return _quickBetLabel;
}

- (UILabel *)quickNeedPayLabel
{
    if (!_quickNeedPayLabel) {
        _quickNeedPayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _quickNeedPayLabel.backgroundColor = [UIColor clearColor];
        _quickNeedPayLabel.textAlignment = NSTextAlignmentLeft;
        _quickNeedPayLabel.font = FONT_SCALE(13);
        _quickNeedPayLabel.text = @"";
        _quickNeedPayLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _quickNeedPayLabel;
}

- (UIButton *)quickConfirmButton
{
    if (!_quickConfirmButton) {
        _quickConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quickConfirmButton setTintColor:UIColorFromRGB(0xffffff)];
        [_quickConfirmButton setBackgroundColor:UIColorFromRGB(0xd21100)];
        [_quickConfirmButton setTitle:@"确定支付" forState:UIControlStateNormal];
        _quickConfirmButton.layer.cornerRadius = 3.f;
        _quickConfirmButton.layer.masksToBounds = YES;
        [_quickConfirmButton addTarget:self action:@selector(paymentConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quickConfirmButton;
}

- (UILabel *)subTitleLabel{
    
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.textColor = UIColorFromRGB(0x999999);
        _subTitleLabel.font = FONT_SCALE(12.f);
    }
    return _subTitleLabel;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}

@end
