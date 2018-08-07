//
//  CLNewbieGuidanceService.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLNewbieGuidanceService.h"
#import "CLConfigMessage.h"
#import "CLMainTabbarViewController.h"
#import "AppDelegate.h"
#import "CLCacheManager.h"
#import "CQmyproxy.h"
#define NewGuidanceNameHome @"NewGuidanceNameHome"
#define NewGuidanceNameFT @"NewGuidanceNameFT"
#define NewGuidanceNameDE @"NewGuidanceNameDE"
#define NewGuidanceNameOrderList @"NewGuidanceNameOrderList"
#define NewbieGuidanceNameFootBall @"NewbieGuidanceTypeFootBall"
#define NewbieGuidanceNameBasketBall @"NewbieGuidanceTypeBasketBall"
#define NewbieGuidanceNameSSQ @"NewbieGuidanceTypeSSQ"
#define NewbieGuidanceNameDLT @"NewbieGuidanceTypeDLT"

@interface CLNewbieGuidanceService ()

@property (nonatomic, strong) UIImageView *newbieImageView;
@property (nonatomic, strong) NSMutableArray *showNewImageArray;

@end
@implementation CLNewbieGuidanceService

static CLNewbieGuidanceService *service = nil;
+ (UIView *)getNewGuidanceViewWithType:(CLNewbieGuidanceType)type{
    
//    if (!service) {
//        service = [[CLNewbieGuidanceService alloc] init];
//    }
//    NSString *newGuidanceStr = [CLCacheManager getNoableClearCacheFormLocationcacheFileWithName:[service getCacheNameWithType:type]];
//    if ([newGuidanceStr isEqualToString:@"1"]) {
//        //已经过了新手引导
//        return nil;
//    }else{
//        //缓存
//        [CLCacheManager saveToNoableClearCacheWithContent:@"1" cacheFileName:[service getCacheNameWithType:type]];
//        //展示新手引导图片
//        [service showNewGuidanceWithtype:type];
//        return [service getNewGuidanceImage];
//    }
    return nil;
}
+ (void)showNewGuidanceInWindowWithType:(CLNewbieGuidanceType)type{
    
//    if (!service) {
//        service = [[CLNewbieGuidanceService alloc] init];
//    }
//
//    NSString *newGuidanceStr = [CLCacheManager getNoableClearCacheFormLocationcacheFileWithName:[service getCacheNameWithType:type]];
//    if ([newGuidanceStr isEqualToString:@"1"]) {
//        //已经过了新手引导
//        return;
//    }else{
//        //缓存
//        [CLCacheManager saveToNoableClearCacheWithContent:@"1" cacheFileName:[service getCacheNameWithType:type]];
//        //展示新手引导图片
//        [service showNewGuidanceWithtype:type];
//        [service showNewGuidanceImage];
//    }
}
#pragma mark ------------ event Response ------------
- (void)tapOnClick:(UIGestureRecognizer *)tap{
 
    if (self.showNewImageArray && self.showNewImageArray.count > 0) {
        self.newbieImageView.image = (UIImage *)self.showNewImageArray[0];
        [self.showNewImageArray removeObjectAtIndex:0];
    }else{
        [self.newbieImageView removeFromSuperview];
//        [[CQmyproxy dealerProxy] alterClosed:@"UIView"];
    }
    
}

#pragma mark ------------ private ------------
- (void)showNewGuidanceWithtype:(CLNewbieGuidanceType)type{
    
    [self.showNewImageArray removeAllObjects];
    switch (type) {
        case CLNewbieGuidanceTypeHome:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"homeQuickBet.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"homeLottery.png"]];
        }
            break;
        case CLNewbieGuidanceTypeFT:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"ft_playMothed.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"ft_helper.png"]];
        }
            break;
        case CLNewbieGuidanceTypeDe:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"de_playMothed.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"de_helper.png"]];
        }
            break;
        case CLNewbieGuidanceTypeOrderList:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"orderListAward.png"]];
        }
            break;
        case CLNewbieGuidanceTypeFootBall:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"footBallNewbieGuidance1.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"footBallNewbieGuidance2.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"footBallNewbieGuidance3.png"]];
        }
            break;
            
        case CLNewbieGuidanceTypeBasketBall:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"basketBallNewbieGuidance1.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"basketBallNewbieGuidance2.png"]];
            
            break;
        }
        case CLNewbieGuidanceTypeSSQ:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"SSQNewbieGuidance1.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"SSQNewbieGuidance2.png"]];
        }
            break;
        case CLNewbieGuidanceTypeDLT:{
            
            [self.showNewImageArray addObject:[UIImage imageNamed:@"DLTNewbieGuidance1.png"]];
            [self.showNewImageArray addObject:[UIImage imageNamed:@"DLTNewbieGuidance2.png"]];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 添加图片
- (void)showNewGuidanceImage{
    
    if (self.showNewImageArray && self.showNewImageArray.count > 0) {
        self.newbieImageView.image = (UIImage *)self.showNewImageArray[0];
        UIView *mainWindow = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
        [mainWindow addSubview:self.newbieImageView];
        [self.showNewImageArray removeObjectAtIndex:0];
    }
}
- (UIView *)getNewGuidanceImage{
    
    if (self.showNewImageArray && self.showNewImageArray.count > 0) {
        self.newbieImageView.image = (UIImage *)self.showNewImageArray[0];
        [self.showNewImageArray removeObjectAtIndex:0];
        return self.newbieImageView;
    }
    return nil;
}
#pragma mark ------------ getter Mothed ------------
- (UIImageView *)newbieImageView{
    
    if (!_newbieImageView) {
        _newbieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _newbieImageView.userInteractionEnabled = YES;
        _newbieImageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnClick:)];
        [_newbieImageView addGestureRecognizer:tap];
    }
    return _newbieImageView;
}
- (NSMutableArray *)showNewImageArray{
    
    if (!_showNewImageArray) {
        _showNewImageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _showNewImageArray;
}
- (NSString *)getCacheNameWithType:(CLNewbieGuidanceType)type{
    
    switch (type) {
        case CLNewbieGuidanceTypeHome:{
            
            return NewGuidanceNameHome;
        }
            break;
        case CLNewbieGuidanceTypeFT:{
            
            return NewGuidanceNameFT;
        }
            break;
        case CLNewbieGuidanceTypeDe:{
            
            return NewGuidanceNameDE;
        }
            break;
        case CLNewbieGuidanceTypeOrderList:{
            
            return NewGuidanceNameOrderList;
        }
            break;
        case CLNewbieGuidanceTypeFootBall:{
            
            return NewbieGuidanceNameFootBall;
        }
            break;
        
        case CLNewbieGuidanceTypeBasketBall:{
            
            return NewbieGuidanceNameBasketBall;
        }
            break;
        case CLNewbieGuidanceTypeSSQ:{
            
            return NewbieGuidanceNameSSQ;
        }
            break;
        case CLNewbieGuidanceTypeDLT:{
            
            return NewbieGuidanceNameDLT;
        }
            break;
        default:
            return nil;
            break;
    }
}
@end
