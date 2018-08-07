//
//  CLOrderBasicCashViewModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/17.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CLOrderBasicCashType){
    
    CLOrderBasicCashTypeText,
    CLOrderBasicCashTypeImg,
    CLOrderBasicCashTypeBtn,
};

@interface CLOrderBasicCashViewModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;

@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIColor* contentColor;

@property (nonatomic, strong) NSString* payBtnTitle;
@property (nonatomic) long long payEndTime;

@property (nonatomic, strong) UIImage* image;

@property (nonatomic) CLOrderBasicCashType type;

/**
 继续支付时间是否倒计时(0:不倒计时  1:倒计时)
 */
@property(nonatomic, assign ) NSInteger ifCountdown;

@end
