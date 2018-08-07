//
//  CLMainTabbarViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLMainTabbarViewController.h"
#import "CLBaseNavigationViewController.h"
#import "CLConfigMessage.h"
#import "CLGlobalTimer.h"
#import "CLAllJumpManager.h"
#import "CLTools.h"
#import "AppDelegate.h"
#import "CLTabbarTempCheckAPI.h"
static NSString * const HomeVC_ClassName = @"CLHomeViewController";
static NSString * const AwardAnnouncementVC_ClassName = @"CLAwardAnnouncementViewController";
static NSString * const UserCenterVC_ClassName = @"CLUserCenterViewController";
static NSString * const ArticleCircleVC_ClassName = @"MomentsViewController";


static NSString * const HomeVC_Title = @"投注大厅";
static NSString * const AwardAnnouncementVC_Title = @"开奖公告";
static NSString * const ArticleCircleVC_Title = @"圈子";
static NSString * const UserCenterVC_Title = @"我";

@interface CLMainTabbarViewController ()<CLRequestCallBackDelegate>
{
    NSDictionary *__itemTitleDictionary;
}
@property (nonatomic, strong) NSArray *className_Array;
@property (nonatomic, strong) CLTabbarTempCheckAPI *checkTabbarReleaseStatusAPI;

@end

@implementation CLMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addViewControllers];
    //注册全局定时器
    [CLGlobalTimer shareGlobalTimer];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    for (UIView *view in self.tabBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1) {
            view.backgroundColor = UIColorFromRGB(0xe5e5e5);
        }
    }
}


#pragma mark ------ add ViewControllers ------
- (void)addViewControllers{
    if (DEFAULTS(bool, @"bet_limit_status")) {
        NSArray *className_array = @[HomeVC_ClassName, AwardAnnouncementVC_ClassName, UserCenterVC_ClassName];
        __itemTitleDictionary = @{HomeVC_ClassName:HomeVC_Title,
                                  AwardAnnouncementVC_ClassName:AwardAnnouncementVC_Title,
                                  UserCenterVC_ClassName:UserCenterVC_Title};
        NSMutableArray *classVC_array = [[NSMutableArray alloc] initWithCapacity:className_array.count];
        for (NSString *class_name in className_array) {
            UINavigationController *nav = [self navigationItemsWithClassifyName:class_name];
            [classVC_array addObject:nav];
        }
        [[CLAllJumpManager shareAllJumpManager] registerAllJumpNavigationController:classVC_array[0]];
        self.viewControllers = classVC_array;
    }else{
        [self.checkTabbarReleaseStatusAPI start];
    }
    
}
- (UINavigationController*)navigationItemsWithClassifyName:(NSString *)rootClassName
{
    Class someClass = NSClassFromString(rootClassName);
    id obj = [[someClass alloc] init];
    
    CLBaseNavigationViewController* navigation = [[CLBaseNavigationViewController alloc] initWithRootViewController:obj];
    
    UIImage* imageUnSelect = nil;
    UIImage* imageSelect = nil;
    
    imageUnSelect = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",rootClassName]];
    imageSelect = [UIImage imageNamed:[NSString stringWithFormat:@"%@Select.png",rootClassName]];
    UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:[__itemTitleDictionary objectForKey:rootClassName] image:[imageUnSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[imageSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Courier-Bold" size:11],NSFontAttributeName,UIColorFromRGB(0xAAAAAA),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Courier-Bold" size:11],NSFontAttributeName,THEME_COLOR,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    navigation.tabBarItem = item;
    return navigation;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLRequestCallBackDelegate

- (void)requestFinished:(CLBaseRequest *)request {
    
    NSArray *className_array = @[HomeVC_ClassName, AwardAnnouncementVC_ClassName,ArticleCircleVC_ClassName, UserCenterVC_ClassName];
    __itemTitleDictionary = @{HomeVC_ClassName:HomeVC_Title,
                              AwardAnnouncementVC_ClassName:AwardAnnouncementVC_Title,
                              ArticleCircleVC_ClassName:ArticleCircleVC_Title,
                              UserCenterVC_ClassName:UserCenterVC_Title};
    if (request.urlResponse.success) {
        if ([request.urlResponse.responseObject[@"resp"][@"ifAuditing"] integerValue] == 0) {
            className_array = @[HomeVC_ClassName, AwardAnnouncementVC_ClassName, UserCenterVC_ClassName];
            __itemTitleDictionary = @{HomeVC_ClassName:HomeVC_Title,
                                      AwardAnnouncementVC_ClassName:AwardAnnouncementVC_Title,
                                      UserCenterVC_ClassName:UserCenterVC_Title};
            SET_DEFAULTS(Bool, @"bet_limit_status", YES);
        }else{
            SET_DEFAULTS(Bool, @"bet_limit_status", NO);
        }
    }else{
            SET_DEFAULTS(Bool, @"bet_limit_status", NO);
    }
    
    NSMutableArray *classVC_array = [[NSMutableArray alloc] initWithCapacity:className_array.count];
    for (NSString *class_name in className_array) {
        UINavigationController *nav = [self navigationItemsWithClassifyName:class_name];
        [classVC_array addObject:nav];
    }
    [[CLAllJumpManager shareAllJumpManager] registerAllJumpNavigationController:classVC_array[0]];
    self.viewControllers = classVC_array;
}

- (void)requestFailed:(CLBaseRequest *)request {
    SET_DEFAULTS(Bool, @"tempTabbar", NO);
    NSArray *className_array = @[HomeVC_ClassName, AwardAnnouncementVC_ClassName,ArticleCircleVC_ClassName, UserCenterVC_ClassName];
    __itemTitleDictionary = @{HomeVC_ClassName:HomeVC_Title,
                              AwardAnnouncementVC_ClassName:AwardAnnouncementVC_Title,
                              ArticleCircleVC_ClassName:ArticleCircleVC_Title,
                              UserCenterVC_ClassName:UserCenterVC_Title};
    NSMutableArray *classVC_array = [[NSMutableArray alloc] initWithCapacity:className_array.count];
    for (NSString *class_name in className_array) {
        UINavigationController *nav = [self navigationItemsWithClassifyName:class_name];
        [classVC_array addObject:nav];
    }
    [[CLAllJumpManager shareAllJumpManager] registerAllJumpNavigationController:classVC_array[0]];
    self.viewControllers = classVC_array;
}

- (void)cancelRequest:(CLBaseRequest *)request {
    
}


- (CLTabbarTempCheckAPI *)checkTabbarReleaseStatusAPI{
    if (!_checkTabbarReleaseStatusAPI) {
        _checkTabbarReleaseStatusAPI = [[CLTabbarTempCheckAPI alloc] init];
        _checkTabbarReleaseStatusAPI.delegate = self;
    }
    return _checkTabbarReleaseStatusAPI;
}


@end
