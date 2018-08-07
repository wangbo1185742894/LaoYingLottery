//
//  CQImgAndTextView.h
//  caiqr
//
//  Created by 彩球 on 16/4/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CQImgTextAlignment){
    CQImgTextAlignmentLeft,
    CQImgTextAlignmentRight,
    CQImgTextAlignmentCenter,
};

@interface CQImgAndTextView : UIView

@property (nonatomic, copy) void(^tapGestureHandler)(void);

@property (nonatomic, assign) CGFloat imgToHeightScale;

@property (nonatomic, assign) CGFloat textToHeightScale;

@property (nonatomic, assign) CGFloat imgAndTextSpacing;

@property (nonatomic, assign) CGFloat leftSpacing;

@property (nonatomic, assign) CGFloat rightSpacing;

@property (nonatomic, assign) CQImgTextAlignment imgTextAlignment;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) UIFont* titleFont;

@property (nonatomic, strong) UIColor* titleColor;

@property (nonatomic, strong) UIImage* img;

@property (nonatomic, readwrite) BOOL canClick;

- (void)setImgUrl:(NSString *)imgUrl placeholder:(UIImage*)img;

@end
