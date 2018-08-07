//
//  CLOrderDetailLineViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLOrderDetailLineViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic) NSRange linkRange;
@property (nonatomic, strong) UIColor* linkColor;
@property (nonatomic, strong) NSString* linkText;
@end
