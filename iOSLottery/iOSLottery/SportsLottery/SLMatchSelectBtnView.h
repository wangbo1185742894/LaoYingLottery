//
//  SLMatchSelectBtnView.h
//  赛事筛选
//
//  Created by 任鹏杰 on 2017/5/9.
//  Copyright © 2017年 任鹏杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SLMatchSelectBtnDelegate <NSObject>

- (void)selectBtnAtIndex:(NSInteger)index;

@end

@interface SLMatchSelectBtnView : UIView

+ (SLMatchSelectBtnView *)selectBtnViewWithLeftTitle:(NSString *)leftTitle
                                       middleTitle:(NSString *)middleTitle
                                        rightTitle:(NSString *)rightTitle;

@property (nonatomic, weak) id<SLMatchSelectBtnDelegate>delegate;

@end
