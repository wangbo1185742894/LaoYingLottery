//
//  CLAboutUsViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLAboutUsViewController.h"

@interface CLAboutUsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) UIImageView *appIcon;
@property (strong, nonatomic) UILabel *copyrightLabel;

@property (nonatomic, strong) NSMutableArray* aboutUSDataSource;
@end

@implementation CLAboutUsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"关于我们";
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.appIcon];
    [self.view addSubview:self.myTableView];
    [self.view addSubview:self.copyrightLabel];
    
    self.aboutUSDataSource = [NSMutableArray arrayWithCapacity:0];
    NSDictionary* rowOne = @{@"title":@"当前版本",@"value":[NSString stringWithFormat:@"v %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]};
    [self.aboutUSDataSource addObject:rowOne];
    
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(__SCALE(0 + 30.f));
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(__SCALE(100));
    }];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.appIcon.mas_bottom).offset(__SCALE(20.f));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.copyrightLabel.mas_top).offset(__SCALE(- 10.f));
    }];
    
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view).offset(__SCALE(- 10.f));
        make.left.right.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aboutUSDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    aboutUsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"aboutUsCellId"];
    if (!cell) {
        cell = [[aboutUsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutUsCellId"];
    }
    
    cell.textLabel.font = FONT_FIX(12);
    cell.textLabel.text = [[self.aboutUSDataSource objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.rightLabel.text = [[self.aboutUSDataSource objectAtIndex:indexPath.row] objectForKey:@"value"];
    cell.rightLabel.textColor = UIColorFromRGB(0x666666);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
#pragma mark ------------ getter Mothed ------------
- (UITableView *)myTableView{
    
    if (!_myTableView) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.backgroundColor = CLEARCOLOR;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.scrollEnabled = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (UIImageView *)appIcon{
    
    if (!_appIcon) {
        _appIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _appIcon.contentMode = UIViewContentModeScaleAspectFit;
        _appIcon.image = [UIImage imageNamed:@"aboutUs.png"];
    }
    return _appIcon;
}
- (UILabel *)copyrightLabel{
    
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _copyrightLabel.text = @"Copyright©2016-2018 \n\n西安海创中盈信息技术有限公司";
        _copyrightLabel.textColor = UIColorFromRGB(0x999999);
        _copyrightLabel.font = FONT_SCALE(13.f);
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.numberOfLines = 0;
    }
    return _copyrightLabel;
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


@implementation aboutUsCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = UIColorFromRGB(0xffffff);
        self.rightLabel = [[UILabel alloc] initWithFrame:__Rect(SCREEN_WIDTH - 150, 0, 130, 50)];
        self.rightLabel.backgroundColor = CLEARCOLOR;
        self.rightLabel.textAlignment = NSTextAlignmentRight;
        self.rightLabel.font = FONT_FIX(12);
        [self.contentView addSubview:self.rightLabel];
        
        CALayer* layer = [CALayer layer];
        layer.frame = __Rect(0, 49, SCREEN_WIDTH, 1);
        layer.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        [self.layer addSublayer:layer];
        
        CALayer* layer1 = [CALayer layer];
        layer1.frame = __Rect(0, 0, SCREEN_WIDTH, 1);
        layer1.backgroundColor = UIColorFromRGB(0xefefef).CGColor;
        [self.layer addSublayer:layer1];
    }
    return  self;
}

@end
