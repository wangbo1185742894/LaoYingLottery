//
//  CKPayRedSelectViewController.m
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKPayRedSelectViewController.h"
#import "CKUserPaymentSelectedHeaderView.h"
#import "CKPayRedSelectCell.h"
#import "CKRedPacketUISource.h"
#import "CKDefinition.h"
@interface CKPayRedSelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;


@end

@implementation CKPayRedSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(40.f), __SCALE(30))];
    label.text = @"红包";
    label.font = [UIFont boldSystemFontOfSize:__SCALE_HALE(17.f)];
    label.textColor = UIColorFromRGB(0xffffff);
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    [self.view addSubview:self.mainTableView];
    
}

- (void)setRedList:(id)redList{
    
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:redList];
    if ([redList count]) {
        self.mainTableView.tableHeaderView = [CKUserPaymentSelectedHeaderView userPaymentSelectedHeaderView];
    }
    [self.mainTableView reloadData];
}

#pragma mark ------------ tableview delegate ------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *idCell = @"CKPayRedSelectCell";
    CKPayRedSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (!cell) {
        cell = [[CKPayRedSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
    }
    
    CKRedPacketUISource *source = self.dataSourceArray[indexPath.row];
    cell.redAmount = source.title;
    cell.descString = source.descString;
    cell.descColorString = source.descColorString;
    cell.isSelectState = source.selected;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CKRedPacketUISource *source = self.dataSourceArray[indexPath.row];
    
    !self.selectRedIdBlock ? : self.selectRedIdBlock(source.fid);
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ------------ getter Mothed ------------
- (UITableView *)mainTableView{
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5.f, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBar_HEIGHT - 5.f) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.estimatedRowHeight = 200.f;
        _mainTableView.rowHeight = UITableViewAutomaticDimension;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTableView;
}

- (NSMutableArray *)dataSourceArray{
    
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataSourceArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
