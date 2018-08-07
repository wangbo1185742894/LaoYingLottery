//
//  CLPushManagerViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLPushManagerViewController.h"

@interface CLPushManagerViewController ()

@end

@implementation CLPushManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"推送管理";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 170)];
    imageView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 - 20);
    imageView.image = [UIImage imageNamed:@"pushMessageImage.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
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
