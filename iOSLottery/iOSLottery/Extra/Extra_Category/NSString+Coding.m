//
//  NSString+Coding.m
//  iOSLottery
//
//  Created by 彩球 on 16/11/3.
//  Copyright © 2016年 caiqr. All rights reserved.
//

#import "NSString+Coding.h"
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

@implementation NSString (Coding)


- (NSString *) md5{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


- (NSString *)base64
{
    NSData* originData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [GTMBase64 stringByEncodingData:originData];
}

- (NSString*)decodeBase64
{
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:self options:0];
    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    return decodeStr;
}

- (NSString *)urlEncode
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

- (NSString *)urlDecode
{
    NSString *input = self;
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}



+ (NSString *)retbitStringCount:(NSInteger)count
{
    char data[count];
    for (int x = 0; x < count; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:count encoding:NSUTF8StringEncoding];
}



@end
