//
//  BBBetDetailsController.m
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "BBBetDetailsController.h"
#import "UIBarButtonItem+SLBarButtonItem.h"
#import "UIViewController+SLBaseViewController.h"

#import "SLBetDetailsTopView.h"

#import "SLBetDetailsFooterView.h"

#import "SLSportsCreateOrderRequest.h"

#import "SLBetDetailBottomView.h"
#import "BBMatchInfoManager.h"

#import "SLBetDetailsAlertVeiw.h"

#import "SLConfigMessage.h"

#import "BBBetDetailsInfoManager.h"

#import "SLWebViewController.h"

#import "SLExternalService.h"

#import "SLBetDetailsModel.h"

#import "BBBetDetailsCell.h"

#import "BBBetDetailBottomView.h"

#import "BBAllPlayMethodView.h"

#import "SLEndBetAlertView.h"

#import "BBMatchInfoManager.h"

@interface BBBetDetailsController ()<UITableViewDelegate,UITableViewDataSource, CLRequestCallBackDelegate>

/**
 顶部View(编辑/清空赛事)
 */
@property (nonatomic, strong) SLBetDetailsTopView *topView;

@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) CALayer *whiteLayer;
@property (nonatomic, strong) UIView *whiteView;

/**
 tableView的区尾
 */
@property (nonatomic, strong) SLBetDetailsFooterView *footerView;

@property (nonatomic, strong)NSMutableArray *dateArray;

/**
 底部投注项View
 */
@property (nonatomic, strong) BBBetDetailBottomView *detailBottomView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) BBMatchInfoManager *dataManager;

/**
 提示框
 */
@property (nonatomic, strong) SLBetDetailsAlertVeiw *alertView;

@property (nonatomic, strong) BBAllPlayMethodView *allPlayMethodView;

@property (nonatomic, assign) BOOL isFromAllOddsView;//标记是否是从全部赔率列表里删除的一场比赛

/**
 创建订单请求
 */
@property (nonatomic, strong) SLSportsCreateOrderRequest *request;


@property (nonatomic, strong) UIAlertController *alertVC;

@property (nonatomic, strong) SLEndBetAlertView *endBetAlertView;


@end

@implementation BBBetDetailsController

- (void)dealloc{
    
    NSLog(@"我死了");
    
}

#pragma mark ---- life Cycle ----

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    [self.request cancel];
    
    self.request.delegate = nil;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.request.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    [self configData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad
{

    [self configNavigation];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.whiteView];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.detailBottomView];
    
    self.listTableView.tableFooterView = self.footerView;
    [self.listTableView.layer addSublayer:self.whiteLayer];
    
    self.view.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.equalTo(self.view);
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(SL__SCALE(15.f));
        make.right.equalTo(self.view.mas_right).offset(SL__SCALE(-15.f));
        make.height.mas_equalTo(SL__SCALE(5.f));
    }];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.whiteView.mas_bottom);
        make.left.equalTo(self.whiteView.mas_left);
        make.right.equalTo(self.whiteView.mas_right);
        make.bottom.equalTo(self.detailBottomView.mas_top);
    }];
    
    [self.detailBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(self.view);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    self.whiteLayer.frame = CGRectMake(0, - SL_SCREEN_HEIGHT, self.listTableView.frame.size.width, SL_SCREEN_HEIGHT);
}

- (void)configNavigation
{
    [self setNavTitle:@"投注详情"];
    
    UIBarButtonItem *backItem = [UIBarButtonItem sl_itemWithImage:@"play_back" target:self action:@selector(backItemClick)];
    
    UIBarButtonItem *space = [UIBarButtonItem sl_spaceItemWithWidth:-9];
    
    self.navigationItem.leftBarButtonItems = @[space,backItem];
    
}

- (void)backItemClick
{
    //清空串关选择项
//    [[SLBetInfoCache shareBetInfoCache].allSelectBetItem.chuanGuanArray removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark ------------ keyBoard Notification ------------
- (void)keyboardShow:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:NO];
}

- (void)keyboardHidden:(NSNotification *)noti{
    
    [self keyboardAnimationWithNoti:noti isHidden:YES];
}



