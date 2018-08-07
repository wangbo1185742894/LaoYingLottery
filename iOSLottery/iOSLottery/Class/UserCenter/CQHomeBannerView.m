//
//  CQHomeBannerView.m
//  caiqr
//
//  Created by 彩球 on 16/1/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "CQHomeBannerView.h"
#import "CLConfigMessage.h"
#import "CQMarqueeView.h"
#import "CLHomeBannerModel.h"
#import "CLAllJumpManager.h"
#import "CLNativePushService.h"
@interface CQHomeBannerView () <PZFocusImageLoopDelegate>

@property (nonatomic, strong) NSMutableArray* banners;

@end

@implementation CQHomeBannerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xf1f1f1);
        
        [self addSubview:self.focusImageLoop];
        [self addSubview:self.marqueeView];
    }
    return self;
}

- (void) configureBanners:(NSArray*)banners marquees:(NSArray*)marquees {
    
    self.marqueeView.textArray = marquees;
    if (self.banners.count > 0) [self.banners removeAllObjects];
    [self.banners addObjectsFromArray:banners];
    [self.focusImageLoop reloadFocusImage];
    
}

#pragma mark - PZFocusImageLoopDelegate

- (NSInteger) focusImageLoopCount {
    
    return self.banners.count;
}

- (NSString*) focusImageUrlAtIndex:(NSInteger)index {
    
    if (self.banners.count > 0) {
        CLHomeBannerModel* banner = self.banners[index];
        return banner.imgUrl;
    }else{
        return @"";
    }
}

- (void) focusImageSelectAtIndex:(NSInteger)index {
    
    if (index >= self.banners.count) {
        return;
    }
    CLHomeBannerModel* banner = self.banners[index];
    if ([banner.detailUrl hasPrefix:@"eaglegames"]) {
        [CLNativePushService pushNativeUrl:banner.detailUrl];
    }else if ([banner.detailUrl hasPrefix:@"http"]){
        [[CLAllJumpManager shareAllJumpManager] open:banner.detailUrl];
    }
}

#pragma mark - getter

- (CQMarqueeView *)marqueeView {
    
    if (!_marqueeView) {
        _marqueeView = [CQMarqueeView shareMarqueeViewWithFrame:__Rect(0, __Obj_Bounds_Height(self) - CL__SCALE(45.f), SCREEN_WIDTH, CL__SCALE(35))];
        _marqueeView.backgroundColor = [UIColor whiteColor];
    }
    return _marqueeView;
}

- (PZFocusImageLoop *)focusImageLoop
{
    if (!_focusImageLoop) {
        PZFocusImageLoop* focusImageLoop = [[PZFocusImageLoop alloc] initWithFrame:__Rect(0, 0, SCREEN_WIDTH, __Obj_Bounds_Height(self) - CL__SCALE(45))];
        focusImageLoop.delegate = self;
        _focusImageLoop = focusImageLoop;
        SAFE_RELEASE(focusImageLoop)
    }
    return _focusImageLoop;
}

- (NSMutableArray *)banners {
    
    if (!_banners) {
        _banners = [NSMutableArray new];
    }
    return _banners;
}

@end
