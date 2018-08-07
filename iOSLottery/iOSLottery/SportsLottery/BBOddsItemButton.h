//
//  BBOddsItemButton.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/8/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBOddsItemButton : UIButton

@property (nonatomic, assign) BOOL showLeftLine;
@property (nonatomic, assign) BOOL showRightLine;
@property (nonatomic, assign) BOOL showTopLine;
@property (nonatomic, assign) BOOL showBottomLine;

- (void)setPlayName:(NSString *)str;

- (void)setAttributePlayName:(NSString *)str attributeArr:(NSArray *)attributeArr;

- (void)setOdds:(NSString *)str;



@end
