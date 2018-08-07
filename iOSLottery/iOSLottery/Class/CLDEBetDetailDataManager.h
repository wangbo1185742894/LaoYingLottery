//
//  CLDEBetDetailDataManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/12/5.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLDEBetDetailModel;
@interface CLDEBetDetailDataManager : NSObject

- (NSArray <CLDEBetDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)gameEn;

@end
