//
//  CLBankCardDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/2.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBankCardDetailViewController.h"
#import "CLBankCardInfoModel.h"
#import "CLBankCardReliveAPI.h"
#import "CLAlertController.h"

@interface CLBankCardDetailViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLAlertControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *rightMoreBarButtonItem;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *mainDataSource;
@property (nonatomic, strong) CLBankCardReliveAPI* reliveAPI;

@property (nonatomic, strong) CLAlertController* alertController;

@end

@implementation CLBankCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navTitleText = @"银行卡详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainTableView];
    [self.navigationItem setRightBarButtonItem:self.rightMoreBarButtonItem];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    
    [self configureData];
}

- (void) configureData {
    
    [self.mainDataSource addObject:[CQUserBankInfoCellModel createUserInfoCellModelWithItem:@"所属银行" infoString:self.bankCardModel.bank_short_name]];
    NSMutableString *bankCardMobile = [NSMutableString stringWithString:self.bankCardModel.mobile];
    if (bankCardMobile.length == 11) {
        [bankCardMobile replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    [self.mainDataSource addObject:[CQUserBankInfoCellModel createUserInfoCellModelWithItem:@"预留手机号" infoString:bankCardMobile]];
    [self.mainDataSource addObject:[CQUserBankInfoCellModel createUserInfoCellModelWithItem:@"手续费" infoString:@"手续费全免"]];
    [self.mainTableView reloadData];

}


- (void) relieveBankCardEvent:(id)sender {
    
    self.alertController = [CLAlertController alertControllerWithTitle:@"是否解除绑定此银行卡" message:nil style:CLAlertControllerStyleActionSheet delegate:self];
    self.alertController.buttonItems = @[@"取消",@"解绑"];
    self.alertController.destructiveButtonIndex = 1;
    [self.alertController show];
    
}

#pragma mark - CLAlertControllerDelegate
- (void)alertController:(CLAlertController *)alertController SelectIndex:(NSInteger)index{
    
    if (index == 1) {
        //解绑
        self.bankCardModel.status = 0;//解绑时此状态为0
        self.reliveAPI.bankCardInfo = [self.bankCardModel mj_keyValues];
        [self.reliveAPI start];
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self show:@"解绑成功"];
        WS(_weakSelf)
        DELAY(1.f, ^{
            [_weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}


- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CQUserBankInfoCell userBankInfoCellHeightIsLastCell:(indexPath.row == self.mainDataSource.count - 1)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CQUserBankInfoCell createUserBankInfoCellWithTableView:tableView method:self.mainDataSource[indexPath.row] isLastCell:(indexPath.row == self.mainDataSource.count - 1)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (UIBarButtonItem *)rightMoreBarButtonItem
{
    if (!_rightMoreBarButtonItem) {
        UIButton* rightFuncBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightFuncBtn setImage:[UIImage imageNamed:@"rightNaviFuncImg"] forState:UIControlStateNormal];
        rightFuncBtn.frame = __Rect(0, 0, 30, 30);
        [rightFuncBtn addTarget:self action:@selector(relieveBankCardEvent:) forControlEvents:UIControlEventTouchUpInside];
        _rightMoreBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightFuncBtn];
    }
    return _rightMoreBarButtonItem;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}

- (CLBankCardReliveAPI *)reliveAPI {
    
    if (!_reliveAPI) {
        _reliveAPI = [[CLBankCardReliveAPI alloc] init];
        _reliveAPI.delegate = self;
    }
    return _reliveAPI;
}


- (void)dealloc {
    
    if (_reliveAPI) {
        _reliveAPI.delegate = nil;
        [_reliveAPI cancel];
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




@interface CQUserBankInfoCell()

@property (nonatomic, strong) UILabel *itemLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) CALayer *bottomLayer;
@end

@implementation CQUserBankInfoCell

+ (CGFloat)userBankInfoCellHeightIsLastCell:(BOOL)isLastCell
{
    return __SCALE(35.f);
}

+ (instancetype)createUserBankInfoCellWithTableView:(UITableView *)tableView method:(id)method isLastCell:(BOOL)isLastCell
{
    CQUserBankInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CQUserBankInfoCellID"];
    if (!cell) {
        cell = [[CQUserBankInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CQUserBankInfoCellID"];
    }
    [cell assignUserBankInfoWithObj:method isLastCell:isLastCell];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.itemLabel];
        [self.contentView addSubview:self.descLabel];
        [self.contentView.layer addSublayer:self.bottomLayer];
    }
    return self;
}

- (void)assignUserBankInfoWithObj:(id)obj isLastCell:(BOOL)isLastCell
{
    CQUserBankInfoCellModel *model = (CQUserBankInfoCellModel *)obj;
    self.itemLabel.text = model.itemString;
    self.descLabel.text = model.infoString;
    self.itemLabel.frame = __Rect(10, 0, 60, [CQUserBankInfoCell userBankInfoCellHeightIsLastCell:isLastCell]);
    self.descLabel.frame = __Rect(__Obj_XW_Value(self.itemLabel), 0, SCREEN_WIDTH - __Obj_Bounds_Width(self.itemLabel) - 10, __Obj_Bounds_Height(self.itemLabel));
    self.bottomLayer.frame = __Rect(0, [CQUserBankInfoCell userBankInfoCellHeightIsLastCell:isLastCell] - .5f, SCREEN_WIDTH, .5f);
}

#pragma mark - gettingMethod

- (UILabel *)itemLabel
{
    if (!_itemLabel) {
        AllocNormalLabel(_itemLabel, @"-", FONT(13), NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect(10, 0, 60, [CQUserBankInfoCell userBankInfoCellHeightIsLastCell:NO]));
    }
    return _itemLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        AllocNormalLabel(_descLabel, @"-", FONT(13), NSTextAlignmentLeft, UIColorFromRGB(0x333333), __Rect(__Obj_XW_Value(self.itemLabel), 0, SCREEN_WIDTH - __Obj_Bounds_Width(self.itemLabel) - 10, __Obj_Bounds_Height(self.itemLabel)));
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, [CQUserBankInfoCell userBankInfoCellHeightIsLastCell:NO] - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

@end


@implementation CQUserBankInfoCellModel

+ (instancetype)createUserInfoCellModelWithItem:(NSString *)itemString infoString:(NSString *)infoString
{
    CQUserBankInfoCellModel *model = [[CQUserBankInfoCellModel alloc] init];
    model.itemString = itemString;
    model.infoString = infoString;
    return model;
}

@end

