//
//  SLMatchSelectModel.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SLMatchSelectModel : NSObject<NSCopying, NSMutableCopying>


/**
 联赛id
 */
@property (nonatomic, assign) NSInteger seasionId;

/**
 联赛名
 */
@property (nonatomic, strong) NSString *titile;

/**
 是否选中
 */
@property (nonatomic, assign) BOOL isSelect;

/**
 是否是五大联赛
 */
@property (nonatomic, assign) BOOL isFiveLeague;
/**
 联赛总场次
 */
@property (nonatomic, assign) NSInteger leagueTotal;

@end
