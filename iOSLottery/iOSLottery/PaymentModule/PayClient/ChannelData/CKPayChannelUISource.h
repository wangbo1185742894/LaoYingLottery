//
//  CKPayChannelUISource.h
//  iOSLottery
//
//  Created by 彩球 on 17/4/14.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKPayChannelFilterInterface.h"


@interface CKPayChannelUISource : NSObject <CKPayChannelUISourceInterface>

@property (nonatomic) NSInteger channel_id;                 //渠道id
@property (nonatomic, strong) NSString* channel_icon_str;   //渠道icon
@property (nonatomic, strong) NSString* channel_name;       //渠道名称
@property (nonatomic, strong) NSString* channel_subtitle;   //渠道副标题


@property (nonatomic, strong) NSString* channel_state_msg;  //渠道状态信息
@property (nonatomic) BOOL isSelected;                      //是否选择
@property (nonatomic) BOOL usability;                       //是否可用
@property (nonatomic) BOOL onlyShowChannelNm;               //是否仅显示渠道名称


@end
