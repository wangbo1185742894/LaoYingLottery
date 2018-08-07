//
//  CLAwardDetailBonusCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAwardDetailBonusCell : UITableViewCell

@property (nonatomic, strong) UIColor* lastLabelColor;
@property (nonatomic, assign) BOOL has_BottomLine;
@property (nonatomic) NSInteger count;

- (void) configureItems:(NSString *)info;

@property (nonatomic) BOOL isShowColor;
@property (nonatomic) BOOL isTitle;
@end
