//
//  CLConfigMessage.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//
#import "CQDefinition.h"
#import "Masonry.h"
#import "CLConfigWebURL.h"
#import "CLConfiguration.h"
#ifndef CLConfigMessage_h
#define CLConfigMessage_h

#define GlobalTimerRuning @"globalTimerRun"  //倒计时一直在运行
#define APP_HASNET @"has_Net" //检测客户端有无网络
#define FT_ShakeAnimationStart @"FT_ShakeAnimationStart" //快三摇一摇动画开始了
#define DE_ShakeAnimationStart @"DE_ShakeAnimationStart" //D11摇一摇动画开始了
//------------------------通用字典key配置  start-----------------------------//
static NSString *const KEYNAME_NewFastThree = @"newKuanSanLottery";
static NSString *const KEYNAME_dEvelenFive = @"dEleven_fiveLottery";
//------------------------通用字典key配置  end-----------------------------//



//------------------------通用字体大小设置  start-----------------------------//
//#define FONT_FIT(F) [UIFont systemFontOfSize:(((F)/(96.f / 72.f)) / (([UIScreen mainScreen].bounds.size.width) / 320.0f))]

//------------------------通用字体大小设置  end-----------------------------//




//------------------------颜色类配置  start-----------------------------//
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// rgb颜色转换 且可改变透明度（16进制->10进制）
#define UIColorFromRGBandAlpha(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
// rgb颜色转换 将字符串转换成16进制
#define UIColorFromStr(colorStr) UIColorFromRGB(strtoul([colorStr UTF8String],0,16))
//清除背景色
#define CLEARCOLOR [UIColor clearColor]

#define THEME_COLOR UIColorFromRGB(0xe63222)//app主题色

#define UNABLE_COLOR UIColorFromRGB(0xffaaaa)//按钮不可被点击

#define LINK_COLOR UIColorFromRGB(0x5494ff)//跳转链接等的颜色

#define SEPARATE_COLOR UIColorFromRGB(0xe5e5e5)//分隔线
//------------------------颜色类配置  end-----------------------------//

#endif /* CLConfigMessage_h */
