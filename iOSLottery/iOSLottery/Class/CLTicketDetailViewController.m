//
//  CLTicketDetailViewController.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/27.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLTicketDetailViewController.h"
#import "CLOrderTicketAPI.h"
#import "UIScrollView+CLRefresh.h"
#import "CLOrderTicketModel.h"
#import "CLOrderStatus.h"

@interface CLTicketDetailViewController () <UITableViewDelegate,UITableViewDataSource,CLRequestCallBackDelegate>

@property (nonatomic, strong) UITableView* mainTableView;

@property (nonatomic, strong) CLOrderTicketAPI* ticketAPI;

@end

@implementation CLTicketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"出票详情";
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.mainTableView startRefreshAnimating];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.ticketAPI pullData].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    CLOrderTicketModel* vo = [self.ticketAPI pullData][section];
    return  vo.ticketVos.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return __SCALE(30);
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CLTicketHeadView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CLTicketHeadViewId"];
    if (!headerView) {
        headerView = [[CLTicketHeadView alloc] initWithReuseIdentifier:@"CLTicketHeadViewId"];
    }
    CLOrderTicketModel* vo = [self.ticketAPI pullData][section];
    headerView.titleLbl.text = [NSString stringWithFormat:@"【%@】",vo.extraCn];
    headerView.titleLbl.font = FONT_SCALE(14);
    headerView.titleLbl.textColor = UIColorFromRGB(0x333333);
    return headerView;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLTicketCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CLTicketCellId"];
    if (!cell) {
        cell = [[CLTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CLTicketCellId"];
    }
    CLOrderTicketModel* vo = [self.ticketAPI pullData][indexPath.section];
    CLTicketVo* ticket = vo.ticketVos[indexPath.row];
    
    cell.multipleLbl.text = [NSString stringWithFormat:@"%zi倍",ticket.times];
    
    cell.stateLbl.text = ticket.ticketStatusCn;
    
    cell.stateLbl.textColor = ticket.prizeStatus > orderPrizeStatusNoBonus ? THEME_COLOR : UIColorFromRGB(0x333333);
    
    cell.ticketNoLbl.text = [NSString stringWithFormat:@"票号:%@",ticket.ticketId];
    NSMutableString* infos = [NSMutableString stringWithCapacity:0];
    for (NSString* objc in ticket.lotteryNumbers) {
        [infos appendFormat:@"%@%@",(infos.length > 0)?@"\n":@"",objc];
    }
    cell.ticketInfoLbl.text = infos;
    
    cell.showBottomLine = !((vo.ticketVos.count - 1) == indexPath.row);
    
    
    return cell;
}

#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    if (request.urlResponse.success) {
        [self.ticketAPI dealingwithTicketForDict:request.urlResponse.resp];
        [self.mainTableView reloadData];
    } else {
        [self show:request.urlResponse.errorMessage];
    }
    [self.mainTableView stopRefreshAnimating];
}

- (void)requestFailed:(CLBaseRequest *)request {
    
    [self show:request.urlResponse.errorMessage];
}

#pragma mark - getter

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = __SCALE(200);
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.backgroundColor = UIColorFromRGB(0xF7F7EE);
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        WS(_ws)
        [_mainTableView addRefresh:^{
            _ws.ticketAPI.orderId = _ws.orderId;
            [_ws.ticketAPI start];
        }];

        
    }
    return _mainTableView;
}

- (CLOrderTicketAPI *)ticketAPI {
    
    if (!_ticketAPI) {
        _ticketAPI = [[CLOrderTicketAPI alloc] init];
        _ticketAPI.delegate = self;
    }
    return _ticketAPI;
}

- (void)dealloc {
    
    if (_ticketAPI) {
        _ticketAPI.delegate = nil;
        [_ticketAPI cancel];
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



@implementation CLTicketHeadView

- (instancetype) initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLbl = [[UILabel alloc] init];
        UIView* lineView = [[UIView alloc] init];
        lineView.backgroundColor = UIColorFromRGB(0xdcdcdc);
        [self.contentView addSubview:lineView];
        [self.contentView addSubview:self.titleLbl];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.top.equalTo(self.contentView).offset(__SCALE(5.f));
            make.bottom.equalTo(self.contentView);
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.mas_equalTo(.5f);
        }];
    }
    return self;
}

@end



@interface CLTicketCell ()

@property (nonatomic, strong) UIView* lineView;

@end

@implementation CLTicketCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.ticketNoLbl = [[UILabel alloc] init];
        
        self.multipleLbl = [[UILabel alloc] init];
        self.stateLbl = [[UILabel alloc] init];
        self.lineView = [[UIView alloc] init];
        
        self.ticketInfoLbl = [[UILabel alloc] init];
        self.ticketInfoLbl.numberOfLines = 0;
        self.ticketInfoLbl.font = FONT_SCALE(15);
        self.ticketInfoLbl.textColor = UIColorFromRGB(0x333333);
        
        
        self.ticketNoLbl.font = FONT_SCALE(12);
        self.ticketNoLbl.textColor = UIColorFromRGB(0x999999);
        self.multipleLbl.textAlignment = NSTextAlignmentCenter;
        self.multipleLbl.font = FONT_SCALE(13);
        self.multipleLbl.textColor = UIColorFromRGB(0x333333);
        
        self.stateLbl.textAlignment = NSTextAlignmentRight;
        self.stateLbl.font = FONT_SCALE(13);
        self.stateLbl.textColor = UIColorFromRGB(0x333333);
        self.lineView.backgroundColor = UIColorFromRGB(0xe5e5e5);
        
        [self.contentView addSubview:self.ticketInfoLbl];
        [self.contentView addSubview:self.ticketNoLbl];
        [self.contentView addSubview:self.multipleLbl];
        [self.contentView addSubview:self.stateLbl];
        [self.contentView addSubview:self.lineView];
        
        [self.ticketNoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.top.right.equalTo(self.contentView);
            make.height.mas_equalTo(__SCALE(20));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(__SCALE(10.f));
            make.right.equalTo(self.contentView).offset(__SCALE(- 10.f));
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(.5f);
        }];
        
        [self.ticketInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView).offset(__SCALE(10));
            make.width.equalTo(self).multipliedBy(0.4);
            make.top.equalTo(self.ticketNoLbl.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];
        
        [self.multipleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.ticketInfoLbl.mas_right);
            make.top.bottom.equalTo(self.ticketInfoLbl);
            make.width.equalTo(self).multipliedBy(0.3);
        }];
        
        [self.stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.multipleLbl.mas_right);
            make.right.equalTo(self.contentView).offset(-__SCALE(10.f));
            make.top.bottom.equalTo(self.ticketInfoLbl);
        }];
        
    }
    return self;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    
    self.lineView.hidden = !showBottomLine;
}


@end

