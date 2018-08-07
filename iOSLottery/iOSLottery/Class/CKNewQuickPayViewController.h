//
//  CKNewQuickPayViewController.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/5/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseViewController.h"

typedef NS_ENUM(NSInteger, CKQuickOrderType) {
    
    CKQuickOrderTypeNormal = 0,
    CKQuickOrderTypeFollow,
    CKQuickOrderTypeFootball
};

@interface CKNewQuickPayViewController : CLBaseViewController

@property (nonatomic, strong) NSString*preHandleToken;
@property (nonatomic, strong) UIImage *backImage;
@property (nonatomic, assign) CKQuickOrderType orderType;

@end
