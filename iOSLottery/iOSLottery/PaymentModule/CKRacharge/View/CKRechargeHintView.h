//
//  CKRechargeHintView.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKRechargeHintView : UIView

@property (nonatomic, strong) UIButton *recommendBtn;

- (void)showTitleText:(NSString *)text buttonTitle:(NSString *)buttonTitile;

@end
