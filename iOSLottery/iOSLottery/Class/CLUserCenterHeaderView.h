//
//  CLUserCenterHeaderView.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/18.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLUserCenterHeaderActionType){
    
    CLUserCenterHeaderActionTypeLoginning,
    CLUserCenterHeaderActionTypeHeadImg,
    CLUserCenterHeaderActionTypePersonalMsg,
    CLUserCenterHeaderActionTypeVC,
    CLUserCenterHeaderActionTypeDF,
    CLUserCenterHeaderActionTypeRE,
};

@protocol CLUserCenterHeaderDelegate <NSObject>

- (void) userCenterHeaderActionType:(CLUserCenterHeaderActionType)type;

@end

@interface CLUserCenterHeaderView : UIView

@property (nonatomic, weak) id<CLUserCenterHeaderDelegate> delegate;

@property (nonatomic) BOOL isLoginning;

@property (nonatomic, strong) NSString* userHeadImg;

@property (nonatomic, strong) NSString* userNickName;

//直接赋值 展示图片
@property (nonatomic, strong) NSString* redEnvopleImgUrl;
@property (nonatomic, assign) BOOL isShowBottomView;

// update data
- (void)updateData;

@end

