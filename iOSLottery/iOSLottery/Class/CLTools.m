//
//  CLTools.m
//  iOSLottery
//
//  Created by huangyuchen on 2016/11/16.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLTools.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
#import "UIViewController+CLTransition.h"
#import "CLConfigMessage.h"
@implementation CLTools

#pragma mark - 将View生成图片
UIImage*snapshot(UIView* view)
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 将颜色转换成图片
+ (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - 传入两个数值，得出对应的排列组合个数
/**
 传入两个数值，得出对应的排列组合个数
 
 @param allCount  所有元素个数
 @param needCount 需要排列的个数
 
 @return 返回排列组个的个数
 */
+ (NSInteger)getPermutationCombinationNumber:(NSInteger)allCount needCount:(NSInteger)needCount{
    
    if (allCount < needCount) return 0;
    //排列组合 公式（ 6 * 5 * 4 ）/ (3 * 2 * 1)
    //被除数
    NSInteger dividendNumber = 1;
    //除数
    NSInteger divisorNumber = 1;
    //两次for循环得到 需要的 数值
    for (NSInteger i = 1; i <= needCount; i++) {
        
        dividendNumber *= (allCount - (i - 1));
        divisorNumber *= (i);
    }
    return dividendNumber / divisorNumber;
}


#pragma mark - 生成不重复的随机数
+(NSArray <NSString *>*)randomArrayWithCount:(NSInteger)count maxNumber:(NSInteger)maxNumber
{
    //随机数产生结果
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = 0; i < MAXFLOAT; i++) {
        NSInteger randomNumber = arc4random() % maxNumber + 1;
        BOOL isStore = YES;
        for (NSNumber *number in resultArray) {
            if ([number integerValue] == randomNumber) {
                isStore = NO;
            }
        }
        if (isStore) {
            [resultArray addObject:[NSString stringWithFormat:@"%02zi", randomNumber]];
        }
        if (resultArray.count == count) {
            break;
        }
    }
    return resultArray;
}

#pragma mark - 将秒数转换成分秒  若大于1小时，则转换成时分秒
+ (NSString *)timeFormatted:(long long)totalSeconds
{
    if (totalSeconds < 0) {
        return @"00:00";
    }
    long long seconds = totalSeconds % 60;
    long long minutes = (totalSeconds / 60) % 60;
    long long hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%lld:%02lld:%02lld",hours, minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%02lld:%02lld",minutes, seconds];
    }
    
}

+ (void)sortSequenceWithArray:(NSMutableArray *)sortArray{
    
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    [sortArray sortUsingComparator:cmptr];
}

#pragma mark - 获取源控制器
+ (UIViewController *)getOriginViewController{
    
    CLMainTabbarViewController* rootTabbarVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    
    UIViewController* sourceViewController = rootTabbarVC.selectedViewController;
    //找到当前选中VC的present页面
    while (sourceViewController.presentedViewController) {
        sourceViewController = sourceViewController.presentedViewController;
    }
    if ([sourceViewController isKindOfClass:[UIViewController class]]){
        sourceViewController = [sourceViewController searchBeforeNavi];
        if (sourceViewController) {
            if (sourceViewController.presentedViewController) {
                [sourceViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            }
        }
    }
    if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        sourceViewController = ((UINavigationController *)sourceViewController).topViewController;
    }
    return sourceViewController;
}

#pragma mark - 获取当前屏幕展示的ViewController
+ (UIViewController *)getCurrentViewController{
    
    CLMainTabbarViewController* rootTabbarVC = (CLMainTabbarViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController;
    
    UIViewController* sourceViewController = rootTabbarVC.selectedViewController;
    //找到当前选中VC的present页面
    while (sourceViewController.presentedViewController) {
        sourceViewController = sourceViewController.presentedViewController;
    }
    if ([sourceViewController isKindOfClass:[UIViewController class]]){
        sourceViewController = [sourceViewController searchBeforeNavi];
        if (sourceViewController) {
            if (sourceViewController.presentedViewController) {
                return sourceViewController.presentedViewController;
            }
        }
    }
    if ([sourceViewController isKindOfClass:[UINavigationController class]]){
        sourceViewController = ((UINavigationController *)sourceViewController).topViewController;
    }
    return sourceViewController;
}

+ (NSString *)getLEDTimeWithTime:(long long)totalSeconds{
    
    return [self getLEDStringWithString:[self timeFormatted:totalSeconds]];
}

#pragma mark - 液晶字体 映射 关系
+ (NSString *)getLEDStringWithString:(NSString *)numberString{
    
    NSDictionary *dic = @{
                          @"0" : @"\U0000e60c",
                          @"1" : @"\U0000e60b",
                          @"2" : @"\U0000e60f",
                          @"3" : @"\U0000e60d",
                          @"4" : @"\U0000e610",
                          @"5" : @"\U0000e613",
                          @"6" : @"\U0000e612",
                          @"7" : @"\U0000e611",
                          @"8" : @"\U0000e614",
                          @"9" : @"\U0000e615",
                          @":" : @"\U0000e60e"
                          };
    NSString *tempStr = [NSString new];
    for (NSInteger i = 0; i < numberString.length; i++) {
        
        NSString *oneStr = [numberString substringWithRange:NSMakeRange(i, 1)];
        tempStr = [tempStr stringByAppendingString:dic[oneStr]];
    }
    return tempStr;
}

#pragma mark ------------ 手机振动 ------------
+ (void)vibrate{
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - 获取View的大小
+ (CGSize)getViewRealSize:(UIView *)view{
    
    //动态计算高度
    UIView *superView = [[UIView alloc] initWithFrame:CGRectZero];
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    CGSize size = [superView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [view removeFromSuperview];
    superView = nil;
    return size;
}
#pragma mark -  返回特殊标记的字符串
+ (NSArray *)getRangeNeedColorWithTag:(NSString *)tag string:(NSString *)string endFlagString:(NSString *)endFlagString{

    NSMutableString *str = [string mutableCopy];
    NSMutableArray* ranges = [NSMutableArray arrayWithCapacity:0];
    NSRange range = NSMakeRange(0, 0);
    BOOL start = NO;
    
    for(int i=0; i<str.length; i++){
        NSString* s = [str substringWithRange:NSMakeRange(i, 1)];
        if ([s isEqualToString:tag]) {
            if (start) {
                [ranges addObject:[NSValue valueWithRange:range]];
            }
            start = YES;
            range.location = i;
            range.length = 0;
            [str deleteCharactersInRange:NSMakeRange(i, 1)];
            i--;
            continue;
        } else if ([endFlagString rangeOfString:s].location != NSNotFound){
            if (start) {
                [ranges addObject:[NSValue valueWithRange:range]];
                start = NO;
            }
        } else {
            if (start) {
                range.length++;
                if (i == (str.length - 1)) {
                    [ranges addObject:[NSValue valueWithRange:range]];
                }
            }
        }
    }
    return ranges;
}

#pragma mark -  比较两个日期的大小  日期格式为2016-08-14 08:46:20
+ (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        //        相等
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate大
        aa = -1;
    }else if (result==NSOrderedDescending)
    {
        //aDate大
        aa = 1;
    }
    return aa;
}
#pragma mark - 判断字符串时候是url
+ (BOOL)isValidUrl:(NSString *)url
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:url];
}
@end
