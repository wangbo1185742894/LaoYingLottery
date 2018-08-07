//
//  NSString+CKCoding.m
//  caiqr
//
//  Created by 小铭 on 2017/5/4.
//  Copyright © 2017年 Paul. All rights reserved.
//

#import "NSString+CKCoding.h"
#import "GTMBase64.h"
@implementation NSString (CKCoding)

- (NSString*)ck_nativeUrlEncode
{
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    
    return self;
}

- (NSString *)ck_nativeUrlDecode
{
    NSString *input = self;
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)base64
{
    NSData* originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [GTMBase64 stringByEncodingData:originData];
    
    //    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //    return encodeResult;
}

@end
