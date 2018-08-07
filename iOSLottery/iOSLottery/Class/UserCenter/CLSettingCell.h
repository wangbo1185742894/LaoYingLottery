//
//  CLSettingCell.h
//  iOSLottery
//
//  Created by 彩球 on 16/11/30.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSettingCellModel.h"


@interface CLSettingCell : UITableViewCell

@property (nonatomic, assign) BOOL has_bottomLine;
@property (nonatomic, copy) void(^SwitchChange)(BOOL isOn);

- (void) configureSettingCellWithModel:(CLSettingCellModel*)cellModel;

@end
