//
//  CLQueryStringPairs.h
//  caiqr
//
//  Created by 彩球 on 17/3/20.
//  Copyright © 2017年 Paul. All rights reserved.
//

/**
 * 仿AFNetworking 参数请求拼接规范
 */

#import <Foundation/Foundation.h>

NSString * CLQueryStringFromParameters(NSDictionary *parameters ,BOOL useEncode);

@interface CLQueryStringPairs : NSObject

@end
