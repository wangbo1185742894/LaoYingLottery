//
//  CLBankCardListViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBankCardListViewController.h"
#import "UIScrollView+CLRefresh.h"
#import "CQImgAndTextView.h"
#import "CQCreditCardCell.h"
#import "CLBankCardInfoModel.h"
#import "CLBankCardListAPI.h"
#import "CLBankCardDetailViewController.h"
#import "CLUserCenterPageConfigure.h"
#import "NSString+NSFormat.h"
#import "CLAllAlertInfo.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllJumpManager.h"
@interface CLBankCardListViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* cardTableView;

@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;

@property (nonatomic, strong) CQImgAndTextView* addBankCardView;
@property (nonatomic, strong) UIButton* showBankListButton;
@property (nonatomic, strong) UIView* footerView;

@property (nonatomic, strong) CLBankCardListAPI* listAPI;
@property (nonatomic, strong) CLAlertPromptMessageView *alertPromptMessageView;


@end

@implementation CLBankCardListViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.listAPI start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"银行卡信息";
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    
    [self.view addSubview:self.cardTableView];
     [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
    
    [self.cardTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.listAPI dealingWithCardListInfomationWithDict:[request.urlResponse.resp firstObject]];
        [self.cardTableView reloadData];
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self endRefreshing];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self endRefreshing];
}

- (void)endRefreshing{
    
    [self.cardTableView stopRefreshAnimating];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listAPI pullData].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CQCreditCardCell heightOfCreditListCardCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return __SCALE(10.f);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = CLEARCOLOR;
    return [[UIView alloc] init];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CQCreditCardCell* cell = [CQCreditCardCell initWithTableView:tableView mode:creditCardModeNormal];
    
    CLBankCardInfoModel* bankInfo = [self.listAPI pullData][indexPath.row];
    /** bankName为银行卡类型 */
    cell.bankName = bankInfo.card_type_name.length > 0 ? bankInfo.card_type_name : @"储蓄卡";
    /** 银行卡名字 */
    cell.bankCardCode = bankInfo.bank_short_name;
    cell.bankIconUrl = bankInfo.bank_img_url;
    /** 替换银行卡为* */
    cell.cardListCardCode =  [bankInfo.card_no stringByReplacingEachCharactersInRange:NSMakeRange(0, bankInfo.card_no.length - 4) withString:@"*"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WS(_weakSelf);
    
    CLBankCardDetailViewController* detailVC = [[CLBankCardDetailViewController alloc] init];
    detailVC.bankCardModel = [self.listAPI pullData][indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
//    [self.navigationController pushViewController:[CQBankCardDetailViewController pushBankCarkDetailViewControllerWithCardMethod:self.dataSource[indexPath.row] actionBlock:^(CQUserBankInfoModel *deleteModel) {
//        //** 解绑卡成功操作 */
//        [_weakSelf.dataSource removeObject:deleteModel];
//        [_weakSelf.mainTableView reloadData];
//    }] animated:YES];
}


#pragma mark - private

//支持银行卡列表展示 (WebView)
- (void)showBanklistClick:(id)sender {
    
    [[CLAllJumpManager shareAllJumpManager] open:url_BankCard];
}

//右导航按钮说明
- (void)queryAction:(id)sender {
    
    [self.alertPromptMessageView showInView:self.view.window];
}

#pragma mark - getter

- (UITableView *)cardTableView {
    
    if (!_cardTableView) {
        _cardTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _cardTableView.delegate = self;
        _cardTableView.dataSource = self;
        _cardTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _cardTableView.tableFooterView = self.footerView;
        _cardTableView.backgroundColor = [UIColor clearColor];
    }
    return _cardTableView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = UIColorFromRGB(0xefefef);
        _footerView.frame = __Rect(0, 0, SCREEN_WIDTH, [CQCreditCardCell heightOfCreditListCardCellHeight] + 30);
        [_footerView addSubview:self.addBankCardView];
        [_footerView addSubview:self.showBankListButton];
    }
    return _footerView;
}

- (CQImgAndTextView *)addBankCardView
{
    if (!_addBankCardView) {
        _addBankCardView = [[CQImgAndTextView alloc] initWithFrame:__Rect(10, 0, SCREEN_WIDTH - 20, [CQCreditCardCell heightOfCreditListCardCellHeight] - __SCALE(10.f))];
        _addBankCardView.clipsToBounds = YES;
        _addBankCardView.layer.cornerRadius = 5.f;
        _addBankCardView.layer.borderColor = UIColorFromRGB(0xdddddd).CGColor;
        _addBankCardView.layer.borderWidth = .5f;
        _addBankCardView.title = @"添加银行卡";
        _addBankCardView.backgroundColor = UIColorFromRGB(0xffffff);
        _addBankCardView.titleColor = UIColorFromRGB(0xbbbbbb);
        _addBankCardView.titleFont = FONT_SCALE(14);
        _addBankCardView.img = [UIImage imageNamed:@"accountAddCard"];
        _addBankCardView.imgToHeightScale = .15f;
        _addBankCardView.tapGestureHandler = ^{
            [CLUserCenterPageConfigure pushAddBankCardViewController];
        };
    }
    return _addBankCardView;
}

- (UIButton *)showBankListButton
{
    if (!_showBankListButton) {
        _showBankListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showBankListButton.frame = __Rect(0, __Obj_YH_Value(self.addBankCardView) + 5, SCREEN_WIDTH, 30);
        [_showBankListButton setTitle:@"查看可支持银行卡" forState:UIControlStateNormal];
        [_showBankListButton setTitleColor:LINK_COLOR forState:UIControlStateNormal];
        _showBankListButton.titleLabel.font = FONT_SCALE(12.f);
        [_showBankListButton addTarget:self action:@selector(showBanklistClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showBankListButton;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setImage:[UIImage imageNamed:@"questionmarkWhite"] forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, 17, 17);
        [rightFuncBtn addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLBankCardListAPI *)listAPI {
    
    if (!_listAPI) {
        _listAPI = [[CLBankCardListAPI alloc] init];
        _listAPI.delegate = self;
        _listAPI.type = @"2";
    }
    return _listAPI;
}

- (CLAlertPromptMessageView *)alertPromptMessageView{
    
    if (!_alertPromptMessageView) {
        _alertPromptMessageView = [[CLAlertPromptMessageView alloc] init];
        _alertPromptMessageView.desTitle = allAlertInfo_BankCardList;
        _alertPromptMessageView.cancelTitle = @"知道了";
    }
    return _alertPromptMessageView;
}
- (void)dealloc {
    
    if (_listAPI) {
        _listAPI.delegate = nil;
        [_listAPI cancel];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
