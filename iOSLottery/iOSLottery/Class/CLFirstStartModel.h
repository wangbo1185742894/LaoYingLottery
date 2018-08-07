//
//  CLFirstStartModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//客户端启动接口 model

#import "CLBaseModel.h"
#import <UIKit/UIKit.h>
@interface CLFirstStartModel : CLBaseModel

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *picturePrefix;
@property (nonatomic, strong) NSArray *allGame;
@property (nonatomic, assign) long advertTime;
@property (nonatomic, strong) NSArray *advertVos;

@property (nonatomic, strong) NSDictionary *allGameNameDic;//通过allGame 创建gameEn 和 gameName映射  不是后台数据

@end

@interface CLLaunchActivityModel : CLBaseModel

@property (nonatomic, strong) NSString *advertDesc;
@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, assign) long actionType;

@property (nonatomic, strong) UIImage *downloadImage;
@property (nonatomic, assign) long cutDownTime;

@end

