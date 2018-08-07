//
//  CKFOPAlertView.h
//  caiqr
//
//  Created by 洪利 on 2017/4/27.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CKFOP_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CKFOP_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CKFOP_SCREEN_SCALE (CKFOP_SCREEN_WIDTH / 320.0f)
#define CKFOP_SCALE(a) (a * CKFOP_SCREEN_SCALE)
#define CKFOP_SCALE_HALE(a) (a * ((((CKFOP_SCREEN_SCALE - 1) / 2.0f)) + 1))
#define CKFOP_SCALE_ADD_HALE(a) ((a) * (((CKFOP_SCREEN_SCALE - 1) > 0)? 2 :1))
#define CKFOP_FONT(F) [UIFont systemFontOfSize:F]
#define CKFOP_FONT_SCALE(F) [UIFont systemFontOfSize:CKFOP_SCALE_HALE(F)]
#define CKFOP_FONT_FIX(F) [UIFont systemFontOfSize:CKFOP_SCALE(F)]
// rgb颜色转换（16进制->10进制）
#define CKFOP_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface CKFOPAlertView : UIView

@property (nonatomic, copy) void (^ chooseComplete)(id);
+ (instancetype)creatWithData:(id)model  frame:(CGRect)frame;

@end



@interface CKFOPCell : UITableViewCell

@property (nonatomic, strong) NSString *data;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isSelected;

@end
