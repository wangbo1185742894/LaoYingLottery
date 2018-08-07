//
//  CKPayRedSelectViewController.h
//  caiqr
//
//  Created by huangyuchen on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CKPayRedSelectViewController : UIViewController

@property (nonatomic, strong) id redList;
@property (nonatomic, copy) void(^selectRedIdBlock)(NSString *);

@end
