//
//  CQDefinition.h
//  caiqr
//
//  Created by Apple on 14/12/11.
//  Copyright (c) 2014年 Paul. All rights reserved.
//

#ifndef caiqr_CQDefinition_h
#define caiqr_CQDefinition_h

//#import "CQLaunchConf.h"
#import "CQViewQuickAllocDef.h"

//----------------------系统----------------------------

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define NOTIFICATION_GOTO_LOGIN_ObSERVERNAME  @"APP_GotoLoginNotificationObserverName"
#define NOTIFICATION_USEROFFLINE_OBSERVERNAME @"UserOffLineNotificationObserverName"


//获取系统版本
#define Client_DisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_GTR9 (IOS_VERSION >= 9.0)
#define IOS_VERSION_GTR8 (IOS_VERSION >= 8.0)
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define Device_Name [[UIDevice currentDevice] name]
#define Device_Model [[UIDevice currentDevice] model]
#define Device_LocationModel [[UIDevice currentDevice] localizedModel]
#define APP_VERSION  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define IPHONE4S (([[UIScreen mainScreen] bounds].size.height) <= 480)
#define SHORT_SCREEN_WIDTH_PHONE  (([[UIScreen mainScreen] bounds].size.width) <= 320)

//是否是iphoneX
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


//----------------------系统----------------------------



//-------------------获取设备大小-------------------------
//NavBar高度
#define NavigationBar_HEIGHT ((IOS_VERSION >= 7.0)?64:44)


//-------------------获取设备大小-------------------------



//--------------------打印日志-------------------------

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

//---------------------打印日志--------------------------


//---------------------数据监测--------------------------

#define DataNotEmpty(a) (![(a) isKindOfClass:[NSNull class]] && (a != nil))
#define DataNotError(a) (![(a) isKindOfClass:[NSError class]])
#define __DataExist(a) (a != nil)

//----------------------内存----------------------------

//使用ARC和不使用ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif


//释放一个对象

#define SAFE_RELEASE(x) x=nil;



//----------------------内存----------------------------


#define SuppressPerformSelectorLeakWarning(Stuff) \
            do { \
                _Pragma("clang diagnostic push") \
                _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
                Stuff; \
                _Pragma("clang diagnostic pop") \
            } while (0)

//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------


#define TeamFlag_Default [UIImage imageNamed:@"default_Teamflag"]
#define BANNERIMAGE_DEFAULT [UIImage imageNamed:@"banner默认图"]



//----------------------Warning----------------------

#define CQSuppressPerformSelectorWarning(PerformCall) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
PerformCall; \
_Pragma("clang diagnostic pop") \
} while (0)




//----------------------其他----------------------------

//方正黑体简体字体定义
#define FONT(F) [UIFont systemFontOfSize:F]
#define FONT_SCALE(F) [UIFont systemFontOfSize:__SCALE_HALE(F)]
#define FONT_BOLD(F) [UIFont boldSystemFontOfSize:__SCALE_HALE(F)]
#define FONT_FIX(F) [UIFont systemFontOfSize:__SCALE(F)]

//程序的本地化,引用国际化的文件
#define MyLocal(x, ...) NSLocalizedString(x, nil)

//G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)
#define DELAY(t,block) BACK(^{ \
                                sleep(t);\
                            MAIN(block); \
                        });

//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define DEFAULTS(type, key) ([[NSUserDefaults standardUserDefaults] type##ForKey:key])
#define SET_DEFAULTS(Type, key, val) do {\
        [[NSUserDefaults standardUserDefaults] set##Type:val forKey:key];\
        [[NSUserDefaults standardUserDefaults] synchronize];\
} while (0)

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


#endif
