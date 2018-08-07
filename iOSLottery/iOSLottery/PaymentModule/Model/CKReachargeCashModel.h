//
//  CKReachargeCashModel.h
//  caiqr
//
//  Created by 彩球 on 17/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface CKReachargeCashModel : NSObject

@property (nonatomic, assign) long amount;
@property (nonatomic, strong) NSString* flow_id;
@property (nonatomic, strong) NSString* pay_for_token;
@property (nonatomic) NSInteger pay_channel_key;
@property (nonatomic) NSInteger pay_for_channel;
@property (nonatomic, strong) NSString* handle_id;

@end
