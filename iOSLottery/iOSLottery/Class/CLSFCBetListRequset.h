//
//  CLSFCBetListRequset.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/26.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLLotteryBusinessRequest.h"

@interface CLSFCBetListRequset : CLLotteryBusinessRequest<CLBaseConfigRequest>

@property (nonatomic, strong) NSString *gameEn;

@end
