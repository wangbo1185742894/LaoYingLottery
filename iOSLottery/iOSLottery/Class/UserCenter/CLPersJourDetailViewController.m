//
//  CLPersJourDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/25.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLPersJourDetailViewController.h"

#import "CLUserCashJournalDeailModel.h"
#import "CLMemoCell.h"
#import "UILabel+CLAttributeLabel.h"

#import "CLCheckOrderTypeAPI.h"
#import "CaiqrWebImage.h"

#import "CLFollowDetailViewController.h"
#import "CLLottBetOrdDetaViewController.h"
#import "CLAlertPromptMessageView.h"
#import "CLAllJumpManager.h"
@interface CLPersJourDetailViewController ()<UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray  *mainDataSource;

@property (nonatomic, strong) CLUserCashJournalDeailModel *balanceDetailModel;
@property (nonatomic, strong) CLCheckOrderTypeAPI* checkOrderTypeAPI;
@property (nonatomic, strong) CLPersJourDetailHeadView* headView;

@property (nonatomic, strong) CLUserCashJournalDeailModel *statusModel;

@property (nonatomic, strong) CLAlertPromptMessageView *alertView;

@end

@implementation CLPersJourDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navTitleText = @"记录详情";
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - assingDataSource
//** 账户余额列表详情，红包列表详情 */
- (void)assignDataSource:(id)dataSource
{
    self.statusModel = (CLUserCashJournalDeailModel *)dataSource;
    if (!self.statusModel)
    {
        [self show:@"暂无无法查看,请稍后访问"];
        return;
    }
    self.balanceDetailModel = self.statusModel;
    [self.mainDataSource removeAllObjects];
    [self.mainDataSource addObjectsFromArray:self.statusModel.memo_array];
    
    
    //** headerView */
    self.headView.titleLbl.text = @"已入账";
    NSString *journalString = [NSString stringWithFormat:@"%@%@",self.statusModel.amount,@"元"];
    self.headView.contentLbl.textColor = [self.statusModel.amount integerValue] > 0 ? UIColorFromRGB(0xe00000) :UIColorFromRGB(0x55bb55);
    [self.headView.contentLbl attributeWithText:journalString controParams:@[[AttributedTextParams attributeRange:[journalString rangeOfString:@"元"] Color:UIColorFromRGB(0x333333) Font:FONT_SCALE(11)]]];
    
    self.mainTableView.tableHeaderView = self.headView;
    [self.mainTableView reloadData];
}

#pragma mark - 跳转详情
- (void)pushOrderDetail:(NSDictionary *)dict{
    
    
    OrderType type = [self.checkOrderTypeAPI orderTypeForDict:dict];
    if ([dict[@"ifSkipDetail"] integerValue] == 1) {
        if (type == OrderTypeNormal) {
            NSInteger gameType = [dict[@"gameType"]?:@"" integerValue];
            if (gameType > 0) {
                /** 如果是高频，大盘彩，竞彩，北单 */
                if (gameType == 3) {
                    /** 如果是竞彩 */
                    [[CLAllJumpManager shareAllJumpManager] open:[NSString stringWithFormat:@"SLBetOrderDetailsController_push/%@", self.checkOrderTypeAPI.orderId] dissmissPresent:YES animation:NO];
                }else if (gameType == 1 || gameType == 2){
                    /** 大盘彩或高频彩 */
                    CLLottBetOrdDetaViewController* orderVC = [[CLLottBetOrdDetaViewController alloc] init];
                    orderVC.orderId = self.checkOrderTypeAPI.orderId;
                    [self.navigationController pushViewController:orderVC animated:YES];
                }
            }
        } else if (type == OrderTypeFollow) {
            CLFollowDetailViewController* followVC = [[CLFollowDetailViewController alloc] init];
            followVC.followID = self.checkOrderTypeAPI.orderId;
            [self.navigationController pushViewController:followVC animated:YES];
        }
    }else{
        //判断是否有线上版本
        self.alertView = nil;
        self.alertView = [[CLAlertPromptMessageView alloc] init];
        self.alertView.desTitle = self.checkOrderTypeAPI.bulletTips;
        
        if (self.checkOrderTypeAPI.ifSkipDownload == 1) {
            self.alertView.cancelTitle = @"立即更新";
            [self.alertView showInView:self.view];
            WS(_weakSelf)
            self.alertView.btnOnClickBlock = ^(){
                if (_weakSelf.checkOrderTypeAPI.ifSkipDownload == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_weakSelf.checkOrderTypeAPI.skipUrl]];
                }
            };
        }else{
            self.alertView.cancelTitle = @"知道了";
            self.alertView.btnOnClickBlock = nil;
        }
        [self.alertView showInWindow];
    }
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        
        [self pushOrderDetail:request.urlResponse.resp];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
}


- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - tableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLMemoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLPserJourDetaiListCellId"];
    if (!cell) {
        cell = [[CLMemoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CLPserJourDetaiListCellId"];
    }
    NSDictionary* dict = self.mainDataSource[indexPath.row];
    
    id title = dict[@"title"];
    if ([title isKindOfClass:NSString.class]) {
        cell.titleLbl.text = title;
    }

    id objc = dict[@"content"];
    if ((indexPath.row == self.mainDataSource.count - 1) && (self.balanceDetailModel.operate_type_id == UserCashBalanceOrderPayMent || self.balanceDetailModel.operate_type_id == UserCashBalanceOrderReturnAward)) {
        /** 可点击状态 */
        cell.contentLbl.text = @"查看订单";
        cell.contentLbl.textColor = THEME_COLOR;
    }else{
        if ([objc isKindOfClass:[NSString class]]) {
            if ([objc componentsSeparatedByString:@";"].count == 2 && [[[objc componentsSeparatedByString:@";"] firstObject] hasPrefix:@"http"]) {
                
                cell.contentLbl.text = [objc componentsSeparatedByString:@";"][1];
                [self asyLoadUrlImage:[objc componentsSeparatedByString:@";"][0] atLable:cell.contentLbl];
                cell.contentLbl.textColor = UIColorFromRGB(0x333333);
            } else {
                cell.contentLbl.text = objc;
                cell.contentLbl.textColor = UIColorFromRGB(0x333333);
            }
        }else{
            cell.contentLbl.text = @"";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString* content = self.mainDataSource[indexPath.row][@"content"];
    if ((indexPath.row == self.mainDataSource.count - 1) &&
        [content isKindOfClass:NSString.class] &&
        (content.length > 0) &&
        (self.statusModel.operate_type_id == UserCashBalanceOrderPayMent ||
         self.statusModel.operate_type_id == UserCashBalanceOrderReturnAward )) {
        
        self.checkOrderTypeAPI.orderId = content;
        [self.checkOrderTypeAPI start];
        
    }
}
- (void) asyLoadUrlImage:(NSString*)urlstr atLable:(UILabel*)label {
    
    
    [CaiqrWebImage downloadImageUrl:urlstr progress:nil completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
        if (finished) {
            NSMutableAttributedString* mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
            NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [self imageWithImage:image scaleToSize:CGSizeMake(14, 14)];
            NSAttributedString* icon = [NSAttributedString  attributedStringWithAttachment:textAttachment];
            [mutableAttributedString insertAttributedString:icon atIndex:0];
            label.attributedText = mutableAttributedString;
        }
    }];
}

- (UIImage*) imageWithImage:(UIImage*)image scaleToSize:(CGSize)size {
    
    UIImage* newImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - gettingMethod

- (UITableView *)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = UIColorFromRGB(0xefefef);
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 40.f;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
//        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (NSMutableArray *)mainDataSource
{
    if (!_mainDataSource) {
        _mainDataSource = [[NSMutableArray alloc] init];
    }
    return _mainDataSource;
}

- (CLCheckOrderTypeAPI *)checkOrderTypeAPI {
    
    if (!_checkOrderTypeAPI) {
        _checkOrderTypeAPI = [[CLCheckOrderTypeAPI alloc] init];
        _checkOrderTypeAPI.delegate = self;
    }
    return _checkOrderTypeAPI;
}

- (CLPersJourDetailHeadView *)headView {
    
    if (!_headView) {
        _headView = [[CLPersJourDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100.f)];
    }
    return _headView;
}

- (void)dealloc {
    
    if (_checkOrderTypeAPI) {
        _checkOrderTypeAPI.delegate = nil;
        [_checkOrderTypeAPI cancel];
    }
}

@end


@implementation CLPersJourDetailHeadView


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


@end

