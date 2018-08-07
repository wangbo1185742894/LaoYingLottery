//
//  DiscribMessageViewController.m
//  MJSports
//
//  Created by 彩球 on 2018/1/13.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import "DiscribMessageViewController.h"
#import "CLWebViewActivityViewController.h"

@interface DiscribMessageViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextView* messageTextView;
@property (nonatomic, strong) UILabel *inputLbl;
@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIButton *agreementImageButton;
@property (nonatomic, strong) UIAlertView* releaseSuccessAlert;
@property (nonatomic, strong) UIAlertView* releaseFailAlert;

@end

@implementation DiscribMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发布";
    UIButton* doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [doneBtn setTitle:@"确认" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [doneBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.inputLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 20)];
    self.inputLbl.font = [UIFont systemFontOfSize:15];
    self.inputLbl.textColor = [UIColor blackColor];
    self.inputLbl.text = @"请输入要发布的内容:";
    [self.view addSubview:self.inputLbl];
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 140, self.view.bounds.size.width - 40, 200)];
    self.messageTextView.font = [UIFont systemFontOfSize:18];
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:self.messageTextView];
    
    
    self.agreementButton = [[UIButton alloc] initWithFrame: CGRectMake(92, CGRectGetMaxY(self.messageTextView.frame)+10, 160, 40)];
    
    [self.agreementButton setContentHorizontalAlignment:(UIControlContentHorizontalAlignmentLeft)];
    [self.agreementButton setTitle:@"《用户服务协议》" forState: UIControlStateNormal];
    [self.agreementButton setTitleColor: [UIColor blueColor] forState:UIControlStateNormal];
    self.agreementButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.agreementButton addTarget:self action:@selector(agreementButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreementButton];
    
    self.agreementImageButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.messageTextView.frame)+10, 90, 40)];
    self.agreementImageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.agreementImageButton setTitle:@"请遵守" forState:UIControlStateNormal];
    [self.agreementImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.agreementImageButton setImage:[UIImage imageNamed:@"mj_analysis_unselect.png"] forState:UIControlStateNormal];
    [self.agreementImageButton setImage:[UIImage imageNamed:@"mj_analysis_select.png"] forState:UIControlStateSelected];
    [self.agreementImageButton addTarget:self action:@selector(agreementImageButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementImageButton setSelected:YES];
    [self.view addSubview:self.agreementImageButton];
    [self.messageTextView becomeFirstResponder];
    
    
    // Do any additional setup after loading the view.
}
- (void)agreementImageButtonOnClick {
    
    [self.agreementImageButton setSelected:!self.agreementImageButton.isSelected];
}

- (void)agreementButtonOnClick: (UIButton *)btn {
    if (!self.agreementImageButton.isSelected) {
        
        UIAlertView* vv = [[UIAlertView alloc] initWithTitle:@"" message:@"请遵守圈子协议" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [vv show];
        
        return;
    }
    CLWebViewActivityViewController *webView = [[CLWebViewActivityViewController alloc] init];
    webView.activityUrlString = @"https://m.caiqr.com/daily/mojieai-yonghuxieyi/index.htm";
    [self.navigationController pushViewController:webView animated: YES];
}


- (void) makeSure {
    if (self.messageTextView.text.length == 0) {
        
        UIAlertView* vv = [[UIAlertView alloc] initWithTitle:@"" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [vv show];
        
        return;
    }
    
    self.releaseSuccessAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
    [self.releaseSuccessAlert show];
//    [MJVendorsRequest sendSocialConversionWithSocial_id:self.socialID content:self.messageTextView.text callback:^(BOOL state, NSString* msg) {
//        if (state) {
//            if (msg.length > 0) {
//                self.releaseSuccessAlert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//                [self.releaseSuccessAlert show];
//            }else {
//                [self.delegate publishData];
//                [self.navigationController popViewControllerAnimated:true];
//            }
//
//        } else {
//            self.releaseFailAlert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//            [self.releaseFailAlert show];
//        }
//    }];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView == self.releaseSuccessAlert) {
        
        [self.delegate publishData];
        [self.navigationController popViewControllerAnimated:true];
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
