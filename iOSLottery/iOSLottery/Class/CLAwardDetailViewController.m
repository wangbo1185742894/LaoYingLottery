//
//  CLAwardDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLAwardDetailViewController.h"
#import "CLAwardK3View.h"
#import "CLAwardD11View.h"
#import "CLSSQAwardDetailHeaderView.h"
#import "CLAwardDetailBonusCell.h"
#import "CLAwardBottomBetView.h"

#import "CLAwardVoModel.h"
#import "CLJumpLotteryManager.h"
#import "CLAllJumpManager.h"
#import "CLConfigWebURL.h"

#import "CLATDrawDetailsHeaderView.h"
#import "CLSFCMatchResultCell.h"
#import "UIBarButtonItem+SLBarButtonItem.h"

#import "CLOrderDetailBetNumModel.h"

#import "CLSFCPeriodDetailsHeaderView.h"

#import "CLQLCPeriodDetailsHeaderView.h"

@interface CLAwardDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CLAwardK3View* k3View;
@property (nonatomic, strong) CLAwardD11View* d11View;
@property (nonatomic, strong) CLSSQAwardDetailHeaderView *ssqView;

@property (nonatomic, strong) CLATDrawDetailsHeaderView *atView;

@property (nonatomic, strong) CLQLCPeriodDetailsHeaderView *qlcView;

@property (nonatomic, strong) CLSFCPeriodDetailsHeaderView *sfcView;

@property (nonatomic, strong) CLAwardBottomBetView* bottomButton;
@property (nonatomic, strong) UIView* headerView;
@property (nonatomic, strong) UIImageView *wavyLineImageView;
@property (nonatomic, strong) UIView *lineview;

@property (nonatomic, strong) UITableView* mainTableView;

@property (nonatomic, strong) NSMutableArray* items;

@property (nonatomic, strong) UIView *tableViewFooter;

@property (nonatomic, strong) UIButton *webViewButton;//跳转webView的按钮
@property (nonatomic, strong) UIButton *webImageButton;

@end

