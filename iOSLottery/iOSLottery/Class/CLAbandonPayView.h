//
//  CLAbandonPayView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAbandonPayView : UIView

@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, strong) NSString *contentString;
@property (nonatomic, strong) NSString *okBtnTitle;
@property (nonatomic, strong) NSString *cancelBtnTitel;
@property (nonatomic, copy) void(^abandonBlock)(CLAbandonPayView *);
@property (nonatomic, copy) void(^continueButtonBlock)(CLAbandonPayView *);
@property (nonatomic, copy) void(^tapSelfBlock)(CLAbandonPayView *);

@end
