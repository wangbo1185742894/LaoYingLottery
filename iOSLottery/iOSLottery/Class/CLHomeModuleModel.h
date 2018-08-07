//
//  CLHomeModuleModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

typedef NS_ENUM(NSInteger, HomeModuleStyle){
    
    HomeModuleStyleQuickBet,//快速投入
    HomeModuleStyleLottery,//彩种入口
    HomeModuleStyleFocus,//今日关注
    HomeModuleStyleNormal,//普通cell
    HomeModuleStyleMargin//标题Cell
};



@interface CLHomeModuleModel : CLBaseModel

@property (nonatomic, strong) NSString* title;
@property (nonatomic) HomeModuleStyle style;
@property (nonatomic, strong) id moduleObjc;

- (NSInteger) count;

- (float) cellHeight;

@end
