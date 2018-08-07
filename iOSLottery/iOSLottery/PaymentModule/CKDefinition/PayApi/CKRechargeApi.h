//
//  CKRechargeApi.h
//  caiqr
//
//  Created by 任鹏杰 on 2017/4/28.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "CKBaseAPI.h"

//#import "CKRechargeModel.h"

@interface CKRechargeApi : CKBaseAPI

/**
 字典转数据模型

 @param dict 数据字典
 */
- (void)dealingWithRechargeData:(NSDictionary*)dict;

- (NSMutableArray*) pullChannel;
- (NSArray*) pullFillList;
- (NSString *) pullTemplate;
- (NSArray *) pullBigMoney;
- (NSArray *) pullLimit_list;


@end
