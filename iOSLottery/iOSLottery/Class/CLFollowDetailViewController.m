//
//  CLFollowDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLFollowDetailViewController.h"
#import "CLFollowDetailHeaderView.h"

#import "CLFollowDetailPeriodCell.h"
#import "CLFollowDetailPeriodHeaderCell.h"
#import "CLFollowDetailNumberTopCell.h"
#import "CLFollowDetailNumberBottomCell.h"
#import "CLOrderDetailBetNumCell.h"

#import "CLFollowDetailAPI.h"
#import "CLContinueToPayAPI.h"
#import "CLFollowDetailHandler.h"

#import "Masonry.h"
#import "UIScrollView+CLRefresh.h"

#import "CLFollowDetailNumberModel.h"

#import "CLLottBetOrdDetaViewController.h"
#import "CKNewPayViewController.h"
#import "CLJumpLotteryManager.h"

#import "CLEmptyPageService.h"

@interface CLFollowDetailViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate,CLEmptyPageServiceDelegate>

@property (nonatomic, strong) UITableView* followDetailTableView;

@property (nonatomic, strong) NSMutableArray* followDetailData;

@property (nonatomic, strong) UIView *baseHeaderView;
@property (nonatomic, strong) CLFollowDetailHeaderView* headerView;

@property (nonatomic, strong) CLFollowDetailAPI* followApi;
@property (nonatomic, strong) CLContinueToPayAPI* continuePayAPI;
@property (nonatomic) BOOL isShowAllNumber;

@property (nonatomic, strong) UIView *detailFooterView;//底部的再来一单按钮
@property (nonatomic, strong) UIButton *betAgainBtn;//再来一单按钮
@property (nonatomic, strong) UIView *lineView;//再来一单的上方的线
@property (nonatomic, strong) NSString *gameEn;

@property (nonatomic, strong) CLEmptyPageService *emptyPage;

@property (nonatomic, assign) BOOL isFollowApi;

@end

@implementation CLFollowDetailViewController

- (id)initWithRouterParams:(NSDictionary *)params{
    
    if (self = [self init]) {
        
        self.followID = params[@"followId"];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleText = @"追号详情";
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.followDetailTableView];
    [self.view addSubview:self.detailFooterView];
    [self.baseHeaderView addSubview:self.headerView];
    [self.detailFooterView addSubview:self.betAgainBtn];
    [self.detailFooterView addSubview:self.lineView];
    self.isShowAllNumber = NO;
    [self.followDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.detailFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(__SCALE(49.f));
    }];
    
    [self.betAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.detailFooterView);
        make.height.width.equalTo(self.detailFooterView).multipliedBy(.7);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.detailFooterView);
        make.left.equalTo(self.detailFooterView);
        make.right.equalTo(self.detailFooterView);
        make.height.mas_equalTo(.5f);
    }];
    
    self.followApi.followID = self.followID;
    [self.followDetailTableView startRefreshAnimating];
    
    self.isFollowApi = YES;
}

- (void) showBetNumbers:(id)sender {
    
    self.isShowAllNumber = !self.isShowAllNumber;
    [self.followDetailTableView reloadData];
}

- (void)continueToPay {
    
    self.continuePayAPI.followId = self.followID;
    [self showLoading];
    [self.continuePayAPI start];
}

