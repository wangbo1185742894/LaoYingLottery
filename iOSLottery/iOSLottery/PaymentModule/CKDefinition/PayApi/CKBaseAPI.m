//
//  CKBaseAPI.m
//  CKPayClient
//
//  Created by 彩球 on 17/5/5.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CKBaseAPI.h"

@interface CKBaseAPI ()

@end

@implementation CKBaseAPI


- (void)start {
    
    [self performSelector:NSSelectorFromString(@"ck_startRequest")];
}


@end