#pragma mark - 键盘出现或消失的动画
- (void)keyboardAnimationWithNoti:(NSNotification *)noti isHidden:(BOOL)isHidden{
    
    //获取键盘的高度
    NSDictionary *userInfo = [noti userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *duration = [noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];//动画时间
    NSNumber *curve = [noti.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];//动画曲线
    CGRect keyboardRect = [aValue CGRectValue];
    NSInteger height = isHidden ? 0 : - keyboardRect.size.height;
    [self.detailBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(height);
        make.left.right.equalTo(self.view);
    }];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    // set views with new info
    [self.view layoutIfNeeded];
    self.maskView.hidden = isHidden;
    // commit animations
    [UIView commitAnimations];
}

#pragma mark - 配置数据
- (void)configData{
    
    [self.dateArray removeAllObjects];
    [self.dateArray addObjectsFromArray:[BBBetDetailsInfoManager getBetInfo]];
    
    [self.topView setisSelectNumber:self.dateArray.count];
    [self.listTableView reloadData];
    
    [self.detailBottomView reloadBetDetailBottonViewUI];
}

#pragma mark ------------ event Response ------------
- (void)hiddenKeyBoard{
    
    [self.detailBottomView hiddenKeyBoard];
    [self.detailBottomView hiddenChuanGuanSelectView];
}


#pragma mark --- 立即支付 ----
- (void)pay{
    /** 支付 */
    
    self.request.gameId = [BBMatchInfoManager shareManager].getGameId;
    self.request.lotteryNumber = [BBMatchInfoManager getCreateOrderNumber];
    self.request.betTimes = [NSString stringWithFormat:@"%zi", [[BBMatchInfoManager shareManager] getMultiple]];
    self.request.amount = [NSString stringWithFormat:@"%zi", 2 * [[BBMatchInfoManager shareManager] getNote] * [[BBMatchInfoManager shareManager] getMultiple]];
    self.request.gameExtra = [BBMatchInfoManager getCreateOrderChuanGuan];
    [SLExternalService startLoading];
    [self.request start];
}

#pragma mark ------------ request delegate ------------
- (void)requestFinished:(CLBaseRequest *)request{
    
    if (request.urlResponse.success) {
        WS_SL(_weakSelf)
        
        NSDictionary *resp = request.urlResponse.resp;
        
        if ([request.urlResponse.resp[@"isBetAvailable"] integerValue] == 0) {
            
            //有几场比赛过期  弹窗 重新选择 返回选号页面
//            self.alertVC = [UIAlertController alertControllerWithTitle:nil message:request.urlResponse.resp[@"message"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"重新选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                [_weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
//            
//            if ([request.urlResponse.resp[@"jumpType"] integerValue] == 2) {
//                
//                alertAction1 = [UIAlertAction actionWithTitle:@"去足球看看" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//                    
//                    [SLExternalService goToFootBallViewController];
//
//                }];
//            }
//            
//            [_alertVC addAction:alertAction];
//            [_alertVC addAction:alertAction1];
//            
//            [self presentViewController:self.alertVC animated:YES completion:nil];
            
            
            
            self.endBetAlertView = [[SLEndBetAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];

            self.endBetAlertView.type = SLEndBetGuideTypeNoSale;
            
            self.endBetAlertView.title = resp[@"saleInfo"];
            self.endBetAlertView.jumpButtonTitle = resp[@"buttonTips"];
            self.endBetAlertView.desText = resp[@"message"];
            
            
            if ([resp[@"jumpType"] integerValue] == 2) {
                
                self.endBetAlertView.jumpLotteryBlock = ^{
                 
                    [_weakSelf dismissViewControllerAnimated:YES completion:^{
                        [SLExternalService goToFootBallViewController];
                    }];
                    
                    
                    [[BBMatchInfoManager shareManager] clearMatch];
                };
                
            }else{
            
                self.endBetAlertView.jumpLotteryBlock = ^{
                  
                    [_weakSelf.navigationController popViewControllerAnimated:YES];
                };
            }
            

            [self.view.window addSubview:self.endBetAlertView];
            
            
        }else{
            NSMutableDictionary *payOrderInfo = [NSMutableDictionary dictionaryWithDictionary:request.urlResponse.resp];
            [payOrderInfo setObject:@"jclq_mix_p" forKey:@"gameEn"];
            [SLExternalService createOrderSuccess:payOrderInfo origin:_weakSelf];
            //创建订单成功 清除 保存的投注项
            [[BBMatchInfoManager shareManager] clearMatch];
        }
        
    }else{
        
        [SLExternalService showError:request.urlResponse.errorMessage];
    }
    [SLExternalService stopLoading];
}

- (void)requestFailed:(CLBaseRequest *)request{
    
    [SLExternalService showError:request.urlResponse.errorMessage];
    [SLExternalService stopLoading];
}


- (void)deleteMatchIssue:(NSString *)matchIssue
{
    
    if ([[BBMatchInfoManager shareManager] afterRemoveCanBetWithMatchIssue:matchIssue]) {
        
        [self.alertView showInWindowWithType:SLAlertTypeDelete matchIssue:matchIssue];
    }else{
        [self.alertView showInWindowWithType:SLAlertTypeCancel matchIssue:matchIssue];
    }
}


#pragma mark ---- 串关选择重点 -----
- (void)alertSureButtonClick:(SLAlertType)type matchIssue:(NSString *)matchIssue{
    
    switch (type) {
        case SLAlertTypeDelete:{
            
            [[BBMatchInfoManager shareManager] removeOneMatchWithIssue:matchIssue];
            
            [self deleteOneMatchForReloadTable:matchIssue];
            
        }
            break;
        case SLAlertTypeEmpty:{
            
            
            [[BBMatchInfoManager shareManager] clearMatch];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case SLAlertTypeCancel:{
            
            [[BBMatchInfoManager shareManager] removeOneMatchWithIssue:matchIssue];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)deleteOneMatchForReloadTable:(NSString *)matchIssue{
    
    __block NSInteger indexRow = -1;
    [self.dateArray enumerateObjectsUsingBlock:^(SLBetDetailsModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.matchIssue isEqualToString:matchIssue]) {
            [self.dateArray removeObject:obj];
            indexRow = idx;
            *stop = YES;
        }
    }];
    
    if (indexRow != -1) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexRow inSection:0];
        [self.listTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.topView setisSelectNumber:self.dateArray.count];
        [self.detailBottomView reloadBetDetailBottonViewUI];
    }
}



