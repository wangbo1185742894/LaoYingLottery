//
//  CLLotteryOmissionView.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/17.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , CLOmissionPromptType) {
    
    CLOmissionPromptTypeKuaiSan,
    CLOmissionPromptTypeD11
};

@interface CLLotteryOmissionView : UIView

+ (void)showLotteryOmissionInWindowWithType:(CLOmissionPromptType)type;

@end
