//
//  CQMicroPaymentViewController.m
//  caiqr
//
//  Created by 彩球 on 16/4/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLMicroPaymentViewController.h"
#import "CLSettingAdapter.h"
#import "CLSetFreePayQuotaAPI.h"
#import "CLFreePayQuotaListAPI.h"

@interface CLMicroPaymentViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* mainTableView;
@property (nonatomic, strong) NSMutableArray* dataSource;

@property (nonatomic, assign) NSInteger location;
@property (nonatomic, strong) NSString *free_desc_string;

@property (nonatomic, strong) CLFreePayQuotaListAPI* quotaListAPI;
@property (nonatomic, strong) CLSetFreePayQuotaAPI* setQuotaAPI;

@end

@implementation CLMicroPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navTitleText = @"小额免密金额";
    [self.view addSubview:self.mainTableView];
    [self.quotaListAPI start];
    self.location = -1;
}


#pragma mrak - reloadDataSource

- (void)configDataSource:(id)method
{
    NSDictionary *dataDic = (NSDictionary *)method;
    NSArray *dataArr = [NSArray arrayWithArray:dataDic[@"quota_list"]];
    self.free_desc_string = [NSString stringWithFormat:@"%@",dataDic[@"word"]];
    for (int i = 0; i < dataArr.count; i++) {
        CQMicroPaymentInfo* info = [[CQMicroPaymentInfo alloc] init];
        info.microPayAmount = [dataArr[i] integerValue];
        info.isSelectState = (info.microPayAmount == [CLSettingAdapter getFreePayPwdAmount]);
        if (info.microPayAmount == [CLSettingAdapter getFreePayPwdAmount])
        {
            self.location = i;
        }
        [self.dataSource addObject:info];
    }
    [self.mainTableView reloadData];
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.quotaListAPI) {
        
        if (request.urlResponse.success) {
            [self configDataSource:[request.urlResponse.resp firstObject]];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    } else if (request == self.setQuotaAPI) {
        
        if (request.urlResponse.success) {
            NSInteger freeAmount = [[[request.urlResponse.resp firstObject] objectForKey:@"free_pay_pwd_quota"] integerValue];
            [CLSettingAdapter updateFreePayPwdAmount:freeAmount];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self show:request.urlResponse.errorMessage];
        }
        
    }
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CQMicroPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CQMicroPaymentCellId"];
    if (!cell) {
        cell = [[CQMicroPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CQMicroPaymentCellId"];
    }
    
    CQMicroPaymentInfo* info = self.dataSource[indexPath.row];
    cell.textLabel.font = FONT_SCALE(13.f);
    cell.textLabel.text = [NSString stringWithFormat:@"%@%zi",self.free_desc_string,info.microPayAmount];
    cell.isSelectState = info.isSelectState;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.location == indexPath.row) return;
    [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [((CQMicroPaymentInfo*)obj) cancelSelectState];
    }];
    
    CQMicroPaymentInfo* info = self.dataSource[indexPath.row];
    info.isSelectState = YES;
    
    self.location = indexPath.row;
    
    self.setQuotaAPI.free_pay_amount = [NSString stringWithFormat:@"%zi",info.microPayAmount];
    self.setQuotaAPI.free_pay_status = @"";
    [self.setQuotaAPI start];
}


#pragma mark - getter

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _mainTableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}


- (CLFreePayQuotaListAPI *)quotaListAPI {
    
    if (!_quotaListAPI) {
        _quotaListAPI = [[CLFreePayQuotaListAPI alloc] init];
        _quotaListAPI.delegate = self;
    }
    return _quotaListAPI;
}

- (CLSetFreePayQuotaAPI *)setQuotaAPI {
    
    if (!_setQuotaAPI) {
        _setQuotaAPI = [[CLSetFreePayQuotaAPI alloc] init];
        _setQuotaAPI.delegate = self;
    }
    return _setQuotaAPI;
}

- (void)dealloc {
    
    if (_quotaListAPI) {
        _quotaListAPI.delegate = nil;
        [_quotaListAPI cancel];
    }
    
    if (_setQuotaAPI) {
        _setQuotaAPI.delegate = nil;
        [_setQuotaAPI cancel];
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




@interface CQMicroPaymentCell ()

@property (nonatomic, strong) UIImageView* selectImgView;
@property (nonatomic, strong) CALayer *bottomLayer;
@end

@implementation CQMicroPaymentCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.selectImgView];
        [self.contentView.layer addSublayer:self.bottomLayer];
        self.isSelectState = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)selectClicked:(id)sender
{
    if (self.microPaySelect) {
        self.microPaySelect(self);
    }
}

- (void)setIsSelectState:(BOOL)isSelectState
{
//    self.selectImgView.backgroundColor = isSelectState?[UIColor greenColor]:[UIColor grayColor];
    self.selectImgView.image = [UIImage imageNamed:(isSelectState?@"accountSel_YES":@"accountSel_NO")];
}

- (UIImageView *)selectImgView
{
    if (!_selectImgView) {
        _selectImgView = [[UIImageView alloc] init];;
        _selectImgView.frame = __Rect(SCREEN_WIDTH - 25.f, 17.f, 20.f, 20.f);
    }
    return _selectImgView;
}

- (CALayer *)bottomLayer
{
    if (!_bottomLayer) {
        _bottomLayer = [[CALayer alloc] init];
        _bottomLayer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        _bottomLayer.frame = __Rect(0, CGRectGetMaxY(self.contentView.frame) - .5f, SCREEN_WIDTH, .5f);
    }
    return _bottomLayer;
}

@end



@implementation CQMicroPaymentInfo

- (void)cancelSelectState
{
    self.isSelectState = NO;
}

@end




