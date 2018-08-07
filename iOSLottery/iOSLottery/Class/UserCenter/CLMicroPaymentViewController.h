//
//  CQMicroPaymentViewController.h
//  caiqr
//
//  Created by 彩球 on 16/4/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CLBaseViewController.h"
#import "CLBaseModel.h"

@interface CLMicroPaymentViewController : CLBaseViewController

@property (nonatomic, copy) void(^userSettingFreeSuccessBlock)(NSInteger amount);

@end



@interface CQMicroPaymentCell : UITableViewCell

@property (nonatomic, readwrite) BOOL isSelectState;

@property (nonatomic, copy) void(^microPaySelect)(CQMicroPaymentCell* cell);

@end


@interface CQMicroPaymentInfo : CLBaseModel

@property (nonatomic, assign) NSInteger microPayAmount;
@property (nonatomic, assign) BOOL isSelectState;

- (void)cancelSelectState;

@end
