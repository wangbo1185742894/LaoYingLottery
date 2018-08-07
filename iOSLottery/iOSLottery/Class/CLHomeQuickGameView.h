//
//  CLHomeQuickGameView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLHomeQuickGameView : UIView

- (void) switchNumberWithArray:(NSArray *)numArray;

@property (nonatomic, strong) NSString* gameEn;

@end
