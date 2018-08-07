//
//  CLTicketDetailsBetItem.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLTicketDetailsBetItem : UIView

@property (nonatomic, strong) NSArray *itemArray;

@end

@interface SLTicketDetailsItem : UIView

- (void)setUpMessageWithString:(NSString *)string;

@end