#pragma mark --- TableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dateArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLBetDetailsModel *model = self.dateArray[indexPath.row];
    
    BBBetDetailsCell *cell = [BBBetDetailsCell createBetDetailsCellWithTableView:tableView];
    
    WS_SL(_weakSelf)
    __weak BBBetDetailsCell *weakCell = cell;
    cell.deleteBlock = ^(NSString *matchIssue){
        
        [_weakSelf deleteMatchIssue:matchIssue];
        self.isFromAllOddsView = NO;
    };
    
    cell.editBetBlock = ^(NSString *matchIssue) {
        
        [_weakSelf showAllOddsWithMatnIssue:matchIssue indexPath:[tableView indexPathForCell:weakCell]];
        
    };
    
    
    if (indexPath.row == self.dateArray.count - 1) {
        
        model.hiddenBottomLine = YES;
    }else{
        
        model.hiddenBottomLine = NO;
    }
    
    cell.betDetailModel = model;
    
    return cell;
    
}

- (void)showAllOddsWithMatnIssue:(NSString *)matchIssue indexPath:(NSIndexPath *)indexPath
{
    WS_SL(_weakSelf)
    if (self.allPlayMethodView) {
        [self.allPlayMethodView removeFromSuperview];
        self.allPlayMethodView = nil;
    }
    
    self.allPlayMethodView = [[BBAllPlayMethodView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.allPlayMethodView.reloadSelectDataBlock = ^(NSIndexPath *indexPath) {
        
        [_weakSelf configData];
        
    };
    self.allPlayMethodView.sureClearMatchBlock = ^{
        
        [_weakSelf deleteMatchIssue:matchIssue];
        
        _weakSelf.isFromAllOddsView = YES;
    };
    self.allPlayMethodView.selectIndexPath = indexPath;
    
    self.allPlayMethodView.currentMatchInfo = [[BBMatchInfoManager shareManager] getMatchInfoWithIssue:matchIssue];
    
    [self.allPlayMethodView showInWindow];
}


#pragma mark ---- Get Method ---

- (SLBetDetailsTopView *)topView
{
    
    if (_topView == nil) {
        WS_SL(_weak)
        _topView = [[SLBetDetailsTopView alloc] initWithFrame:(CGRectZero)];
        [_topView returnEditClick:^{
            
            [_weak backItemClick];
        }];
        
        [_topView returnEmptyClick:^{
            
            //清空标记
            self.isFromAllOddsView = NO;
            
            [_weak.alertView showInWindowWithType:SLAlertTypeEmpty matchIssue:@""];
        }];
    }
    
    return _topView;
}

- (UITableView *)listTableView
{
    
    if (_listTableView == nil) {
        
        _listTableView = [[UITableView alloc] initWithFrame:(CGRectZero) style:(UITableViewStylePlain)];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.estimatedRowHeight = 400;
        _listTableView.rowHeight = UITableViewAutomaticDimension;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.showsHorizontalScrollIndicator = NO;
        
        _listTableView.contentInset = UIEdgeInsetsMake(0, 0, SL__SCALE(20.f), 0);
        
        _listTableView.backgroundColor = SL_UIColorFromRGB(0xfaf8f6);
        
    }
    
    return _listTableView;
}

- (SLBetDetailsFooterView *)footerView
{
    
    if (_footerView == nil) {
        WS_SL(_weakSelf)
        _footerView = [[SLBetDetailsFooterView alloc] initWithFrame:(CGRectMake(0, 0, 200, 33))];
        _footerView.entrustBlock = ^{
            
            SLWebViewController *webView = [[SLWebViewController alloc] init];
            webView.activityUrlString = @"https://m.caiqr.com/help/c2cAgreementYing.html";
            [_weakSelf.navigationController pushViewController:webView animated:YES];
        };
    }
    return _footerView;
}

- (NSMutableArray *)dateArray
{
    
    if (_dateArray == nil) {
        
        _dateArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dateArray;
}

- (BBBetDetailBottomView *)detailBottomView{
    
    if (!_detailBottomView) {
        _detailBottomView = [[BBBetDetailBottomView alloc] init];
        WS_SL(_weakSelf)
        _detailBottomView.payBlock = ^{
            
            [SLExternalService checkIsLoginWithComplete:^{
                
                [_weakSelf pay];
            }];
            
        };
        
        _detailBottomView.twoChuanOneBlock = ^{
            
            SLWebViewController *web = [[SLWebViewController alloc] init];
            web.activityUrlString = @"https://m.laoyingcp.com/help/introdution_of_chuan_laoying.html";
            [_weakSelf.navigationController pushViewController:web animated:YES];
        };
        
        _detailBottomView.chuanGuanShowBlock = ^(BOOL select) {
            
            _weakSelf.maskView.hidden = !select;
        };
    }
    return _detailBottomView;
}

- (UIView *)maskView{
    
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        
        _maskView.backgroundColor = SL_UIColorFromRGBandAlpha(0x000000, 0.7);
        _maskView.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard)];
        [_maskView addGestureRecognizer:tap];
        
    }
    return _maskView;
}