#pragma mark ------------ event Response ------------
- (void)folloeAgainBtnOnClick:(UIButton *)btn{
    
    if (self.gameEn.length > 0) {
        [CLJumpLotteryManager jumpLotteryWithGameEn:self.gameEn];
    }
}
#pragma mark ------------ private Mothed ------------
- (void)configFollowFooterViewWithData:(CLFollowDetailModel *)model{
    
    if (model.isShowFooterView) {
        
        self.detailFooterView.hidden = NO;
        [self.followDetailTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).offset(__SCALE(- 49.f));
        }];
        
    }else{
        
        self.detailFooterView.hidden = YES;
        [self.followDetailTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }
    [self.view updateConstraintsIfNeeded];
    self.gameEn = model.gameEn;
}
#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request == self.continuePayAPI) {
        
        self.isFollowApi = NO;
        
        [self stopLoading];
        //继续支付
        if (request.urlResponse.success) {
            
//            NSLog(@"%@",request.urlResponse.resp);
            CKNewPayViewController *paymentController = [[CKNewPayViewController alloc] init];
            paymentController.lotteryGameEn = self.gameEn;
            paymentController.periodTime = self.headerView.currentSaleTime;
            paymentController.pushType = CKPayPushTypeOrderAndFollow;
            paymentController.hidesBottomBarWhenPushed = YES;
            paymentController.orderType = CKOrderTypeFollow;
            paymentController.payConfigure = request.urlResponse.resp;
            [self.navigationController pushViewController:paymentController animated:YES];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
    
        
    } else if (request == self.followApi) {
        
        self.isFollowApi = YES;
        //追号详情
        if (request.urlResponse.success) {
            
            NSDictionary *tempDic = request.urlResponse.resp;
            
            if (tempDic.count == 0) {
                
                self.followDetailData = nil;
                
                self.followDetailTableView.tableHeaderView = nil;
                
                [self.followDetailTableView reloadData];
                
                self.detailFooterView.hidden = YES;
                
                [self.emptyPage showNoWebWithSuperView:self.view];
                
                return;
                
            }else{
            
                [self.emptyPage removeEmptyView];
            }
            
            CLFollowDetailModel* followVM = [CLFollowDetailHandler dealingWithOrderDetaViewData:request.urlResponse.resp lotteryCodeAdapter:nil];
            if (self.followDetailTableView.tableHeaderView == nil) {
                self.followDetailTableView.tableHeaderView = self.baseHeaderView;
            }
            [self.headerView configureHeaderViewModel:followVM.headerVM];
            //动态计算头部视图高度
            [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(self.baseHeaderView);
            }];
            
            CGFloat height = [self.baseHeaderView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            self.baseHeaderView.frame = __Rect(0, 0, SCREEN_WIDTH, height);
            
            if (self.followDetailData.count > 0) {
                [self.followDetailData removeAllObjects];
            }
            [self.followDetailData addObjectsFromArray:followVM.followOrderArrays];
            [self configFollowFooterViewWithData:followVM];
            [self.followDetailTableView reloadData];
        } else {
            [self show:request.urlResponse.errorMessage];
        }
        
        [self endRefreshing];
    }
    
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    
    if (self.isFollowApi) {
        
        self.followDetailData = nil;
        
        self.followDetailTableView.tableHeaderView = nil;
        
        self.detailFooterView.hidden = YES;
        
        [self.followDetailTableView reloadData];
        
        [self.emptyPage showNoWebWithSuperView:self.view];
    }
    
    [self show:request.urlResponse.errorMessage];
    [self endRefreshing];
}

- (void)noWebOnClickWithEmpty:(CLEmptyView *)emptyView
{

    if (self.isFollowApi) {
        
        [self.followApi start];
    }else{
    
        [self.continuePayAPI start];
    }
    
}


