//
//  CLRedEnveDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/28.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLRedEnveDetailViewController.h"
#import "UIScrollView+CLRefresh.h"
#import "CLRedEnveDetailAPI.h"
#import "CLRedEnveDetaModel.h"
#import "CLConfigMessage.h"
#import "UILabel+CLAttributeLabel.h"
#import "CLMemoCell.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"

#import "CLRedEnveConsumeListViewController.h"

@interface CLRedEnveDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* mainTableView;

@property (nonatomic, strong) CLRedEvneDetaHeadView* headView;

@property (nonatomic, strong) CLRedEnveDetailAPI* detailApi;

@property (nonatomic, strong) UIView *tableFooterView;

@property (nonatomic, strong) UIButton *betButton;//去投注Button

@end

@implementation CLRedEnveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"红包详情";
    [self.view addSubview:self.mainTableView];
    
    self.detailApi.fid = self.fid;
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.tableFooterView addSubview:self.betButton];
    
    [self.mainTableView startRefreshAnimating];
}
#pragma mark ------------ event respone ------------
- (void)betButtonOnClick:(UIButton *)btn{
    
    //跳转首页
    [CATransaction setDisableActions:YES];//关闭隐式动画
    [self.navigationController popToRootViewControllerAnimated:NO];
    CLMainTabbarViewController* rootTabbarVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    rootTabbarVC.selectedIndex = 0;
    
}
#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.detailApi pullDetailData].red_table.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(_weakSelf);
    
    CLMemoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLRedEnvelopeDetailCellId"];
    if (!cell) {
        cell = [[CLMemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLRedEnvelopeDetailCellId"];
    }
    
    NSDictionary* dict = [self.detailApi pullDetailData].red_table[indexPath.row];
    
    cell.titleLbl.text = dict[@"title"];
    cell.titleLbl.textAlignment = NSTextAlignmentLeft;
    id objc = dict[@"content"];
    if ([objc isKindOfClass:[NSString class]]) {
        
        BOOL canClick = [objc hasPrefix:@"详情_"];
        cell.contentLbl.textColor = canClick?THEME_COLOR:cell.titleLbl.textColor;
        
        if (canClick) {
            cell.contentLbl.text = @"详情";
        } else {
            cell.contentLbl.text = objc;
        }
        
        [cell setSuppleEvent:^BOOL{
            return canClick;
        } message:^{
            NSString* fid = [[objc componentsSeparatedByString:@"_"] lastObject];
//            NSLog(@"消费编号:%@",fid);
            CLRedEnveConsumeListViewController* vc = [[CLRedEnveConsumeListViewController alloc] init];
            vc.user_fid = fid;
            [_weakSelf.navigationController pushViewController:vc animated:YES];
            
        }];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.detailApi configureDetailInfoFromDict:[request.urlResponse.resp firstObject]];
        [self.headView configureHeadData:[self.detailApi pullDetailData]];
        
        if ([self.detailApi pullDetailData].red_button) {
            
            self.mainTableView.tableFooterView = self.tableFooterView;
            if ([self.detailApi pullDetailData].red_button[@"button_text"]) {
                [self.betButton setTitle:[self.detailApi pullDetailData].red_button[@"button_text"]  forState:UIControlStateNormal];
            }else{
                [self.betButton setTitle:@"去投注"  forState:UIControlStateNormal];
            }
        }else{
            self.mainTableView.tableFooterView = nil;
        }
        self.mainTableView.tableHeaderView = self.headView;
        
        [self.mainTableView reloadData];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self.mainTableView stopRefreshAnimating];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
    [self.mainTableView stopRefreshAnimating];
}

#pragma mark - getter

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 40.f;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WS(_weakSelf);
        [_mainTableView addRefresh:^{
            
            [_weakSelf.detailApi start];
        }];
    }
    return _mainTableView;
}

- (CLRedEvneDetaHeadView *)headView {
    
    if (!_headView) {
        _headView = [[CLRedEvneDetaHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _headView;
}



- (CLRedEnveDetailAPI *)detailApi {
    
    if (!_detailApi) {
        _detailApi = [[CLRedEnveDetailAPI alloc] init];
        _detailApi.delegate = self;
    }
    return _detailApi;
}

- (UIView *)tableFooterView{
    
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50.f)];
    }
    return _tableFooterView;
}

- (UIButton *)betButton{
    
    if (!_betButton) {
        _betButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - __SCALE(40.f), __SCALE(35))];
        _betButton.layer.cornerRadius = 2.f;
        _betButton.layer.masksToBounds = YES;
        _betButton.layer.borderWidth = .5f;
        _betButton.layer.borderColor = THEME_COLOR.CGColor;
        _betButton.center = self.tableFooterView.center;
        [_betButton setTitle:@"去投注" forState:UIControlStateNormal];
        [_betButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _betButton.titleLabel.font = FONT_SCALE(15.f);
        _betButton.backgroundColor = UIColorFromRGB(0xff4747);
        [_betButton addTarget:self action:@selector(betButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betButton;
}
- (void)dealloc {
    
    if (_detailApi) {
        _detailApi.delegate = nil;
        [_detailApi cancel];
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

@implementation CLRedEvneDetaHeadView


- (instancetype) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLbl = [[UILabel alloc] init];
        self.titleLbl.font = FONT_SCALE(15);
        self.titleLbl.textColor = UIColorFromRGB(0x666666);
        self.titleLbl.backgroundColor = [UIColor clearColor];
        
        self.contentLbl = [[UILabel alloc] init];
        self.contentLbl.font = FONT_SCALE(30);
        self.contentLbl.textColor = UIColorFromRGB(0x666666);
        self.contentLbl.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.top.right.equalTo(self);
            make.height.equalTo(self).multipliedBy(.5f);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
            make.right.bottom.equalTo(self);
            make.height.equalTo(self).multipliedBy(.6f);
        }];
        
    }
    return self;
}

- (void)configureHeadData:(CLRedEnveDetaModel*)data{
    
    NSString *journalRedString = [NSString stringWithFormat:@"%@%@",data.red_balance,@"元"];
    //** 红包可用状态 */
    if (!data.red_status)
    {
        self.contentLbl.textColor = [data.red_balance integerValue] > 0 ? [UIColor redColor] : [UIColor greenColor] ;
        [self.contentLbl attributeWithText:journalRedString controParams:@[[AttributedTextParams attributeRange:[journalRedString rangeOfString:@"元"] Color:UIColorFromRGB(0x333333) Font:FONT_SCALE(11)]]];
        self.titleLbl.text = @"可用金额";
    }
    else
    {
        self.titleLbl.textColor = self.contentLbl.textColor = UIColorFromRGB(0x666666);
        [self.contentLbl attributeWithText:journalRedString controParams:@[[AttributedTextParams attributeRange:[journalRedString rangeOfString:@"元"] Color:UIColorFromRGB(0x666666) Font:FONT_SCALE(11)]]];
        self.titleLbl.text = @"过期金额";
    }

}

@end

