//
//  CLSettingCellModel.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, CLSettingCellType) {
    
    CLSettingCellTypeNormal,
    CLSettingCellTypeRemark,
    CLSettingCellTypeSwitch,
};

@interface CLSettingCellModel : NSObject

@property (nonatomic) CLSettingCellType cellType;

@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) NSString* remark;

@property (nonatomic) BOOL isOn;

+ (CLSettingCellModel*)settingTitle:(NSString*)title;

+ (CLSettingCellModel*)settingTitle:(NSString*)title remark:(NSString*)remark;

+ (CLSettingCellModel*)settingTitle:(NSString*)title remark:(NSString*)remark isOn:(BOOL)isOn;

@end
