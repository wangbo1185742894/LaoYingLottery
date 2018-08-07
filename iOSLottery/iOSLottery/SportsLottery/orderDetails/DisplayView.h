//
//  DisplayView.h
//  ModuleTest
//
//  Created by 彩球 on 16/7/14.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"


@interface DisplayView : UIView

@property (nonatomic, strong) CoreTextData *data;

/**
 是否偏移
 */
@property (nonatomic, assign) BOOL isOffset;

@end
