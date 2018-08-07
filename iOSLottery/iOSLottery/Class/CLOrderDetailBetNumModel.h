//
//  CLOrderDetailBetNumModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/21.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TitleType) {
    
    TitleNormal, //普通模式
    TitleTypeBonusNumber, //开奖号码
    TitleTypeBetNumber, //投注号码
    TitleTypeLeShanNumber //leshan
};

typedef NS_ENUM(NSInteger, MessageType) {
    
    BounsMessageType,
    MatchMessageType,
    EmptyMessageType
};

@interface CLOrderDetailBetNumModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* betNumber;
@property (nonatomic, assign) TitleType titleType;
@property (nonatomic, strong) NSString* gameEn;
@property (nonatomic, strong) UIColor *betNumberColor;


#pragma mark ----- 胜负彩使用 -----
@property (nonatomic, strong) NSString *awayName;

@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) NSString *matchId;

@property (nonatomic, strong) NSString *betOption;

@property (nonatomic, strong) NSString *result;

@property (nonatomic, strong) NSString *score;

@property (nonatomic, assign) NSInteger serialNumber;

/**
 奖金信息
 */
@property (nonatomic, strong) NSString *bounsMessageString;

/**
 是否是奖金类型
 */
@property (nonatomic, assign) NSInteger messageType;

/**
 空白行cell高度
 */
@property (nonatomic, assign) NSInteger emptyCellHeight;

/**
 是否是title标签
 */
@property (nonatomic, assign) BOOL isTitle;

@end
