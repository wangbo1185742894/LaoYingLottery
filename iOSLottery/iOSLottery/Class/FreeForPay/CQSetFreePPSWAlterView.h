//
//  CQSetFreePPSWAlterView.h
//  caiqr
//
//  Created by 洪利 on 2017/3/9.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQSetFreePPSWAlterView : UIView
@property (nonatomic, copy) void (^ chooseComplete)();
+ (instancetype)creatWithData:(id)model  frame:(CGRect)frame;

@end



@interface CQFreeOfPayCell : UITableViewCell

@property (nonatomic, strong) NSString *data;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSelected;

@end
