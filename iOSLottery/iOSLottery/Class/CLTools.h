//
//  CLTools.h
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CLTools : NSObject
#pragma mark - 将View生成图片
UIImage*snapshot(UIView* view);

#pragma mark - 通过颜色生成图片
+ (UIImage*)createImageWithColor:(UIColor*) color;

#pragma mark - 传入两个数值，得出对应的排列组合个数
+ (NSInteger)getPermutationCombinationNumber:(NSInteger)allCount needCount:(NSInteger)needCount;


/**
 生成不重复的随机数

 @param count     个数
 @param maxNumber 最大值 （最小值是 1）

 @return 返回随机数 数组
 */
+(NSArray <NSString *>*)randomArrayWithCount:(NSInteger)count maxNumber:(NSInteger)maxNumber;

/**
 返回时分秒

 @param totalSeconds 时间 秒数

 @return 返回时间字符串
 */
+ (NSString *)timeFormatted:(long long)totalSeconds;

/**
 返回液晶字体的十分秒

 @param totalSeconds 总秒数
 @return 液晶字体
 */
+ (NSString *)getLEDTimeWithTime:(long long)totalSeconds;

/**
 对数组进行正序排序

 @param sortArray 需要排序的数组
 */
+ (void)sortSequenceWithArray:(NSMutableArray *)sortArray;

/**
 获取当前nav栈顶控制器

 @return 返回控制器
 */
+ (UIViewController *)getOriginViewController;


/**
 获取当前屏幕展示的ViewController

 @return ViewController
 */
+ (UIViewController *)getCurrentViewController;
/**
 手机振动
 */
+ (void)vibrate;

/**
 获取View的大小

 @param view View
 @return 大小
 */
+ (CGSize)getViewRealSize:(UIView *)view;


/**
 返回特殊标记的字符串

 @param tag 标记
 @param string 字符串
 @param endFlagString 结束符
 @return 返回range的数组
 */
+ (NSArray *)getRangeNeedColorWithTag:(NSString *)tag string:(NSString *)string endFlagString:(NSString *)endFlagString;


/**
 比较两个日期的大小  日期格式为2016-08-14 08：46：20

 @param aDate aDate
 @param bDate bDate
 @return 返回1表示aDate大   返回-1 表示bDate大
 */
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate;


/**
 判断url是否是url格式

 @param url urlString
 @return ret
 */
+ (BOOL)isValidUrl:(NSString *)url;
@end
