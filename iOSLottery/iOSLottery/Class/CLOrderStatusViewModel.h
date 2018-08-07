//
//  CLOrderStatusParam.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CLOrderStatusType){
    
    CLOrderStatusTypeDot,
    CLOrderStatusTypeLine,
};

typedef NS_ENUM(NSInteger, CLOrderStatusDotType) {
    
    CLOrderStatusDotTypeDefault,
    CLOrderStatusDotTypeSuccess,
    CLOrderStatusDotTypeFail,
    CLOrderStatusDotTypeLight,
    CLOrderStatusDotTypeDark,
};

@interface CLOrderStatusViewModel : NSObject

@property (nonatomic) CLOrderStatusType statusType; //线段还是节点

@property (nonatomic) BOOL lineLight;   //线段的亮与暗

@property (nonatomic) CLOrderStatusDotType dotType;
@property (nonatomic, strong) NSString* dotTitle;
@property (nonatomic, strong) NSString* dotText;

/* 设置点状态 */
- (void)setDotTypeWithFlagString:(NSString*)flag;

+ (CLOrderStatusViewModel*)defaultLineParams;

+ (CLOrderStatusViewModel*)defaultDotParams;


@end
