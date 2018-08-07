//
//  CLBaseNavigationViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseNavigationViewController.h"
#import "CLBaseViewController.h"
@interface CLBaseNavigationViewController () <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation CLBaseNavigationViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    NSLog(@"%@", self.navigationBar.subviews.firstObject.subviews);
    for (UIView *view in self.navigationBar.subviews.firstObject.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.frame.size.height <= 1) {
            view.hidden = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateHighlighted];
    self.interactivePopGestureRecognizer.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{

//    if (self.childViewControllers.count == 1) {
//        
//        return NO;
//    }
//    return YES;
    return NO;
}


- (void)navigationController:(UINavigationController *)navController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // hide the nav bar if going home
    
    if ([viewController isKindOfClass:[CLBaseViewController class]]) {
        BOOL hide = ((CLBaseViewController*)viewController).hideNavigationBar;
//        BOOL hides = ((CLBaseViewController*)viewController).hidesNavigationBar;
        
        [navController setNavigationBarHidden:(hide) animated:animated];
    } else {
        [navController setNavigationBarHidden:NO animated:animated];
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
