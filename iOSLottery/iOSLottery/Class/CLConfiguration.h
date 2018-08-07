//
//  CLConfiguration.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/9/13.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#ifndef CLConfiguration_h
#define CLConfiguration_h

//文字大小
#define CL_FONT_SCALE(F) [UIFont systemFontOfSize:CL__SCALE_HALE(F)]
//文字加粗
#define CL_FONT_BOLD(F) [UIFont boldSystemFontOfSize:CL__SCALE_HALE(F)]

//获取屏幕 宽度、高度
#define CL_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CL_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CL_SCREEN_SCALE (CL_SCREEN_WIDTH / 375.0f)

#define CL__SCALE(a) (a * CL_SCREEN_SCALE)
#define CL__SCALE_HALE(a) (a * ((((CL_SCREEN_SCALE - 1) / 2.0f)) + 1))
#define CL__SCALE_ADD_HALE(a) ((a) * (((CL_SCREEN_SCALE - 1) > 0)? 2 :1))

#define CL__Rect(x,y,w,h) CGRectMake(x, y, w, h)


#endif /* CLConfiguration_h */
