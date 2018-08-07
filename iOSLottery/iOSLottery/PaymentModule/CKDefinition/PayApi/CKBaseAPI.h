//
//  CKBaseAPI.h
//  CKPayClient
//
//  Created by 彩球 on 17/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLBaseRequest.h"
@interface CKBaseAPI : NSObject

@property (nonatomic, weak) id delegate;

- (void)start;

@end
