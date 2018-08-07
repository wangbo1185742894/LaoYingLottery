//
//  CLFTBetDetailDataManager.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLFTBetDetailModel;
@interface CLFTBetDetailDataManager : NSObject

- (NSArray <CLFTBetDetailModel *>*)getBetDetailModelWithGameEn:(NSString *)lotteryGameEn;

@end
