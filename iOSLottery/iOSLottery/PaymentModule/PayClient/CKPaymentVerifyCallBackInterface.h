//
//  CKPaymentVerifyCallBackInterface.h
//  caiqr
//
//  Created by 彩球 on 17/5/3.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CKPaymentBaseSource;
@protocol CKPaymentVerifyCallBackInterface <NSObject>

- (void)verifySuccessForMethod:(void(^)(id info))callBack;

@optional

- (void)setPersonalPaymentSource:(CKPaymentBaseSource*)source;

@end
