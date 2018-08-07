//
//  CLBaseViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"
#import "UMMobClick/MobClick.h"
#import "CLCheckTokenManager.h"
static NSString * const HomeVC_ClassName_Base = @"CLHomeViewController";
static NSString * const AwardAnnouncementVC_ClassName_Base = @"CLAwardAnnouncementViewController";
static NSString * const UserCenterVC_ClassName_Base = @"CLUserCenterViewController";
static NSString * const ArticleCircleVC_ClassName_Base = @"MomentsViewController";

@interface CLBaseViewController ()

@property (nonatomic, strong) CLCheckTokenManager *checkTokenManager;
@property (nonatomic, strong) UILabel *navTitleLabel;//导航栏标题
@property (nonatomic, strong) NSString *realPageStatistics;//真正统计到的页面title

@end

@implementation CLBaseViewController

#pragma mark - 统跳协议
- (id)initWithRouterParams:(NSDictionary *)params {
    if ((self = [self init])) {
    }
    return self;
}
- (instancetype)init{
    
    if (self = [super init]) {
        
        if ([self isKindOfClass:NSClassFromString(HomeVC_ClassName_Base)] ||
            [self isKindOfClass:NSClassFromString(AwardAnnouncementVC_ClassName_Base)] ||
            [self isKindOfClass:NSClassFromString(UserCenterVC_ClassName_Base)] ||
            [self isKindOfClass:NSClassFromString(ArticleCircleVC_ClassName_Base)]) {
            
            self.hidesBottomBarWhenPushed = NO;
        }else{
            self.hidesBottomBarWhenPushed = YES;
        }
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if ([self isKindOfClass:NSClassFromString(HomeVC_ClassName_Base)] ||
        [self isKindOfClass:NSClassFromString(AwardAnnouncementVC_ClassName_Base)] ||
        [self isKindOfClass:NSClassFromString(UserCenterVC_ClassName_Base)]||
        [self isKindOfClass:NSClassFromString(ArticleCircleVC_ClassName_Base)]) {
        
        self.tabBarController.tabBar.hidden = NO;
    }else{
        self.tabBarController.tabBar.hidden = YES;
    }
    //友盟页面统计
    if (self.navTitleText && self.navTitleText.length > 0) {
        //如果有页面title就传页面title
        self.realPageStatistics = [NSString stringWithFormat:@"%@_%@", self.navTitleText, NSStringFromClass([self class])];
    }else if (self.pageStatisticsName && self.pageStatisticsName.length > 0){
        //如果有页面title就传 pageStatisticsName
        self.realPageStatistics = [NSString stringWithFormat:@"%@_%@", self.pageStatisticsName, NSStringFromClass([self class])];
    }else{
        self.realPageStatistics = NSStringFromClass([self class]);
    }
    [MobClick beginLogPageView:self.realPageStatistics];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    //结束页面统计
    if (self.realPageStatistics && self.realPageStatistics.length > 0)
    {
        [MobClick endLogPageView:self.realPageStatistics];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //添加后台切换至前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ViewContorlBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    //移除后台切换至前台通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    //关闭 系统自带的 返回文字
    if (IOS_VERSION >= 11) {
        
    }else{
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = THEME_COLOR;
    self.navigationController.navigationBar.translucent = NO;

    // Do any additional setup after loading the view.
    
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, __SCALE(150), 44)];
    self.navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.navTitleLabel;
}

- (void)setNavTitleText:(NSString *)navTitleText{
    
    self.navTitleLabel.text = navTitleText;
    [self.navTitleLabel sizeToFit];
}

#pragma mark ------------ 后台唤起调用方法 ------------
- (void)ViewContorlBecomeActive:(NSNotification *)notification {
    
    //校验token
    WS(_weakSelf)
    self.checkTokenManager = [[CLCheckTokenManager alloc] init];
    
    self.checkTokenManager.destroyCheckTokenManager = ^(){
        
        _weakSelf.checkTokenManager = nil;
    };
    [self.checkTokenManager checkUserToken];
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