@implementation CLAwardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navTitleText = @"期次详情";
    
    self.items = [NSMutableArray new];
    
    if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"ssq"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"dlt"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"pl3"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"pl5"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"fc3d"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"qxc"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"qlc"]) {
        [self.items addObject:@"奖项,中奖注数,每注奖金(元)"];
    }else if([[self.awardVo.gameEn lowercaseString] hasSuffix:@"sfc"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"rx9"]){
        
        CLOrderDetailBetNumModel *model1 = [[CLOrderDetailBetNumModel alloc] init];
        
        model1.bounsMessageString = @"胜负彩,中奖注数,每注金额";
        model1.messageType = BounsMessageType;
        model1.isTitle = YES;
        
        [self.items addObject:model1];
        
        NSArray *sfcArray = self.awardVo.traditionalPlayTypeAndBonus[@"sfc"];
        
        for (NSString *str in sfcArray) {
            
            CLOrderDetailBetNumModel *model = [CLOrderDetailBetNumModel new];
            
            model.bounsMessageString = str;
            model.messageType = BounsMessageType;
            
            [self.items addObject:model];
        }
        
        CLOrderDetailBetNumModel *empty1 = [[CLOrderDetailBetNumModel alloc] init];
        empty1.messageType = EmptyMessageType;
        empty1.emptyCellHeight = CL__SCALE(10.f);
        
        [self.items addObject:empty1];
        
        CLOrderDetailBetNumModel *model2 = [[CLOrderDetailBetNumModel alloc] init];
        
        model2.bounsMessageString = @"任选9,中奖注数,每注金额";
        model2.messageType = BounsMessageType;
        model2.isTitle = YES;
        
        [self.items addObject:model2];
        
        NSArray *rx9Array = self.awardVo.traditionalPlayTypeAndBonus[@"rx9"];
        
        for (NSString *str in rx9Array) {
            
            CLOrderDetailBetNumModel *model = [CLOrderDetailBetNumModel new];
            
            model.bounsMessageString = str;
            //model.bouns = YES;
            
            [self.items addObject:model];
            
        }
        
        CLOrderDetailBetNumModel *empty2 = [[CLOrderDetailBetNumModel alloc] init];
        empty2.messageType = EmptyMessageType;
        empty2.emptyCellHeight = CL__SCALE(20.f);
        
        [self.items addObject:empty2];
        
        CLOrderDetailBetNumModel *model = [[CLOrderDetailBetNumModel alloc] init];
        
        model.serialNumber = 0;
        model.hostName = @"主队";
        model.result = @"赛果";
        model.awayName = @"客队";
        model.messageType = MatchMessageType;
            
        [self.items addObject:model];
        
    }else{
    
        [self.items addObject:@"奖项,每注奖金(元)"];
    }
    
   
    if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"sfc"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"rx9"]) {
        
        [self.awardVo.sfcAwardVos enumerateObjectsUsingBlock:^( CLOrderDetailBetNumModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
           
            model.messageType = MatchMessageType;
        }];
        
        [self.items addObjectsFromArray:self.awardVo.sfcAwardVos];
        
        
    }else{
    
        
       [self.items addObjectsFromArray:self.awardVo.playTypeAndBonus];

    }
    

    
    if (self.awardVo.ifAuditing == 0) {
        [self.view addSubview:self.bottomButton];
    }
    [self.view addSubview:self.mainTableView];
    if (self.awardVo.ifAuditing == 0) {
        [self.tableViewFooter addSubview:self.webImageButton];
        [self.tableViewFooter addSubview:self.webViewButton];
    }
    self.mainTableView.tableFooterView = self.tableViewFooter;

    if (self.awardVo.ifAuditing == 0) {
        [self.webViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(self.tableViewFooter);
        }];
        [self.webImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.webViewButton.mas_right).offset(1.f);
            make.centerY.equalTo(self.webViewButton);
        }];
        [self.bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.height.mas_equalTo(__SCALE(kDevice_Is_iPhoneX ? 69 : 49));
        }];
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
            make.bottom.equalTo(self.bottomButton.mas_top);
        }];
    }else{
        [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(0);
            make.bottom.mas_equalTo(self.view);
        }];
    }
    
    
    if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"kuai3"]) {
        
        self.k3View.lottNameLbl.text = self.awardVo.gameName;
        self.k3View.timeLbl.text = self.awardVo.awardTime;
        self.k3View.periodLabel.text = [NSString stringWithFormat:@"第%@期", self.awardVo.periodId];
        self.k3View.ShapeLabel.text = self.awardVo.resultMap[@"awardShape"];
        [self.k3View setNumbers:[self.awardVo.winningNumbers componentsSeparatedByString:@" "]];
        [self.headerView addSubview:self.k3View];
    } else if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"11"]) {
        self.d11View.lotteryNameLbl.text = self.awardVo.gameName;
        self.d11View.timeLbl.text = self.awardVo.awardTime;
        self.d11View.periodLabel.text = [NSString stringWithFormat:@"第%@期", self.awardVo.periodId];
        [self.d11View setNumbers:[self.awardVo.winningNumbers componentsSeparatedByString:@" "]];
        [self.headerView addSubview:self.d11View];
        
    } else if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"ssq"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"dlt"]) {
        
        self.ssqView.lotteryNameLbl = self.awardVo.gameName;
        self.ssqView.timeLbl = self.awardVo.awardTime;
        self.ssqView.periodLabel = [NSString stringWithFormat:@"第%@期", self.awardVo.periodId];
        self.ssqView.type = [[self.awardVo.gameEn lowercaseString] hasSuffix:@"ssq"] ? CLAwardLotteryTypeSSQ : CLAwardLotteryTypeDLT;
        NSString *str = self.awardVo.winningNumbers;
        
        str = [str stringByReplacingOccurrencesOfString:@":" withString:@" "];
        
        [self.ssqView setNumbers:[str componentsSeparatedByString:@" "]];
        self.ssqView.periodScaleTxt = self.awardVo.periodSale;
        self.ssqView.bonusScaleTxt = self.awardVo.poolBonus;
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(165.f));
        self.wavyLineImageView.frame = __Rect(0, __SCALE(145), SCREEN_WIDTH, __SCALE(8.f));
        self.lineview.frame = __Rect(0, __SCALE(165), SCREEN_WIDTH, .5f);
        [self.headerView addSubview:self.ssqView];
    
    }else if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"pl3"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"pl5"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"fc3d"]){
    
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(165.f));
        
        self.wavyLineImageView.frame = __Rect(0, __SCALE(145), SCREEN_WIDTH, __SCALE(8.f));
        self.lineview.frame = __Rect(0, __SCALE(165), SCREEN_WIDTH, .5f);
        
        [self.atView setData:self.awardVo];
        
        [self.headerView addSubview:self.atView];
    }else if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"qlc"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"qxc"]){
    
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(165.f));
        
        self.wavyLineImageView.frame = __Rect(0, __SCALE(145), SCREEN_WIDTH, __SCALE(8.f));
        self.lineview.frame = __Rect(0, __SCALE(165), SCREEN_WIDTH, .5f);
        
        [self.qlcView setData:self.awardVo];
        
        [self.headerView addSubview:self.qlcView];

    }else if ([[self.awardVo.gameEn lowercaseString] hasSuffix:@"sfc"] || [[self.awardVo.gameEn lowercaseString] hasSuffix:@"rx9"]){
    
        self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, __SCALE(165.f));
        
        self.wavyLineImageView.frame = __Rect(0, __SCALE(145), SCREEN_WIDTH, __SCALE(8.f));
        self.lineview.frame = __Rect(0, __SCALE(165), SCREEN_WIDTH, .5f);
        
        [self.sfcView setData:self.awardVo];
        
        [self.headerView addSubview:self.sfcView];
    }
    
    self.mainTableView.tableHeaderView = self.headerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"%f %f ",self.mainTableView.contentInset.top,self.mainTableView.contentInset.bottom);
}

