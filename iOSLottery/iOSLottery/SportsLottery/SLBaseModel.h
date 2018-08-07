//
//  SLBaseModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/12.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

/**
 *  判断obj数据是否是字符串 如果不是返回缺省值
 * @return  字符串
 */

NSString* NSStringFromValidData(id obj);

/**
 *  判断integer类型数据有效性 无效返回0
 */

NSInteger NSIntegerFormValidData(id obj);

//赔率小数点保留位数控制
NSString* BetOddsTransitionString(id odds);

/** 返回有效数据 */
id NSValidData(id obj);

@interface SLBaseModel : NSObject

@end
