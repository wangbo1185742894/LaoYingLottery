//
//  BBMatchSelectBtnView.h
//  SportsLottery
//
//  Created by 小铭 on 2017/8/15.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBMatchSelectBtnView : UIView

+ (BBMatchSelectBtnView *)selectBtnViewWithLeftTitle:(NSString *)leftTitle
                                          rightTitle:(NSString *)rightTitle;

@property (nonatomic, copy) void(^BBMatchSelectBlock)(NSInteger);

@end