- (SLBetDetailsAlertVeiw *)alertView
{
    
    if (_alertView == nil) {
        
        _alertView = [[SLBetDetailsAlertVeiw alloc] initWithFrame:(CGRectZero)];
        WS_SL(_weakSelf)
        //弹窗确定按钮点击事件
        [_alertView returnSureClick:^(SLAlertType type, NSString *matchIssue) {
            
            [_weakSelf.allPlayMethodView removeFromSuperview];
            
            [_weakSelf alertSureButtonClick:type matchIssue:matchIssue];
        }];
        
        
        [_alertView returnCancelClick:^(SLAlertType type, NSString *matchIssue) {
            

            if (type == SLAlertTypeCancel || type == SLAlertTypeDelete) {
                
                _weakSelf.allPlayMethodView.currentMatchInfo = [[BBMatchInfoManager shareManager] getMatchInfoWithIssue:matchIssue];
            }
            
        }];
    }
    
    return _alertView;
    
}


- (CALayer *)whiteLayer{
    
    if (!_whiteLayer) {
        _whiteLayer = [[CALayer alloc] init];
        _whiteLayer.backgroundColor = SL_UIColorFromRGB(0xffffff).CGColor;
    }
    return _whiteLayer;
}
- (UIView *)whiteView{
    
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = SL_UIColorFromRGB(0xffffff);
    }
    return _whiteView;
}

- (SLSportsCreateOrderRequest *)request{
    
    if (!_request) {
        _request = [[SLSportsCreateOrderRequest alloc] init];
        _request.delegate = self;
    }
    return _request;
}


@end