- (void)endRefreshing{
    
    [self.followDetailTableView stopRefreshAnimating];
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.followDetailData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CLFollowDetailSectionViewModel* secVM = self.followDetailData[section];
    if (secVM.sectionType == CLFollowDetailSectionTypeLottNumBody) {
        if (!self.isShowAllNumber) {
            return MIN(secVM.sectionArray.count, 3);
        }
    }
    return secVM.sectionArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    CLFollowDetailSectionViewModel* secVM = self.followDetailData[indexPath.section];
    
    if (secVM.sectionType == CLFollowDetailSectionTypeLottNumTop) {
        CLFollowDetailNumberTopCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLFollowDetailNumberTopCellId"];
        if (!cell) {
            cell = [[CLFollowDetailNumberTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLFollowDetailNumberTopCellId"];
        }
        NSString* followModeCn = secVM.sectionArray[indexPath.row];
        [cell setTitle:@"投注项 " content:followModeCn];
        
        return cell;

    } else if (secVM.sectionType == CLFollowDetailSectionTypeLottNumBody) {
        
        CLOrderDetailBetNumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLOrderDetailBetNumCellId"];
        if (!cell) {
            cell = [[CLOrderDetailBetNumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLOrderDetailBetNumCellId"];
        }
        CLFollowDetailNumberModel* num = secVM.sectionArray[indexPath.row];
        cell.nameLbl.text = num.extraCn;
        cell.numLbl.text = num.lotteryNumber;

        return cell;
    } else if (secVM.sectionType == CLFollowDetailSectionTypeLottNumBottom) {
        CLFollowDetailNumberBottomCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLFollowDetailNumberBottomCellId"];
        if (!cell) {
            cell = [[CLFollowDetailNumberBottomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLFollowDetailNumberBottomCellId"];
        }
        cell.titleLabel.text = self.isShowAllNumber?@"收起":@"展开";
        cell.contentImageView.image = [UIImage imageNamed:!self.isShowAllNumber?@"order_downArrow.png":@"order_upArrow"];
        cell.cellEventTouchUp = ^(){
            
            [self showBetNumbers:nil];
        };
        if (secVM.sectionArray.count > 0) {
            cell.isEmpty = [secVM.sectionArray[0] isEqualToString:@""];
        }
        return cell;
        
    } else if (secVM.sectionType == CLFollowDetailSectionTypeFollowNumTop) {
        CLFollowDetailPeriodHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLFollowDetailPeriodHeaderCellId"];
        if (!cell) {
            cell = [[CLFollowDetailPeriodHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLFollowDetailPeriodHeaderCellId"];
        }
        [cell configurePeroidData:secVM.sectionArray[indexPath.row]];
        return cell;

    } else if (secVM.sectionType == CLFollowDetailSectionTypeFollowNumBody) {
        CLFollowDetailPeriodCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLFollowDetailPeriodCellId"];
        if (!cell) {
            cell = [[CLFollowDetailPeriodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLFollowDetailPeriodCellId"];
        }
        [cell assignData:secVM.sectionArray[indexPath.row]];
        return cell;

    } else {
        return nil;
    }
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLFollowDetailSectionViewModel* secVM = self.followDetailData[indexPath.section];
    if (secVM.sectionType == CLFollowDetailSectionTypeFollowNumBody) {
        
        CLFollowDetailProgramModel* proM = secVM.sectionArray[indexPath.row];
        CLLottBetOrdDetaViewController* orderVC = [[CLLottBetOrdDetaViewController alloc] init];
        orderVC.orderId = proM.orderId;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

#pragma mark - getter

- (UITableView *)followDetailTableView {
    
    if (!_followDetailTableView) {
        _followDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _followDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _followDetailTableView.delegate = self;
        _followDetailTableView.dataSource = self;
        _followDetailTableView.estimatedRowHeight = __SCALE(30);
        _followDetailTableView.rowHeight = UITableViewAutomaticDimension;
        WS(_weakSelf)
        [_followDetailTableView addRefresh:^{
            
            [_weakSelf.followApi start];
        }];
    }
    return _followDetailTableView;
}
- (UIView *)baseHeaderView{
    
    if (!_baseHeaderView) {
        _baseHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _baseHeaderView.backgroundColor = CLEARCOLOR;
    }
    return _baseHeaderView;
}
- (CLFollowDetailHeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[CLFollowDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, __SCALE(105.f))];
        WS(_weakSelf)
        _headerView.gotoPayment = ^{
            [_weakSelf continueToPay];
        };
    }
    return _headerView;
}

- (NSMutableArray *)followDetailData {
    
    if (!_followDetailData) {
        _followDetailData = [NSMutableArray new];
    }
    return _followDetailData;
}

-(CLFollowDetailAPI *)followApi {
    
    if (!_followApi) {
        _followApi = [[CLFollowDetailAPI alloc] init];
        _followApi.delegate = self;
    }
    return _followApi;
}

- (CLContinueToPayAPI *)continuePayAPI {
    
    if (!_continuePayAPI) {
        _continuePayAPI = [[CLContinueToPayAPI alloc] init];
        _continuePayAPI.delegate = self;
    }
    return _continuePayAPI;
}

- (UIView *)detailFooterView{
    
    if (!_detailFooterView) {
        _detailFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _detailFooterView.backgroundColor = UIColorFromRGB(0xffffff);
        _detailFooterView.hidden = YES;
    }
    return _detailFooterView;
}

- (UIButton *)betAgainBtn{
    
    if (!_betAgainBtn) {
        _betAgainBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_betAgainBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [_betAgainBtn setBackgroundColor:THEME_COLOR];
        _betAgainBtn.layer.cornerRadius = 2.f;
        [_betAgainBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _betAgainBtn.titleLabel.font = FONT_SCALE(16);
        [_betAgainBtn addTarget:self action:@selector(folloeAgainBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betAgainBtn;
}
- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
    }
    return _lineView;
}

- (CLEmptyPageService *)emptyPage
{

    if (_emptyPage == nil) {
        
        _emptyPage = [[CLEmptyPageService alloc] init];
        
        _emptyPage.delegate = self;
    }
    return _emptyPage;
}

- (void)dealloc {
    
    if (_followApi) {
        _followApi.delegate = nil;
        [_followApi cancel];
    }
    
    if (_continuePayAPI) {
        _continuePayAPI.delegate = nil;
        [_continuePayAPI cancel];
    }
    if (_headerView) {
        [_headerView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
