//
//  CQHomeBannerView.h
//  caiqr
//
//  Created by 彩球 on 16/1/22.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZFocusImageLoop.h"

@class CQMarqueeView;

@interface CQHomeBannerView : UIView

//- (instancetype)initWithFrame:(CGRect)frame withFuncItem:(NSArray*)funcItems;

@property (nonatomic, strong) PZFocusImageLoop* focusImageLoop;

@property (nonatomic, strong) CQMarqueeView* marqueeView;


- (void) configureBanners:(NSArray*)banners marquees:(NSArray*)marquees;

@end
