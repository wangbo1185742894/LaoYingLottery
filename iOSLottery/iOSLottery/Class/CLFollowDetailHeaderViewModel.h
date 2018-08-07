//
//  CLFollowDetailHeaderViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLFollowDetailHeaderViewModel : CLBaseModel

@property (nonatomic, strong) NSString* lottIcon;
@property (nonatomic, strong) NSString* lottName;
@property (nonatomic, strong) NSString* followStatusCn;
@property (nonatomic, assign) long saleEndTime;
@property (nonatomic, strong) NSString* payBtnTitle;
@property (nonatomic) BOOL isWaitPay;
@property (nonatomic, assign) NSInteger isShowRefund;

@property (nonatomic, strong) NSMutableArray* cashMsgArray;

@end
