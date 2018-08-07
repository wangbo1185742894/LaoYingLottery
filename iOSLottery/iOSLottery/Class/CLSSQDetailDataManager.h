//
//  CLSSQDetailDataManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/7.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLSSQDetailModel;
@interface CLSSQDetailDataManager : NSObject

- (NSArray <CLSSQDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)gameEn;

@end
