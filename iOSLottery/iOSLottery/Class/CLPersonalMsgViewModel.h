//
//  CLPersonalMsgViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/22.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"
#import <UIKit/UIKit.h>

@interface CLPersonalMsgViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) UIColor* contentColor;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, strong) NSString* headImgStr;
@property (nonatomic) BOOL canClicking;

@property (nonatomic, readonly) BOOL isHeadImgShow;

+ (CLPersonalMsgViewModel *) initHeadImage:(NSString*)headImgStr state:(NSString*)state canClick:(BOOL)click;

+ (CLPersonalMsgViewModel *) initTitle:(NSString*)title content:(NSString*)content state:(NSString*)state canClick:(BOOL)click;

@end

@interface CLPersonalMsgAPIModel : CLBaseModel

@property (nonatomic, strong) NSString* nick_name;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* head_img_url;
@property (nonatomic) NSInteger bound_count;
@property (nonatomic) NSInteger change_head_img_times;
@property (nonatomic) NSInteger change_nick_name_times;
@property (nonatomic, strong) NSArray* third_list;

@end
