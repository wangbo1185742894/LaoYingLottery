//
//  CLHomeModuleModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/12/8.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLHomeModuleModel.h"
#import "CQDefinition.h"
#import <UIKit/UIKit.h>

@implementation CLHomeModuleModel


- (NSInteger) count {
    
    if (self.style == HomeModuleStyleQuickBet) {
        return [self.moduleObjc count];
    } else if (self.style == HomeModuleStyleLottery) {
        
        if (([self.moduleObjc count] % 2) == 0) {
            return [self.moduleObjc count] / 2;
        }else{
            return ([self.moduleObjc count] / 2) + 1;
        }
    } else if (self.style == HomeModuleStyleFocus) {
        return [self.moduleObjc count];
    } else if (self.style == HomeModuleStyleMargin){
        return 1;
    }
    else {
        return 0;
    }
    
}

- (float) cellHeight {
    
    float height = 0;
    switch (self.style) {
            
        case HomeModuleStyleQuickBet:
            {height = __SCALE(140.f);}
            break;
        case HomeModuleStyleLottery:
            {height = __SCALE(70.f);}
            break;
        case HomeModuleStyleFocus:
            {height = __SCALE(70.f);}
            break;
        case HomeModuleStyleMargin:
            {height = __SCALE(35.f);}
            break;
        default:
            height = 0;
            break;
    }
    return height;
}


@end
