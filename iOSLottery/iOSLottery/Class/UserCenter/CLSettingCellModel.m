//
//  CLSettingCellModel.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "CLSettingCellModel.h"

@implementation CLSettingCellModel

+ (CLSettingCellModel*)settingTitle:(NSString*)title remark:(NSString*)remark isOn:(BOOL)isOn {
    
    CLSettingCellModel* model = [CLSettingCellModel settingTitle:title remark:remark];
    model.isOn = isOn;
    model.cellType = CLSettingCellTypeSwitch;
    return model;
}

+ (CLSettingCellModel*)settingTitle:(NSString*)title remark:(NSString*)remark {
    
    CLSettingCellModel* model = [CLSettingCellModel settingTitle:title];
    if (remark) {
        model.remark = remark;
        model.cellType = CLSettingCellTypeRemark;
    }
    return model;
}

+ (CLSettingCellModel*)settingTitle:(NSString*)title {
    
    CLSettingCellModel* model = [[CLSettingCellModel alloc] init];
    model.title = title;
    model.cellType = CLSettingCellTypeNormal;
    return model;
}

@end