- (void)gotoBetLottery {
    
    [CLJumpLotteryManager jumpLotteryWithGameEn:self.awardVo.gameEn];
}

#pragma mark ------------ event Response ------------
- (void)webViewButtonOnClick:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:url_HowToBonus];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.awardVo.gameEn isEqualToString:@"sfc"] || [self.awardVo.gameEn isEqualToString:@"rx9"]) {
        
        CLOrderDetailBetNumModel *model = self.items[indexPath.row];
        
        if (model.messageType == EmptyMessageType) {
            
            return model.emptyCellHeight;
        }
    }
    
    return __SCALE(25.f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //兼容胜负彩
    if ([self.awardVo.gameEn isEqualToString:@"sfc"] || [self.awardVo.gameEn isEqualToString:@"rx9"]) {
        
        CLOrderDetailBetNumModel *model = self.items[indexPath.row];
        
        if (model.messageType == BounsMessageType) {
            
            CLAwardDetailBonusCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLAwardDetailBonusCellId"];
            if (!cell) {
                cell = [[CLAwardDetailBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLAwardDetailBonusCellId"];
                
                cell.count = 3;
            }
            cell.lastLabelColor = THEME_COLOR;
            [cell configureItems:model.bounsMessageString];
            cell.isShowColor = (indexPath.row % 2 == 0);
            cell.isTitle = model.isTitle;
            return cell;

        }else if (model.messageType == MatchMessageType){
            
            CLSFCMatchResultCell *cell = [CLSFCMatchResultCell createCellWithTableView:tableView type:(CLSFCMatchResultPeriodType)];
            
            
            [cell setModel:model];
            
            return cell;
        }else if (model.messageType == EmptyMessageType){
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
            
            if (cell == nil) {
                
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"emptyCell"];
                
                cell.contentView.backgroundColor = UIColorFromRGB(0xf1f1f1);
            }
            return cell;
        }
        
    }
    
    
        
    //其他彩种
    CLAwardDetailBonusCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLAwardDetailBonusCellId"];
    if (!cell) {
        cell = [[CLAwardDetailBonusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLAwardDetailBonusCellId"];
        if ([self.awardVo.gameEn hasSuffix:@"ssq"] || [self.awardVo.gameEn hasSuffix:@"dlt"] || [self.awardVo.gameEn hasSuffix:@"pl3"] || [self.awardVo.gameEn hasSuffix:@"pl5"] || [self.awardVo.gameEn hasSuffix:@"fc3d"] || [self.awardVo.gameEn hasSuffix:@"qlc"] || [self.awardVo.gameEn hasSuffix:@"qxc"]) {
            cell.count = 3;
            cell.lastLabelColor = THEME_COLOR;
        }else{
            cell.count = 2;
        }
    }
    cell.isShowColor = (indexPath.row % 2 == 0);
    cell.isTitle = (indexPath.row == 0);
      [cell configureItems:self.items[indexPath.row]];
    if (indexPath.row == self.items.count - 1) {
        cell.has_BottomLine = YES;
    }else{
        cell.has_BottomLine = NO;
    }
    
    return cell;
}

#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _mainTableView.rowHeight = __SCALE(30);
        _mainTableView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _mainTableView;
}

- (CLAwardK3View *)k3View {
    
    if (!_k3View) {
        _k3View = [[CLAwardK3View alloc] initWithFrame:__Rect(0, __SCALE(0), SCREEN_WIDTH, __SCALE(90))];
        _k3View.backgroundColor = UIColorFromRGB(0xffffff);
        _k3View.isMidCenter = YES;
    }
    return _k3View;
}

- (CLAwardD11View *)d11View {
    
    if (!_d11View) {
        _d11View = [[CLAwardD11View alloc] initWithFrame:__Rect(0, __SCALE(0), SCREEN_WIDTH, __SCALE(90))];
        _d11View.backgroundColor = UIColorFromRGB(0xffffff);
        _d11View.isCenter = YES;
    }
    return _d11View;
}

- (CLSSQAwardDetailHeaderView *)ssqView {
    
    if (!_ssqView) {
        _ssqView = [[CLSSQAwardDetailHeaderView alloc] initWithFrame:__Rect(0, __SCALE(0), SCREEN_WIDTH, __SCALE(145))];
        _ssqView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _ssqView;
}

- (CLATDrawDetailsHeaderView *)atView
{
    if (!_atView) {
        _atView = [[CLATDrawDetailsHeaderView alloc] initWithFrame:__Rect(0, __SCALE(0), SCREEN_WIDTH, CL__SCALE(176.f))];
        _atView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _atView;
}

- (CLQLCPeriodDetailsHeaderView *)qlcView
{
    if (!_qlcView) {
        _qlcView = [[CLQLCPeriodDetailsHeaderView alloc] initWithFrame:__Rect(0, __SCALE(0), SCREEN_WIDTH, CL__SCALE(176.f))];
        _qlcView.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _qlcView;
}

- (CLSFCPeriodDetailsHeaderView *)sfcView
{

    if (_sfcView == nil) {
        
        _sfcView = [[CLSFCPeriodDetailsHeaderView alloc] initWithFrame:(CGRectMake(0, 0,SCREEN_WIDTH , CL__SCALE(176.f)))];
    }
    return _sfcView;
}

- (UIView *)headerView {
    
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __SCALE(105))];
        _headerView.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        self.wavyLineImageView = [[UIImageView alloc] initWithFrame:__Rect(0, __SCALE(90), SCREEN_WIDTH, __SCALE(8.f))];
        self.wavyLineImageView.image = [UIImage imageNamed:@"CMTWareLine.png"];
        self.wavyLineImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_headerView addSubview:self.wavyLineImageView];
        
        self.lineview = [[UIView alloc] initWithFrame:__Rect(0, __SCALE(105), SCREEN_WIDTH, .5f)];
        self.lineview.backgroundColor = SEPARATE_COLOR;
        [_headerView addSubview:self.lineview];
    }
    return _headerView;
}

- (CLAwardBottomBetView *)bottomButton {
    
    WS(weakSelf)
    if (!_bottomButton) {
        
        _bottomButton = [CLAwardBottomBetView awardBottomWithType:[self.awardVo.gameEn isEqualToString:@"sfc"] ? CLAwardBottomTypeSFC : CLAwardBottomTypeNormal];
        
        
        [_bottomButton returnLeftButtonBlock:^{
            
            [weakSelf gotoBetLottery];
        }];
        
        [_bottomButton returnRightButtonBlock:^{
            
            [CLJumpLotteryManager jumpLotteryWithGameEn:@"rx9"];
            
        }];
    }
    return _bottomButton;
}

- (UIView *)tableViewFooter{
    
    if (!_tableViewFooter) {
        _tableViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __SCALE(100.f), __SCALE(30.f))];
        _tableViewFooter.backgroundColor = CLEARCOLOR;
    }
    return _tableViewFooter;
}

- (UIButton *)webViewButton{
    
    if (!_webViewButton) {
        _webViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, __SCALE(60.f), __SCALE(35.f))];
        [_webViewButton setTitle:@"中奖后如何领奖" forState:UIControlStateNormal];
        [_webViewButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        [_webViewButton addTarget:self action:@selector(webViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _webViewButton.adjustsImageWhenHighlighted = NO;
        _webViewButton.titleLabel.font = FONT_SCALE(13);
    }
    return _webViewButton;
}

- (UIButton *)webImageButton{
    
    if (!_webImageButton) {
        _webImageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, __SCALE(60.f), __SCALE(35.f))];
        [_webImageButton setImage:[UIImage imageNamed:@"registerArrow.png"] forState:UIControlStateNormal];
        [_webImageButton addTarget:self action:@selector(webViewButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        _webImageButton.adjustsImageWhenHighlighted = NO;
    }
    return _webImageButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
