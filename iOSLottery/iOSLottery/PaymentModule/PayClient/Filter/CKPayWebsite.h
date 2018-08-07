//
//  CKPayWebsite.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/23.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKPayIntermediaryInterface.h"

@interface CKPayWebsite : NSObject

/* 
    payMentHost
    UrlScheme
 */

+ (void)websitePaymentWithInfo:(id)info
                transitionType:(NSInteger)transitionType
                      h5Prefix:(NSString *)paymentUrlPrefix
                  intermediary:(id<CKPayIntermediaryInterface>) inter
                      complete:(void(^)(void))complete;


+ (BOOL)checkPageValidUrl:(NSURL*)url;

@end
