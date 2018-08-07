//
//  CLSFCTopView.h
//  iOSLottery
//
//  Created by 任鹏杰 on 2017/10/24.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLSFCTopViewBlock)();

@interface CLSFCTopView : UIView

- (void)reloadUI;

- (void)returnEndCountDown:(CLSFCTopViewBlock)block;

@end
