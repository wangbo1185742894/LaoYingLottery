//
//  CLEmptyButton.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLEmptyButton : UIButton

//按钮点击
@property (nonatomic, copy)void (^ btnselected)();

- (instancetype)initWithFrame:(CGRect)frame withtitle:(NSString *)titleString withBackgroundColor:(UIColor *)backGroundColor;

@end
