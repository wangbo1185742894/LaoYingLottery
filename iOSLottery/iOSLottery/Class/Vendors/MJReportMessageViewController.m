//
//  MJReportMessageViewController.m
//  MJSports
//
//  Created by huangyuchen on 2018/4/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import "MJReportMessageViewController.h"
//#import "MJSports-Swift.h"

@interface MJReportMessageViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextView* messageTextView;
@property (nonatomic, strong) UILabel *inputLbl;

@property (nonatomic, strong) UIAlertView* success;


@end

@implementation MJReportMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"举报";
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
    self.inputLbl.text = @"请输入要举报的内容:";
    [self.view addSubview:self.inputLbl];
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 140, self.view.bounds.size.width - 40, 200)];
    self.messageTextView.font = [UIFont systemFontOfSize:18];
    self.messageTextView.layer.borderWidth = 1;
    self.messageTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:self.messageTextView];
    
    [self.messageTextView becomeFirstResponder];
    
    
    // Do any additional setup after loading the view.
}


- (void) makeSure {
    
    [self.messageTextView resignFirstResponder];
    if (self.messageTextView.text.length == 0) {
        
        UIAlertView* vv = [[UIAlertView alloc] initWithTitle:@"" message:@"内容不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [vv show];
        
        return;
    }
    
    self.success = [[UIAlertView alloc] initWithTitle:@"" message:@"举报成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [self.success show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.success == alertView) {
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
