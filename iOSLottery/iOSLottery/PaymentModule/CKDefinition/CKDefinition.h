//
//  CKDefinition.h
//  caiqr
//
//  Created by huangyuchen on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#ifndef CKDefinition_h
#define CKDefinition_h

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
//NavBar高度
#define NavigationBar_HEIGHT ((IOS_VERSION >= 7.0)?64:44)

//文字大小
#define FONT_SCALE(F) [UIFont systemFontOfSize:__SCALE_HALE(F)]

#define TABLEBAR_HEIGHT 49.0f
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_SCALE (SCREEN_WIDTH / 320.0f)

#define __SCALE(a) (a * SCREEN_SCALE)
#define __SCALE_HALE(a) (a * ((((SCREEN_SCALE - 1) / 2.0f)) + 1))
#define __SCALE_ADD_HALE(a) ((a) * (((SCREEN_SCALE - 1) > 0)? 2 :1))

#define __Rect(x,y,w,h) CGRectMake(x, y, w, h)

#define __Obj_YH_Value(obj) (obj.frame.origin.y + obj.bounds.size.height)
#define __Obj_XW_Value(obj) (obj.frame.origin.x + obj.bounds.size.width)
#define __Obj_Bounds_Width(obj) (obj.bounds.size.width)
#define __Obj_Bounds_Height(obj) (obj.bounds.size.height)
#define __Obj_Frame_X(obj) (obj.frame.origin.x)
#define __Obj_Frame_Y(obj) (obj.frame.origin.y)

//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// rgb颜色转换 且可改变透明度（16进制->10进制）
#define UIColorFromRGBandAlpha(rgbValue,al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]
//rgb颜色转换 （string->16进制）
#define UIColorFromStringToRGB(colorStringValue) UIColorFromRGB(strtoul([colorStringValue UTF8String],0,16));
//清除背景色
#define CLEARCOLOR [UIColor clearColor]


#endif /* CKDefinition_h */
