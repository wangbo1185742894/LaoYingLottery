//
//  CLUserCenterItem.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/4/6.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLUserCenterItem : CLBaseModel

typedef NS_ENUM(NSInteger, UserCenterCellType) {
    
    UserCenterCellTypeAccount= 1,
    UserCenterCellTypeRedEnvelop,
    UserCenterCellTypeBet,
    UserCenterCellTypeFollow,
    UserCenterCellTypeActivity,
    UserCenterCellTypeHelp,
};


/**
 图片name
 */
//@property (nonatomic, strong) NSString* iconName;

/**
 标题
 */
@property (nonatomic, strong) NSString* title;

/**
 item类型
 */
@property (nonatomic) NSInteger type;

/**
 图片name
 */
@property (nonatomic, strong) NSString* imgStr;

/**
 是否需要登录显示
 */
@property (nonatomic) BOOL showNeedLogin;

+ (CLUserCenterItem *)userCenterItmeWithTitile:(NSString *)title type:(UserCenterCellType)type showNeedLogin:(BOOL)isNeed imageName:(NSString *)imageName;

@end


