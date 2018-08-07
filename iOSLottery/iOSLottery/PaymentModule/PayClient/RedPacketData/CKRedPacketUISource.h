//
//  CKRedPacketUISource.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKRedPacketFilterInterface.h"

@interface CKRedPacketUISource : NSObject <CKRedPacketUISourceInterface>

@property (nonatomic, strong) NSString* fid;
@property (nonatomic, strong) NSString* imgStr;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* selectedTitle;
@property (nonatomic, strong) NSString* balanceStr;
@property (nonatomic, strong) NSString *descString;
@property (nonatomic, strong) NSString *descColorString;
@property (nonatomic) BOOL selected;
@property (nonatomic) long long balance; //单位:分

@end
