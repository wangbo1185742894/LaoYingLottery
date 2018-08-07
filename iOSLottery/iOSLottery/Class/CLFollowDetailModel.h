//
//  CLFollowDetailModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import "CLFollowDetailNumbetTopVM.h"
#import "CLFollowDetailProgramModel.h"

@class CLFollowDetailHeaderViewModel;

typedef NS_ENUM(NSInteger, CLFollowDetailSectionType) {
    
    CLFollowDetailSectionTypeLottNumTop,
    CLFollowDetailSectionTypeLottNumBody,
    CLFollowDetailSectionTypeLottNumBottom,
    CLFollowDetailSectionTypeFollowNumTop,
    CLFollowDetailSectionTypeFollowNumBody,
};

@interface CLFollowDetailSectionViewModel : NSObject

@property (nonatomic) CLFollowDetailSectionType sectionType;
@property (nonatomic, strong) NSMutableArray* sectionArray;

@end


@interface CLFollowDetailModel : CLBaseModel

@property (nonatomic, assign) BOOL isShowFooterView;
@property (nonatomic, strong) NSString *gameEn;
@property (nonatomic, strong) CLFollowDetailHeaderViewModel* headerVM;
@property (nonatomic, strong) NSMutableArray* followOrderArrays;

@end


/* 基础API数据 */
@interface CLFollowDetailBaseAPIModel : CLBaseModel

@property (nonatomic, strong) NSString* followId;
@property (nonatomic, strong) NSString* gameEn;
@property (nonatomic, strong) NSString* userCode;
@property (nonatomic, strong) NSString* gameName;
@property (nonatomic) double amount;
@property (nonatomic) double bonus;
@property (nonatomic) NSInteger prizeStatus;
@property (nonatomic) NSInteger followStatus;
@property (nonatomic, strong) NSString* followStatusCn;
@property (nonatomic, strong) NSString* bonusAmountTxt;
@property (nonatomic, strong) NSString* bonusAmountValue;
@property (nonatomic, assign) long saleEndTime;
@property (nonatomic, strong) NSString* followModeCn;
@property (nonatomic, strong) NSString* followInfo;
@property (nonatomic) NSInteger periodDone;
@property (nonatomic) NSInteger totalPeriod;
@property (nonatomic) NSInteger ifShowPay;
@property (nonatomic, strong) NSArray* lotteryNumVoList;
@property (nonatomic, strong) NSArray<CLFollowDetailProgramModel*>* followOrderVos;
@property (nonatomic) NSInteger ifShowRefundDesc;
@property (nonatomic, assign) NSInteger ifShowTrueAmount;
@property (nonatomic, assign) double trueAmount;
@property (nonatomic, assign) NSInteger ifShowOrderRefundDesc;
@property (nonatomic, assign) NSInteger ifShowFollowRefundDesc;


@end
