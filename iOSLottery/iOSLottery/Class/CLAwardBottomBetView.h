//
//  CLAwardBottomBetView.h
//  iOSLottery
//
//  Created by 彩球 on 16/12/9.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLAwardBottomBlock)();

typedef NS_ENUM(NSInteger,CLAwardBottomType) {

    CLAwardBottomTypeNormal,
    CLAwardBottomTypeSFC
    
};
@interface CLAwardBottomBetView : UIView

@property (nonatomic, copy) CLAwardBottomBlock leftBlock;

@property (nonatomic, copy) CLAwardBottomBlock rightBlock;

+ (instancetype)awardBottomWithType:(CLAwardBottomType)type;

- (void)returnLeftButtonBlock:(CLAwardBottomBlock)leftBlock;

- (void)returnRightButtonBlock:(CLAwardBottomBlock)rightBlock;

@end
