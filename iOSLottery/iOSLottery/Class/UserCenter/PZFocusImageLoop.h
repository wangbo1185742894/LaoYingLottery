//
//  PZFocusImageLoop.h
//  SSLTlottery
//
//  Created by Paul on 15-1-5.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FocusImageInfo;

@protocol PZFocusImageLoopDelegate <NSObject>

- (NSInteger) focusImageLoopCount;

- (NSString*) focusImageUrlAtIndex:(NSInteger)index;

- (void) focusImageSelectAtIndex:(NSInteger)index;

@end


#pragma mark - PZFocusImageLoop

@interface PZFocusImageLoop : UIView<UIScrollViewDelegate>

//@property (nonatomic, copy) void(^focusClick)(FocusImageInfo*imageInfo);

@property (nonatomic, assign) BOOL autoLoop;

@property (nonatomic, weak) id<PZFocusImageLoopDelegate> delegate;

- (void) reloadFocusImage;

@end

#pragma mark - PZPageControl



@interface PZPageControl : UIView

@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame ItemCount:(NSInteger)count;

@end

#pragma mark - FocusImageInfo
#import "CLBaseModel.h"

@interface FocusImageInfo : CLBaseModel

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSString* action;
@property (nonatomic) NSInteger actionType;
@property (nonatomic, strong) NSString* desc;
@property (nonatomic, strong) NSString* imageUrl;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString* push;



+ (FocusImageInfo*)createFocusImageInfo:(NSDictionary*)dictionary;

@end



