//
//  CLArchiverData.m
//  iOSLottery
//
//  Created by huangyuchen on 2017/1/9.
//  Copyright © 2017年 caiqr. All rights reserved.
//

#import "CLArchiverData.h"

@implementation CLArchiverData
+ (CLArchiverData *)sharedManager
{
    static CLArchiverData *sharedAccountManagerCQArchiverDataInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerCQArchiverDataInstance = [[self alloc] init];
    });
    return sharedAccountManagerCQArchiverDataInstance;
}

- (BOOL)saveToFile:(id)data FileName:(NSString*)file_name
{
    NSString* documentPath = [CLArchiverData getCanClearDocumentPath];
    NSString *arrayFilePath = [documentPath stringByAppendingPathComponent:file_name];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:data toFile:arrayFilePath];
    return ret;
}

- (id)getFromFileWithFileName:(NSString*)file_name
{
    NSString *documentPath       = [CLArchiverData getCanClearDocumentPath];
    NSString *arrayFilePath      = [documentPath stringByAppendingPathComponent:file_name];
    // 恢复对象
    return [NSKeyedUnarchiver unarchiveObjectWithFile:arrayFilePath];
}
//返回可清空缓存的文件夹路径
+ (NSString *)getCanClearDocumentPath {
//    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = documents[0];
    
    NSString *documentClear = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"canClearFolder"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    //判断文件夹是否存在 不存在则创建
    BOOL isDirExist = [fileManager fileExistsAtPath:documentClear isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentClear withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            BOOL bCreateDirSecond = [fileManager createDirectoryAtPath:documentClear withIntermediateDirectories:YES attributes:nil error:nil];
            if (!bCreateDirSecond) {
                return @"";
            }
        }
    }
    return documentClear;
}


- (BOOL)saveNoableClearToFile:(id)data FileName:(NSString*)file_name
{
    NSString* documentPath = [CLArchiverData getCanClearDocumentPath];
    NSString *arrayFilePath = [documentPath stringByAppendingPathComponent:file_name];
    
    BOOL ret = [NSKeyedArchiver archiveRootObject:data toFile:arrayFilePath];
    return ret;
}

- (id)getNoableClearFromFileWithFileName:(NSString*)file_name
{
    NSString *documentPath       = [CLArchiverData getCanClearDocumentPath];
    NSString *arrayFilePath      = [documentPath stringByAppendingPathComponent:file_name];
    // 恢复对象
    return [NSKeyedUnarchiver unarchiveObjectWithFile:arrayFilePath];
}
//返回不可清空缓存的文件夹路径
+ (NSString *)getNoableClearDocumentPath {
    
    NSString *documentClear = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"NoableClearFolder"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    //判断文件夹是否存在 不存在则创建
    BOOL isDirExist = [fileManager fileExistsAtPath:documentClear isDirectory:&isDir];
    if(!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentClear withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            BOOL bCreateDirSecond = [fileManager createDirectoryAtPath:documentClear withIntermediateDirectories:YES attributes:nil error:nil];
            if (!bCreateDirSecond) {
                return @"";
            }
        }
    }
    return documentClear;
}
@end
