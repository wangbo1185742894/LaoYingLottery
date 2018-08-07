//
//  SLConfigMessage.h
//  SportsLottery
//
//  Created by 任鹏杰 on 2017/5/10.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "Masonry.h"
#import "UINavigationController+SLBaseNavigationController.h"

#ifndef SLConfigMessage_h
#define SLConfigMessage_h

//弱引用
#define WS_SL(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//文字大小
#define SL_FONT_SCALE(F) [UIFont systemFontOfSize:SL__SCALE_HALE(F)]
//文字加粗
#define SL_FONT_BOLD(F) [UIFont boldSystemFontOfSize:SL__SCALE_HALE(F)]

//获取屏幕 宽度、高度
#define SL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SL_SCREEN_SCALE (SL_SCREEN_WIDTH / 375.0f)

#define SL__SCALE(a) (a * SL_SCREEN_SCALE)
#define SL__SCALE_HALE(a) (a * ((((SL_SCREEN_SCALE - 1) / 2.0f)) + 1))
#define SL__SCALE_ADD_HALE(a) ((a) * (((SL_SCREEN_SCALE - 1) > 0)? 2 :1))

#define SL__Rect(x,y,w,h) CGRectMake(x, y, w, h)

//是否是iphoneX
#define SL_kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//------------------------颜色类配置  start-----------------------------//
// rgb颜色转换（16进制->10进制）
#define SL_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// rgb颜色转换 且可改变透明度（16进制->10进制）
#define SL_UIColorFromRGBandAlpha(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
// rgb颜色转换 将字符串转换成16进制
#define SL_UIColorFromStr(colorStr) SL_UIColorFromRGB(strtoul([colorStr UTF8String],0,16))

//清除背景色
#define SL_CLEARCOLOR [UIColor clearColor]

#define SL_REDCOLOR SL_UIColorFromRGB(0XFC5548)

#define SL_GRAYCOLOR SL_UIColorFromRGB(0XDDDDDD)

//订单详情页cell分割线颜色
#define SL_SEPARATORCOLOR SL_UIColorFromRGB(0xECE5DD)

//------------------------颜色类配置  end-----------------------------//

#endif /* SLConfigMessage_h */
