//
//  CLWithdrawSuccessViewController.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/29.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLWithdrawSuccessViewController.h"
#import "CLConfigMessage.h"
#import "CLWithdrawSuccessModel.h"
#import "Masonry.h"
#import "CaiqrWebImage.h"

@interface CLWithdrawSuccessViewController ()

@property (nonatomic, copy) void(^definiteActionBlock)(void);
@property (nonatomic, strong) UIImageView *headImageView;//头部图标
@property (nonatomic, strong) UILabel *proposeLabel;//提现申请提交label
@property (nonatomic, strong) UILabel *userInfoLabel;//提现到某个账户
@property (nonatomic, strong) UILabel *descLabel;//说明label
@property (nonatomic, strong) UIButton *finishedButton;//完成按钮

@end

@implementation CLWithdrawSuccessViewController
#pragma mark - 类方法
+ (instancetype)withdrawSuccessWithTitile:(NSString *)titleString method:(id)obj definiteAction:(void (^)(void))definiteAction
{
    CLWithdrawSuccessViewController *successAction = [[CLWithdrawSuccessViewController alloc] init];
    successAction.proposeLabel.text = titleString;
    [successAction assignData:obj];
    successAction.definiteActionBlock = definiteAction;
    return successAction;
}
#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleText = @"提现成功";
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.headImageView];
    [self.view addSubview:self.proposeLabel];
    [self.view addSubview:self.userInfoLabel];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.finishedButton];
    [self addSubContraint];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - responseEvent
- (void)transitionViewController
{
    if (self.definiteActionBlock) {
        self.definiteActionBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----- private Mothed
#pragma mark - 配置数据
- (void)assignData:(id)obj
{
    CLWithdrawSuccessModel *model = [CLWithdrawSuccessModel mj_objectWithKeyValues:[obj firstObject]];
    NSArray *memoArr = nil;
    if ([model.memo isKindOfClass:[NSString class]])
    {
        NSString *jsonString = [NSString stringWithFormat:@"%@",model.memo];
        memoArr = [jsonString mj_JSONObject];
    }
    NSMutableArray * tempArr = [CLUserCashBalanceMemo mj_objectArrayWithKeyValuesArray:memoArr];
    CLUserCashBalanceMemo * memo = nil;
    for (CLUserCashBalanceMemo  * _Nonnull obj in tempArr) {
        if ([obj isKindOfClass:[CLUserCashBalanceMemo class]]) {
            if ([obj.title isEqualToString:@"提现到"]){
                memo = obj;
                break;
            }
        }
    }
    if (memo) {
        if ([memo.content rangeOfString:@";"].length)
        {
            NSString *descString = memo.content;
            NSTextAttachment __block *descTextAttachment = [[NSTextAttachment alloc] init];
            descTextAttachment.bounds = __Rect(0, -2, 15, 15);
            NSString *imageString = [NSString stringWithFormat:@"%@",[descString componentsSeparatedByString:@";"].firstObject];
            descString = [NSString stringWithFormat:@"%@    %@", memo.title,[descString componentsSeparatedByString:@";"].lastObject];
            NSMutableAttributedString *descTextLabelString = [[NSMutableAttributedString alloc] initWithString:descString];
            [CaiqrWebImage downloadImageUrl:imageString progress:nil completed:^(UIImage *image, NSError *error, BOOL finished, NSURL *imageURL) {
                if (image != nil)
                {
                    descTextAttachment.image = image;
                }
            }];
            
            //将图片插入到  memo.title及两个空格 的后面
            [descTextLabelString insertAttributedString:[NSAttributedString attributedStringWithAttachment:descTextAttachment] atIndex:(memo.title.length + 2)];
            self.userInfoLabel.attributedText = descTextLabelString;
        }
        else
        {
            self.userInfoLabel.text = [NSString stringWithFormat:@"%@  %@", memo.title, memo.content];
        }
    }
}
#pragma mark - 添加约束
- (void)addSubContraint{
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(__SCALE(0.f + 30.f));
        make.width.height.mas_equalTo(__SCALE(58.f));
    }];
    [self.proposeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(__SCALE(25.f));
    }];
    [self.userInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.proposeLabel.mas_bottom).offset(__SCALE(8.f));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.userInfoLabel.mas_bottom).offset(__SCALE(5.f));
    }];
    
    [self.finishedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headImageView);
        make.top.equalTo(self.descLabel.mas_bottom).offset(__SCALE(30.f));
        make.height.mas_equalTo(__SCALE(37.f));
        make.width.mas_equalTo(SCREEN_WIDTH - __SCALE(10.f) * 2);
    }];
    
    
}
#pragma mrak - gettingMethod
- (UIImageView *)headImageView{
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.image = [UIImage imageNamed:@"cashFinished.png"];
    }
    return _headImageView;
}
- (UILabel *)proposeLabel{
    if (!_proposeLabel) {
        
        _proposeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _proposeLabel.text = @"提现申请已提交";
        _proposeLabel.textColor = UIColorFromRGB(0x333333);
        _proposeLabel.textAlignment = NSTextAlignmentCenter;
        _proposeLabel.font = FONT_SCALE(18);
        
    }
    return _proposeLabel;
}
- (UILabel *)userInfoLabel{
    if (!_userInfoLabel) {
        _userInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userInfoLabel.font = FONT_SCALE(12);
    }
    return _userInfoLabel;
}
- (UILabel *)descLabel{
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = UIColorFromRGB(0x666666);
        _descLabel.font = FONT_SCALE(12);
        _descLabel.text = @"具体到账时间以银行处理为准";
    }
    return _descLabel;
}
- (UIButton *)finishedButton{
    if (!_finishedButton) {
        _finishedButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_finishedButton setTitle:@"完成" forState:UIControlStateNormal];
        _finishedButton.titleLabel.font = FONT_SCALE(15);
        [_finishedButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [_finishedButton addTarget:self action:@selector(transitionViewController) forControlEvents:UIControlEventTouchUpInside];
        _finishedButton.backgroundColor = THEME_COLOR;
        _finishedButton.layer.cornerRadius = 3.f;
    }
    return _finishedButton;
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
