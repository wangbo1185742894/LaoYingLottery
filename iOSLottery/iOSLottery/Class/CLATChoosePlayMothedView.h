//
//  CLATChoosePlayMothedView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLATChoosePlayMothedView : UIView

//@property (nonatomic, assign) CLSSQPlayMothedType playMothedType;
@property (nonatomic, copy) void(^reloadData)();

@end
