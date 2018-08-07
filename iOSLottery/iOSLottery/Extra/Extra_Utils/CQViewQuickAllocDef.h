//
//  CQViewQuickAllocDef.h
//  caiqr
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 Paul. All rights reserved.
//

#ifndef caiqr_CQViewQuickAllocDef_h
#define caiqr_CQViewQuickAllocDef_h

#define TABLEBAR_HEIGHT (kDevice_Is_iPhoneX ? 83.0f : 49.0f)
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


//----------------------UILabel----------------------------

#define AllocNormalLabel(_obj,_text,_font,_align,_color,_rect)   \
                                                        _obj = [[UILabel alloc] initWithFrame:_rect];\
                                                        _obj.backgroundColor = [UIColor clearColor];\
                                                        _obj.textAlignment = _align; \
                                                        _obj.font = _font; \
                                                        if (_text != nil ) \
                                                        { \
                                                            _obj.text = _text; \
                                                        } \
                                                        _obj.textColor = _color;



//----------------------UIButton----------------------------




//----------------------UIImageView----------------------------


#endif
