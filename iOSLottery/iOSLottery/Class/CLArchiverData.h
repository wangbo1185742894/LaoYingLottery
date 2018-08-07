//
//  CLArchiverData.h
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLArchiverData : NSObject

+ (CLArchiverData *)sharedManager;
/**
 *  归档文件到本地
 */
- (BOOL)saveToFile:(id)data FileName:(NSString*)file_name;

/**
 *  获取本地归档文件
 */
- (id)getFromFileWithFileName:(NSString*)file_name;


+ (NSString *)getCanClearDocumentPath;

//归档不可清空缓存的文件
- (BOOL)saveNoableClearToFile:(id)data FileName:(NSString*)file_name;
- (id)getNoableClearFromFileWithFileName:(NSString*)file_name;
//返回不可清空缓存的文件夹路径
+ (NSString *)getNoableClearDocumentPath;

@end
