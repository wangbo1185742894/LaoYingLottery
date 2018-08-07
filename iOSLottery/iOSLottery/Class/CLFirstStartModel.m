//
//  CLFirstStartModel.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/18.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLFirstStartModel.h"

@implementation CLFirstStartModel

- (void)setAllGame:(NSArray *)allGame{
    
    _allGame = allGame;
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:0];
    for (NSDictionary *dic in allGame) {
        
        [tempDic setObject:dic[@"gameName"] forKey:dic[@"gameEn"]];
    }
    self.allGameNameDic = tempDic;
}

@end

@implementation CLLaunchActivityModel

+ (NSArray *)mj_ignoredPropertyNames{
    
    return @[@"downloadImage"];
}

@end
