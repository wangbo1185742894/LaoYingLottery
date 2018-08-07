//
//  DiscribMessageViewController.h
//  MJSports
//
//  Created by 彩球 on 2018/1/13.
//  Copyright © 2018年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusModel.h"


@protocol DiscribMessageViewControllerDelegate <NSObject>
    
- (void) publishData;

@end

@interface DiscribMessageViewController : UIViewController
//
@property (nonatomic, weak) id<DiscribMessageViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *socialID;

@end


