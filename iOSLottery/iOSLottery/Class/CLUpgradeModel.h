//
//  CLUpgradeModel.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/3/22.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLBaseModel.h"

@interface CLUpgradeModel : CLBaseModel

/*
 "version_type": "caiqr",
 "version_name": "v3.5",
 "v_num":1,
 "system_type": 1,
 "download_address": "xxxxxx",
 "channel_download_address":"",
 "version_describe": "xxxxx",
 "is_pop_up": 0,
 "force_upgrade": 0,
 "is_upgrade": 1，
 "new_md5":""
 */

@property (nonatomic, strong) NSString *versionType;
@property (nonatomic, strong) NSString *versionName;
@property (nonatomic, assign) long vNum;
@property (nonatomic, assign) long systemType;
@property (nonatomic, strong) NSString *downloadAddress;
@property (nonatomic, strong) NSString *channelDownloadAddress;
@property (nonatomic, strong) NSString *versionDescribe;
@property (nonatomic, assign) long isPopUp;
@property (nonatomic, assign) long forceUpgrade;
@property (nonatomic, assign) long isUpgrade;
@property (nonatomic, assign) long isPatch;
@property (nonatomic, strong) NSString *patchDownloadAddress;
@end
