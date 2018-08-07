//
//  CLBuyRedEnveSelectViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/10.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBuyRedEnveSelectViewController.h"
#import "CLBuyRedEnveSelectCell.h"
#import "CLRedEnvePayViewController.h"
#import "CLBuyRedEnveListAPI.h"
#import "CLBuyRedEnveSelectModel.h"

#import "CLRedEnvePayViewController.h"
#import "UINavigationItem+CLNavigationCustom.h"
#import "CLAllAlertInfo.h"
#import "UINavigationController+CLDestroyCurrentController.h"
#import "CLAllJumpManager.h"
@interface CLBuyRedEnveSelectViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLBuyRedEnveSelectCellDelegate>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) UIBarButtonItem* rightMoreBarButtonItem;
@property (nonatomic, strong) CLBuyRedEnveListAPI* redEnveListAPI;

@end

@implementation CLBuyRedEnveSelectViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self addKeyBoardNotification];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"购买红包";
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self showLoading];
    [self.redEnveListAPI start];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
}
#pragma mark - eventRespone
- (void)queryAction:(UIButton *)btn{
    
    [[CLAllJumpManager shareAllJumpManager] open:url_redExplain];
}

- (void) addKeyBoardNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(self.mainTableView.contentInset.top, 0, keyboardSize.height, 0);
    self.mainTableView.contentInset = insets;
    self.mainTableView.scrollIndicatorInsets = insets;
    self.mainTableView.contentOffset = CGPointMake(self.mainTableView.contentOffset.x, self.mainTableView.contentSize.height - self.mainTableView.frame.size.height + keyboardSize.height);
    
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *info = [notification userInfo];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[info[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(self.mainTableView.contentInset.top, 0, 0, 0);
    self.mainTableView.contentInset = insets;
    self.mainTableView.scrollIndicatorInsets = insets;
    
    [UIView commitAnimations];
    
}

#pragma mark - CLBuyRedEnveSelectCellDelegate

- (NSString *)inputAmountChangeFor:(NSString *)source {
    
    return [self.redEnveListAPI calculateCustomRedAmountWithSourc:source];
}

- (void)purchaseRedEnveolpeAtIndexPath:(NSIndexPath *)indexPath {
    
    CLBuyRedEnveSelectModel* purchaseModel = [self.redEnveListAPI redBuylist][indexPath.row];
    
    if (purchaseModel.amount_value < 50) {
        [self show:@"最低50元"];
        return;
    }
    
    CLRedEnvePayViewController* vc = [[CLRedEnvePayViewController alloc] init];

    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
    for (id obj in [self.redEnveListAPI channelList]) {
        [tmpArray addObject:[obj copy]];
    }
    vc.payChannelArrays = tmpArray;
    vc.userSelectModel = purchaseModel;
    [self.navigationController pushDestroyViewController:vc animated:YES];
    
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.redEnveListAPI dealingWithRedEnvelopListFromDict:[request.urlResponse.resp firstObject]];
    }else {
        [self show:request.urlResponse.errorMessage];
    }
    [self.mainTableView reloadData];
    [self stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self stopLoading];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.redEnveListAPI redBuylist].count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CLBuyRedEnveSelectCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    CLBuyRedEnveSelectModel* listModel = [self.redEnveListAPI redBuylist][indexPath.row];
    
    CLBuyRedEnveSelectCell* cell = [CLBuyRedEnveSelectCell redEnvelopeCellInitWithTableView:tableView];
    cell.delegate = self;
    [cell configureRedValue:listModel.red_amount amountValue:listModel.amount_value isCustom:listModel.isCustom];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLBuyRedEnveSelectModel* purchaseModel = [self.redEnveListAPI redBuylist][indexPath.row];
    if (!purchaseModel.isCustom) {
        [self purchaseRedEnveolpeAtIndexPath:indexPath];
    }
    
}

#pragma mark - getter

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag | UIScrollViewKeyboardDismissModeInteractive;
    }
    return _mainTableView;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightFuncBtn setTitle:@"红包说明" forState:UIControlStateNormal];
        rightFuncBtn.titleLabel.font = FONT_SCALE(15);
        [rightFuncBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, __SCALE(65.f), __SCALE(30.f));
        [rightFuncBtn addTarget:self action:@selector(queryAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
        
    }
    return _rightMoreBarButtonItem;
}

- (CLBuyRedEnveListAPI *)redEnveListAPI {
    
    if (!_redEnveListAPI) {
        _redEnveListAPI = [[CLBuyRedEnveListAPI alloc] init];
        _redEnveListAPI.delegate = self;
    }
    return _redEnveListAPI;
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
